From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Could you help with move-on-write review?
Date: Thu, 25 Nov 2010 22:24:42 +0200
Message-ID: <AANLkTikTnN3tJOZ9tL+MOzQuTwH8TgiL7awXzRoX392L@mail.gmail.com>
References: <AANLkTimsBFPcRv_=+JbxXU+8wK218V-NXAwH5OmGHnFZ@mail.gmail.com>
	<AANLkTinJS=mMc+Xy=P7-pF-hW8+6zBXey8X5mF_0NXUc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51156 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0KYUYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 15:24:43 -0500
Received: by qwb7 with SMTP id 7so1340532qwb.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 12:24:42 -0800 (PST)
In-Reply-To: <AANLkTinJS=mMc+Xy=P7-pF-hW8+6zBXey8X5mF_0NXUc@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 25, 2010 at 4:11 PM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> Hi guys,
>
> I would like to ask you as a big favor to review this patch,
> not as candidate for inclusion in mainline of course, but as a code/d=
esign
> review for my new move-on-write hooks. hopefully, some of this code w=
ill
> find it's way to ext4 some day soon.
>
> The problems with the old data hooks, which I may have mentioned, are=
:
> 1. second write to mmaped page did not call get_block() to trigger
> =A0 =A0move-on-write.
> 2. quota_write() called next3_bread(create=3D1) without notifying thi=
s
> =A0 =A0is a partial write and move-on-write has corrupted it's data,
> =A0 =A0resulting in broken quota file.
> 3. direct I/O was not supported.
>
> The new design uses 3 buffer head flags to signal get_block() about
> move-on-write:
> 1. buffer_move_data() is an explicit request to trigger move-on-write=
=2E
> =A0=A0 =A0users which do not declare move_data (like quota_write) wil=
l not
> =A0 =A0trigger move-on-write. previous hooks would do move-on-write o=
n
> =A0 =A0all regular files data without an explicit request.
> =A0 =A0=A0new design suggests that we rather corrupt snapshot data
> =A0 =A0(missed move-on-write) then corrupt the file system live data
> =A0 =A0(false positive move-on-write).
> 2. buffer_partial_write() signals that in case of move-on-write, the
> old block data
> =A0 =A0needs to be read, before mapping the buffer to a new block.
> 3. buffer_direct_io() signals that in case of move-on-write or hole f=
illing,
> =A0 =A0the buffer should not be mapped on return.
>
> There are 4 places I found that map data blocks and should trigger
> move-on-write:
> 1. write_begin() sets move_data and optionally partial_write flags an=
d
> =A0 =A0unmaps buffers
> 2. ordered_writepage() sets move_data flag and unmaps buffers
> =A0 =A0(snapshots only work with data=3Dordered)
> 3. truncate_page() sets move_data flag (and calls next3_get_block() i=
tself)
> 4. next3_get_block() sets direct_io and move_data flags when (create =
&& !handle)
>
> Know issue:
> snapshot copy of quota files is not consistent with snapshot'ed
> file system (can be fixed, but is it relevant for read-only mount?)
>
> you should know that the core move-on-write code in
> get_blocks_handle() has not changed much
> (only the move_data and direct_io flag checks were added) and it has
> been used for quite some time now,
> so I do not expect to find major bugs in the block move mechanism its=
elf.
>
> I revised my 'next3 test' scripts to rewrite random data to files via=
 direct I/O
> and mmap to test the new move-on-write hooks in next3_get_block() and=
 in
> ordered_writepage() and it all seems to work fine.
> quotas also seems to work fine now.
>
> I understand if this review is not on the top of your priorities,
> but if you can find the time for it, I would very much appreciate it.
>

And shortly thereafter comes v2...
tried to apply to kernel 2.6.32 and realized that DIO_SKIP_HOLES did no=
t exist,
so I simplified the hook further by introducing a special
get_block_dio() function
to deal only with direct I/O writes:


=3D=3D=3Dnext3_snapshot_hooks_data.patch=3D=3D=3D

next3: snapshot hooks - move data blocks

Before every regular file data buffer write,
the function next3_get_block() is called to map the buffer to disk.
We use this hook to call the snapshot API snapshot_get_move_access(),
to optionally move the block to the snapshot file.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

