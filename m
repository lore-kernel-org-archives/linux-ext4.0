From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: 2.6.39.1: Intel I340-T4: irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
Date: Sat, 18 Jun 2011 11:05:16 -0600
Message-ID: <C9702C53-7906-46F5-B635-3ED698A394C2@gmail.com>
References: <alpine.DEB.2.02.1106172106080.7672@p34.internal.lan> <4DFCD004.5090400@teksavvy.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-net@vger.kernel.org" <linux-net@vger.kernel.org>,
	"e1000-devel@lists.sourceforge.net"
	<e1000-devel@lists.sourceforge.net>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mark Lord <kernel@teksavvy.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34326 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1FRRFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 13:05:02 -0400
In-Reply-To: <4DFCD004.5090400@teksavvy.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-18, at 10:19 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 11-06-17 09:16 PM, Justin Piszcz wrote:
>> 
>> Kernel 2.6.39.1, x86_64.
>> Has anyone seen a page allocation failure on a NIC before?
> ..
>> [60295.925691] irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
>> [60295.945328] Pid: 2299, comm: irq/64-eth3-TxR Not tainted 2.6.39.1 #1
>> [60295.945329] Call Trace:
>> [60295.945330]  <IRQ>  [<ffffffff810882f6>] ? __alloc_pages_nodemask+0x606/0x890
>> [60295.945341]  [<ffffffff810b1435>] ? cache_alloc_refill+0x2c5/0x530
>> [60295.945343]  [<ffffffff810b180b>] ? kmem_cache_alloc+0x7b/0xa0
>> [60295.945347]  [<ffffffff815031ac>] ? sk_prot_alloc.clone.35+0x3c/0x120
>> [60295.945349]  [<ffffffff81503320>] ? sk_clone+0x10/0x2b0
>> [60295.945352]  [<ffffffff815580bb>] 
> 
> Not on a NIC, but also with 2.6.39:
> 
> [35850.612899] sd 4:0:0:0: [sdc] Attached SCSI disk
> [35943.085264] mount: page allocation failure. order:5, mode:0xc0d0
> [35943.085277] Pid: 14228, comm: mount Not tainted 2.6.39 #10
> [35943.085284] Call Trace:
> [35943.085306]  [<ffffffff8106fa96>] ? __alloc_pages_nodemask+0x710/0x74d
> [35943.085322]  [<ffffffff8106fb5b>] ? __get_free_pages+0x12/0x50
> [35943.085335]  [<ffffffff810f9120>] ? ext4_fill_super+0xe4f/0x20ff
> [35943.085347]  [<ffffffff810f82d1>] ? ext4_remount+0x40e/0x40e

There are a few places in the ext4 mount that are doing large allocations. In some places they fall back to vmalloc, so they should really be done with GFP_NOWARN.

 A few places don't yet fall back to vmalloc(), which is a problem with fragmented memory or very large filesystems. We were trying to test a 192TB ext4 filesystem, but were unable to mount it without patching the kernel.

Cheers, Andreas