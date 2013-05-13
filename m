From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 0/2 v4] dump a sparse file in debugfs
Date: Mon, 13 May 2013 21:33:48 +0800
Message-ID: <20130513133348.GA12883@gmail.com>
References: <1359085145-15490-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45283 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3EMNQE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 May 2013 09:16:04 -0400
Received: by mail-pd0-f171.google.com with SMTP id r11so4466000pdi.16
        for <linux-ext4@vger.kernel.org>; Mon, 13 May 2013 06:16:02 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1359085145-15490-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:39:03AM +0800, Zheng Liu wrote:
> Hi all,
> 
> This is the fourth try to support to dump a sparse file in debugfs.  In this
> patch series the only change is using ext2fs_llseek() in dump_file to get a
> better portability.

Hi Ted,

Could please take a look at this patch series?  It has been sent out
for a long time.  I have forgotten it completely until I clean up my
e2fsprogs tree.  I try to rebase this patch series against the latest
master branch of e2fsprogs tree, and it can be applied without any
changes.

Thanks,
                                                - Zheng

> 
> v4 <- v3:
>  - call ext2fs_llseek() in dump_file to seek to the next data because of better
>    portability
> 
> v3 <- v2:
>  - use extent interfaces to handle extent-based file in seek_data/hole function
>  - call ext2fs_file_llseek() to retrieve current offset in dump_file()
> 
> v2 <- v1:
>  - split original patch into two parts.
>  - make code clearly according to Ted's suggestions
> 
> Regards,
> 						- Zheng
> 
> Zheng Liu (2):
>   libext2fs: introduce lseek SEEK_DATA/HOLE
>   debugfs: dump a sparse file
> 
>  debugfs/dump.c            |  48 +++++++++--
>  lib/ext2fs/ext2_err.et.in |   6 ++
>  lib/ext2fs/ext2fs.h       |   3 +
>  lib/ext2fs/fileio.c       | 208 +++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 254 insertions(+), 11 deletions(-)
> 
> -- 
> 1.7.12.rc2.18.g61b472e
> 
