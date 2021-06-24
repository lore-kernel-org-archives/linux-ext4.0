Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2FDC49EA6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4EC613EB
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jun 2021 14:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhFXO0A (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:26:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:51524 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230008AbhFXOZ7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2021 10:25:59 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15OENTle000852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 10:23:30 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7D60115C3CD7; Thu, 24 Jun 2021 10:23:29 -0400 (EDT)
Date:   Thu, 24 Jun 2021 10:23:29 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 2/2] fs: ext4: Add check to prevent attempting to resize
 an fs with sparse_super2
Message-ID: <YNSVYTq/ovC6sEAT@mit.edu>
References: <bee03303d999225ecb3bfa5be8576b2f4c6edbe6.1623093259.git.josh@joshtriplett.org>
 <74b8ae78405270211943cd7393e65586c5faeed1.1623093259.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74b8ae78405270211943cd7393e65586c5faeed1.1623093259.git.josh@joshtriplett.org>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 07, 2021 at 12:15:24PM -0700, Josh Triplett wrote:
> The in-kernel ext4 resize code doesn't support filesystem with the
> sparse_super2 feature. It fails with errors like this and doesn't finish
> the resize:
> EXT4-fs (loop0): resizing filesystem from 16640 to 7864320 blocks
> EXT4-fs warning (device loop0): verify_reserved_gdb:760: reserved GDT 2 missing grp 1 (32770)
> EXT4-fs warning (device loop0): ext4_resize_fs:2111: error (-22) occurred during file system resize
> EXT4-fs (loop0): resized filesystem to 2097152
> 
> To reproduce:
> mkfs.ext4 -b 4096 -I 256 -J size=32 -E resize=$((256*1024*1024)) -O sparse_super2 ext4.img 65M
> truncate -s 30G ext4.img
> mount ext4.img /mnt
> python3 -c 'import fcntl, os, struct ; fd = os.open("/mnt", os.O_RDONLY | os.O_DIRECTORY) ; fcntl.ioctl(fd, 0x40086610, struct.pack("Q", 30 * 1024 * 1024 * 1024 // 4096), False) ; os.close(fd)'
> dmesg | tail
> e2fsck ext4.img
> 
> The userspace resize2fs tool has a check for this case: it checks if the
> filesystem has sparse_super2 set and if the kernel provides
> /sys/fs/ext4/features/sparse_super2. However, the former check requires
> manually reading and parsing the filesystem superblock.
> 
> Detect this case in ext4_resize_begin and error out early with a clear
> error message.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Applied, thanks.

					- Ted
