Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60544 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbeJCVWs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 17:22:48 -0400
Date: Wed, 3 Oct 2018 10:34:05 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, dchinner@redhat.com, adilger@dilger.ca,
        wshilong@ddn.com
Subject: Re: [PATCH v4 1/2] ext4: fix setattr project check upon fssetxattr
 ioctl
Message-ID: <20181003143405.GA4555@thunk.org>
References: <1537258530-4435-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537258530-4435-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2018 at 05:15:29PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wangshilong1991@gmail.com>
> 
> Currently, project quota could be changed by fssetxattr
> ioctl, and existed permission check inode_owner_or_capable()
> is obviously not enough, just think that common users could
> change project id of file, that could make users to
> break project quota easily.
> 
> This patch try to follow same regular of xfs project
> quota:
> 
> "Project Quota ID state is only allowed to change from
> within the init namespace. Enforce that restriction only
> if we are trying to change the quota ID state.
> Everything else is allowed in user namespaces."
> 
> Besides that, check and set project id'state should
> be an atomic operation, protect whole operation with
> inode lock, ext4_ioctl_setproject() is only used for
> ioctl EXT4_IOC_FSSETXATTR, we have held mnt_want_write_file()
> before ext4_ioctl_setflags(), and ext4_ioctl_setproject()
> is called after ext4_ioctl_setflags(), we could share
> codes, so remove it inside ext4_ioctl_setproject().
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, thanks.

					- Ted
