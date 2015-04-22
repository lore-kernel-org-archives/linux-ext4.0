From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/35] undo-io: add new calls to and speed up the undo io
 manager
Date: Tue, 21 Apr 2015 19:47:44 -0700
Message-ID: <20150422024744.GG11592@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023506.25243.44459.stgit@birch.djwong.org>
 <B42FC5F2-8E81-4F2F-B16C-4029EC8DC0EC@dilger.ca>
 <20150421150012.GI3238@thunk.org>
 <20150421164802.GA31102@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41162 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbbDVCrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2015 22:47:49 -0400
Content-Disposition: inline
In-Reply-To: <20150421164802.GA31102@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 21, 2015 at 12:48:02PM -0400, Theodore Ts'o wrote:
> On Tue, Apr 21, 2015 at 11:00:12AM -0400, Theodore Ts'o wrote:
> > However, if the user types ^C, or e2fsck crashes out with a call to
> > fatal_error(), we *should* make sure the undo log is in a proper state
> > so it can be replied.
> 
> It looks like the current set of patches are registering an atexit()
> cleanup handler, but there aren't changes to add signal handlers; is
> this correct?
> 
> In the case of e2fsck, we have signal handlers already, but many of
> the other e2fsprogs programs don't have signal handlers and unless I
> missed them when I did a quick scan, it looks like this patch series
> doesn't add any.

Correct, it does not.  I hadn't made up my mind if I wanted to continue writing
stuff out if one of the bad signals comes in, but for the specific case of ^C
it does seem warranted.  I'm also not quite sure when's a good time to install
our own "default" handler ... I guess each undo io manager could install
itself via sigaction and store the old pointer for calling later?

WAL could be useful too, but I wouldn't want undo_io and wal_io banging around
inside libext2fs together.

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
