From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/35] undo-io: add new calls to and speed up the undo io
 manager
Date: Tue, 21 Apr 2015 12:48:02 -0400
Message-ID: <20150421164802.GA31102@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023506.25243.44459.stgit@birch.djwong.org>
 <B42FC5F2-8E81-4F2F-B16C-4029EC8DC0EC@dilger.ca>
 <20150421150012.GI3238@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50668 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbbDUQsF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2015 12:48:05 -0400
Content-Disposition: inline
In-Reply-To: <20150421150012.GI3238@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 21, 2015 at 11:00:12AM -0400, Theodore Ts'o wrote:
> However, if the user types ^C, or e2fsck crashes out with a call to
> fatal_error(), we *should* make sure the undo log is in a proper state
> so it can be replied.

It looks like the current set of patches are registering an atexit()
cleanup handler, but there aren't changes to add signal handlers; is
this correct?

In the case of e2fsck, we have signal handlers already, but many of
the other e2fsprogs programs don't have signal handlers and unless I
missed them when I did a quick scan, it looks like this patch series
doesn't add any.

					- Ted
