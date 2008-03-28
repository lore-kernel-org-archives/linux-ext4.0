From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: mballoc errors
Date: Fri, 28 Mar 2008 15:03:51 +0100
Message-ID: <47ECFAC7.3050404@bull.net>
References: <47EAC302.5040109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45049 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbYC1ODT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Mar 2008 10:03:19 -0400
In-Reply-To: <47EAC302.5040109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> This report just came in on the fedora list...
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 717:
> 23410 blocks in bitmap, 23411 in gd
> 
> EXT4-fs error (device dm-0): ext4_mb_generate_buddy: EXT4-fs: group 721:
> 19309 blocks in bitmap, 19333 in gd
> 
> has anyone else seen this problem in testing?  I guess it means
> freespace accounting got out of sync...?
> 
I've got no problem running tests on filesystems with a 4K blocksize.
But since I work on FS with 1K blocksize, I've got the following errors
while running fsstress:

EXT4-fs error (device sdc1): ext4_ext_find_extent: bad header in inode #4407333: 
invalid magic - magic dada, entries 56026, max 56026(0), depth 56026(0)

or

EXT4-fs error (device sdc1): ext4_valid_block_bitmap: Invalid block bitmap - 
block_group = 6767, block = 55435267

I already found a bug in the patch ext4-fallocate-full-fs-ENOSPC-handling.
In the function, ext4_ext_zeroout()
       /* convert ee_pblock in 512 byte sector */
       ee_pblock = ee_pblock << (blkbits >> 9);
should be
       ee_pblock = ee_pblock << (blkbits - 9);

But after doing this change, the problems occur more quickly.
I'm not sure that the function ext4_ext_zeroout() is correct if
blocksize < pagesize.
Aneesh, could you check that please?
Thanks,
   Valerie


How I reproduce the problem:
# mkfs.ext3 -I256 -E test_fs -b 1024 /dev/sdc1
# mount -t ext4dev /dev/sdc1 /mnt/test
# fsstress -d /mnt/test -n1000 -p1000




