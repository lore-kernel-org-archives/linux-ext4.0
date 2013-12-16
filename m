From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V4] mke2fs: disallow creating FS on a loop mounted file
 with no option
Date: Mon, 16 Dec 2013 00:49:16 -0500
Message-ID: <20131216054916.GL28536@thunk.org>
References: <527B309D.4090706@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40397 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab3LPFtT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 00:49:19 -0500
Content-Disposition: inline
In-Reply-To: <527B309D.4090706@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 07, 2013 at 03:18:05PM +0900, Kazuya Mio wrote:
> When /etc/mtab is a symlink of /proc/mounts, mke2fs without -FF option
> can create a filesystem on the image file that is mounted.
> According to mke2fs man page, we should specify -FF option in this case.
> 
> This patch protects filesystem from unintended mke2fs caused by human error.
> 
> How to reproduce:
>   # mke2fs -t ext4 -Fq fs.img
>   # mount -o loop fs.img /mnt/mp1
>   # mke2fs -t ext4 -Fq fs.img && echo "mke2fs success"
>   mke2fs success
> 
> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>

Thanks, applied.

						- Ted
