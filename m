Return-Path: <SRS0=mHRP=MP=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35656 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbeJCXMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 3 Oct 2018 19:12:49 -0400
Date: Wed, 3 Oct 2018 12:23:39 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-ext4@vger.kernel.org, dchinner@redhat.com, adilger@dilger.ca,
        wshilong@ddn.com
Subject: Re: [PATCH v2 RESEND 2/2] ext4: fix to detect failure of
 dquot_initialize in project ioctl
Message-ID: <20181003162338.GE2835@thunk.org>
References: <1537258530-4435-1-git-send-email-wshilong1991@gmail.com>
 <1537258530-4435-2-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537258530-4435-2-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2018 at 05:15:30PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> We return most failure of dquota_initialize() except
> inode evict, this could make a bit sense, for example
> we allow file removal even quota files are broken?
> 
> But it dosen't make sense to allow setting project
> if quota files etc are broken.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Applied, thanks.

					- Ted
