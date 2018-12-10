Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40960 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbeLJFKl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 00:10:41 -0500
Date: Mon, 10 Dec 2018 00:10:37 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, miaoxie@huawei.com
Subject: Re: [PATCH] ext4: fix unsafe extent initialization
Message-ID: <20181210051037.GG1840@mit.edu>
References: <20181208142558.47955-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181208142558.47955-1-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 08, 2018 at 10:25:58PM +0800, zhangyi (F) wrote:
> Current ext4 will call ext4_ext_convert_to_initialized() to split and
> initialize an unwritten extent if someone write something to it. It may
> also zeroout the nearby blocks and expand the split extent if the
> allocated extent is fully inside i_size or new_size. But it may lead to
> inode inconsistency when system crash or the power fails.
> 
> Consider the following case:
>  - Create an empty file and buffer write from block A to D (with delay
>    allocate). It will update the i_size to D.
>  - Zero range from part of block B to D. It will allocate an unwritten
>    extent from B to D.
>  - The write back worker write block B and initialize the unwritten
>    extent from B to D, and then update the i_disksize to B.
>  - System crash.
>  - Remount and fsck complain about the extent size exceeds the inode
>    size.
> 
> This patch add checking i_disksize and chose the small one between
> i_size to make sure it's safe to convert extent to initialized.
> 
> ---------------------
> 
> This problem can reproduce by xfstests generic/482 with fsstress seed
> 1544025012.

Hmm, your explanation is great and the patch makes sense.  I haven't
been able to reproduce the problem by adding -s 1544025012 to the
fsstress arguments.  This may be because fsstress being run with two
processes (-p 2) and the failure may be timing dependent?

How easily can you replicate the problem?

						- Ted
