From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH 0/8]ext4: online defrag (ver 0.9)
Date: Fri, 30 May 2008 11:52:53 -0700
Message-ID: <1212173573.8596.84.camel@BVR-FS.beaverton.ibm.com>
References: <483FE24F.50105@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Shen Feng <shen@cn.fujitsu.com>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:35146 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYE3Sw5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 14:52:57 -0400
In-Reply-To: <483FE24F.50105@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the update.
On Fri, 2008-05-30 at 20:17 +0900, Akira Fujita wrote:
> - Current mballoc in the ext4 patch queue (linux-2.6.26-rc4) doesn't
>   work fine, ext4_mb_init_caches() which is changed by
>   ext4-add-error-handling-in-ext4-mb_laod_buddy.patch returns -EIO.
>   You can reproduce this kind of issue easily with following
> procedure.
>   1. mke2fs -j -E test_fs /devname
>   2. mount -t ext4dev -o mballoc,extents /devname /mountpoint
>   3. mkdir DIR /mountpint
>      mkdir: cannot create directory `/mnt/mp2/DIR1': No space left on
> device
> 
> 
Ccing Shen Feng for this bug...

> Next steps:
> 1. Implement FS_IOC_FIEMAP instead of EXT4_EXTENTS_INFO to reduce ioctl count.
> 2. Remove the restriction of block size (Enable defrag with 1KB and 2KB).
> 3. Remove the limit of target file size (now 128MB) in -f mode.
>    * The post about -f mode can be found at:
>    http://marc.info/?l=linux-ext4&m=118239067704899&w=4
> 
> Summary of patches:
> * The following patches are new ext4 online defrag patches.
>   Mingming, please replace these patches with the ext4 patch queue's.
> 
Done.

Regards,
Mingming

