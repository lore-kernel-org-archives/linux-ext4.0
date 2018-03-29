From: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Subject: Re: linux-next 20180327 - "SELinux: (dev dm-3, type ext4) getxattr
 errno 34"
Date: Thu, 29 Mar 2018 14:29:50 -0400
Message-ID: <db97ea5d-0925-63bd-6840-1364a7977a50@tycho.nsa.gov>
References: <24018.1522346273@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
To: valdis.kletnieks-PjAqaU27lzQ@public.gmane.org, "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
In-Reply-To: <24018.1522346273-+bZmOdGhbsPr6rcHtW+onFJE71vCis6O@public.gmane.org>
Content-Language: en-US
List-Post: <mailto:selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Help: <mailto:selinux-request-+05T5uksL2qpZYMLLGbcSA@public.gmane.org?subject=help>
Errors-To: selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org
Sender: "Selinux" <selinux-bounces-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On 03/29/2018 01:57 PM, valdis.kletnieks-PjAqaU27lzQ@public.gmane.org wrote:
> Seeing this error trying to mount ext4 disks. next-20180320 was OK.
> 
> SELinux: (dev dm-3, type ext4) getxattr errno 34
> 
> and for /var, it refused to mount entirely (which brought the boot
> process to a screeching halt).
> 
> git log shows commits in the past few days against both selinux and ext4,
> but nothing obvious.
> 
> This ring any bells, or is it time to start bisecting?

commit de57a63ea4389e39b1cdd1cef15e1ec9b58a964c
Author: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Date:   Sun Mar 25 02:58:44 2018 -0400

    ext4: add better range checking for e_value_size in xattrs
    
    https://bugzilla.kernel.org/show_bug.cgi?id=199185
    
    Reported-by: Wen Xu <wen.xu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org>
    Signed-off-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
    Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

broke a longstanding assumption by SELinux that it could call getxattr with a NULL buffer and 0 size to probe whether the filesystem supports the security xattrs at mount time.

Options for fixing:
- Revert or revise that patch to not return -ERANGE if buffer is NULL (prior behavior),
- Change SELinux sb_finish_set_opts() to treat -ERANGE as a non-error result.

