From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/9] ext4: honor the O_SYNC flag for aysnchronous
 direct I/O requests
Date: Wed, 21 Nov 2012 17:54:36 +0100
Message-ID: <20121121165436.GB30250@quack.suse.cz>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074131.24645.38489.stgit@blackbox.djwong.org>
 <20121120100751.GB1408@quack.suse.cz>
 <x49sj84hwl4.fsf@segfault.boston.devel.redhat.com>
 <20121121005626.GC10507@quack.suse.cz>
 <x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, axboe@kernel.dk,
	tytso@mit.edu, david@fromorbit.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	hch@infradead.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2KUQyl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Nov 2012 11:54:41 -0500
Content-Disposition: inline
In-Reply-To: <x49r4nnujx6.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 21-11-12 09:09:41, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> Just to be clear, are you saying you would like me to remove the
> >> mutex_lock/unlock pair from ext4_sync_file?  (I had already factored out
> >> the common code between this new code path and the fsync path in my tree.)
> >   Yes, after some thinking I came to that conclusion. We actually need to
> > keep i_mutex around ext4_flush_unwritten_io() to avoid livelocks but the
> > rest doesn't need it. The change should be definitely a separate patch just
> > in case there's something subtle I missed and we need to bisect in
> > future... I've attached a patch for that so that blame for bugs goes my way
> > ;) Compile tested only so far. I'll give it some more testing overnight.
> 
> Great, thanks Jan!  I'll include this in the next posting.
  OK, patch passed xfstests and a test banging one file with random IO and
fsyncs from 8 processes (in data=ordered, data=journal, and nojournal
modes). So it seems I didn't miss anything substantial. So ship it! ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
