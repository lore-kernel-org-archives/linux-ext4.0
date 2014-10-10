From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] block: free q->flush_rq in blk_init_allocated_queue
	error paths
Date: Fri, 10 Oct 2014 11:19:06 -0400
Message-ID: <20141010151906.GB8874@redhat.com>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
	<1412951028-4085-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Jens Axboe <axboe@fb.com>, Mark Fasheh <mfasheh@suse.com>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: Jan Kara <jack@suse.cz>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1412951028-4085-3-git-send-email-jack@suse.cz>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 10, 2014 at 04:23:07PM +0200, Jan Kara wrote:
 > From: Dave Jones <davej@redhat.com>
 > 
 > Commit 7982e90c3a57 ("block: fix q->flush_rq NULL pointer crash on
 > dm-mpath flush") moved an allocation to blk_init_allocated_queue(), but
 > neglected to free that allocation on the error paths that follow.
 > 
 > Signed-off-by: Dave Jones <davej@fedoraproject.org>
 > Acked-by: Mike Snitzer <snitzer@redhat.com>
 > Signed-off-by: Jens Axboe <axboe@fb.com>
 > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Um, This got applied months ago.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