> 
> dmesg follows...
> 
> [    0.000000] microcode: microcode updated early to revision 0x1f, date = 2018-02-07
> [    0.000000] Linux version 4.16.0-rc7-next-20180327-dirty (source-+bZmOdGhbsPr6rcHtW+onFJE71vCis6O@public.gmane.org) (gcc version 8.0.1 20180317 (Red Hat 8.0.1-0.19) (GCC)) #565 SMP PREEMPT Wed Mar 28 01:01:48 EDT 2018
> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.16.0-rc7-next-20180327-dirty root=/dev/mapper/turing--police-root ro rd.md=0 rd.dm=0 rd.lvm.lv=turing-police/00 console.keymap= rd.luks.uuid=luks-665bb147-9e39-4003-b3ae-7be925f51a97 rd.lvm.lv=turing-police/swap rd.lvm.lv=turing-police/root quiet LANG=en_US.UTF-8 nouveau.modeset=0 rd.driver.blacklist=nouveau video=vesa:off modprobe.blacklist=nouveau nvidia-drm.modeset=1 single
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009efff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ca709fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ca70a000-0x00000000ca7fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ca800000-0x00000000caf52fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000caf53000-0x00000000caffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cb000000-0x00000000cb7b1fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cb7b2000-0x00000000cb7fffff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000cb800000-0x00000000ccefdfff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ccefe000-0x00000000ccffffff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cd000000-0x00000000ce5aefff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ce5af000-0x00000000cefa5fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cefa6000-0x00000000cefe8fff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000cefe9000-0x00000000cf2b1fff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000cf2b2000-0x00000000cf7effff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000cf7f0000-0x00000000cf7fffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000040dfacfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000040dfad000-0x000000040dfadfff] unusable
> [    0.000000] BIOS-e820: [mem 0x000000040dfae000-0x000000040dfaefff] usable
> [    0.000000] BIOS-e820: [mem 0x000000040dfaf000-0x000000040dfaffff] unusable
> [    0.000000] BIOS-e820: [mem 0x000000040dfb0000-0x000000040dfeafff] usable
> [    0.000000] BIOS-e820: [mem 0x000000040dfeb000-0x000000040dfebfff] unusable
> [    0.000000] BIOS-e820: [mem 0x000000040dfec000-0x000000042dffffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] e820: update [mem 0xc7b50018-0xc7b6ce57] usable ==> usable
> [    0.000000] e820: update [mem 0xc7b50018-0xc7b6ce57] usable ==> usable
> [    0.000000] extended physical RAM map:
> [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009cfff] usable
> [    0.000000] reserve setup_data: [mem 0x000000000009d000-0x000000000009efff] reserved
> [    0.000000] reserve setup_data: [mem 0x000000000009f000-0x000000000009ffff] usable
> [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000c7b50017] usable
> [    0.000000] reserve setup_data: [mem 0x00000000c7b50018-0x00000000c7b6ce57] usable
> [    0.000000] reserve setup_data: [mem 0x00000000c7b6ce58-0x00000000ca709fff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000ca70a000-0x00000000ca7fffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000ca800000-0x00000000caf52fff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000caf53000-0x00000000caffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000cb000000-0x00000000cb7b1fff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000cb7b2000-0x00000000cb7fffff] ACPI data
> [    0.000000] reserve setup_data: [mem 0x00000000cb800000-0x00000000ccefdfff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000ccefe000-0x00000000ccffffff] ACPI NVS
> [    0.000000] reserve setup_data: [mem 0x00000000cd000000-0x00000000ce5aefff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000ce5af000-0x00000000cefa5fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000cefa6000-0x00000000cefe8fff] ACPI NVS
> [    0.000000] reserve setup_data: [mem 0x00000000cefe9000-0x00000000cf2b1fff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000cf2b2000-0x00000000cf7effff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000cf7f0000-0x00000000cf7fffff] usable
> [    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000040dfacfff] usable
> [    0.000000] reserve setup_data: [mem 0x000000040dfad000-0x000000040dfadfff] unusable
> [    0.000000] reserve setup_data: [mem 0x000000040dfae000-0x000000040dfaefff] usable
> [    0.000000] reserve setup_data: [mem 0x000000040dfaf000-0x000000040dfaffff] unusable
> [    0.000000] reserve setup_data: [mem 0x000000040dfb0000-0x000000040dfeafff] usable
> [    0.000000] reserve setup_data: [mem 0x000000040dfeb000-0x000000040dfebfff] unusable
> [    0.000000] reserve setup_data: [mem 0x000000040dfec000-0x000000042dffffff] usable
> [    0.000000] efi: EFI v2.31 by American Megatrends
> [    0.000000] efi:  ACPI=0xcb7f1000  ACPI 2.0=0xcb7f1000  SMBIOS=0xf0000 
> [    0.000000] secureboot: Secure boot disabled
> [    0.000000] random: fast init done
> [    0.000000] SMBIOS 2.7 present.
> [    0.000000] DMI: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x42e000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-DFFFF uncachable
> [    0.000000]   E0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask C00000000 write-back
> [    0.000000]   1 base 400000000 mask FE0000000 write-back
> [    0.000000]   2 base 420000000 mask FF8000000 write-back
> [    0.000000]   3 base 428000000 mask FFC000000 write-back
> [    0.000000]   4 base 42C000000 mask FFE000000 write-back
> [    0.000000]   5 base 0E0000000 mask FE0000000 uncachable
> [    0.000000]   6 base 0D0000000 mask FF0000000 uncachable
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
> [    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
> [    0.000000] e820: last_pfn = 0xcf800 max_arch_pfn = 0x400000000
> [    0.000000] Base memory trampoline at [        (ptrval)] 97000 size 24576
> [    0.000000] BRK [0x403b91000, 0x403b91fff] PGTABLE
> [    0.000000] BRK [0x403b92000, 0x403b92fff] PGTABLE
> [    0.000000] BRK [0x403b93000, 0x403b93fff] PGTABLE
> [    0.000000] BRK [0x403b94000, 0x403b94fff] PGTABLE
> [    0.000000] BRK [0x403b95000, 0x403b95fff] PGTABLE
> [    0.000000] BRK [0x403b96000, 0x403b96fff] PGTABLE
> [    0.000000] BRK [0x403b97000, 0x403b97fff] PGTABLE
> [    0.000000] BRK [0x403b98000, 0x403b98fff] PGTABLE
> [    0.000000] BRK [0x403b99000, 0x403b99fff] PGTABLE
> [    0.000000] BRK [0x403b9a000, 0x403b9afff] PGTABLE
> [    0.000000] BRK [0x403b9b000, 0x403b9bfff] PGTABLE
> [    0.000000] BRK [0x403b9c000, 0x403b9cfff] PGTABLE
> [    0.000000] RAMDISK: [mem 0x3b87d000-0x3c441fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000CB7F1000 000024 (v02 DELL  )
> [    0.000000] ACPI: XSDT 0x00000000CB7F1088 000094 (v01 DELL   CBX3     01072009 AMI  00010013)
> [    0.000000] ACPI: FACP 0x00000000CB7FB720 00010C (v05 DELL   CBX3     01072009 AMI  00010013)
> [    0.000000] ACPI: DSDT 0x00000000CB7F11B0 00A56F (v02 DELL   CBX3     00000021 INTL 20091112)
> [    0.000000] ACPI: FACS 0x00000000CCFED080 000040
> [    0.000000] ACPI: APIC 0x00000000CB7FB830 000072 (v03 DELL   CBX3     01072009 AMI  00010013)
> [    0.000000] ACPI: FPDT 0x00000000CB7FB8A8 000044 (v01 DELL   CBX3     01072009 AMI  00010013)
> [    0.000000] ACPI: TCPA 0x00000000CB7FB8F0 000032 (v02 APTIO4 NAPAASF  00000001 MSFT 01000013)
> [    0.000000] ACPI: MCFG 0x00000000CB7FB928 00003C (v01 DELL   CBX3     01072009 MSFT 00000097)
> [    0.000000] ACPI: HPET 0x00000000CB7FB968 000038 (v01 DELL   CBX3     01072009 AMI. 00000005)
> [    0.000000] ACPI: SSDT 0x00000000CB7FB9A0 000415 (v01 SataRe SataTabl 00001000 INTL 20091112)
> [    0.000000] ACPI: SSDT 0x00000000CB7FBDB8 0009B9 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
> [    0.000000] ACPI: SSDT 0x00000000CB7FC778 000B22 (v01 PmRef  CpuPm    00003000 INTL 20051117)
> [    0.000000] ACPI: DMAR 0x00000000CB7FD2A0 000080 (v01 INTEL  SNB      00000001 INTL 00000001)
> [    0.000000] ACPI: ASF! 0x00000000CB7FD320 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
> [    0.000000] ACPI: SSDT 0x00000000CB7FD3C8 000579 (v01 AMITCG PROC     00000001 INTL 20051117)
> [    0.000000] ACPI: BGRT 0x00000000CB7FD948 000038 (v00 ??              01072009 AMI  00010013)
> [    0.000000] ACPI: SSDT 0x00000000CB7FD980 00198A (v01 NvdRef NvdTabl  00001000 INTL 20091112)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x0000000000001000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x000000042dffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
> [    0.000000]   node   0: [mem 0x000000000009f000-0x000000000009ffff]
> [    0.000000]   node   0: [mem 0x0000000000100000-0x00000000ca709fff]
> [    0.000000]   node   0: [mem 0x00000000ca800000-0x00000000caf52fff]
> [    0.000000]   node   0: [mem 0x00000000cb000000-0x00000000cb7b1fff]
> [    0.000000]   node   0: [mem 0x00000000cb800000-0x00000000ccefdfff]
> [    0.000000]   node   0: [mem 0x00000000cd000000-0x00000000ce5aefff]
> [    0.000000]   node   0: [mem 0x00000000cefe9000-0x00000000cf2b1fff]
> [    0.000000]   node   0: [mem 0x00000000cf7f0000-0x00000000cf7fffff]
> [    0.000000]   node   0: [mem 0x0000000100000000-0x000000040dfacfff]
> [    0.000000]   node   0: [mem 0x000000040dfae000-0x000000040dfaefff]
> [    0.000000]   node   0: [mem 0x000000040dfb0000-0x000000040dfeafff]
> [    0.000000]   node   0: [mem 0x000000040dfec000-0x000000042dffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000042dffffff]
> [    0.000000] On node 0 totalpages: 4179247
> [    0.000000]   DMA32 zone: 13205 pages used for memmap
> [    0.000000]   DMA32 zone: 23 pages reserved
> [    0.000000]   DMA32 zone: 845106 pages, LIFO batch:31
> [    0.000000]   Normal zone: 52096 pages used for memmap
> [    0.000000]   Normal zone: 3334141 pages, LIFO batch:31
> [    0.000000] Reserved but unavailable: 97 pages
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> [    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] e820: [mem 0xcf800000-0xf7ffffff] available for PCI devices
> [    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] percpu: Embedded 497 pages/cpu @        (ptrval) s1995800 r8192 d31720 u2097152
> [    0.000000] pcpu-alloc: s1995800 r8192 d31720 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4113923
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.16.0-rc7-next-20180327-dirty root=/dev/mapper/turing--police-root ro rd.md=0 rd.dm=0 rd.lvm.lv=turing-police/00 console.keymap= rd.luks.uuid=luks-665bb147-9e39-4003-b3ae-7be925f51a97 rd.lvm.lv=turing-police/swap rd.lvm.lv=turing-police/root quiet LANG=en_US.UTF-8 nouveau.modeset=0 rd.driver.blacklist=nouveau video=vesa:off modprobe.blacklist=nouveau nvidia-drm.modeset=1 single
> [    0.000000] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> [    0.000000] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
> [    0.000000] Memory: 16175608K/16716988K available (22540K kernel code, 11268K rwdata, 4472K rodata, 3784K init, 15076K bss, 541380K reserved, 0K cma-reserved)
> [    0.000000] Kernel/User page tables isolation: enabled
> [    0.000000] ftrace: allocating 36386 entries in 143 pages
> [    0.000000] ================================================================================
> [    0.000000] UBSAN: Undefined behaviour in lib/radix-tree.c:123:14
> [    0.000000] member access within null pointer of type 'const struct radix_tree_node'
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [    0.000000] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    0.000000] Call Trace:
> [    0.000000]  dump_stack+0x83/0xca
> [    0.000000]  ubsan_epilogue+0xd/0x3a
> [    0.000000]  handle_null_ptr_deref+0x85/0x90
> [    0.000000]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [    0.000000]  __radix_tree_replace+0x1e4/0x1f0
> [    0.000000]  radix_tree_iter_replace+0x25/0x50
> [    0.000000]  idr_alloc_u32+0x166/0x1f0
> [    0.000000]  idr_alloc+0x7e/0xd0
> [    0.000000]  worker_pool_assign_id+0x61/0xd0
> [    0.000000]  ? mutex_lock_nested+0x1b/0x20
> [    0.000000]  workqueue_init_early+0x58f/0xc53
> [    0.000000]  start_kernel+0x4f7/0x813
> [    0.000000]  x86_64_start_reservations+0x40/0x61
> [    0.000000]  x86_64_start_kernel+0x7b/0x9e
> [    0.000000]  secondary_startup_64+0xa5/0xb0
> [    0.000000] ================================================================================
> [    0.000000] Running RCU self tests
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 	RCU lockdep checking is enabled.
> [    0.000000] 	RCU debug extended QS entry/exit.
> [    0.000000] 	Tasks RCU enabled.
> [    0.000000] NR_IRQS: 4352, nr_irqs: 456, preallocated irqs: 16
> [    0.000000] Console: colour dummy device 160x64
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 7903 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] ACPI: Core revision 20180313
> [    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
> [    0.000000] hpet clockevent registered
> [    0.000000] APIC: Switch to symmetric I/O mode setup
> [    0.000000] DMAR: Host address width 36
> [    0.000000] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
> [    0.000000] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
> [    0.000000] DMAR: RMRR base: 0x000000ce715000 end: 0x000000ce734fff
> [    0.000000] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
> [    0.000000] DMAR-IR: HPET id 0 under DRHD base 0xfed90000
> [    0.000000] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
> [    0.000000] DMAR-IR: Enabled IRQ remapping in x2apic mode
> [    0.000000] x2apic enabled
> [    0.000000] Switched APIC routing to cluster x2apic.
> [    0.000000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.005000] tsc: Fast TSC calibration using PIT
> [    0.006000] tsc: Detected 2691.328 MHz processor
> [    0.007000] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x26cb3e4c6e2, max_idle_ns: 440795296607 ns
> [    0.007000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5382.65 BogoMIPS (lpj=2691328)
> [    0.007000] pid_max: default: 32768 minimum: 301
> [    0.007000] Security Framework initialized
> [    0.007000] Yama: becoming mindful.
> [    0.007000] SELinux:  Initializing.
> [    0.007000] SELinux:  Starting in permissive mode
> [    0.007000] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.007000] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.008383] CPU: Physical Processor ID: 0
> [    0.008386] CPU: Processor Core ID: 0
> [    0.008394] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.008396] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.008402] mce: CPU supports 7 MCE banks
> [    0.008425] process: using mwait in idle threads
> [    0.008430] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
> [    0.008433] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
> [    0.008438] Spectre V2 : Mitigation: Full generic retpoline
> [    0.008441] Spectre V2 : Spectre v2 mitigation: Enabling Indirect Branch Prediction Barrier
> [    0.008443] Spectre V2 : Enabling Restricted Speculation for firmware calls
> [    0.008608] Freeing SMP alternatives memory: 32K
> [    0.017782] TSC deadline timer enabled
> [    0.017792] smpboot: CPU0: Intel(R) Core(TM) i5-3340M CPU @ 2.70GHz (family: 0x6, model: 0x3a, stepping: 0x9)
> [    0.023059] Performance Events: PEBS fmt1+, IvyBridge events, 16-deep LBR, full-width counters, Intel PMU driver.
> [    0.023102] ... version:                3
> [    0.023105] ... bit width:              48
> [    0.023107] ... generic registers:      4
> [    0.023110] ... value mask:             0000ffffffffffff
> [    0.023113] ... max period:             00007fffffffffff
> [    0.023115] ... fixed-purpose events:   3
> [    0.023118] ... event mask:             000000070000000f
> [    0.025039] Hierarchical SRCU implementation.
> [    0.029314] NMI watchdog: Enabled. Permanently consumes one hw-PMU counter.
> [    0.031037] smp: Bringing up secondary CPUs ...
> [    0.039236] x86: Booting SMP configuration:
> [    0.039243] .... node  #0, CPUs:      #1 #2 #3
> [    0.059150] smp: Brought up 1 node, 4 CPUs
> [    0.059150] smpboot: Max logical packages: 1
> [    0.059150] smpboot: Total of 4 processors activated (21530.62 BogoMIPS)
> [    0.061057] ================================================================================
> [    0.061100] UBSAN: Undefined behaviour in arch/x86/mm/fault.c:1228:12
> [    0.061126] member access within null pointer of type 'struct mm_struct'
> [    0.061154] CPU: 2 PID: 34 Comm: kdevtmpfs Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [    0.061157] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    0.061160] Call Trace:
> [    0.061169]  dump_stack+0x83/0xca
> [    0.061179]  ubsan_epilogue+0xd/0x3a
> [    0.061185]  handle_null_ptr_deref+0x85/0x90
> [    0.061193]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [    0.061203]  __do_page_fault+0x8e4/0x990
> [    0.061211]  ? error_entry+0x82/0x100
> [    0.061224]  do_page_fault+0x43/0x480
> [    0.061234]  page_fault+0x25/0x50
> [    0.061239] RIP: 0010:copy_mount_options+0x191/0x2b0
> [    0.061242] RSP: 0000:ffff99518016fe40 EFLAGS: 00010286
> [    0.061248] RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000ece
> [    0.061251] RDX: ffff995180170000 RSI: 0000000000000001 RDI: ffff89dbda9bc132
> [    0.061254] RBP: ffff99518016fe78 R08: 0000000000000000 R09: 0000000000000000
> [    0.061257] R10: 0000000000000000 R11: 0000000000000000 R12: ffff89dbda9bc132
> [    0.061259] R13: ffff89dbda9bc000 R14: ffff995180170ece R15: 00007ffffffff000
> [    0.061287]  ksys_mount+0xdc/0x170
> [    0.061298]  devtmpfsd+0xa8/0x1e0
> [    0.061308]  kthread+0x1a9/0x280
> [    0.061313]  ? handle_create+0x390/0x390
> [    0.061317]  ? kthread_create_worker_on_cpu+0x70/0x70
> [    0.061325]  ret_from_fork+0x3a/0x50
> [    0.061345] ================================================================================
> [    0.061585] devtmpfs: initialized
> [    0.063212] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
> [    0.063212] futex hash table entries: 1024 (order: 5, 131072 bytes)
> [    0.064584] NET: Registered protocol family 16
> [    0.065164] audit: initializing netlink subsys (disabled)
> [    0.065260] audit: type=2000 audit(1522335052.065:1): state=initialized audit_enabled=0 res=1
> [    0.065402] cpuidle: using governor ladder
> [    0.065444] cpuidle: using governor menu
> [    0.065444] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> [    0.065444] ACPI: bus type PCI registered
> [    0.066116] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.066124] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.066138] pmd_set_huge: Cannot satisfy [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR override.
> [    0.066265] PCI: Using configuration type 1 for base access
> [    0.066435] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
> [    0.076102] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    0.077300] ACPI: Added _OSI(Module Device)
> [    0.077305] ACPI: Added _OSI(Processor Device)
> [    0.077309] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.077313] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.077318] ACPI: Added _OSI(Linux-Dell-Video)
> [    0.114834] ACPI: 6 ACPI AML tables successfully acquired and loaded
> [    0.141081] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
> [    0.148101] ACPI: Dynamic OEM Table Load:
> [    0.148129] ACPI: SSDT 0xFFFF89DBDABB2800 000523 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
> [    0.149820] ACPI: Dynamic OEM Table Load:
> [    0.149846] ACPI: SSDT 0xFFFF89DBDABF1800 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
> [    0.150910] ACPI: Dynamic OEM Table Load:
> [    0.150936] ACPI: SSDT 0xFFFF89DBDA414A00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
> [    0.155118] ACPI: EC: EC started
> [    0.155124] ACPI: EC: interrupt blocked
> [    0.161343] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as first EC
> [    0.161350] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x10, EC_CMD/EC_SC=0x934, EC_DATA=0x930
> [    0.161355] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions
> [    0.161358] ACPI: Interpreter enabled
> [    0.161377] ACPI: (supports S0 S5)
> [    0.161381] ACPI: Using IOAPIC for interrupt routing
> [    0.161479] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.162659] ACPI: Enabled 14 GPEs in block 00 to 3F
> [    0.205434] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 1)
> [    0.229963] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.229977] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    0.230738] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
> [    0.232083] PCI host bridge to bus 0000:00
> [    0.232090] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> [    0.232094] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> [    0.232099] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> [    0.232103] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
> [    0.232107] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
> [    0.232111] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
> [    0.232115] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
> [    0.232120] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
> [    0.232124] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
> [    0.232128] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
> [    0.232132] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
> [    0.232136] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfeafffff window]
> [    0.232142] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.232172] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
> [    0.232715] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
> [    0.232798] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [    0.233419] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
> [    0.233470] pci 0000:00:14.0: reg 0x10: [mem 0xf7720000-0xf772ffff 64bit]
> [    0.233620] pci 0000:00:14.0: PME# supported from D3hot D3cold
> [    0.234120] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
> [    0.234169] pci 0000:00:16.0: reg 0x10: [mem 0xf773c000-0xf773c00f 64bit]
> [    0.234322] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.234807] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
> [    0.234852] pci 0000:00:19.0: reg 0x10: [mem 0xf7700000-0xf771ffff]
> [    0.234870] pci 0000:00:19.0: reg 0x14: [mem 0xf7739000-0xf7739fff]
> [    0.234889] pci 0000:00:19.0: reg 0x18: [io  0xf040-0xf05f]
> [    0.235042] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
> [    0.235533] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
> [    0.235578] pci 0000:00:1a.0: reg 0x10: [mem 0xf7738000-0xf77383ff]
> [    0.235746] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.236256] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
> [    0.236305] pci 0000:00:1b.0: reg 0x10: [mem 0xf7730000-0xf7733fff 64bit]
> [    0.236480] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.236970] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
> [    0.237170] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.237213] pci 0000:00:1c.0: Enabling MPC IRBNCE
> [    0.237220] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
> [    0.237710] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
> [    0.237896] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [    0.237936] pci 0000:00:1c.1: Enabling MPC IRBNCE
> [    0.237942] pci 0000:00:1c.1: Intel PCH root port ACS workaround enabled
> [    0.238447] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
> [    0.238636] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> [    0.238675] pci 0000:00:1c.2: Enabling MPC IRBNCE
> [    0.238680] pci 0000:00:1c.2: Intel PCH root port ACS workaround enabled
> [    0.239190] pci 0000:00:1c.3: [8086:1e16] type 01 class 0x060400
> [    0.239375] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.239415] pci 0000:00:1c.3: Enabling MPC IRBNCE
> [    0.239421] pci 0000:00:1c.3: Intel PCH root port ACS workaround enabled
> [    0.239916] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
> [    0.240112] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
> [    0.240153] pci 0000:00:1c.5: Enabling MPC IRBNCE
> [    0.240159] pci 0000:00:1c.5: Intel PCH root port ACS workaround enabled
> [    0.240658] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
> [    0.240703] pci 0000:00:1d.0: reg 0x10: [mem 0xf7737000-0xf77373ff]
> [    0.240876] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.241378] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
> [    0.242052] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
> [    0.242097] pci 0000:00:1f.2: reg 0x10: [io  0xf090-0xf097]
> [    0.242115] pci 0000:00:1f.2: reg 0x14: [io  0xf080-0xf083]
> [    0.242134] pci 0000:00:1f.2: reg 0x18: [io  0xf070-0xf077]
> [    0.242154] pci 0000:00:1f.2: reg 0x1c: [io  0xf060-0xf063]
> [    0.242172] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
> [    0.242192] pci 0000:00:1f.2: reg 0x24: [mem 0xf7736000-0xf77367ff]
> [    0.242301] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.242780] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
> [    0.242823] pci 0000:00:1f.3: reg 0x10: [mem 0xf7735000-0xf77350ff 64bit]
> [    0.242873] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
> [    0.243499] pci 0000:01:00.0: [10de:0dfc] type 00 class 0x030000
> [    0.243527] pci 0000:01:00.0: reg 0x10: [mem 0xf5000000-0xf5ffffff]
> [    0.243544] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.243561] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
> [    0.243573] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
> [    0.243585] pci 0000:01:00.0: reg 0x30: [mem 0xf6000000-0xf607ffff pref]
> [    0.243595] pci 0000:01:00.0: enabling Extended Tags
> [    0.243624] pci 0000:01:00.0: BAR 1: assigned to efifb
> [    0.244367] pci 0000:01:00.1: [10de:0bea] type 00 class 0x040300
> [    0.244389] pci 0000:01:00.1: reg 0x10: [mem 0xf6080000-0xf6083fff]
> [    0.244434] pci 0000:01:00.1: enabling Extended Tags
> [    0.244708] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.244713] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.244719] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60fffff]
> [    0.244725] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
> [    0.244849] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.245035] pci 0000:03:00.0: [14e4:4727] type 00 class 0x028000
> [    0.245095] pci 0000:03:00.0: reg 0x10: [mem 0xf7600000-0xf7603fff 64bit]
> [    0.245181] pci 0000:03:00.0: enabling Extended Tags
> [    0.245353] pci 0000:03:00.0: supports D1 D2
> [    0.245357] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
> [    0.245635] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.245648] pci 0000:00:1c.1:   bridge window [mem 0xf7600000-0xf76fffff]
> [    0.245775] pci 0000:00:1c.2: PCI bridge to [bus 04-07]
> [    0.245783] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
> [    0.245791] pci 0000:00:1c.2:   bridge window [mem 0xf6b00000-0xf74fffff]
> [    0.245803] pci 0000:00:1c.2:   bridge window [mem 0xf2b00000-0xf34fffff 64bit pref]
> [    0.245919] pci 0000:00:1c.3: PCI bridge to [bus 08-0b]
> [    0.245927] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
> [    0.245935] pci 0000:00:1c.3:   bridge window [mem 0xf6100000-0xf6afffff]
> [    0.245949] pci 0000:00:1c.3:   bridge window [mem 0xf2100000-0xf2afffff 64bit pref]
> [    0.246208] pci 0000:0c:00.0: [1217:8221] type 00 class 0x080501
> [    0.246295] pci 0000:0c:00.0: reg 0x10: [mem 0xf7502000-0xf75021ff]
> [    0.246683] pci 0000:0c:00.0: supports D1 D2
> [    0.246687] pci 0000:0c:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.249184] pci 0000:00:1c.5: PCI bridge to [bus 0c]
> [    0.249199] pci 0000:00:1c.5:   bridge window [mem 0xf7500000-0xf75fffff]
> [    0.249276] pci_bus 0000:00: on NUMA node 0
> [    0.255867] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.256200] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.256516] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.256828] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.257153] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.257469] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.257784] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.258110] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.267278] ACPI: EC: interrupt unblocked
> [    0.267314] ACPI: EC: event unblocked
> [    0.267326] ACPI: \_SB_.PCI0.LPCB.ECDV: GPE=0x10, EC_CMD/EC_SC=0x934, EC_DATA=0x930
> [    0.267334] ACPI: \_SB_.PCI0.LPCB.ECDV: Used as boot DSDT EC to handle transactions and events
> [    0.268048] pci 0000:01:00.0: vgaarb: setting as boot VGA device
> [    0.268054] pci 0000:01:00.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
> [    0.268061] pci 0000:01:00.0: vgaarb: bridge control possible
> [    0.268065] vgaarb: loaded
> [    0.268531] SCSI subsystem initialized
> [    0.268570] libata version 3.00 loaded.
> [    0.268595] ACPI: bus type USB registered
> [    0.268679] usbcore: registered new interface driver usbfs
> [    0.268722] usbcore: registered new interface driver hub
> [    0.268823] usbcore: registered new device driver usb
> [    0.268879] Linux video capture interface: v2.00
> [    0.268903] pps_core: LinuxPPS API ver. 1 registered
> [    0.268906] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti-k2GhghHVRtY@public.gmane.org>
> [    0.268920] PTP clock support registered
> [    0.269066] Registered efivars operations
> [    0.276698] Advanced Linux Sound Architecture Driver Initialized.
> [    0.276779] PCI: Using ACPI for IRQ routing
> [    0.280492] PCI: pci_cache_line_size set to 64 bytes
> [    0.280706] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
> [    0.280713] e820: reserve RAM buffer [mem 0xc7b50018-0xc7ffffff]
> [    0.280718] e820: reserve RAM buffer [mem 0xca70a000-0xcbffffff]
> [    0.280722] e820: reserve RAM buffer [mem 0xcaf53000-0xcbffffff]
> [    0.280726] e820: reserve RAM buffer [mem 0xcb7b2000-0xcbffffff]
> [    0.280730] e820: reserve RAM buffer [mem 0xccefe000-0xcfffffff]
> [    0.280735] e820: reserve RAM buffer [mem 0xce5af000-0xcfffffff]
> [    0.280739] e820: reserve RAM buffer [mem 0xcf2b2000-0xcfffffff]
> [    0.280744] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
> [    0.280748] e820: reserve RAM buffer [mem 0x40dfad000-0x40fffffff]
> [    0.280752] e820: reserve RAM buffer [mem 0x40dfaf000-0x40fffffff]
> [    0.280757] e820: reserve RAM buffer [mem 0x40dfeb000-0x40fffffff]
> [    0.280761] e820: reserve RAM buffer [mem 0x42e000000-0x42fffffff]
> [    0.281325] NetLabel: Initializing
> [    0.281329] NetLabel:  domain hash size = 128
> [    0.281331] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    0.281390] NetLabel:  unlabeled traffic allowed by default
> [    0.281503] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
> [    0.282119] wmi_bus wmi_bus-PNP0C14:00: WQBC data block query control method not found
> [    0.282549] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.282576] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.285071] clocksource: Switched to clocksource tsc-early
> [    0.290212] Warning: could not register annotated branches stats
> [    0.359621] VFS: Disk quotas dquot_6.6.0
> [    0.359664] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.359905] pnp: PnP ACPI init
> [    0.360387] system 00:00: [io  0x0680-0x069f] has been reserved
> [    0.360395] system 00:00: [io  0x1000-0x100f] has been reserved
> [    0.360401] system 00:00: [io  0x1100-0x1103] has been reserved
> [    0.360407] system 00:00: [io  0xffff] has been reserved
> [    0.360413] system 00:00: [io  0x0400-0x0453] has been reserved
> [    0.360418] system 00:00: [io  0x0458-0x047f] has been reserved
> [    0.360424] system 00:00: [io  0x0500-0x057f] has been reserved
> [    0.360430] system 00:00: [io  0x164e-0x164f] has been reserved
> [    0.360458] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.360560] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.360774] system 00:02: [io  0x0454-0x0457] has been reserved
> [    0.360788] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.360988] system 00:03: [io  0x04d0-0x04d1] has been reserved
> [    0.361027] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.361194] pnp 00:04: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.361284] pnp 00:05: Plug and Play ACPI device, IDs DLL0535 PNP0f13 (active)
> [    0.364343] pnp 00:06: Plug and Play ACPI device, IDs PNP0401 (disabled)
> [    0.366665] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.366672] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.366678] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.366684] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.366689] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.366695] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.366702] system 00:07: [mem 0xfed90000-0xfed93fff] could not be reserved
> [    0.366707] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.366713] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
> [    0.366719] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.366725] system 00:07: [mem 0xd0000000-0xd0000fff] has been reserved
> [    0.366739] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.376077] pnp 00:08: Plug and Play ACPI device, IDs PNP0c31 (active)
> [    0.376101] pnp: PnP ACPI: found 9 devices
> [    0.388681] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
> [    0.388771] pci 0000:00:01.0: PCI bridge to [bus 01]
> [    0.388776] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> [    0.388782] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60fffff]
> [    0.388787] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
> [    0.388794] pci 0000:00:1c.0: PCI bridge to [bus 02]
> [    0.388819] pci 0000:00:1c.1: PCI bridge to [bus 03]
> [    0.388831] pci 0000:00:1c.1:   bridge window [mem 0xf7600000-0xf76fffff]
> [    0.388847] pci 0000:00:1c.2: PCI bridge to [bus 04-07]
> [    0.388854] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
> [    0.388864] pci 0000:00:1c.2:   bridge window [mem 0xf6b00000-0xf74fffff]
> [    0.388872] pci 0000:00:1c.2:   bridge window [mem 0xf2b00000-0xf34fffff 64bit pref]
> [    0.388884] pci 0000:00:1c.3: PCI bridge to [bus 08-0b]
> [    0.388889] pci 0000:00:1c.3:   bridge window [io  0xc000-0xcfff]
> [    0.388899] pci 0000:00:1c.3:   bridge window [mem 0xf6100000-0xf6afffff]
> [    0.388907] pci 0000:00:1c.3:   bridge window [mem 0xf2100000-0xf2afffff 64bit pref]
> [    0.388919] pci 0000:00:1c.5: PCI bridge to [bus 0c]
> [    0.388929] pci 0000:00:1c.5:   bridge window [mem 0xf7500000-0xf75fffff]
> [    0.388946] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [    0.388950] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [    0.388954] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
> [    0.388957] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
> [    0.388961] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
> [    0.388964] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
> [    0.388968] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
> [    0.388972] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
> [    0.388975] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
> [    0.388979] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
> [    0.388983] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
> [    0.388986] pci_bus 0000:00: resource 15 [mem 0xd0000000-0xfeafffff window]
> [    0.388990] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> [    0.388994] pci_bus 0000:01: resource 1 [mem 0xf5000000-0xf60fffff]
> [    0.388997] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
> [    0.389022] pci_bus 0000:03: resource 1 [mem 0xf7600000-0xf76fffff]
> [    0.389026] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
> [    0.389029] pci_bus 0000:04: resource 1 [mem 0xf6b00000-0xf74fffff]
> [    0.389033] pci_bus 0000:04: resource 2 [mem 0xf2b00000-0xf34fffff 64bit pref]
> [    0.389037] pci_bus 0000:08: resource 0 [io  0xc000-0xcfff]
> [    0.389040] pci_bus 0000:08: resource 1 [mem 0xf6100000-0xf6afffff]
> [    0.389044] pci_bus 0000:08: resource 2 [mem 0xf2100000-0xf2afffff 64bit pref]
> [    0.389047] pci_bus 0000:0c: resource 1 [mem 0xf7500000-0xf75fffff]
> [    0.389662] NET: Registered protocol family 2
> [    0.390207] tcp_listen_portaddr_hash hash table entries: 8192 (order: 7, 720896 bytes)
> [    0.390683] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.391086] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
> [    0.392888] TCP: Hash tables configured (established 131072 bind 32768)
> [    0.393137] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
> [    0.394144] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
> [    0.395320] NET: Registered protocol family 1
> [    0.416598] pci 0000:00:1a.0: quirk_usb_early_handoff+0x0/0x71a took 17777 usecs
> [    0.434595] pci 0000:00:1d.0: quirk_usb_early_handoff+0x0/0x71a took 17533 usecs
> [    0.434636] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> [    0.434671] pci 0000:01:00.1: Linked as a consumer to 0000:01:00.0
> [    0.434815] PCI: CLS mismatch (64 != 32), using 64 bytes
> [    0.435143] Unpacking initramfs...
> [    1.837656] Freeing initrd memory: 12052K
> [    1.837761] DMAR: No ATSR found
> [    1.837937] DMAR: dmar0: Using Queued invalidation
> [    1.837980] DMAR: Setting RMRR:
> [    1.838237] DMAR: Setting identity map for device 0000:00:14.0 [0xce715000 - 0xce734fff]
> [    1.838397] DMAR: Setting identity map for device 0000:00:1a.0 [0xce715000 - 0xce734fff]
> [    1.838529] DMAR: Setting identity map for device 0000:00:1d.0 [0xce715000 - 0xce734fff]
> [    1.838547] DMAR: Prepare 0-16MiB unity mapping for LPC
> [    1.838694] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> [    1.838805] DMAR: Intel(R) Virtualization Technology for Directed I/O
> [    1.838982] iommu: Adding device 0000:00:00.0 to group 0
> [    1.839074] iommu: Adding device 0000:00:01.0 to group 1
> [    1.839123] iommu: Adding device 0000:00:14.0 to group 2
> [    1.839190] iommu: Adding device 0000:00:16.0 to group 3
> [    1.839238] iommu: Adding device 0000:00:19.0 to group 4
> [    1.839286] iommu: Adding device 0000:00:1a.0 to group 5
> [    1.839336] iommu: Adding device 0000:00:1b.0 to group 6
> [    1.839384] iommu: Adding device 0000:00:1c.0 to group 7
> [    1.839435] iommu: Adding device 0000:00:1c.1 to group 8
> [    1.839484] iommu: Adding device 0000:00:1c.2 to group 9
> [    1.839533] iommu: Adding device 0000:00:1c.3 to group 10
> [    1.839581] iommu: Adding device 0000:00:1c.5 to group 11
> [    1.839631] iommu: Adding device 0000:00:1d.0 to group 12
> [    1.839731] iommu: Adding device 0000:00:1f.0 to group 13
> [    1.839779] iommu: Adding device 0000:00:1f.2 to group 13
> [    1.839827] iommu: Adding device 0000:00:1f.3 to group 13
> [    1.839848] iommu: Adding device 0000:01:00.0 to group 1
> [    1.839872] iommu: Adding device 0000:01:00.1 to group 1
> [    1.839920] iommu: Adding device 0000:03:00.0 to group 14
> [    1.839968] iommu: Adding device 0000:0c:00.0 to group 15
> [    1.846429] RAPL PMU: API unit is 2^-32 Joules, 3 fixed counters, 163840 ms ovfl timer
> [    1.846432] RAPL PMU: hw unit of domain pp0-core 2^-16 Joules
> [    1.846435] RAPL PMU: hw unit of domain package 2^-16 Joules
> [    1.846438] RAPL PMU: hw unit of domain pp1-gpu 2^-16 Joules
> [    1.848846] cryptomgr_test (55) used greatest stack depth: 14352 bytes left
> [    1.850687] Initialise system trusted keyrings
> [    1.850882] workingset: timestamp_bits=46 max_order=22 bucket_order=0
> [    1.851129] zbud: loaded
> [    1.851926] pstore: using deflate compression
> [    1.852139] SELinux:  Registering netfilter hooks
> [    1.853334] cryptomgr_test (57) used greatest stack depth: 14064 bytes left
> [    1.858646] Key type asymmetric registered
> [    1.858664] Asymmetric key parser 'x509' registered
> [    1.858689] io scheduler noop registered
> [    1.858694] io scheduler deadline registered
> [    1.858728] io scheduler cfq registered (default)
> [    1.858847] atomic64_test: passed for x86-64 platform with CX8 and with SSE
> [    1.863448] efifb: probing for efifb
> [    1.863490] efifb: framebuffer at 0xe0000000, using 8100k, total 8100k
> [    1.863494] efifb: mode is 1920x1080x32, linelength=7680, pages=1
> [    1.863497] efifb: scrolling: redraw
> [    1.863500] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    1.869999] Console: switching to colour frame buffer device 240x67
> [    1.875932] fb0: EFI VGA frame buffer device
> [    1.875965] intel_idle: MWAIT substates: 0x21120
> [    1.875968] intel_idle: v0.4.1 model 0x3A
> [    1.876807] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    2.296273] ACPI: AC Adapter [AC] (off-line)
> [    2.296559] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    2.296567] ACPI: Lid Switch [LID0]
> [    2.296702] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> [    2.296726] ACPI: Power Button [PBTN]
> [    2.296868] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
> [    2.296876] ACPI: Sleep Button [SBTN]
> [    2.297035] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> [    2.297042] ACPI: Power Button [PWRF]
> [    2.301507] ACPI: Video Device [VID] (multi-head: yes  rom: yes  post: no)
> [    2.303890] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:14/LNXVIDEO:00/input/input4
> [    2.312351] thermal LNXTHERM:00: registered as thermal_zone0
> [    2.312355] ACPI: Thermal Zone [THM] (38 C)
> [    2.313097] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> [    2.316089] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [    2.321700] tpm_tis 00:08: 1.2 TPM (device-id 0x3204, rev-id 64)
> [    2.384677] ACPI: Battery Slot [BAT0] (battery present)
> [    2.386295] loop: module loaded
> [    2.387443] zram: Added device: zram0
> [    2.391425] ACPI: Battery Slot [BAT1] (battery absent)
> [    2.395943] ACPI: Battery Slot [BAT2] (battery absent)
> [    2.401129] ahci 0000:00:1f.2: version 3.0
> [    2.401928] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> [    2.401970] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x33 impl SATA mode
> [    2.401975] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
> [    2.416908] scsi host0: ahci
> [    2.417588] scsi host1: ahci
> [    2.418139] scsi host2: ahci
> [    2.418596] scsi host3: ahci
> [    2.419029] scsi host4: ahci
> [    2.419462] scsi host5: ahci
> [    2.419656] ata1: SATA max UDMA/133 abar m2048@0xf7736000 port 0xf7736100 irq 26
> [    2.419664] ata2: SATA max UDMA/133 abar m2048@0xf7736000 port 0xf7736180 irq 26
> [    2.419667] ata3: DUMMY
> [    2.419669] ata4: DUMMY
> [    2.419676] ata5: SATA max UDMA/133 abar m2048@0xf7736000 port 0xf7736300 irq 26
> [    2.419680] ata6: SATA max UDMA/133 abar m2048@0xf7736000 port 0xf7736380 irq 26
> [    2.420424] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    2.420428] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    2.421198] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    2.561313] e1000e 0000:00:19.0 0000:00:19.0 (uninitialized): registered PHC clock
> [    2.682275] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) f0:1f:af:0c:8a:da
> [    2.682315] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    2.682356] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: 7011FF-0FF
> [    2.682429] PPP generic driver version 2.4.2
> [    2.682781] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    2.682785] ehci-pci: EHCI PCI platform driver
> [    2.683474] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    2.683801] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    2.683846] ehci-pci 0000:00:1a.0: debug port 2
> [    2.687819] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    2.687898] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7738000
> [    2.694078] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    2.694356] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.694365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.694368] usb usb1: Product: EHCI Host Controller
> [    2.694372] usb usb1: Manufacturer: Linux 4.16.0-rc7-next-20180327-dirty ehci_hcd
> [    2.694376] usb usb1: SerialNumber: 0000:00:1a.0
> [    2.695129] hub 1-0:1.0: USB hub found
> [    2.695187] hub 1-0:1.0: 2 ports detected
> [    2.696675] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    2.696900] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    2.696926] ehci-pci 0000:00:1d.0: debug port 2
> [    2.700878] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    2.700932] ehci-pci 0000:00:1d.0: irq 21, io mem 0xf7737000
> [    2.707150] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    2.707397] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.707403] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.707407] usb usb2: Product: EHCI Host Controller
> [    2.707411] usb usb2: Manufacturer: Linux 4.16.0-rc7-next-20180327-dirty ehci_hcd
> [    2.707415] usb usb2: SerialNumber: 0000:00:1d.0
> [    2.708133] hub 2-0:1.0: USB hub found
> [    2.708169] hub 2-0:1.0: 2 ports detected
> [    2.708868] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    2.708897] ohci-pci: OHCI PCI platform driver
> [    2.708946] uhci_hcd: USB Universal Host Controller Interface driver
> [    2.709671] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    2.709935] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
> [    2.711159] xhci_hcd 0000:00:14.0: hcc params 0x20007181 hci version 0x100 quirks 0x0000b930
> [    2.711173] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> [    2.711810] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    2.711815] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.711819] usb usb3: Product: xHCI Host Controller
> [    2.711823] usb usb3: Manufacturer: Linux 4.16.0-rc7-next-20180327-dirty xhci-hcd
> [    2.711826] usb usb3: SerialNumber: 0000:00:14.0
> [    2.712369] hub 3-0:1.0: USB hub found
> [    2.712440] hub 3-0:1.0: 4 ports detected
> [    2.714434] xhci_hcd 0000:00:14.0: xHCI Host Controller
> [    2.714740] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
> [    2.714752] xhci_hcd 0000:00:14.0: Host supports USB 3.0  SuperSpeed
> [    2.714980] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    2.714987] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    2.714990] usb usb4: Product: xHCI Host Controller
> [    2.714994] usb usb4: Manufacturer: Linux 4.16.0-rc7-next-20180327-dirty xhci-hcd
> [    2.714997] usb usb4: SerialNumber: 0000:00:14.0
> [    2.715653] hub 4-0:1.0: USB hub found
> [    2.715712] hub 4-0:1.0: 4 ports detected
> [    2.717877] usbcore: registered new interface driver usb-storage
> [    2.717967] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> [    2.718538] i8042: Warning: Keylock active
> [    2.720892] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    2.721128] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    2.721455] mousedev: PS/2 mouse device common for all mice
> [    2.722860] rtc_cmos 00:01: RTC can wake from S4
> [    2.723277] rtc_cmos 00:01: registered as rtc0
> [    2.723356] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    2.723409] i2c /dev entries driver
> [    2.724210] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
> [    2.724916] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    2.725777] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    2.733220] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [    2.733227] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> [    2.733232] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
> [    2.733578] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    2.735622] ata1.00: ATA-8: ST500LX003-1AC15G, DEM4, max UDMA/133
> [    2.735631] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    2.743036] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> [    2.743046] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> [    2.743055] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
> [    2.743330] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    2.745493] ata1.00: configured for UDMA/133
> [    2.747325] scsi 0:0:0:0: Direct-Access     ATA      ST500LX003-1AC15 DEM4 PQ: 0 ANSI: 5
> [    2.748823] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/466 GiB)
> [    2.748837] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    2.748910] sd 0:0:0:0: [sda] Write Protect is off
> [    2.748917] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    2.749059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    2.755524]  sda: sda1 sda2 sda3
> [    2.756442] usbcore: registered new interface driver uvcvideo
> [    2.756448] USB Video Class driver (1.1.1)
> [    2.757952] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.761080] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> [    2.761159] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
> [    2.761657] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> [    2.761688] iTCO_vendor_support: vendor-support=0
> [    2.761716] device-mapper: uevent: version 1.0.3
> [    2.761935] device-mapper: ioctl: 4.38.0-ioctl (2018-02-28) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> [    2.761949] intel_pstate: Intel P-state driver initializing
> [    2.762623] sdhci: Secure Digital Host Controller Interface driver
> [    2.762629] sdhci: Copyright(c) Pierre Ossman
> [    2.762743] sdhci-pci 0000:0c:00.0: SDHCI controller found [1217:8221] (rev 5)
> [    2.762884] sdhci-pci 0000:0c:00.0: enabling device (0100 -> 0102)
> [    2.764062] mmc0 bounce up to 128 segments into one, max segment size 65536 bytes
> [    2.765254] mmc0: SDHCI controller on PCI [0000:0c:00.0] using DMA
> [    2.765669] sdhci-pltfm: SDHCI platform and OF driver helper
> [    2.765853] EFI Variables Facility v0.08 2004-May-17
> [    2.778901] pstore: Registered efi as persistent store backend
> [    2.778938] hidraw: raw HID events driver (C) Jiri Kosina
> [    2.779029] usbcore: registered new interface driver usbhid
> [    2.779031] usbhid: USB HID core driver
> [    2.781172] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
> [    2.781300] snd_hda_intel 0000:01:00.1: Disabling MSI
> [    2.782352] Initializing XFRM netlink socket
> [    2.782445] NET: Registered protocol family 10
> [    2.783368] Segment Routing with IPv6
> [    2.783650] NET: Registered protocol family 17
> [    2.783666] NET: Registered protocol family 15
> [    2.783685] sctp: Hash tables configured (bind 32/51)
> [    2.783792] Key type dns_resolver registered
> [    2.783796] start plist test
> [    2.789634] snd_hda_codec_idt hdaudioC0D0: autoconfig for 92HD93BXX: line_outs=1 (0xe/0x0/0x0/0x0/0x0) type:line
> [    2.789645] snd_hda_codec_idt hdaudioC0D0:    speaker_outs=1 (0xd/0x0/0x0/0x0/0x0)
> [    2.789651] snd_hda_codec_idt hdaudioC0D0:    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
> [    2.789656] snd_hda_codec_idt hdaudioC0D0:    mono: mono_out=0x0
> [    2.789662] snd_hda_codec_idt hdaudioC0D0:    inputs:
> [    2.789668] snd_hda_codec_idt hdaudioC0D0:      Dock Mic=0xf
> [    2.789674] snd_hda_codec_idt hdaudioC0D0:      Internal Mic=0x11
> [    2.789679] snd_hda_codec_idt hdaudioC0D0:      Headset Mic=0xa
> [    2.791587] end plist test
> [    2.792771] microcode: sig=0x306a9, pf=0x10, revision=0x1f
> [    2.793040] microcode: Microcode Update Driver: v2.2.
> [    2.793106] sched_clock: Marking stable (2793008113, 0)->(2801139402, -8131289)
> [    2.793894] registered taskstats version 1
> [    2.793949] Loading compiled-in X.509 certificates
> [    2.797686] modprobe (130) used greatest stack depth: 13408 bytes left
> [    2.801984] Loaded X.509 cert 'Magrathea: Glacier signing key: bb72777f81e5af93500bb2beebab944a32df62b5'
> [    2.802118] zswap: loaded using pool lzo/zbud
> [    2.814325] Key type big_key registered
> [    2.818543] input: HDA Intel PCH Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [    2.818983] input: HDA Intel PCH Headset Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [    2.819363] input: HDA Intel PCH Dock Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    2.819739] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [    2.821061] Key type encrypted registered
> [    2.822397] console [netcon0] enabled
> [    2.822400] netconsole: network logging started
> [    2.822478] rtc_cmos 00:01: setting system clock to 2018-03-29 14:50:55 UTC (1522335055)
> [    2.822805] cfg80211: Loading compiled-in X.509 certificates for regulatory database
> [    2.827660] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [    2.827713] ALSA device list:
> [    2.827716]   #0: HDA Intel PCH at 0xf7730000 irq 29
> [    2.828155] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
> [    2.828174] cfg80211: failed to load regulatory.db
> [    2.848296] tsc: Refined TSC clocksource calibration: 2691.258 MHz
> [    2.848334] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x26cafc29fa8, max_idle_ns: 440795270837 ns
> [    2.848588] clocksource: Switched to clocksource tsc
> [    3.019064] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    3.035123] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    3.037210] snd_hda_codec_generic hdaudioC1D0: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
> [    3.037225] snd_hda_codec_generic hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.037234] snd_hda_codec_generic hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.037242] snd_hda_codec_generic hdaudioC1D0:    mono: mono_out=0x0
> [    3.037249] snd_hda_codec_generic hdaudioC1D0:    dig-out=0x5/0x0
> [    3.037256] snd_hda_codec_generic hdaudioC1D0:    inputs:
> [    3.054662] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.056612] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ8C2, 1.02, max UDMA/133
> [    3.060153] ata2.00: configured for UDMA/133
> [    3.065393] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ8C2    1.02 PQ: 0 ANSI: 5
> [    3.075215] snd_hda_codec_generic hdaudioC1D1: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
> [    3.075230] snd_hda_codec_generic hdaudioC1D1:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.075239] snd_hda_codec_generic hdaudioC1D1:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.075247] snd_hda_codec_generic hdaudioC1D1:    mono: mono_out=0x0
> [    3.075254] snd_hda_codec_generic hdaudioC1D1:    dig-out=0x5/0x0
> [    3.075261] snd_hda_codec_generic hdaudioC1D1:    inputs:
> [    3.106739] sr 1:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    3.106751] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    3.107771] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.112195] snd_hda_codec_generic hdaudioC1D2: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
> [    3.112211] snd_hda_codec_generic hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.112219] snd_hda_codec_generic hdaudioC1D2:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.112225] snd_hda_codec_generic hdaudioC1D2:    mono: mono_out=0x0
> [    3.112242] snd_hda_codec_generic hdaudioC1D2:    dig-out=0x5/0x0
> [    3.112249] snd_hda_codec_generic hdaudioC1D2:    inputs:
> [    3.148364] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    3.148390] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    3.150115] snd_hda_codec_generic hdaudioC1D3: autoconfig for Generic: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
> [    3.150118] hub 1-1:1.0: USB hub found
> [    3.150128] snd_hda_codec_generic hdaudioC1D3:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.150167] snd_hda_codec_generic hdaudioC1D3:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    3.150175] snd_hda_codec_generic hdaudioC1D3:    mono: mono_out=0x0
> [    3.150183] snd_hda_codec_generic hdaudioC1D3:    dig-out=0x5/0x0
> [    3.150190] snd_hda_codec_generic hdaudioC1D3:    inputs:
> [    3.150501] hub 1-1:1.0: 6 ports detected
> [    3.165980] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    3.165989] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    3.167083] hub 2-1:1.0: USB hub found
> [    3.167329] hub 2-1:1.0: 8 ports detected
> [    3.184536] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
> [    3.185135] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
> [    3.185720] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
> [    3.186377] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
> [    3.333672] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input7
> [    3.416091] ata5: SATA link down (SStatus 0 SControl 300)
> [    3.424189] usb 1-1.2: new high-speed USB device number 3 using ehci-pci
> [    3.440178] usb 2-1.8: new full-speed USB device number 3 using ehci-pci
> [    3.471191] usb 3-1: new low-speed USB device number 2 using xhci_hcd
> [    3.524311] usb 1-1.2: New USB device found, idVendor=13b1, idProduct=003e
> [    3.524325] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.524334] usb 1-1.2: Product: Linksys AE6000
> [    3.524342] usb 1-1.2: Manufacturer: Cisco
> [    3.524350] usb 1-1.2: SerialNumber: 0009
> [    3.544086] usb 2-1.8: New USB device found, idVendor=0a5c, idProduct=5801
> [    3.544101] usb 2-1.8: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.544110] usb 2-1.8: Product: 5880
> [    3.544118] usb 2-1.8: Manufacturer: Broadcom Corp
> [    3.544125] usb 2-1.8: SerialNumber: 0123456789ABCD
> [    3.544913] usb 2-1.8: config 0 descriptor??
> [    3.614393] usb 3-1: New USB device found, idVendor=045e, idProduct=0023
> [    3.614407] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.614416] usb 3-1: Product: Microsoft Trackball Optical®
> [    3.614424] usb 3-1: Manufacturer: Microsoft
> [    3.624796] input: Microsoft Microsoft Trackball Optical® as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.0/0003:045E:0023.0001/input/input16
> [    3.626655] hid-generic 0003:045E:0023.0001: input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft Trackball Optical®] on usb-0000:00:14.0-1/input0
> [    3.728120] ata6: SATA link down (SStatus 0 SControl 300)
> [    3.740388] Freeing unused kernel memory: 3784K
> [    3.740393] Write protecting the kernel read-only data: 30720k
> [    3.741855] Freeing unused kernel memory: 2012K
> [    3.745382] Freeing unused kernel memory: 1672K
> [    3.745769] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    3.745772] x86/mm: Checking user space page tables
> [    3.745823] x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [    3.798862] systemd[1]: systemd 238 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
> [    3.811514] systemd[1]: Detected architecture x86-64.
> [    3.811535] systemd[1]: Running in initial RAM disk.
> [    3.817275] systemd[1]: Set hostname to <turing-police.cc.vt.edu>.
> [    3.817781] ================================================================================
> [    3.817858] UBSAN: Undefined behaviour in net/ipv6/route.c:413:2
> [    3.817900] member access within null pointer of type 'struct rt6_info'
> [    3.817945] CPU: 1 PID: 1 Comm: systemd Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [    3.817948] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    3.817950] Call Trace:
> [    3.817957]  dump_stack+0x83/0xca
> [    3.817966]  ubsan_epilogue+0xd/0x3a
> [    3.817971]  handle_null_ptr_deref+0x85/0x90
> [    3.817976]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [    3.817985]  ip6_dst_destroy+0xd4/0xf0
> [    3.817991]  dst_destroy+0x50/0x130
> [    3.817997]  dst_release_immediate+0x47/0x5c
> [    3.818002]  ip6_route_info_create+0x123/0xf10
> [    3.818016]  ip6_route_add+0x3c/0xf0
> [    3.818025]  addrconf_prefix_route+0xc9/0x180
> [    3.818047]  inet6_addr_add+0x30d/0x360
> [    3.818059]  inet6_rtm_newaddr+0x50b/0x7d0
> [    3.818078]  rtnetlink_rcv_msg+0x1c1/0x5e0
> [    3.818088]  ? rtnetlink_put_metrics+0x290/0x290
> [    3.818093]  netlink_rcv_skb+0x4d/0x140
> [    3.818103]  rtnetlink_rcv+0x15/0x20
> [    3.818106]  netlink_unicast+0x215/0x340
> [    3.818115]  netlink_sendmsg+0x2ee/0x6b0
> [    3.818127]  sock_sendmsg+0x6a/0xf0
> [    3.818133]  __sys_sendto+0x15d/0x220
> [    3.818154]  ? do_syscall_64+0x43/0xe4d
> [    3.818162]  SyS_sendto+0xe/0x20
> [    3.818165]  do_syscall_64+0xb7/0xe4d
> [    3.818172]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [    3.818182]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [    3.818185] RIP: 0033:0x7fb92c516174
> [    3.818188] RSP: 002b:00007ffe332ab508 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> [    3.818192] RAX: ffffffffffffffda RBX: 000056069dd124c0 RCX: 00007fb92c516174
> [    3.818195] RDX: 000000000000002c RSI: 000056069dd126c0 RDI: 0000000000000004
> [    3.818197] RBP: 000056069dd12770 R08: 00007ffe332ab510 R09: 0000000000000010
> [    3.818199] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe332ab574
> [    3.818201] R13: 000056069c5980f0 R14: 00007ffe332ab620 R15: 000056069dd122e0
> [    3.818216] ================================================================================
> [    3.818618] ================================================================================
> [    3.818676] UBSAN: Undefined behaviour in net/ipv4/fib_trie.c:504:6
> [    3.818717] member access within null pointer of type 'struct tnode'
> [    3.818761] CPU: 1 PID: 1 Comm: systemd Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [    3.818763] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    3.818765] Call Trace:
> [    3.818770]  dump_stack+0x83/0xca
> [    3.818777]  ubsan_epilogue+0xd/0x3a
> [    3.818781]  handle_null_ptr_deref+0x85/0x90
> [    3.818787]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [    3.818795]  tnode_free+0xdf/0x130
> [    3.818802]  replace+0xc7/0x290
> [    3.818811]  resize+0x717/0x1080
> [    3.818820]  ? put_child+0x9d/0x3e0
> [    3.818829]  fib_insert_alias+0x3da/0x900
> [    3.818840]  fib_table_insert+0x20e/0x690
> [    3.818855]  fib_magic+0x187/0x310
> [    3.818873]  fib_add_ifaddr+0x15d/0x1a0
> [    3.818880]  fib_netdev_event+0xb1/0x250
> [    3.818887]  notifier_call_chain+0x4b/0x160
> [    3.818896]  raw_notifier_call_chain+0x2e/0x50
> [    3.818902]  call_netdevice_notifiers_info+0x66/0x110
> [    3.818910]  __dev_notify_flags+0x6a/0x120
> [    3.818915]  ? sched_clock_cpu+0x16b/0x1e0
> [    3.818922]  dev_change_flags+0x62/0x90
> [    3.818930]  do_setlink+0x3c5/0x1b20
> [    3.818934]  ? cyc2ns_read_end+0x22/0x30
> [    3.818938]  ? native_sched_clock+0x95/0x100
> [    3.818949]  ? sched_clock_cpu+0x16b/0x1e0
> [    3.818952]  ? sched_clock_cpu+0x16b/0x1e0
> [    3.818960]  ? __lock_acquire+0x291/0x18c0
> [    3.818964]  ? cyc2ns_read_end+0x22/0x30
> [    3.818969]  ? nla_parse+0xce/0x1e0
> [    3.818977]  rtnl_setlink+0x12e/0x1e0
> [    3.819016]  rtnetlink_rcv_msg+0x1c1/0x5e0
> [    3.819026]  ? rtnetlink_put_metrics+0x290/0x290
> [    3.819032]  netlink_rcv_skb+0x4d/0x140
> [    3.819041]  rtnetlink_rcv+0x15/0x20
> [    3.819044]  netlink_unicast+0x215/0x340
> [    3.819053]  netlink_sendmsg+0x2ee/0x6b0
> [    3.819065]  sock_sendmsg+0x6a/0xf0
> [    3.819071]  __sys_sendto+0x15d/0x220
> [    3.819091]  ? do_syscall_64+0x43/0xe4d
> [    3.819098]  SyS_sendto+0xe/0x20
> [    3.819102]  do_syscall_64+0xb7/0xe4d
> [    3.819109]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [    3.819119]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [    3.819122] RIP: 0033:0x7fb92c516174
> [    3.819125] RSP: 002b:00007ffe332ab508 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> [    3.819129] RAX: ffffffffffffffda RBX: 000056069dd124c0 RCX: 00007fb92c516174
> [    3.819131] RDX: 0000000000000020 RSI: 000056069dd12310 RDI: 0000000000000004
> [    3.819133] RBP: 000056069dd12770 R08: 00007ffe332ab510 R09: 0000000000000010
> [    3.819136] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe332ab574
> [    3.819138] R13: 000056069c5980f0 R14: 00007ffe332ab640 R15: 000056069dd12bb0
> [    3.819153] ================================================================================
> [    3.844389] ln (161) used greatest stack depth: 12880 bytes left
> [    3.977471] systemd[1]: Reached target Slices.
> [    3.977901] systemd[1]: Listening on Journal Socket (/dev/log).
> [    3.977919] systemd[1]: Reached target Swap.
> [    3.981502] systemd[1]: Created slice system-systemd\x2dcryptsetup.slice.
> [    3.981835] systemd[1]: Listening on udev Control Socket.
> [    3.982195] systemd[1]: Listening on Journal Socket.
> [    4.042198] audit: type=1130 audit(1522335056.718:2): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.049881] audit: type=1130 audit(1522335056.726:3): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.054149] systemd-tmpfile (188) used greatest stack depth: 12808 bytes left
> [    4.059273] audit: type=1130 audit(1522335056.736:4): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-tmpfiles-setup-dev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.060405] ================================================================================
> [    4.060555] UBSAN: Undefined behaviour in kernel/params.c:582:43
> [    4.060638] member access within null pointer of type 'struct module'
> [    4.060735] CPU: 3 PID: 194 Comm: systemd-vconsol Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [    4.060739] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [    4.060743] Call Trace:
> [    4.060754]  dump_stack+0x83/0xca
> [    4.060769]  ubsan_epilogue+0xd/0x3a
> [    4.060778]  handle_null_ptr_deref+0x85/0x90
> [    4.060790]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [    4.060805]  param_attr_store+0x16c/0x1c0
> [    4.060819]  module_attr_store+0x30/0x70
> [    4.060827]  ? sysfs_file_ops+0x6a/0x100
> [    4.060837]  sysfs_kf_write+0x68/0xc0
> [    4.060848]  ? sysfs_file_ops+0x100/0x100
> [    4.060855]  kernfs_fop_write+0x1a8/0x2c0
> [    4.060862]  ? rcu_read_lock_sched_held+0x78/0x80
> [    4.060877]  __vfs_write+0x3e/0xc0
> [    4.060890]  vfs_write+0x18e/0x3c0
> [    4.060907]  ksys_write+0x58/0xc0
> [    4.060922]  SyS_write+0xe/0x10
> [    4.060929]  do_syscall_64+0xb7/0xe4d
> [    4.060944]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [    4.060963]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [    4.060970] RIP: 0033:0x7f572fe72324
> [    4.060975] RSP: 002b:00007ffe493f6338 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [    4.060983] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f572fe72324
> [    4.060988] RDX: 0000000000000002 RSI: 00005555a4e49b80 RDI: 0000000000000005
> [    4.060992] RBP: 00005555a4e49b80 R08: 000000000000000a R09: 00007f5730141190
> [    4.060997] R10: 000000000000000a R11: 0000000000000246 R12: 00005555a4e48260
> [    4.061001] R13: 0000000000000002 R14: 00007f573013c760 R15: 0000000000000002
> [    4.061034] ================================================================================
> [    4.200215] audit: type=1130 audit(1522335056.877:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.200274] audit: type=1131 audit(1522335056.877:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.291667] audit: type=1130 audit(1522335056.968:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.454936] dracut-cmdline (186) used greatest stack depth: 12472 bytes left
> [    4.457477] audit: type=1130 audit(1522335057.134:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-cmdline comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.565142] audit: type=1130 audit(1522335057.242:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-pre-udev comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.594630] audit: type=1130 audit(1522335057.271:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-udevd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    4.981955] udevadm (325) used greatest stack depth: 11784 bytes left
> [    5.082663] e1000e 0000:00:19.0 eno1: renamed from eth0
> [    5.489148] kauditd_printk_skb: 2 callbacks suppressed
> [    5.489151] audit: type=1130 audit(1522335058.166:13): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-ask-password-plymouth comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    5.604733] audit: type=1130 audit(1522335058.281:14): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    5.604761] audit: type=1131 audit(1522335058.281:15): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [    7.078194] usb 3-2: new full-speed USB device number 3 using xhci_hcd
> [    7.206705] usb 3-2: New USB device found, idVendor=1050, idProduct=0407
> [    7.206715] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    7.206721] usb 3-2: Product: Yubikey 4 OTP+U2F+CCID
> [    7.206726] usb 3-2: Manufacturer: Yubico
> [    7.206731] usb 3-2: SerialNumber: 0004612067
> [    7.214319] input: Yubico Yubikey 4 OTP+U2F+CCID as /devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/0003:1050:0407.0002/input/input17
> [    7.269377] hid-generic 0003:1050:0407.0002: input,hidraw1: USB HID v1.10 Keyboard [Yubico Yubikey 4 OTP+U2F+CCID] on usb-0000:00:14.0-2/input0
> [    7.271879] hid-generic 0003:1050:0407.0003: hidraw2: USB HID v1.10 Device [Yubico Yubikey 4 OTP+U2F+CCID] on usb-0000:00:14.0-2/input1
> [    8.686961] random: crng init done
> [   16.966372] ================================================================================
> [   16.966553] UBSAN: Undefined behaviour in lib/radix-tree.c:123:14
> [   16.966645] member access within null pointer of type 'const struct radix_tree_node'
> [   16.966759] CPU: 0 PID: 405 Comm: systemd-cryptse Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [   16.966764] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [   16.966769] Call Trace:
> [   16.966781]  dump_stack+0x83/0xca
> [   16.966797]  ubsan_epilogue+0xd/0x3a
> [   16.966806]  handle_null_ptr_deref+0x85/0x90
> [   16.966818]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [   16.966833]  __radix_tree_delete+0xea/0x110
> [   16.966850]  radix_tree_delete_item+0x5b/0xf0
> [   16.966869]  idr_remove+0x25/0x40
> [   16.966879]  ipc_rmid+0x5d/0x110
> [   16.966896]  freeary+0x5d2/0xc10
> [   16.966928]  ksys_semctl+0xc0b/0x1320
> [   16.966941]  ? current_kernel_time64+0xe1/0x110
> [   16.966954]  ? trace_hardirqs_on_caller+0x156/0x260
> [   16.966967]  ? current_kernel_time64+0x8f/0x110
> [   16.966986]  ? __audit_syscall_entry+0xf5/0x1e0
> [   16.967002]  SyS_semctl+0xe/0x10
> [   16.967010]  do_syscall_64+0xb7/0xe4d
> [   16.967026]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [   16.967048]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [   16.967056] RIP: 0033:0x7fc15b3dc049
> [   16.967061] RSP: 002b:00007ffc0e24af40 EFLAGS: 00000246 ORIG_RAX: 0000000000000042
> [   16.967070] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc15b3dc049
> [   16.967075] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [   16.967080] RBP: 000000000d4d850b R08: 0000000000000007 R09: 0000000000000006
> [   16.967085] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fc15940e8f0
> [   16.967089] R13: 000055c1b12db4d0 R14: 000055c1b12dd878 R15: 0000000000000001
> [   16.967124] ================================================================================
> [   17.243892] audit: type=1130 audit(1522335069.920:16): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-cryptsetup@luks\x2d665bb147\x2d9e39\x2d4003\x2db3ae\x2d7be925f51a97 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.223171] audit: type=1130 audit(1522335071.900:17): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.398092] audit: type=1130 audit(1522335072.074:18): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-fsck-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.446713] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
> [   19.513274] ================================================================================
> [   19.513392] UBSAN: Undefined behaviour in fs/ext4/readpage.c:129:13
> [   19.513472] member access within null pointer of type 'struct page'
> [   19.513558] CPU: 3 PID: 697 Comm: systemd-fstab-g Tainted: G                T 4.16.0-rc7-next-20180327-dirty #565
> [   19.513562] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A20 05/08/2017
> [   19.513566] Call Trace:
> [   19.513578]  dump_stack+0x83/0xca
> [   19.513592]  ubsan_epilogue+0xd/0x3a
> [   19.513601]  handle_null_ptr_deref+0x85/0x90
> [   19.513612]  __ubsan_handle_type_mismatch_v1+0x5e/0x70
> [   19.513627]  ext4_mpage_readpages+0x11fa/0x13f7
> [   19.513672]  ? __alloc_pages_nodemask+0x475/0x710
> [   19.513691]  ext4_readpages+0x62/0xd0
> [   19.513705]  __do_page_cache_readahead+0x36c/0x5d0
> [   19.513741]  ondemand_readahead+0x284/0x5e0
> [   19.513746]  ? ondemand_readahead+0x284/0x5e0
> [   19.513764]  page_cache_sync_readahead+0x50/0xa0
> [   19.513778]  generic_file_buffered_read+0x721/0x16a0
> [   19.513798]  ? native_sched_clock+0x95/0x100
> [   19.513813]  ? sched_clock_cpu+0x16b/0x1e0
> [   19.513837]  generic_file_read_iter+0x121/0x230
> [   19.513853]  ext4_file_read_iter+0xa8/0x130
> [   19.513863]  new_sync_read+0x14d/0x2d0
> [   19.513897]  __vfs_read+0x5c/0xc0
> [   19.513910]  vfs_read+0x164/0x330
> [   19.513926]  ksys_read+0x58/0xc0
> [   19.513940]  SyS_read+0xe/0x10
> [   19.513947]  do_syscall_64+0xb7/0xe4d
> [   19.513961]  ? trace_hardirqs_off_thunk+0x1a/0x1c
> [   19.513980]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> [   19.513986] RIP: 0033:0x7f1896b812e4
> [   19.513991] RSP: 002b:00007ffca2ce5b98 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> [   19.513999] RAX: ffffffffffffffda RBX: 0000562b66b4c260 RCX: 00007f1896b812e4
> [   19.514003] RDX: 0000000000001000 RSI: 0000562b66b4e7b0 RDI: 0000000000000004
> [   19.514008] RBP: 0000000000000d68 R08: 0000000000000003 R09: 0000000000000077
> [   19.514012] R10: 0000562b66b4c010 R11: 0000000000000246 R12: 00007f1896e4b760
> [   19.514017] R13: 00007f1896e4c2a0 R14: 0000000000000fff R15: 0000562b66b4c260
> [   19.514047] ================================================================================
> [   19.722875] audit: type=1130 audit(1522335072.399:19): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.722924] audit: type=1131 audit(1522335072.399:20): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=initrd-parse-etc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.866908] audit: type=1130 audit(1522335072.543:21): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2d00 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.918720] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
> [   19.961803] audit: type=1130 audit(1522335072.638:22): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.962060] audit: type=1131 audit(1522335072.638:23): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=systemd-sysctl comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.978026] audit: type=1130 audit(1522335072.654:24): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   19.978083] audit: type=1131 audit(1522335072.655:25): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel msg='unit=dracut-initqueue comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   20.266194] systemd-journald[191]: Received SIGTERM from PID 1 (systemd).
> [   20.439273] systemd: 16 output lines suppressed due to ratelimiting
> [   21.920105] SELinux: 32768 avtab hash slots, 74868 rules.
> [   21.964699] SELinux: 32768 avtab hash slots, 74868 rules.
> [   22.047458] SELinux:  7 users, 14 roles, 3906 types, 270 bools, 16 sens, 1024 cats
> [   22.047466] SELinux:  129 classes, 74868 rules
> [   22.063289] SELinux:  Permission name_connect in class sctp_socket not defined in policy.
> [   22.063294] SELinux:  Permission association in class sctp_socket not defined in policy.
> [   22.063353] SELinux:  Class bpf not defined in policy.
> [   22.063355] SELinux: the above unknown classes and permissions will be denied
> [   22.063385] SELinux:  policy capability network_peer_controls=1
> [   22.063388] SELinux:  policy capability open_perms=1
> [   22.063390] SELinux:  policy capability extended_socket_class=1
> [   22.063392] SELinux:  policy capability always_check_network=0
> [   22.063394] SELinux:  policy capability cgroup_seclabel=1
> [   22.063396] SELinux:  policy capability nnp_nosuid_transition=1
> [   22.063398] SELinux:  Completing initialization.
> [   22.063400] SELinux:  Setting up existing superblocks.
> [   22.113170] SELinux: (dev dm-3, type ext4) getxattr errno 34
> [   22.113197] SELinux: (dev dm-1, type ext4) getxattr errno 34
> [   22.142679] systemd[1]: Successfully loaded SELinux policy in 384.345ms.
> [   22.401128] systemd[1]: Relabelled /dev, /run and /sys/fs/cgroup in 46.734ms.
> [   22.450420] systemd[1]: systemd 238 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=hybrid)
> [   22.463651] systemd[1]: Detected architecture x86-64.
> [   22.470239] systemd[1]: Set hostname to <turing-police.cc.vt.edu>.
> [   22.789850] systemd-cryptse (745) used greatest stack depth: 11336 bytes left
> [   23.146719] kauditd_printk_skb: 23 callbacks suppressed
> [   23.146723] audit: type=1400 audit(1522335075.823:49): avc:  denied  { map_create } for  pid=1 comm="systemd" scontext=system_u:system_r:kernel_t:s15:c0.c1023 tcontext=system_u:system_r:kernel_t:s15:c0.c1023 tclass=bpf permissive=1
> [   23.146767] audit: type=1400 audit(1522335075.823:50): avc:  denied  { map_read map_write } for  pid=1 comm="systemd" scontext=system_u:system_r:kernel_t:s15:c0.c1023 tcontext=system_u:system_r:kernel_t:s15:c0.c1023 tclass=bpf permissive=1
> [   23.146930] audit: type=1400 audit(1522335075.823:51): avc:  denied  { prog_load } for  pid=1 comm="systemd" scontext=system_u:system_r:kernel_t:s15:c0.c1023 tcontext=system_u:system_r:kernel_t:s15:c0.c1023 tclass=bpf permissive=1
> [   23.147233] audit: type=1400 audit(1522335075.824:52): avc:  denied  { prog_run } for  pid=1 comm="systemd" scontext=system_u:system_r:kernel_t:s15:c0.c1023 tcontext=system_u:system_r:kernel_t:s15:c0.c1023 tclass=bpf permissive=1
> [   23.750831] systemd[1]: Unnecessary job for /dev/mapper/turing--police-00 was removed.
> [   23.750845] systemd[1]: Unnecessary job for dev-disk-by\x2duuid-665bb147\x2d9e39\x2d4003\x2db3ae\x2d7be925f51a97.device was removed.
> [   23.774997] audit: type=1130 audit(1522335076.451:53): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.775056] audit: type=1131 audit(1522335076.451:54): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.778494] systemd[1]: Stopped Switch Root.
> [   23.778919] audit: type=1130 audit(1522335076.455:55): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=initrd-switch-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.778952] audit: type=1131 audit(1522335076.455:56): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=initrd-switch-root comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.779371] systemd[1]: systemd-journald.service: Service has no hold-off time, scheduling restart.
> [   23.779419] systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 1.
> [   23.779449] systemd[1]: Stopped Journal Service.
> [   23.779549] audit: type=1130 audit(1522335076.456:57): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.779578] audit: type=1131 audit(1522335076.456:58): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-journald comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   23.783972] systemd[1]: Starting Journal Service...
> [   23.858769] EXT4-fs (dm-1): re-mounted. Opts: (null)
> [   23.879665] EXT4-fs (dm-3): re-mounted. Opts: (null)
> [   24.627397] udevadm (776) used greatest stack depth: 11000 bytes left
> [   25.198372] bcma-pci-bridge 0000:03:00.0: enabling device (0100 -> 0102)
> [   25.198740] bcma: bus0: Found chip with id 0x4313, rev 0x01 and package 0x08
> [   25.198782] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x24, class 0x0)
> [   25.198816] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x18, class 0x0)
> [   25.198876] bcma: bus0: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x11, class 0x0)
> [   25.211934] bcma: bus0: Bus registered
> [   25.409527] e1000e 0000:00:19.0 em1: renamed from eno1
> [   25.956101] input: Dell WMI hotkeys as /devices/platform/PNP0C14:00/wmi_bus/wmi_bus-PNP0C14:00/9DBB5994-A997-11DA-B012-B622A1EF5492/input/input18
> [   25.996287] cryptd: max_cpu_qlen set to 1000
> [   26.121735] dell_laptop: Using dell-rbtn acpi driver for receiving events
> [   26.471046] brcmsmac bcma0:1: mfg 4bf core 812 rev 24 class 0 irq 17
> [   26.474576] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [   26.511455] Adding 4079612k swap on /dev/mapper/turing--police-swap.  Priority:-2 extents:1 across:4079612k FS
> [   26.653226] brcmsmac bcma0:1 wlp3s0b1: renamed from wlan0
> [   26.825907] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [   26.863431] SELinux: (dev sda2, type ext4) getxattr errno 34
> [   28.835377] kauditd_printk_skb: 20 callbacks suppressed
> [   28.835380] audit: type=1130 audit(1522335081.512:79): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=lvm2-pvscan@253:0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.108745] audit: type=1130 audit(1522335081.781:80): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dlocal comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.120076] audit: type=1130 audit(1522335081.792:81): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dsrc comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.129200] audit: type=1130 audit(1522335081.802:82): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dvar comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.136330] audit: type=1130 audit(1522335081.813:83): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dvm comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.144845] audit: type=1130 audit(1522335081.821:84): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dopt comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.151627] audit: type=1130 audit(1522335081.828:85): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2d01 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.161755] audit: type=1130 audit(1522335081.838:86): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dmusic comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.173484] audit: type=1130 audit(1522335081.850:87): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dcatalogs comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.180903] audit: type=1130 audit(1522335081.857:88): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:kernel_t:s15:c0.c1023 msg='unit=systemd-fsck@dev-mapper-turing\x2d\x2dpolice\x2dhome comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> [   29.717406] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   29.717443] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   29.783941] EXT4-fs (dm-10): mounted filesystem with ordered data mode. Opts: (null)
> [   29.783980] SELinux: (dev dm-10, type ext4) getxattr errno 34
> [   29.941436] EXT4-fs (dm-9): mounted filesystem with ordered data mode. Opts: (null)
> [   29.941466] SELinux: (dev dm-9, type ext4) getxattr errno 34
> [   30.040298] EXT4-fs (dm-7): mounted filesystem with ordered data mode. Opts: (null)
> [   30.040326] SELinux: (dev dm-7, type ext4) getxattr errno 34
> [   30.057813] EXT4-fs (dm-5): mounted filesystem with ordered data mode. Opts: (null)
> [   30.057831] SELinux: (dev dm-5, type ext4) getxattr errno 34
> [   30.271397] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
> [   30.271436] SELinux: (dev dm-4, type ext4) getxattr errno 34
> [   30.304661] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
> [   30.304681] SELinux: (dev dm-6, type ext4) getxattr errno 34
> [   30.378592] EXT4-fs (dm-12): mounted filesystem with ordered data mode. Opts: (null)
> [   30.378608] SELinux: (dev dm-12, type ext4) getxattr errno 34
> [   30.441804] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   30.441828] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   30.468088] EXT4-fs (dm-11): mounted filesystem with ordered data mode. Opts: (null)
> [   30.468104] SELinux: (dev dm-11, type ext4) getxattr errno 34
> [   30.861590] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   30.861606] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   31.051454] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   31.051483] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   31.216168] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   31.216204] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   51.700920] kauditd_printk_skb: 3 callbacks suppressed
> [   51.700924] audit: type=1400 audit(1522335104.375:92): avc:  denied  { transition } for  pid=1114 comm="sulogin" path="/usr/bin/bash" dev="dm-1" ino=263319 scontext=system_u:system_r:kernel_t:s15:c0.c1023 tcontext=root:sysadm_r:sysadm_t:s0 tclass=process permissive=1
> [   51.701028] audit: type=1400 audit(1522335104.375:92): avc:  denied  { entrypoint } for  pid=1114 comm="sulogin" path="/usr/bin/bash" dev="dm-1" ino=263319 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:unlabeled_t:s15:c0.c1023 tclass=file permissive=1
> [   51.704229] audit: type=1400 audit(1522335104.375:92): avc:  denied  { map } for  pid=1114 comm="bash" path="/usr/bin/bash" dev="dm-1" ino=263319 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:unlabeled_t:s15:c0.c1023 tclass=file permissive=1
> [   51.704256] audit: type=1400 audit(1522335104.375:92): avc:  denied  { execute } for  pid=1114 comm="bash" path="/usr/bin/bash" dev="dm-1" ino=263319 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:unlabeled_t:s15:c0.c1023 tclass=file permissive=1
> [   51.704509] audit: type=1300 audit(1522335104.375:92): arch=c000003e syscall=59 success=yes exit=0 a0=556ac75f37b6 a1=7ffe0159b360 a2=556ac75ee7c0 a3=1 items=0 ppid=1107 pid=1114 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="bash" exe="/usr/bin/bash" subj=root:sysadm_r:sysadm_t:s0 key=(null)
> [   51.704526] audit: type=1327 audit(1522335104.375:92): proctitle="bash"
> [   51.750815] audit: type=1400 audit(1522335104.425:93): avc:  denied  { execute_no_trans } for  pid=1117 comm="bash" path="/usr/libexec/grepconf.sh" dev="dm-1" ino=263077 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:unlabeled_t:s15:c0.c1023 tclass=file permissive=1
> [   51.768112] audit: type=1300 audit(1522335104.425:93): arch=c000003e syscall=59 success=yes exit=0 a0=561e9d83f290 a1=561e9d834840 a2=561e9d8404d0 a3=8 items=0 ppid=1114 pid=1117 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="grepconf.sh" exe="/usr/bin/bash" subj=root:sysadm_r:sysadm_t:s0 key=(null)
> [   51.768167] audit: type=1327 audit(1522335104.425:93): proctitle=2F62696E2F7368002F7573722F6C6962657865632F67726570636F6E662E7368002D63
> [   54.931450] audit: type=1400 audit(1522335107.608:94): avc:  denied  { mounton } for  pid=1134 comm="mount" path="/var" dev="dm-3" ino=32001 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:unlabeled_t:s15:c0.c1023 tclass=dir permissive=1
> [   55.064210] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [   55.064231] SELinux: (dev dm-8, type ext4) getxattr errno 34
> [   77.584373] kauditd_printk_skb: 3 callbacks suppressed
> [   77.584376] audit: type=1400 audit(1522335130.261:95): avc:  denied  { write } for  pid=1140 comm="fsck.ext4" name="dm-8" dev="devtmpfs" ino=14187 scontext=root:sysadm_r:sysadm_t:s0 tcontext=system_u:object_r:fixed_disk_device_t:s15:c0.c1023 tclass=blk_file permissive=1
> [   77.584406] audit: type=1300 audit(1522335130.261:95): arch=c000003e syscall=257 success=yes exit=4 a0=ffffff9c a1=55cb8b939d80 a2=82 a3=0 items=0 ppid=1139 pid=1140 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 ses=4294967295 comm="fsck.ext4" exe="/usr/sbin/fsck.ext4" subj=root:sysadm_r:sysadm_t:s0 key=(null)
> [   77.584423] audit: type=1327 audit(1522335130.261:95): proctitle=6673636B2E65787434002F6465762F6D61707065722F747572696E672D2D706F6C6963652D766172
> [  100.253729] EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
> [  100.253760] SELinux: (dev dm-8, type ext4) getxattr errno 34
> 
