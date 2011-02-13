From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH,RFC 1/7] ext4: fold __mpage_da_writepage() into
	write_cache_pages_da()
Date: Sun, 13 Feb 2011 07:48:19 -0500
Message-ID: <20110213124818.GJ19533@dhcp231-156.rdu.redhat.com>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu> <1297556157-21559-2-git-send-email-tytso@mit.edu> <20110213012528.GD19533@dhcp231-156.rdu.redhat.com> <20110213054235.GD2598@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab1BMMxM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Feb 2011 07:53:12 -0500
Content-Disposition: inline
In-Reply-To: <20110213054235.GD2598@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 13, 2011 at 12:42:35AM -0500, Ted Ts'o wrote:
> On Sat, Feb 12, 2011 at 08:25:29PM -0500, Josef Bacik wrote:
> > > +out:
> > > +	pagevec_release(&pvec);
> > > +	cond_resched();
> > > +	return ret;
> > >  }
> > 
> > Do we really need the cond_resched() here?  Seems like it will just add
> > unwanted/uneeded latencies.
> 
> The cond_resched is from the original write_cache_pages(), and if you
> follow the code movement, it goes all the way back to fs/mpage.c's
> __mpage_writepages() from 2.6.11 (the beginning of time as far as the
> Linux 2.6's git repository is concerned).
> 
> The basic idea is that given that writeback threads are basically
> running in a tight loop trying to push out dirty pages, you need to
> eventually give other processes a chance to run --- especially on a UP
> system!  I do wonder whether we are checking way too much, though.
> The cond_resched() I'd be tempted to take out is not the one at the
> end of the function, but the one at the end of the while loop.
> 
> That would allow us to complete the the writeback for a particular
> inode before letting another process run, which would trade off
> efficiency for a bit more scheduling unfairness.  But given that a
> particular writeback call is capped at writing out a relatively small
> mount of data anyway, that would seem to be OK.
> 
> But even XFS has a cond_resched in xfs_cluster_write() (in
> fs/xfs/linux-2.6/xfs_aops.c) so I'd want to do a lot of thinking,
> testing, and benchmarking before removing that call to cond_resched().
>

Ah I didn't look at anybody else.  My thinking was we only really need it in one
place, and we have it in the while() loop.  But you are right, it probably makes
more sense to drop the one in the while loop and then have it before we go back
to the main writeback code.  Thanks,

Josef 
