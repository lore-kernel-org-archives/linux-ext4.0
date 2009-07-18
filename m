From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
 all .data.* sections on X86_64)
Date: Sat, 18 Jul 2009 23:44:16 +0100
Message-ID: <1247957056.4236.20.camel@toshiba-laptop>
References: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
	 <1247574390.28240.67.camel@pc1117.cambridge.arm.com>
	 <20090715080336.GA4823@skywalker> <4A5D9939.3000500@fisher-privat.net>
	 <20090718115556.GA31007@elte.hu>  <4A61CE59.3030905@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>,
	"Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4A61CE59.3030905-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 2009-07-18 at 15:30 +0200, Alexey Fisher wrote:
> suddenly my kernel is not warning free... i have still warning about 
> acpi_init, cpufreg, intel_gem and inoitfy on my PC and about firmware 
> loader on my laptop. So i think there is still some job to do. I will 
> report this warnings soon.

Mine is not warning free either but they look like real leaks. There are
also a few more leaks reported by Jaswinder.

The inotify one was fixed but not in mainline yet (a fix was included in
my kmemleak-fixes branch).

What I get consistently:

unreferenced object 0xf72a9a80 (size 64):
  comm "swapper", pid 1, jiffies 4294892557
  hex dump (first 32 bytes):
    00 00 00 00 38 00 00 00 00 00 00 00 00 00 00 00  ....8...........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<c056aa8d>] kmemleak_alloc+0x3d/0x70
    [<c01e234d>] __kmalloc+0x10d/0x210
    [<c0351122>] kzalloc+0xb/0xd
    [<c0351798>] acpi_add_single_object+0x609/0xe65
    [<c03521c6>] acpi_bus_scan+0xfd/0x174
    [<c07c1629>] acpi_scan_init+0xb5/0xd5
    [<c07c140b>] acpi_init+0x21e/0x262
    [<c010112b>] do_one_initcall+0x2b/0x160
    [<c0799355>] kernel_init+0x150/0x1aa
    [<c0103e57>] kernel_thread_helper+0x7/0x10
    [<ffffffff>] 0xffffffff

Every time I kill the X server (reported here -
http://lkml.org/lkml/2009/7/8/422)

unreferenced object 0xcb5a6600 (size 44):
  comm "gdm", pid 5246, jiffies 4960
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 e4 b5 2d ca 90 4e 15 c0 83 14 00 00  ......-..N......
  backtrace:
    [<c056aa8d>] kmemleak_alloc+0x3d/0x70
    [<c01e0be6>] kmem_cache_alloc+0x156/0x1a0
    [<c01552f9>] alloc_pid+0x19/0x350
    [<c013e6f0>] copy_process+0x800/0x1230
    [<c013f18f>] do_fork+0x6f/0x370
    [<c0101986>] sys_clone+0x36/0x40
    [<c010319c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

And quite a lot of these (also reported here -
http://lkml.org/lkml/2009/7/9/110 - but the first one was fixed by
Jaswinder and included in my kmemleak-fixes branch):

unreferenced object 0xcb0166c0 (size 148):
  comm "Xorg", pid 5251, jiffies 5784
  hex dump (first 32 bytes):
    ff ff ff ff 30 7f 98 c3 00 80 18 cb 90 80 18 cb  ....0...........
    20 81 18 cb b0 81 18 cb 40 82 18 cb d0 82 18 cb   .......@.......
  backtrace:
    [<c056aa8d>] kmemleak_alloc+0x3d/0x70
    [<c01e0be6>] kmem_cache_alloc+0x156/0x1a0
    [<c0317bf0>] idr_pre_get+0x50/0x70
    [<fa448ff4>] drm_gem_handle_create+0x24/0x90 [drm]
    [<fa8b34ad>] i915_gem_create_ioctl+0x5d/0xb0 [i915]
    [<fa4477c2>] drm_ioctl+0x192/0x3a0 [drm]
    [<c01f8339>] vfs_ioctl+0x79/0x90
    [<c01f849a>] do_vfs_ioctl+0x6a/0x5e0
    [<c01f8a73>] sys_ioctl+0x63/0x70
    [<c010319c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

-- 
Catalin
