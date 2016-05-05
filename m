From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: Fix check of dqget() return value in
 ext4_ioctl_setproject()
Date: Thu, 5 May 2016 14:52:34 +0200
Message-ID: <20160505125234.GF1970@quack2.suse.cz>
References: <1459256463-48543-1-git-send-email-seth.forshee@canonical.com>
 <20160422183632.GC109717@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbcEEMwi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 08:52:38 -0400
Content-Disposition: inline
In-Reply-To: <20160422183632.GC109717@ubuntu-hedt>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 22-04-16 13:36:32, Seth Forshee wrote:
> On Tue, Mar 29, 2016 at 08:01:03AM -0500, Seth Forshee wrote:
> > A failed call to dqget() returns an ERR_PTR() and not null. Fix
> > the check in ext4_ioctl_setproject() to handle this correctly.
> > 
> > Fixes: 9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
> > Cc: stable@vger.kernel.org # v4.5
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Thought I'd check and see if this patch was forgotten, I sent it nearly
> a month ago but the bug is still present.

Yeah, it seems Ted forgot to pull the fix. Ted? BTW, feel free to add

Reviewed-by: Jan Kara <jack@suse.cz>

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
