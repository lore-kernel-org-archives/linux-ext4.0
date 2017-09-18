From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [4.14-rc1 bug] fstests generic/441 failure on ext2
Date: Mon, 18 Sep 2017 08:10:24 -0400
Message-ID: <1505736624.5567.21.camel@redhat.com>
References: <20170918112312.GN8034@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Eryu Guan <eguan@redhat.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170918112312.GN8034@eguan.usersys.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-09-18 at 19:23 +0800, Eryu Guan wrote:
> Hi all,
> 
> With ext2 driven by ext4 module (or ext4 without journal, I haven't
> tested ext2 module, but I guess the result is the same), v4.14-rc1
> kernel starts to fail fstests generic/441 as:
> 
> +First fsync after reopen of fd[0] failed: Input/output error
> 
> git bisect shows that this is uncovered by commit ffb959bbdf92 ("mm:
> remove optimizations based on i_size in mapping writeback waits"), which
> removed (i_size == 0) check in filemap_fdatawait().
> 
> I say "uncovered" because test fails with 4.13 kernel too if we re-open
> the test file without O_TRUNC flag in src/fsync-err.c (so file size is
> not zero, and fails the i_size == 0 check).
> 
> The EIO was returned by sync_inode_metadata() in __generic_file_fsync(),
> the call trace is like:
> 
> do_fsync
>  vfs_fsync_range
>   ext4_sync_file
>    __generic_file_fsync
>     sync_inode_metadata
>      writeback_single_inode
>       __writeback_single_inode
>        filemap_fdatawait  => EIO here
> 
> Thanks,
> Eryu

(cc'ing Jan and linux-fsdevel)

Thanks for the bug report. The analysis looks spot-on.

So yeah...we have this "legacy" filemap_fdatawait call in
__writeback_single_inode, and that is returning -EIO, likely because
AS_EIO was set on the inode from the earlier wb errors.

That error return is pretty sketchy since it could be cleared at any
time, and pretty much everything we care about here is now using
errseq_t for error reporting at fsync. I don't think we really care too
much about that flag in this codepath anymore.

Based on the comments in that function, all we really care about there
is waiting until writeback completes. One possible fix would be to just
have __writeback_single_inode ignore the error return from
filemap_fdatawait. Since we know that AS_EIO can be cleared at any time,
we'll just assume that it always is.

Longer term, I think we need to consider how we can rid ourselves of
AS_EIO/AS_ENOSPC altogether.

Anyway, something like this should fix it, I'd think. Anyone relying on
getting the error there is probably subtly broken, and should be using
errseq_t anyway.

Thoughts?

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 245c430a2e41..b9f523ac07b8 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1325,11 +1325,8 @@ __writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
 	 * separate, external IO completion path and ->sync_fs for guaranteeing
 	 * inode metadata is written back correctly.
 	 */
-	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync) {
-		int err = filemap_fdatawait(mapping);
-		if (ret == 0)
-			ret = err;
-	}
+	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
+		filemap_fdatawait(mapping);
 
 	/*
 	 * Some filesystems may redirty the inode during the writeback
