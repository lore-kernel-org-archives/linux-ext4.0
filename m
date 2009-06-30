From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Segmentation fault in e4defrag -c
Date: Wed, 01 Jul 2009 08:43:14 +0900
Message-ID: <4A4AA312.8000007@rs.jp.nec.com>
References: <20090625105558.GA21773@uio.no> <4A4487B0.9080000@sx.jp.nec.com> <20090626093816.GA3175@uio.no> <4A485929.7010403@rs.jp.nec.com> <20090629214959.GT3570@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
	Kazuya Mio <k-mio@sx.jp.nec.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56953 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZF3Xn6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jun 2009 19:43:58 -0400
In-Reply-To: <20090629214959.GT3570@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
Andreas Dilger wrote:
> On Jun 29, 2009  15:03 +0900, Akira Fujita wrote:
>>>   Size: 4050385   	Blocks: 0          IO Block: 4096   regular file
>>> Device: fd12h/64786d	Inode: 688755      Links: 1
>>> Access: (0644/-rw-r--r--)  Uid: ( 1000/   sesse)   Gid: ( 1000/   sesse)
>>> Access: 2009-05-30 03:08:38.724454316 +0200
>>> Modify: 2008-09-01 20:38:26.135589449 +0200
>>> Change: 2008-09-01 20:38:26.135589449 +0200
>> File size is "4050385" but Blocks is "0"
>> probably means blocks are not allocated yet or file is *corrupted*.
>> Is your mp3 file available?
> 
> Well, this is a sparse file for some reason (e.g. failed mp3 p2p download).
> 

Ah, may be so.

>> Anyway, with this patch, 0 blocks file is skipped,
>> therefore the segmentation fault you had will not happen.
> 
> Is it possible that the code has not been tested with sparse files?
> In that case, the check for size == 0 is only going to catch a single
> case of problem, and not handle general sparse files.
> 

I have tested files that have sparse blocks
(e.g. files that have sparse blocks in its beginning,
middle and those combinations) and got fine results.
Unfortunately, like this case, only 0 blocks file (all sparse blocks)
has not been tested yet.

But the kernel space (EXT4_IOC_MOVE_EXTENT) does not have this kind of issue.
Because there is a check of whether the extents of orig_inode
that ext4_ext_find_extent() gets is NULL.
If extents is NULL or ext4_ext_find_extent() fails,
ext4_move_extents() returns an error value (e.g. EINVAL) to the user space.

Regards,
Akira Fujita


