From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext4: Fix deadlock during page writeback
Date: Fri, 1 Jul 2016 11:09:50 +0200
Message-ID: <20160701090950.GB22922@quack2.suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
 <1466073736-30447-2-git-send-email-jack@suse.cz>
 <20160630150548.GC2028@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Eryu Guan <eguan@redhat.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160630150548.GC2028@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 30-06-16 11:05:48, Ted Tso wrote:
> On Thu, Jun 16, 2016 at 12:42:13PM +0200, Jan Kara wrote:
> > Commit 06bd3c36a733 (ext4: fix data exposure after a crash) uncovered a
> > deadlock in ext4_writepages() which was previously much harder to hit.
> > After this commit xfstest generic/130 reproduces the deadlock on small
> > filesystems.
> > 
> > The problem happens when ext4_do_update_inode() sets LARGE_FILE feature
> > and marks current inode handle as synchronous. That subsequently results
> > in ext4_journal_stop() called from ext4_writepages() to block waiting for
> > transaction commit while still holding page locks, reference to io_end,
> > and some prepared bio in mpd structure each of which can possibly block
> > transaction commit from completing and thus results in deadlock.
> 
> Would it be safe to submit the bio *after* calling
> ext4_journal_stop()?  It looks like that would be safe, and I'd prefer
> to minimize the time that a handle is open since that can really
> impact performance when trying to close all existing handles when we
> are starting commit processing.  It looks to me like this would be
> safe in terms of avoiding deadlocks, yes?

But it is not safe - the bio contains pages, those pages have PageWriteback
set and if the inode is part of the running transaction,
ext4_journal_stop() will wait for transaction commit which will wait for
all outstanding writeback on the inode, which will deadlock on those pages
which are part of our unsubmitted bio. So the ordering really has to be the
way it is...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
