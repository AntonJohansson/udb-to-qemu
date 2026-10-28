//
// Functions required for C++ input to interface correctly with KLEE.
// Provides dummy branches for load, stores, and jumps to enable test
// test generation.
//
// Copyright (c) 2025 rev.ng Labs Srl.
//
// This work is licensed under the terms of the GNU GPL, version 2 or
// (at your option) any later version.
//
// See the LICENSE file in the top-level directory for details.
//

#pragma once

#include <assert.h>
#include <stdint.h>
#include <unordered_map>

#include "base-structs.h"

struct MemoryOp {
    uint32_t value;
    uint8_t size;
};

static bool has_jump = false;
static bool has_store = false;
static bool has_load = false;
static bool has_valid_test_jump = false;
static bool has_valid_test_memop = false;
static int jump_pc_offset = 0;
static std::unordered_map<uint32_t, MemoryOp> wmemory;
static std::unordered_map<uint32_t, MemoryOp> rmemory;
static const uint32_t read_pattern = 0x12345678;
static uint32_t number_of_reads = 0;

#define read_memory_xlen(va, enc) read_memory(32, va, enc)
#define write_memory_xlen(va, value, enc) write_memory(32, va, value, enc)

void write_memory(size_t size, XReg va, XReg value, uint32_t encoding) {
    switch (size) {
    case 8: {
        has_store = true;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8 && value.value() != 0) {
            has_valid_test_memop = true;
            wmemory[va.value()] = {value.value() & 0xff, 8};
        }
    } break;
    case 16: {
        has_store = true;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8 && value.value() != 0) {
            has_valid_test_memop = true;
            wmemory[va.value()] = {value.value() & 0xffff, 16};
        }
    } break;
    case 32: {
        has_store = true;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8 && value.value() != 0) {
            has_valid_test_memop = true;
            wmemory[va.value()] = {value.value() & 0xffffffff, 32};
        }
    } break;
    default:
        assert(false);
    }
}

XReg read_memory(size_t size, XReg va, uint32_t encoding) {
    switch (size) {
    case 8: {
        has_load = true;
        ++number_of_reads;
        uint32_t value = number_of_reads * read_pattern;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8) {
            has_valid_test_memop = true;
            rmemory[va.value()] = {value & 0xff, 8};
        }
        return rmemory[va.value()].value;
    } break;
    case 16: {
        has_load = true;
        ++number_of_reads;
        uint32_t value = number_of_reads * read_pattern;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8) {
            has_valid_test_memop = true;
            rmemory[va.value()] = {value & 0xffff, 16};
        }
        return rmemory[va.value()].value;
    } break;
    case 32: {
        has_load = true;
        ++number_of_reads;
        uint32_t value = number_of_reads * read_pattern;
        if (va.value() >= 0x1000 && va.value() <= 0x2ff8) {
            has_valid_test_memop = true;
            rmemory[va.value()] = {value & 0xffffffff, 32};
        }
        return rmemory[va.value()].value;
    } break;
    default:
        assert(false);
    }
}

uint64_t xqci_current_pc() { return 0; }

void xqci_jump_pcrel(int imm) {
    has_jump = true;
    jump_pc_offset = imm;
    if (imm == INST_SIZE + 4) {
        // Skip current instruction + next 4-byte wide jump
        has_valid_test_jump = true;
    } else if (imm == -4) {
        // Jump backwards to previous 4-byte wide jump
        has_valid_test_jump = true;
    }
}

void xqci_jump(XReg pc, int imm) { has_jump = true; }

struct CPUArchState;

int32_t xqci_csrr(CPUArchState *, int32_t csrno) { return 0; }

int32_t xqci_csrr_field(CPUArchState *, int32_t csrno, int32_t field) { return 0; }

void xqci_csrw(CPUArchState *, int32_t csrno, int32_t csrw) {}

void xqci_csrw_field(CPUArchState *, int32_t csrno, int32_t field, int32_t value) {}

