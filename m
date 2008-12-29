From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Free blocks count wrong following shrink with resize2fs
Date: Mon, 29 Dec 2008 07:23:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0812290718130.24239@bogon.housecafe.de>
References: <alpine.DEB.2.00.0812281047450.24239@bogon.housecafe.de> <20081228221421.GB15434@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57308 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYL2GXv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Dec 2008 01:23:51 -0500
In-Reply-To: <20081228221421.GB15434@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 28 Dec 2008, Theodore Tso wrote:
> The net result is the blocks that should be released as being free
> aren't, which is what causes the e2fsck errors, which can be easily
> corrected.  It doesn't cause any other problems, though.

Aha, thanks for the explanation. I was just playing around with resize2fs, 
so no real data was at stake in this case anyway...

>> [    1.737198] EXT3-fs: hda1: couldn't mount because of unsupported optional features (240).
>> [    1.754302] EXT4-fs: barriers enabled
>
> This is normal; the kernel simply tries to mount the filesystem using
> ext3 first, so that the ext4 code only gets used for filesystems that

Ah, I see. When I disabled EXT3* in my .config, the kernel starts with 
EXT4 and the "error" goes away...

Btw, ext4 feels pretty neat already, with vanilla kernel and userland 
tools, no patches applied ...just like a *real* filesystem - great! :-)

Christian.
-- 
BOFH excuse #259:

Someone's tie is caught in the printer, and if anything else gets printed, he'll be in it too.
