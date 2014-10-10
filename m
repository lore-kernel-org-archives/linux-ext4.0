From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] block: free q->flush_rq in blk_init_allocated_queue
 error paths
Date: Fri, 10 Oct 2014 17:32:35 +0200
Message-ID: <20141010153235.GA8705@quack.suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
 <1412951028-4085-3-git-send-email-jack@suse.cz>
 <20141010151906.GB8874@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jens Axboe <axboe@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141010151906.GB8874@redhat.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 10-10-14 11:19:06, Dave Jones wrote:
> On Fri, Oct 10, 2014 at 04:23:07PM +0200, Jan Kara wrote:
>  > From: Dave Jones <davej@redhat.com>
>  > 
>  > Commit 7982e90c3a57 ("block: fix q->flush_rq NULL pointer crash on
>  > dm-mpath flush") moved an allocation to blk_init_allocated_queue(), but
>  > neglected to free that allocation on the error paths that follow.
>  > 
>  > Signed-off-by: Dave Jones <davej@fedoraproject.org>
>  > Acked-by: Mike Snitzer <snitzer@redhat.com>
>  > Signed-off-by: Jens Axboe <axboe@fb.com>
>  > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> Um, This got applied months ago.
  Yes, I mistakenly used git-send-email on a wrong directory. Sorry for
confusion...
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
