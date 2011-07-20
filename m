From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH bigalloc] e2fsprogs: change root-inode to extent-mapped
Date: Wed, 20 Jul 2011 10:28:57 -0400
Message-ID: <FD2C22B8-59C0-4DA9-B059-90B18D37ACE9@mit.edu>
References: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: hao.bigrat@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:56663 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab1GTO3E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jul 2011 10:29:04 -0400
In-Reply-To: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 20, 2011, at 1:38 AM, hao.bigrat@gmail.com wrote:

> From: Robin Dong <sanbai@taobao.com>
> 
> After creating more than 1000 files in root directory on ext4 of bigalloc,
> the kernel reports many error messages like:
> 
> [181126.730911] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc
> [181126.735945] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc
> 
> because the root inode of a new ext4 filesystem is type of block-mapped
> even use mke2fs with "-O extent,bigalloc".

This is fixed already in the "next" branch of e2fsprogs

http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=commit;h=1afb468b9a80031b39eab37272709f45727fb221

This commit was checked in well over a month ago.  If you're not using the latest next branch of e2fsprogs, you really should....   this wasn't the only bigalloc-related mke2fs bug that was fixed, and e2fsck should now be working as well with bigalloc.

-- Ted

