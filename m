From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/35] undo-io: add new calls to and speed up the undo io
 manager
Date: Tue, 21 Apr 2015 11:00:12 -0400
Message-ID: <20150421150012.GI3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023506.25243.44459.stgit@birch.djwong.org>
 <B42FC5F2-8E81-4F2F-B16C-4029EC8DC0EC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50244 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbbDUPAP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2015 11:00:15 -0400
Content-Disposition: inline
In-Reply-To: <B42FC5F2-8E81-4F2F-B16C-4029EC8DC0EC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 11:06:11PM -0500, Andreas Dilger wrote:
> Doesn't it kind of make e2undo useless if it doesn't work unless
> the overwriting operation completed successfully?
> 
> Wouldn't it be better to save the superblock at the start, so that
> it is available if the overwriting operation is interrupted?  It seems
> like e2undo would be most useful if e.g. resize2fs was interrupted in
> the middle of some otherwise-corrupting change to the
> filesystem.

It would be nice if e2fsck's undo log worked correctly after a
powerfailure, but having to constantly call fsync to keep the undo log
consistent probably isn't work it.

However, if the user types ^C, or e2fsck crashes out with a call to
fatal_error(), we *should* make sure the undo log is in a proper state
so it can be replied.

Alternatively, what we *could* do is to implement a write-ahead log
where all of the modified blocks go into separate file, and then the
file system only gets modified at the end, if e2fsck finishes
correctly (or if the user types ^C, we can ask the user if he/she
wants to apply the changes made so far).  I could imagine this being
useful in some cases, but I'm not entirely clear it's worth the effort
to implement.  (And we can always do that later, we shouldn't let the
perfect be the enemy of the good.)

						- Ted

