From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: dax pmd fault handler never returns to userspace
Date: Wed, 18 Nov 2015 13:30:57 -0500
Message-ID: <x49poz7ma72.fsf@segfault.boston.devel.redhat.com>
References: <x49wptfnw2l.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4jnNNFAp_L5BFbP4K6vNhffELSS7g0aekhGnCadsBCfnw@mail.gmail.com>
	<20151118170014.GB10656@linux.intel.com>
	<x4937w3nqze.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-nvdimm <linux-nvdimm@ml01.01.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4grgkLTVHdGhVSOs1sXsiLQyB1ubcRvmhW=hMZnA9MnHQ@mail.gmail.com>
	(Dan Williams's message of "Wed, 18 Nov 2015 10:10:45 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> Hmm, a loop in the resource sibling list?
>
> What does /proc/iomem say?

Inline, below.

-Jeff

# cat /proc/iomem
00000000-00000fff : reserved
00001000-00092fff : System RAM
00093000-00093fff : reserved
00094000-0009ffff : System RAM
000a0000-000bffff : PCI Bus 0000:00
000c4000-000cbfff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-6b4fcfff : System RAM
  01000000-0169edea : Kernel code
  0169edeb-01b3507f : Kernel data
  01cf5000-0200ffff : Kernel bss
6b4fd000-6b97cfff : reserved
6b97d000-6b97dfff : System RAM
6b97e000-6b9fefff : reserved
6b9ff000-76d48017 : System RAM
76d48018-76d4d457 : System RAM
76d4d458-76d4e017 : System RAM
76d4e018-76d7dc57 : System RAM
76d7dc58-76d7e017 : System RAM
76d7e018-76dadc57 : System RAM
76dadc58-76dae017 : System RAM
76dae018-76dddc57 : System RAM
76dddc58-76dde017 : System RAM
76dde018-76e0dc57 : System RAM
76e0dc58-76e0e017 : System RAM
76e0e018-76e18057 : System RAM
76e18058-76e19017 : System RAM
76e19018-76e21057 : System RAM
76e21058-76e22017 : System RAM
76e22018-76e7aa57 : System RAM
76e7aa58-76e7b017 : System RAM
76e7b018-76ed3a57 : System RAM
76ed3a58-76ed4017 : System RAM
76ed4018-76ef0457 : System RAM
76ef0458-784fefff : System RAM
784ff000-791fefff : reserved
  791c9004-791c902f : APEI ERST
  791ca000-791d9fff : APEI ERST
791ff000-7b5fefff : ACPI Non-volatile Storage
7b5ff000-7b7fefff : ACPI Tables
7b7ff000-7b7fffff : System RAM
7b800000-7bffffff : RAM buffer
80000000-8fffffff : PCI MMCONFIG 0000 [bus 00-ff]
  80000000-8fffffff : reserved
90000000-c7ffbfff : PCI Bus 0000:00
  90000000-92afffff : PCI Bus 0000:01
    90000000-9000ffff : 0000:01:00.2
    91000000-91ffffff : 0000:01:00.1
      91000000-91ffffff : mgadrmfb_vram
    92000000-927fffff : 0000:01:00.1
    92800000-928fffff : 0000:01:00.2
      92800000-928fffff : hpilo
    92900000-929fffff : 0000:01:00.2
      92900000-929fffff : hpilo
    92a00000-92a7ffff : 0000:01:00.2
      92a00000-92a7ffff : hpilo
    92a80000-92a87fff : 0000:01:00.2
      92a80000-92a87fff : hpilo
    92a88000-92a8bfff : 0000:01:00.1
      92a88000-92a8bfff : mgadrmfb_mmio
    92a8c000-92a8c0ff : 0000:01:00.2
      92a8c000-92a8c0ff : hpilo
    92a8d000-92a8d1ff : 0000:01:00.0
  92b00000-92bfffff : PCI Bus 0000:02
    92b00000-92b3ffff : 0000:02:00.0
    92b40000-92b7ffff : 0000:02:00.1
    92b80000-92bbffff : 0000:02:00.2
    92bc0000-92bfffff : 0000:02:00.3
  93000000-950fffff : PCI Bus 0000:04
    93000000-937fffff : 0000:04:00.0
      93000000-937fffff : bnx2x
    93800000-93ffffff : 0000:04:00.0
      93800000-93ffffff : bnx2x
    94000000-947fffff : 0000:04:00.1
      94000000-947fffff : bnx2x
    94800000-94ffffff : 0000:04:00.1
      94800000-94ffffff : bnx2x
    95000000-9500ffff : 0000:04:00.0
      95000000-9500ffff : bnx2x
    95010000-9501ffff : 0000:04:00.1
      95010000-9501ffff : bnx2x
    95080000-950fffff : 0000:04:00.0
  95100000-951fffff : PCI Bus 0000:02
    95100000-9510ffff : 0000:02:00.3
      95100000-9510ffff : tg3
    95110000-9511ffff : 0000:02:00.3
      95110000-9511ffff : tg3
    95120000-9512ffff : 0000:02:00.3
      95120000-9512ffff : tg3
    95130000-9513ffff : 0000:02:00.2
      95130000-9513ffff : tg3
    95140000-9514ffff : 0000:02:00.2
      95140000-9514ffff : tg3
    95150000-9515ffff : 0000:02:00.2
      95150000-9515ffff : tg3
    95160000-9516ffff : 0000:02:00.1
      95160000-9516ffff : tg3
    95170000-9517ffff : 0000:02:00.1
      95170000-9517ffff : tg3
    95180000-9518ffff : 0000:02:00.1
      95180000-9518ffff : tg3
    95190000-9519ffff : 0000:02:00.0
      95190000-9519ffff : tg3
    951a0000-951affff : 0000:02:00.0
      951a0000-951affff : tg3
    951b0000-951bffff : 0000:02:00.0
      951b0000-951bffff : tg3
  95200000-953fffff : PCI Bus 0000:03
    95200000-952fffff : 0000:03:00.0
      95200000-952fffff : hpsa
    95300000-953003ff : 0000:03:00.0
      95300000-953003ff : hpsa
    95380000-953fffff : 0000:03:00.0
  95400000-954007ff : 0000:00:1f.2
    95400000-954007ff : ahci
  95401000-954013ff : 0000:00:1d.0
    95401000-954013ff : ehci_hcd
  95402000-954023ff : 0000:00:1a.0
    95402000-954023ff : ehci_hcd
  95404000-95404fff : 0000:00:05.4
c7ffc000-c7ffcfff : dmar1
c8000000-fbffbfff : PCI Bus 0000:80
  c8000000-c8000fff : 0000:80:05.4
fbffc000-fbffcfff : dmar0
fec00000-fecfffff : PNP0003:00
  fec00000-fec003ff : IOAPIC 0
  fec01000-fec013ff : IOAPIC 1
  fec40000-fec403ff : IOAPIC 2
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : PNP0103:00
fed12000-fed1200f : pnp 00:01
fed12010-fed1201f : pnp 00:01
fed1b000-fed1bfff : pnp 00:01
fed1c000-fed3ffff : pnp 00:01
  fed1f410-fed1f414 : iTCO_wdt.0.auto
fed45000-fed8bfff : pnp 00:01
fee00000-feefffff : pnp 00:01
  fee00000-fee00fff : Local APIC
ff000000-ffffffff : pnp 00:01
100000000-47fffffff : System RAM
480000000-87fffffff : Persistent Memory
  480000000-67fffffff : NVDM002C:00
    480000000-67fffffff : btt0.1
  680000000-87fffffff : NVDM002C:01
    680000000-87fffffff : namespace1.0
880000000-c7fffffff : System RAM
c80000000-107fffffff : Persistent Memory
  c80000000-e7fffffff : NVDM002C:02
    c80000000-e7fffffff : namespace2.0
  e80000000-107fffffff : NVDM002C:03
    e80000000-107fffffff : btt3.1
38000000000-39fffffffff : PCI Bus 0000:00
  39fffd00000-39fffefffff : PCI Bus 0000:04
    39fffd00000-39fffd7ffff : 0000:04:00.1
    39fffd80000-39fffdfffff : 0000:04:00.0
    39fffe00000-39fffe1ffff : 0000:04:00.1
    39fffe20000-39fffe3ffff : 0000:04:00.0
  39ffff00000-39ffff0ffff : 0000:00:14.0
    39ffff00000-39ffff0ffff : xhci-hcd
  39ffff10000-39ffff13fff : 0000:00:04.7
    39ffff10000-39ffff13fff : ioatdma
  39ffff14000-39ffff17fff : 0000:00:04.6
    39ffff14000-39ffff17fff : ioatdma
  39ffff18000-39ffff1bfff : 0000:00:04.5
    39ffff18000-39ffff1bfff : ioatdma
  39ffff1c000-39ffff1ffff : 0000:00:04.4
    39ffff1c000-39ffff1ffff : ioatdma
  39ffff20000-39ffff23fff : 0000:00:04.3
    39ffff20000-39ffff23fff : ioatdma
  39ffff24000-39ffff27fff : 0000:00:04.2
    39ffff24000-39ffff27fff : ioatdma
  39ffff28000-39ffff2bfff : 0000:00:04.1
    39ffff28000-39ffff2bfff : ioatdma
  39ffff2c000-39ffff2ffff : 0000:00:04.0
    39ffff2c000-39ffff2ffff : ioatdma
  39ffff31000-39ffff310ff : 0000:00:1f.3
3a000000000-3bfffffffff : PCI Bus 0000:80
  3bffff00000-3bffff03fff : 0000:80:04.7
    3bffff00000-3bffff03fff : ioatdma
  3bffff04000-3bffff07fff : 0000:80:04.6
    3bffff04000-3bffff07fff : ioatdma
  3bffff08000-3bffff0bfff : 0000:80:04.5
    3bffff08000-3bffff0bfff : ioatdma
  3bffff0c000-3bffff0ffff : 0000:80:04.4
    3bffff0c000-3bffff0ffff : ioatdma
  3bffff10000-3bffff13fff : 0000:80:04.3
    3bffff10000-3bffff13fff : ioatdma
  3bffff14000-3bffff17fff : 0000:80:04.2
    3bffff14000-3bffff17fff : ioatdma
  3bffff18000-3bffff1bfff : 0000:80:04.1
    3bffff18000-3bffff1bfff : ioatdma
  3bffff1c000-3bffff1ffff : 0000:80:04.0
    3bffff1c000-3bffff1ffff : ioatdma
