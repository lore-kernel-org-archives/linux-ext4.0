Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274FBC433E0
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D477E2389F
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhANDxC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Jan 2021 22:53:02 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38619 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbhANDxC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2021 22:53:02 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10E3pwCG021668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 22:51:58 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0E6F015C3453; Wed, 13 Jan 2021 22:51:58 -0500 (EST)
Date:   Wed, 13 Jan 2021 22:51:58 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     yangerkun <yangerkun@huawei.com>
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, jack@suse.cz,
        yi.zhang@huawei.com, lihaotian9@huawei.com, lutianxiong@huawei.com,
        linfeilong@huawei.com
Subject: Re: [PATCH v3] ext4: fix bug for rename with RENAME_WHITEOUT
Message-ID: <X/+/3ui/TQ9LjtNZ@mit.edu>
References: <20210105062857.3566-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105062857.3566-1-yangerkun@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jan 05, 2021 at 02:28:57PM +0800, yangerkun wrote:
> We got a "deleted inode referenced" warning cross our fsstress test. The
> bug can be reproduced easily with following steps:
> 
>   cd /dev/shm
>   mkdir test/
>   fallocate -l 128M img
>   mkfs.ext4 -b 1024 img
>   mount img test/
>   dd if=/dev/zero of=test/foo bs=1M count=128
>   mkdir test/dir/ && cd test/dir/
>   for ((i=0;i<1000;i++)); do touch file$i; done # consume all block
>   cd ~ && renameat2(AT_FDCWD, /dev/shm/test/dir/file1, AT_FDCWD,
>     /dev/shm/test/dir/dst_file, RENAME_WHITEOUT) # ext4_add_entry in
>     ext4_rename will return ENOSPC!!
>   cd /dev/shm/ && umount test/ && mount img test/ && ls -li test/dir/file1
>   We will get the output:
>   "ls: cannot access 'test/dir/file1': Structure needs cleaning"
>   and the dmesg show:
>   "EXT4-fs error (device loop0): ext4_lookup:1626: inode #2049: comm ls:
>   deleted inode referenced: 139"
> 
> ext4_rename will create a special inode for whiteout and use this 'ino'
> to replace the source file's dir entry 'ino'. Once error happens
> latter(the error above was the ENOSPC return from ext4_add_entry in
> ext4_rename since all space has been consumed), the cleanup do drop the
> nlink for whiteout, but forget to restore 'ino' with source file. This
> will trigger the bug describle as above.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Thanks, replied.

					- Ted
