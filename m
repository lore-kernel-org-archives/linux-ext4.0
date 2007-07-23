From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix inode_table test in ext234_check_descriptors
Date: Mon, 23 Jul 2007 15:57:33 -0500
Message-ID: <46A5163D.803@redhat.com>
References: <46A4E254.3010606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168AbXGWVDv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 17:03:51 -0400
In-Reply-To: <46A4E254.3010606@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> ext[234]_check_descriptors sanity checks block group descriptor geometry
> at mount time, testing whether the block bitmap, inode bitmap, and
> inode table reside wholly within the blockgroup.  However, the inode
> table test is off by one so that if the last block in the inode table
> resides on the last block of the block group, the test incorrectly 
> fails.  This is because it tests the last block as (start + length)
> rather than (start + length - 1).
> 
> This can be seen by trying to mount a filesystem made such as:
>  mkfs.ext2 -F -b 1024 -m 0 -g 256 -N 3744 fsfile 1024
> which yields:
>  EXT2-fs error (device loop0): ext2_check_descriptors: Inode table for group 0 not in group (block 101)!
>  EXT2-fs: group descriptors corrupted!

Hm, sorry, after seeing Miklos' last patches... should I be sending
these as 3 different patches for ext2, 3, and 4...?

-Eric (who really doesn't want to make Andrew mad at him)  :)
