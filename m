From: Paul Slootman <paul@wurtel.net>
Subject: Re: #blocks per group too big: 37265
Date: Fri, 4 Apr 2008 11:21:20 +0200
Message-ID: <20080404092120.GA28403@msgid.wurtel.net>
References: <20080403161904.GA31670@msgid.wurtel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lw.wurtel.net ([82.192.92.211]:2925 "EHLO lw.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYDDJVZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Apr 2008 05:21:25 -0400
Received: from wurtel.local ([192.168.1.1]:40162 helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <paul@wurtel.net>)
	id 1Jhi6t-0003wm-Bj
	for linux-ext4@vger.kernel.org; Fri, 04 Apr 2008 11:21:23 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.69)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1Jhi6q-0007hU-EI
	for linux-ext4@vger.kernel.org; Fri, 04 Apr 2008 11:21:20 +0200
Content-Disposition: inline
In-Reply-To: <20080403183929.GE13486@40mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The stride parameter is the problem.  Newer versions of e2fsprogs
> don't allow a stride parameter which is too big.  If you want to do
> the perfect calculation, you take the 64k chunk size, and divide it by
> the 4k blocksize to yield a stride parameter of 16.  Actually, though,
> simply using a non-zero stride size is actually good enough --- and if
> you have a even number of RAID-5 disks, you might not need this
> parameter at all.  (It's only purpose is to perturb the location of
> the block bitmaps so that all of the bitmaps don't end up on a single
> hard drive.)

Actually, as I wrote:

>> Removing the stride option didn't help. Removing all options didn't
>> help...

I still end up with a "blocks per group" of 37265, and when mounted I'm
greeted with the message "EXT4-fs: #blocks per group too big: 37265".
Is the ext4 code in the 2.6.25-rc8 kernel too old? According to the
source the number of block per group must be <= 8 * blocksize; with 4k
blocks that would mean 32768, not 37265.

Even passing the -g option to explicitly set the blocks per group gets
ignored.


> BTW, we will be making a new snapshot for people who want to test ext4
> soon....

Kernel code and userspace utils? Or just kernel code?
Where can I find the most recent version of both? I looked at
Documentation/filesystems/ext4.txt, but I feel that's a bit outdated:

  - It's still mke2fs -j /dev/hda1

  - mount /dev/hda1 /wherever -t ext4dev

This ignores the fact you need to set the testing option...


Thanks,
Paul Slootman
