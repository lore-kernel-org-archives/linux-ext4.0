From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH bigalloc] e2fsprogs: change root-inode to extent-mapped
Date: Wed, 20 Jul 2011 09:52:49 -0600
Message-ID: <B27D0C6A-E0F5-4196-872B-392AA72FB348@gmail.com>
References: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Robin Dong <sanbai@taobao.com>, Ted Ts'o <tytso@mit.edu>
To: "hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33132 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1GTP7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 11:59:43 -0400
Received: by pvg12 with SMTP id 12so290521pvg.19
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jul 2011 08:59:43 -0700 (PDT)
In-Reply-To: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-19, at 11:38 PM, hao.bigrat@gmail.com wrote:
> 
> After creating more than 1000 files in root directory on ext4 of bigalloc,
> the kernel reports many error messages like:
> 
> [181126.730911] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc
> [181126.735945] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc
> 
> because the root inode of a new ext4 filesystem is type of block-mapped
> even use mke2fs with "-O extent,bigalloc".

That reminds me of a question I had with bigalloc - are htree directories supported with bigalloc?  For a 1MB bigalloc chunksize it would mean a fanout of 256k, or a maximum directory size of 256GB with only a single level.

Any thoughts about increasing the directory size beyond 2GB?

Cheers, Andeas