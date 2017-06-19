From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 28/28] quota: add extra inode count to dquot transfer
 functions
Date: Mon, 19 Jun 2017 11:03:29 +0200
Message-ID: <20170619090329.GE11837@quack2.suse.cz>
References: <20170531081517.11438-1-tahsin@google.com>
 <20170531081517.11438-28-tahsin@google.com>
 <20170615075735.GB1764@quack2.suse.cz>
 <CAAeU0aNgon_ERWyUNmAGaBCuk3dU9qAxA7QnZ4D8cb5g6JZcPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAeU0aNgon_ERWyUNmAGaBCuk3dU9qAxA7QnZ4D8cb5g6JZcPg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 16-06-17 18:50:58, Tahsin Erdogan wrote:
> On Thu, Jun 15, 2017 at 12:57 AM, Jan Kara <jack@suse.cz> wrote:
> > Hum, rather handle this similarly to how we handle delalloc reserved space.
> > Add a callback to dq_ops to get "inode usage" of an inode and then use it
> > in dquot_transfer(), dquot_free_inode(), dquot_alloc_inode().
> 
> I tried that approach by adding a "int get_inode_usage(struct inode
> *inode, qsize_t *usage)" callback to dquot_operations. Unfortunately,
> ext4 code that calculates the number of internal inodes
> (ext4_xattr_inode_count()) is subject to failures so the callback has
> to be able to report errors. And, that itself is problematic because
> we can't afford to have errors in dquot_free_inode(). If you have
> thoughts about how to address this please let me know.

Well, you can just make dquot_free_inode() return error. Now most callers
won't be able to do much with an error from dquot_free_inode() but that's
the case also for other things during inode deletion - just handle it as
other fatal failures during inode freeing.

> Alternatively, I could try to make this patch less intrusive by
> keeping the existing dquot_transfer() signature and add a new
> dquot_transfer_usage() that accepts inode_usage as a parameter. What
> do you think?

That would be somewhat better than what you do in this patch but I prefer
to handle this like I suggested above.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
