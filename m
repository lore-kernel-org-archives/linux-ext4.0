From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: Wait for proper transaction commit on fsync
Date: Mon, 16 Nov 2009 11:43:31 +0100
Message-ID: <20091116104331.GB23231@duck.suse.cz>
References: <1256647729-29834-1-git-send-email-jack@suse.cz> <1256647729-29834-5-git-send-email-jack@suse.cz> <20091116004641.GM4323@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbZKPKn0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Nov 2009 05:43:26 -0500
Content-Disposition: inline
In-Reply-To: <20091116004641.GM4323@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 15-11-09 19:46:41, Theodore Tso wrote:
> On Tue, Oct 27, 2009 at 01:48:49PM +0100, Jan Kara wrote:
> > +	/*
> > +	 * Transactions that contain inode's metadata needed to complete
> > +	 * fsync and fdatasync, respectively.
> > +	 */
> > +	atomic_t i_sync_tid;
> > +	atomic_t i_datasync_tid;
> 
> Why do we need an atomic_t here at all?  It's not clear it's
> necessary.  What specific race are you worried about?
  Well, i_[data]sync_tid are set and read from several places which aren't
currently synchronized against each other and I din't want to introduce any
synchronization. So atomic_t seemed like a clean way of making clear that
loads / stores from those fields are atomic, regardless of architecture,
memory alignment or whatever insanity that might make us see just half
overwritten field.  On all archs where this means just plain stores / loads
(such as x86), there's no performance hit since the operations are
implemented as such.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
