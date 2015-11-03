From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Corruption from interrupted e2fsck
Date: Tue, 3 Nov 2015 11:00:55 -0500
Message-ID: <20151103160055.GB6729@thunk.org>
References: <B9F63236-3539-492E-83EB-3377836C2FDB@dilger.ca>
 <20151102152353.GA4024@thunk.org>
 <273A3EEA-06EB-4C6B-BD51-060EC20543D4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39739 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbbKCQA5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Nov 2015 11:00:57 -0500
Content-Disposition: inline
In-Reply-To: <273A3EEA-06EB-4C6B-BD51-060EC20543D4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 02, 2015 at 02:31:01PM -0700, Andreas Dilger wrote:
> > You're right.  My suggested fix would be in the case of
> > E2F_FLAG_CANCEL, we set the ctx->invalid_bitmaps flag, and then avoid
> > writing out the quota file if invalid_bitmaps is enabled.
> 
> I was looking at that too.  In some sense it isn't a bad idea to allow
> updating the quota file in this case, but it still bothers me that e2fsck
> would continue on to update the quotas if the user wants to kill it, so
> my preference would be to not write the quota files at all if e2fsck is
> interrupted.

I agree; that's why I suggested that if E2F_FLAG_CANCEL was set, then
we would skip wrting out the quota file.

> It would probably make more sense to have an option like "-E quota-only"
> to allow running a shorter e2fsck (maybe useful for link-farm backups
> that take a long time in later passes) but most of the time pass 1 is
> the slowest so there is usually minimal benefit from skipping later passes.

This is a separate issue.  One of the reasons why I wanted to
integrate the quota checking into e2fsck is that since quota tracking
is *always* enabled if the quota inode(s) are present.  So the only
time the quota should be inconsistent (and so when we would need to
update the quota file) is if the file system itself had gotten
inconsistent, since the quota file is now considered *part* of the
file system metadata that should always be consistence in the absense
of a kernel bug, hardware-induced corruption, or someone messing with
the file system out of band using something like debugfs.

Cheers,

					- Ted
