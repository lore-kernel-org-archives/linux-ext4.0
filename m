From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: disable csum verification before resizing inode
Date: Tue, 2 Dec 2014 22:33:40 -0500
Message-ID: <20141203033340.GR13618@thunk.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20141114231010.GK10043@birch.djwong.org>
 <20141117191039.GL10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36079 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaLCDdr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:33:47 -0500
Content-Disposition: inline
In-Reply-To: <20141117191039.GL10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 17, 2014 at 11:10:39AM -0800, Darrick J. Wong wrote:
> When we're turning on metadata checksumming /and/ resizing the inode
> at the same time, disable checksum verification during the
> resize_inode() call because the subroutines it calls will try to
> verify the checksums (which have not yet been set), causing the
> operation to fail unnecessarily.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
