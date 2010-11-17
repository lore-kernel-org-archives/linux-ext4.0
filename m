From: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Date: Wed, 17 Nov 2010 09:36:21 +0800
Message-ID: <20101117093621.29fed027@feng-i7>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
	<20101115055420.GA21785@localhost>
	<20101115175943.490d3469@feng-i7>
	<20101116121323.GE4757@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: no To-header on input <""@suse.de>,
	"Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101116121323.GE4757@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Jan,

On Tue, 16 Nov 2010 20:13:23 +0800
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   sorry for chiming in a bit late...
> On Mon 15-11-10 17:59:43, Feng Tang wrote:
> > From b16cfc5a560f2549ac69dbb235a550500ea1719f Mon Sep 17 00:00:00
> > 2001 From: Feng Tang <feng.tang@intel.com>
> > Date: Mon, 15 Nov 2010 21:06:44 +0800
> > Subject: [PATCH] jbd2: avoid the concurrent data writeback
> > 
> > When dd a big file to an ext4 partition, it is very likely to happen
> > that both the background flush thread and kjounald try to do data
> > writeback for it, that the flush thread is doing the writeback for
> > this file and jbd2 thread are also waken up to commit the
> > transaction. Because kjounald only calls the generic_writepages()
> > whose path doesn't really allocate disk blocks, the ext4_witepage()
> > may be called lots of times (100000+ for a 1g file dd) without
> > really writing one page back (skipped), which will consume lots of
> > unnecessary CPU time
> > 
> > This could be found by a simple test case with ftrace:
> > $ sync;
> > $ echo 40960 > buffer_size_kb;echo 1 > events/writeback/enable;echo
> > 1 > events/jbd2/enable;echo 1 > events/ext4/enable; $ dd
> > if=/dev/zero of=/home/test/1g.bin bs=1M count=1024;sync; $ cat
> > trace > /home/test/jbd2_ext4_1g_dd.log $ grep -c
> > wcb_writepage /home/test/jbd2_ext4_1g_dd.log
> > 
> > This patch will check if the inode is under data syncing, if yes
> > then don't start the writeback from kjournald
> > 
> > The Perf statics (On my Core Duo 2 + 4G RAM + SATA disk + Ext4 in
> > all default modes): before the patch >  112191
> > writeback:wbc_writepage  #      0.005 M/sec after the patch  >  54
> > writeback:wbc_writepage  #      0.000 M/sec
> > 
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  fs/jbd2/commit.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index f3ad159..0f3e356 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -170,6 +170,10 @@ static int
> > journal_wait_on_commit_record(journal_t *journal,
> >   * We don't do block allocation here even for delalloc. We don't
> >   * use writepages() because with dealyed allocation we may be doing
> >   * block allocation in writepages().
> > + *
> > + * Sometimes when this get called, the host inode may be under data
> > + * syncing initiated by flush thread(especially for a large file),
> > and 
> > + * in such situation, we should skip this path of writeback
> >   */
> >  static int journal_submit_inode_data_buffers(struct address_space
> > *mapping) {
> > @@ -181,6 +185,13 @@ static int
> > journal_submit_inode_data_buffers(struct address_space
> > *mapping) .range_end = i_size_read(mapping->host), };
> >  
> > +	spin_lock(&inode_lock);
> > +	if (mapping->host->i_state & I_SYNC) {
> > +		spin_unlock(&inode_lock);
> > +		return 0;
> > +	}
> > +	spin_unlock(&inode_lock);
> > +
>   Sorry, but this is just wrong. Not only because of inode_lock as
> Christoph pointed out but mainly principially. ext4 and ocfs2 in
> data=ordered mode rely on data pages (with underlying blocks already
> allocated) being written out before transaction commit proceeds for
> data integrity. So you cannot just go and remove the writeback saying
> it improves performance.
> 
> I'm not saying that ext4 handling of ordered mode does not need a
> revision (we actually talked with Ted about it at Kernel Summit). But
> the solution for it is to use IO completion callback to do extent
> tree manipulations and stop using JBD2 for data syncing. We already
> do that for direct IO and conversion of preallocated space so doing
> it in all cases should be reasonably easy. Until that happens, you
> can run ext4 in data=writeback mode which will also stop JBD2 from
> doing the writeback (and effectively is rather similar to your patch).

Glad to know that the revision is on the way, and thanks for the 
detailed clarification.

- Feng 
