From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] jbd2: fix ocfs2 corrupt when updating journal
 superblock fails
Date: Mon, 15 Jun 2015 14:47:31 -0400
Message-ID: <20150615184731.GA5003@thunk.org>
References: <557E703D.2060709@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	jiangyiwen <jiangyiwen@huawei.com>, linux-fsdevel@vger.kernel.org
To: Joseph Qi <joseph.qi@huawei.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <557E703D.2060709@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 15, 2015 at 02:27:09PM +0800, Joseph Qi wrote:
> If updating journal superblock fails after journal data has been flushed,
> the error is omitted and this will mislead the caller as a normal case.
> In ocfs2, the checkpoint will be treated successfully and the other node
> can get the lock to update. Since the sb_start is still pointing to the
> old log block, it will rewrite the journal data during journal recovery
> by the other node. Thus the new updates will be overwritten and ocfs2
> corrupts.
> So in above case we have to return the error, and ocfs2_commit_cache will
> take care of the error and prevent the other node to do update first.
> And only after recovering journal it can do the new updates.
> 
> The issue discussion mail can be found at:
> https://oss.oracle.com/pipermail/ocfs2-devel/2015-June/010856.html
> http://comments.gmane.org/gmane.comp.file-systems.ext4/48841
> 
> Reported-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
> Tested-by: Yiwen Jiang <jiangyiwen@huawei.com>
> Cc: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: <stable@vger.kernel.org>

Thanks, applied.

					- Ted
