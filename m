From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 2.6.39.1: Intel I340-T4: irq/64-eth3-TxR: page allocation failure. order:1, mode:0x20
Date: Sat, 18 Jun 2011 13:44:28 -0600
Message-ID: <5286EF78-DE5C-4B3F-ACE9-EFA2CBB535EF@dilger.ca>
References: <alpine.DEB.2.02.1106172106080.7672@p34.internal.lan> <4DFCD004.5090400@teksavvy.com> <C9702C53-7906-46F5-B635-3ED698A394C2@gmail.com> <s6nmxhft4wk.fsf@blaulicht.switch.brux>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Stephan Boettcher <boettcher@physik.uni-kiel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63910 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1FRTob (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 15:44:31 -0400
In-Reply-To: <s6nmxhft4wk.fsf@blaulicht.switch.brux>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-18, at 11:39 AM, Stephan Boettcher wrote:
> Andreas Dilger <adilger@dilger.ca> writes:
>> There are a few places in the ext4 mount that are doing large
>> allocations. In some places they fall back to vmalloc, so they should
>> really be done with GFP_NOWARN.
>> 
>> A few places don't yet fall back to vmalloc(), which is a problem
>> with fragmented memory or very large filesystems. We were trying to
>> test a 192TB ext4 filesystem, but were unable to mount it without
>> patching the kernel.
> 
> :-O ...  my puny 20TB ext4 filesystem did not do something like
> this, yet.

What sort of experience do you have with using a filesystem > 20TB?
I don't think there are many users out there yet that are doing this
today, so it would be great if you could share some data with us.

So far, we've only been doing testing and benchmarking (mke2fs, e2fsck
times, IO and metadata load tests, etc) and I don't know that all of
the "real world" corner cases have been tested yet.

Cheers, Andreas





