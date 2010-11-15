From: Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH] jbd2: avoid the concurrent data writeback
Date: Mon, 15 Nov 2010 17:59:43 +0800
Message-ID: <20101115175943.490d3469@feng-i7>
References: <1289827533-2576-1-git-send-email-feng.tang@intel.com>
	<20101115055420.GA21785@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101115055420.GA21785@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Fengguang,

Thanks for the review

On Mon, 15 Nov 2010 13:54:20 +0800
"Wu, Fengguang" <fengguang.wu@intel.com> wrote:

> [add CC to mailing lists]
> 
> Tang,
> 
> Good catch!
> 
> On Mon, Nov 15, 2010 at 09:25:33PM +0800, Tang, Feng wrote:
> > When dd a big file to an ext4 partition, it is very likely to happen
> > that both the background flush thread and kjounald try to do data
> > writeback for it, and ext4_witepage may be called 100, 000 times by
> > journal_submit_inode_data_buffers() without really writing one page
> > back (skipped), as those pages haven't had disk blocks allocated
> > yet.
> 
> The above changelog could show a bit more details (to help me
> understand it :).
OK, will update the commit log. 
> 
> Does it happen frequently and hence has measurable overheads?

It could always be reproduced on my Core Duo 2 + 4G RAM + SATA + EXT4 FS.
dd 1G file's time on my machine is reduced to 11.964s from 12.396s.

> 
> Is it safe to skip the inode? Another alternative is to wait for it:
> with inode_wait_for_writeback(inode).

Yes, I think it's safe to skip this inode, as current 
journal_submit_inode_data_buffers() will just return without do any real job
in this case, and following jbd2 transaction process will ensure the
data coherence.

Following is the updated patch, pls help to review. thanks!

- Feng
---------------

>From b16cfc5a560f2549ac69dbb235a550500ea1719f Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Mon, 15 Nov 2010 21:06:44 +0800
Subject: [PATCH] jbd2: avoid the concurrent data writeback

When dd a big file to an ext4 partition, it is very likely to happen
that both the background flush thread and kjounald try to do data
writeback for it, that the flush thread is doing the writeback for
this file and jbd2 thread are also waken up to commit the transaction.
Because kjounald only calls the generic_writepages() whose path
doesn't really allocate disk blocks, the ext4_witepage() may be called
lots of times (100000+ for a 1g file dd) without really writing one page
back (skipped), which will consume lots of unnecessary CPU time

This could be found by a simple test case with ftrace:
$ sync;
$ echo 40960 > buffer_size_kb;echo 1 > events/writeback/enable;echo 1 > events/jbd2/enable;echo 1 > events/ext4/enable;
$ dd if=/dev/zero of=/home/test/1g.bin bs=1M count=1024;sync;
$ cat trace > /home/test/jbd2_ext4_1g_dd.log
$ grep -c wcb_writepage /home/test/jbd2_ext4_1g_dd.log

This patch will check if the inode is under data syncing, if yes then
don't start the writeback from kjournald

The Perf statics (On my Core Duo 2 + 4G RAM + SATA disk + Ext4 in all default modes):
before the patch >  112191  writeback:wbc_writepage  #      0.005 M/sec
after the patch  >  54  writeback:wbc_writepage  #      0.000 M/sec

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 fs/jbd2/commit.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f3ad159..0f3e356 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -170,6 +170,10 @@ static int journal_wait_on_commit_record(journal_t *journal,
  * We don't do block allocation here even for delalloc. We don't
  * use writepages() because with dealyed allocation we may be doing
  * block allocation in writepages().
+ *
+ * Sometimes when this get called, the host inode may be under data
+ * syncing initiated by flush thread(especially for a large file), and 
+ * in such situation, we should skip this path of writeback
  */
 static int journal_submit_inode_data_buffers(struct address_space *mapping)
 {
@@ -181,6 +185,13 @@ static int journal_submit_inode_data_buffers(struct address_space *mapping)
 		.range_end = i_size_read(mapping->host),
 	};
 
+	spin_lock(&inode_lock);
+	if (mapping->host->i_state & I_SYNC) {
+		spin_unlock(&inode_lock);
+		return 0;
+	}
+	spin_unlock(&inode_lock);
+
 	ret = generic_writepages(mapping, &wbc);
 	return ret;
 }
-- 
1.6.3.3
