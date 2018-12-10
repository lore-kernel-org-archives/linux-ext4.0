Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40992 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbeLJFZv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 00:25:51 -0500
Date: Mon, 10 Dec 2018 00:25:46 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Chengguang Xu <cgxu519@gmx.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: compare old and new mode before setting
 update_mode flag
Message-ID: <20181210052546.GH1840@mit.edu>
References: <20181117090152.29132-1-cgxu519@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181117090152.29132-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 17, 2018 at 05:01:52PM +0800, Chengguang Xu wrote:
> If new mode is the same as old mode we don't have to reset
> inode mode in the rest of the code, so compare old and new
> mode before setting update_mode flag.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Thanks, applied.

I know Jan declined the equivalent patch for ext2; but it doesn't add
_that_ much extra complexity, and ext4_mark_inode_dirty() is rather
more heavyweight than ext2_mark_inode_dirty().

						- Ted