#define DEF_SEXTRACT(size)                                                               \
    static int##size##_t sextract##size(uint##size##_t value, int start, int length) {   \
        assert(start >= 0 && length > 0 && length <= size - start);                      \
        return ((int##size##_t)(value << (size - length - start))) >> (size - length);   \
    }

DEF_SEXTRACT(8)
DEF_SEXTRACT(16)
DEF_SEXTRACT(32)
DEF_SEXTRACT(64)

void xqci_raise_IllegalInstruction() {}
XReg get_and_validate_stack_pointer(XReg a, int32_t i) { return a; }
void xqci_set_mode_M() {}
void xqci_set_mode_S() {}
void xqci_set_mode_U() {}

bool xqci_implemented_B() {return true;}
bool xqci_implemented_C() {return true;}
bool xqci_implemented_D() {return true;}
bool xqci_implemented_F() {return true;}
bool xqci_implemented_H() {return true;}
bool xqci_implemented_I() {return true;}
bool xqci_implemented_M() {return true;}
bool xqci_implemented_Q() {return true;}
bool xqci_implemented_S() {return true;}
bool xqci_implemented_Sdext() {return true;}
bool xqci_implemented_Smdbltrp() {return true;}
bool xqci_implemented_Smrnmi() {return true;}
bool xqci_implemented_Svinval() {return true;}
bool xqci_implemented_V() {return true;}
bool xqci_implemented_Zaamo() {return true;}
bool xqci_implemented_Zabha() {return true;}
bool xqci_implemented_Zacas() {return true;}
bool xqci_implemented_Zalasr() {return true;}
bool xqci_implemented_Zalrsc() {return true;}
bool xqci_implemented_Zawrs() {return true;}
bool xqci_implemented_Zba() {return true;}
bool xqci_implemented_Zbb() {return true;}
bool xqci_implemented_Zbc() {return true;}
bool xqci_implemented_Zbkb() {return true;}
bool xqci_implemented_Zbkx() {return true;}
bool xqci_implemented_Zbs() {return true;}
bool xqci_implemented_Zcb() {return true;}
bool xqci_implemented_Zcd() {return true;}
bool xqci_implemented_Zcf() {return true;}
bool xqci_implemented_Zcmop() {return true;}
bool xqci_implemented_Zcmp() {return true;}
bool xqci_implemented_Zcmt() {return true;}
bool xqci_implemented_Zfa() {return true;}
bool xqci_implemented_Zfbfmin() {return true;}
bool xqci_implemented_Zfh() {return true;}
bool xqci_implemented_Zicbom() {return true;}
bool xqci_implemented_Zicbop() {return true;}
bool xqci_implemented_Zicboz() {return true;}
bool xqci_implemented_Zicfilp() {return true;}
bool xqci_implemented_Zicfiss() {return true;}
bool xqci_implemented_Zicond() {return true;}
bool xqci_implemented_Zicsr() {return true;}
bool xqci_implemented_Zifencei() {return true;}
bool xqci_implemented_Zihintntl() {return true;}
bool xqci_implemented_Zihintpause() {return true;}
bool xqci_implemented_Zimop() {return true;}
bool xqci_implemented_Zkn() {return true;}
bool xqci_implemented_Zknd() {return true;}
bool xqci_implemented_Zkne() {return true;}
bool xqci_implemented_Zknh() {return true;}
bool xqci_implemented_Zks() {return true;}
bool xqci_implemented_Zvbb() {return true;}
bool xqci_implemented_Zvbc() {return true;}
bool xqci_implemented_Zvfbfmin() {return true;}
bool xqci_implemented_Zvfbfwma() {return true;}
bool xqci_implemented_Zvkg() {return true;}
bool xqci_implemented_Zvkned() {return true;}
bool xqci_implemented_Zvknha() {return true;}
bool xqci_implemented_Zvks() {return true;}
bool xqci_implemented_U() { return true; }

bool xqci_implemented_Xqccmp() { return true; }
/* Implemented in a default rv32 QEMU machine */
void xqci_syscall(int a, int b) {}

static void iss_syscall(XReg a, XReg b) { xqci_syscall(a.value(), b.value()); }