-----------------------------------------------------------------------=
---------
diff -Nuarp a/fs/next3/inode.c b/fs/next3/inode.c
--- a/fs/next3/inode.c	2010-11-25 21:58:39.000000000 +0200
+++ b/fs/next3/inode.c	2010-11-25 21:58:39.000000000 +0200
@@ -827,6 +827,43 @@ int next3_get_blocks_handle(handle_t *ha

 	partial =3D next3_get_branch(inode, depth, offsets, chain, &err);

+	if (!partial && create && buffer_move_data(bh_result)) {
+		BUG_ON(!next3_snapshot_should_move_data(inode));
+		first_block =3D le32_to_cpu(chain[depth - 1].key);
+		blocks_to_boundary =3D 0;
+		/* should move 1 data block to snapshot? */
+		err =3D next3_snapshot_get_move_access(handle, inode,
+				first_block, 0);
+		if (err)
+			/* do not map found block */
+			partial =3D chain + depth - 1;
+		if (err < 0)
+			/* cleanup the whole chain and exit */
+			goto cleanup;
+		if (buffer_direct_io(bh_result)) {
+			/* suppress direct I/O write to block that needs to be moved */
+			err =3D 0;
+			goto cleanup;
+		}
+		if (err > 0)
+			/* check again under truncate_mutex */
+			err =3D -EAGAIN;
+	}
+	if (partial && create && buffer_direct_io(bh_result)) {
+		/* suppress direct I/O write to holes */
+		loff_t end =3D ((iblock + maxblocks - 1) << inode->i_blkbits) + 1;
+		/*
+		 * we do not know the original write length, but it has to be at lea=
st
+		 * 1 byte into the last requested block. if the minimal length write
+		 * isn't going to extend i_size, we must be cautious and assume that
+		 * direct I/O is async and refuse to fill the hole.
+		 */
+		if (end <=3D inode->i_size) {
+			err =3D 0;
+			goto cleanup;
+		}
+	}
+
 	/* Simplest case - block found, no allocation needed */
 	if (!partial) {
 		first_block =3D le32_to_cpu(chain[depth - 1].key);
@@ -883,6 +920,20 @@ int next3_get_blocks_handle(handle_t *ha
 			partial--;
 		}
 		partial =3D next3_get_branch(inode, depth, offsets, chain, &err);
+		if (!partial &&  buffer_move_data(bh_result)) {
+			BUG_ON(!next3_snapshot_should_move_data(inode));
+			first_block =3D le32_to_cpu(chain[depth - 1].key);
+			blocks_to_boundary =3D 0;
+			/* should move 1 data block to snapshot? */
+			err =3D next3_snapshot_get_move_access(handle, inode,
+					first_block, 0);
+			if (err)
+				/* re-allocate 1 data block */
+				partial =3D chain + depth - 1;
+			if (err < 0)
+				/* cleanup the whole chain and exit */
+				goto out_mutex;
+		}
 		if (!partial) {
 			count++;
 			mutex_unlock(&ei->truncate_mutex);
@@ -919,6 +970,43 @@ int next3_get_blocks_handle(handle_t *ha
 	if (err)
 		goto out_mutex;

+	if (*(partial->p)) {
+		int ret;
+
+		/* old block is being replaced with a new block */
+		if (buffer_partial_write(bh_result) &&
+				!buffer_uptodate(bh_result)) {
+			/* read old block data before moving it to snapshot */
+			map_bh(bh_result, inode->i_sb,
+					le32_to_cpu(*(partial->p)));
+			ll_rw_block(READ, 1, &bh_result);
+			wait_on_buffer(bh_result);
+			/* clear old block mapping */
+			clear_buffer_mapped(bh_result);
+			if (!buffer_uptodate(bh_result)) {
+				err =3D -EIO;
+				goto out_mutex;
+			}
+		}
+
+		if (buffer_partial_write(bh_result))
+			/* prevent zero out of page in block_write_begin() */
+			SetPageUptodate(bh_result->b_page);
+
+		/* move old block to snapshot */
+		ret =3D next3_snapshot_get_move_access(handle, inode,
+				le32_to_cpu(*(partial->p)), 1);
+		if (ret < 1) {
+			/* failed to move to snapshot - free new block */
+			next3_free_blocks(handle, inode,
+					le32_to_cpu(partial->key), 1);
+			err =3D ret ? : -EIO;
+			goto out_mutex;
+		}
+		/* block moved to snapshot - continue to splice new block */
+		err =3D 0;
+	}
+
 	/*
 	 * The next3_splice_branch call will free and forget any buffers
 	 * on the new chain if there is a failure, but that risks using
@@ -953,6 +1041,23 @@ out:
 	return err;
 }

+/* Simple get block for everything except direct I/O write */
+static int next3_get_block(struct inode *inode, sector_t iblock,
+			struct buffer_head *bh_result, int create)
+{
+	handle_t *handle =3D next3_journal_current_handle();
+	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;
+	int ret;
+
+	ret =3D next3_get_blocks_handle(handle, inode, iblock,
+					max_blocks, bh_result, create);
+	if (ret > 0) {
+		bh_result->b_size =3D (ret << inode->i_blkbits);
+		ret =3D 0;
+	}
+	return ret;
+}
+
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
 /*
@@ -964,13 +1069,31 @@ out:
  */
 #define DIO_CREDITS 25

-static int next3_get_block(struct inode *inode, sector_t iblock,
+static int next3_get_block_dio(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create)
 {
 	handle_t *handle =3D next3_journal_current_handle();
 	int ret =3D 0, started =3D 0;
 	unsigned max_blocks =3D bh_result->b_size >> inode->i_blkbits;

+	BUG_ON(handle !=3D NULL);
+	if (NEXT3_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT)) {
+		/*
+		 * DIO_SKIP_HOLES may ask to map direct I/O writes with create=3D0.
+		 * We need to change it to create=3D1, so that we can fall back to
+		 * buffered I/O when data blocks need to be moved to snapshot.
+		 */
+		create =3D 1;
+		/*
+		 * signal next3_get_blocks_handle() to return unmapped block if bloc=
k
+		 * is not allocated or if it needs to be moved to snapshot.
+		 */
+		set_buffer_direct_io(bh_result);
+		if (next3_snapshot_should_move_data(inode))
+			set_buffer_move_data(bh_result);
+	}
+
 	if (create && !handle) {	/* Direct IO write... */
 		if (max_blocks > DIO_MAX_BLOCKS)
 			max_blocks =3D DIO_MAX_BLOCKS;
@@ -1166,6 +1289,71 @@ static void next3_truncate_failed_write(
 	next3_truncate(inode);
 }

+/*
+ * Check if a buffer was written since the last snapshot was taken.
+ * In data=3Dordered, the only mode supported by next3, all dirty data=
 buffers
+ * are flushed on snapshot take via freeze_fs() API, so buffer_jbd(bh)=
 means
+ * that, the buffer was declared dirty data after snapshot take.
+ */
+static int buffer_first_write(handle_t *handle, struct buffer_head *bh=
)
+{
+	return !buffer_jbd(bh);
+}
+
+static int set_move_data(handle_t *handle, struct buffer_head *bh)
+{
+	BUG_ON(buffer_move_data(bh));
+	clear_buffer_mapped(bh);
+	set_buffer_move_data(bh);
+	return 0;
+}
+
+static int set_partial_write(handle_t *handle, struct buffer_head *bh)
+{
+	BUG_ON(buffer_partial_write(bh));
+	set_buffer_partial_write(bh);
+	return 0;
+}
+
+static void set_page_move_data(struct page *page, unsigned from, unsig=
ned to)
+{
+	struct buffer_head *page_bufs =3D page_buffers(page);
+
+	BUG_ON(!page_has_buffers(page));
+	/*
+	 * make sure that get_block() is called even for mapped buffers,
+	 * but not if all buffers were written since last snapshot take.
+	 */
+	if (walk_page_buffers(NULL, page_bufs, from, to,
+				NULL, buffer_first_write)) {
+		/* signal get_block() to move-on-write */
+		walk_page_buffers(NULL, page_bufs, from, to,
+				NULL, set_move_data);
+		if (from > 0 || to < PAGE_CACHE_SIZE)
+			/* signal get_block() to update page before move-on-write */
+			walk_page_buffers(NULL, page_bufs, from, to,
+					NULL, set_partial_write);
+	}
+}
+
+static int clear_move_data(handle_t *handle, struct buffer_head *bh)
+{
+	clear_buffer_partial_write(bh);
+	clear_buffer_move_data(bh);
+	return 0;
+}
+
+static void clear_page_move_data(struct page *page)
+{
+	/*
+	 * partial_write/move_data flags are used to pass the move data block
+	 * request to next3_get_block() and should be cleared at all other ti=
mes.
+	 */
+	BUG_ON(!page_has_buffers(page));
+	walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE,
+			NULL, clear_move_data);
+}
+
 static int next3_write_begin(struct file *file, struct address_space *=
mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -1198,8 +1386,21 @@ retry:
 		ret =3D PTR_ERR(handle);
 		goto out;
 	}
+	/*
+	 * only data=3Dordered mode is supported with snapshots, so the
+	 * buffer heads are going to be attached sooner or later anyway.
+	 */
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, inode->i_sb->s_blocksize, 0);
+	/*
+	 * Check if blocks need to be moved-on-write. if they do, unmap buffe=
rs
+	 * and call block_write_begin() to remap them.
+	 */
+	if (next3_snapshot_should_move_data(inode))
+		set_page_move_data(page, from, to);
 	ret =3D block_write_begin(file, mapping, pos, len, flags, pagep, fsda=
ta,
 							next3_get_block);
+	clear_page_move_data(page);
 	if (ret)
 		goto write_begin_failed;

@@ -1546,6 +1747,12 @@ static int next3_ordered_writepage(struc
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 		page_bufs =3D page_buffers(page);
 	} else {
+		/*
+		 * Check if blocks need to be moved-on-write. if they do, unmap buff=
ers
+		 * and fall through to get_block() path.
+		 */
+		if (next3_snapshot_should_move_data(inode))
+			set_page_move_data(page, 0, PAGE_CACHE_SIZE);
 		page_bufs =3D page_buffers(page);
 		if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
 				       NULL, buffer_unmapped)) {
@@ -1565,6 +1772,7 @@ static int next3_ordered_writepage(struc
 			PAGE_CACHE_SIZE, NULL, bget_one);

 	ret =3D block_write_full_page(page, next3_get_block, wbc);
+	clear_page_move_data(page);

 	/*
 	 * The page can become unlocked at any point now, and
@@ -1778,7 +1986,8 @@ static ssize_t next3_direct_IO(int rw, s
 retry:
 	ret =3D blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
-				 next3_get_block, NULL);
+				 (rw =3D=3D WRITE) ? next3_get_block_dio : next3_get_block,
+				 NULL);
 	if (ret =3D=3D -ENOSPC && next3_should_retry_alloc(inode->i_sb, &retr=
ies))
 		goto retry;

@@ -1964,6 +2173,21 @@ static int next3_block_truncate_page(han
 			goto unlock;
 	}

+	/* check if block needs to be moved to snapshot before zeroing */
+	if (next3_snapshot_should_move_data(inode) &&
+			buffer_first_write(NULL, bh)) {
+		set_buffer_move_data(bh);
+		err =3D next3_get_block(inode, iblock, bh, 1);
+		clear_buffer_move_data(bh);
+		if (err)
+			goto unlock;
+		if (buffer_new(bh)) {
+			unmap_underlying_metadata(bh->b_bdev,
+					bh->b_blocknr);
+			clear_buffer_new(bh);
+		}
+	}
+
 	if (next3_should_journal_data(inode)) {
 		BUFFER_TRACE(bh, "get write access");
 		err =3D next3_journal_get_write_access(handle, bh);
diff -Nuarp a/fs/next3/snapshot.h b/fs/next3/snapshot.h
--- a/fs/next3/snapshot.h	2010-11-25 21:58:40.000000000 +0200
+++ b/fs/next3/snapshot.h	2010-11-25 21:58:39.000000000 +0200
@@ -97,6 +97,15 @@
 #define SNAPSHOT_SET_DISABLED(inode)		\
 	i_size_write((inode), 0)

+enum next3_bh_state_bits {
+	BH_Partial_Write =3D 29,	/* Buffer should be uptodate before write */
+	BH_Direct_IO =3D 30,		/* Buffer is under direct I/O */
+	BH_Move_Data =3D 31,		/* Data block may need to be moved-on-write */
+};
+
+BUFFER_FNS(Partial_Write, partial_write)
+BUFFER_FNS(Direct_IO, direct_io)
+BUFFER_FNS(Move_Data, move_data)


 #define next3_snapshot_cow(handle, inode, bh, cow) 0
@@ -158,6 +167,31 @@ static inline int next3_snapshot_get_cre
 }

 /*
+ * get_move_access() - move block to snapshot
+ * @handle:	JBD handle
+ * @inode:	owner of @block
+ * @block:	address of @block
+ * @move:	if false, only test if @block needs to be moved
+ *
+ * Called from next3_get_blocks_handle() before overwriting a data blo=
ck,
+ * when buffer_move() is true.  Specifically, only data blocks of
regular files,
+ * whose data is not being journaled are moved on full page write.
+ * Journaled data blocks are COWed on get_write_access().
+ * Snapshots and excluded files blocks are never moved-on-write.
+ * If @move is true, then truncate_mutex is held.
+ *
+ * Return values:
+ * =3D 1 - @block was moved or may not be overwritten
+ * =3D 0 - @block may be overwritten
+ * < 0 - error
+ */
+static inline int next3_snapshot_get_move_access(handle_t *handle,
+		struct inode *inode, next3_fsblk_t block, int move)
+{
+	return next3_snapshot_move(handle, inode, block, 1, move);
+}
+
+/*
  * get_delete_access() - move count blocks to snapshot
  * @handle:	JBD handle
  * @inode:	owner of blocks
@@ -216,6 +250,19 @@ extern next3_fsblk_t next3_get_inode_blo



+/*
+ * check if the data blocks of @inode should be moved-on-write
+ */
+static inline int next3_snapshot_should_move_data(struct inode *inode)
+{
+	if (!NEXT3_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				NEXT3_FEATURE_RO_COMPAT_HAS_SNAPSHOT))
+		return 0;
+	/* when a data block is journaled, it is already COWed as metadata */
+	if (next3_should_journal_data(inode))
+		return 0;
+	return 1;
+}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
