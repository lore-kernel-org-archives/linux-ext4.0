From: Amir Goldstein <amir73il@gmail.com>
Subject: Could you help with move-on-write review?
Date: Thu, 25 Nov 2010 16:11:52 +0200
Message-ID: <AANLkTinJS=mMc+Xy=P7-pF-hW8+6zBXey8X5mF_0NXUc@mail.gmail.com>
References: <AANLkTimsBFPcRv_=+JbxXU+8wK218V-NXAwH5OmGHnFZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62076 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0KYOLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Nov 2010 09:11:53 -0500
Received: by qwb7 with SMTP id 7so1003145qwb.19
        for <linux-ext4@vger.kernel.org>; Thu, 25 Nov 2010 06:11:52 -0800 (PST)
In-Reply-To: <AANLkTimsBFPcRv_=+JbxXU+8wK218V-NXAwH5OmGHnFZ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

I would like to ask you as a big favor to review this patch,
not as candidate for inclusion in mainline of course, but as a code/des=
ign
review for my new move-on-write hooks. hopefully, some of this code wil=
l
find it's way to ext4 some day soon.

The problems with the old data hooks, which I may have mentioned, are:
1. second write to mmaped page did not call get_block() to trigger
    move-on-write.
2. quota_write() called next3_bread(create=3D1) without notifying this
    is a partial write and move-on-write has corrupted it's data,
    resulting in broken quota file.
3. direct I/O was not supported.

The new design uses 3 buffer head flags to signal get_block() about
move-on-write:
1. buffer_move_data() is an explicit request to trigger move-on-write.
=A0=A0  users which do not declare move_data (like quota_write) will no=
t
    trigger move-on-write. previous hooks would do move-on-write on
    all regular files data without an explicit request.
=A0  =A0new design suggests that we rather corrupt snapshot data
    (missed move-on-write) then corrupt the file system live data
    (false positive move-on-write).
2. buffer_partial_write() signals that in case of move-on-write, the
old block data
    needs to be read, before mapping the buffer to a new block.
3. buffer_direct_io() signals that in case of move-on-write or hole fil=
ling,
    the buffer should not be mapped on return.

There are 4 places I found that map data blocks and should trigger
move-on-write:
1. write_begin() sets move_data and optionally partial_write flags and
    unmaps buffers
2. ordered_writepage() sets move_data flag and unmaps buffers
    (snapshots only work with data=3Dordered)
3. truncate_page() sets move_data flag (and calls next3_get_block() its=
elf)
4. next3_get_block() sets direct_io and move_data flags when (create &&=
 !handle)

Know issue:
snapshot copy of quota files is not consistent with snapshot'ed
file system (can be fixed, but is it relevant for read-only mount?)

you should know that the core move-on-write code in
get_blocks_handle() has not changed much
(only the move_data and direct_io flag checks were added) and it has
been used for quite some time now,
so I do not expect to find major bugs in the block move mechanism itsel=
f.

I revised my 'next3 test' scripts to rewrite random data to files via d=
irect I/O
and mmap to test the new move-on-write hooks in next3_get_block() and i=
n
ordered_writepage() and it all seems to work fine.
quotas also seems to work fine now.

I understand if this review is not on the top of your priorities,
but if you can find the time for it, I would very much appreciate it.

Thanks,
Amir.


=3D=3D=3Dnext3_snapshot_hooks_data.patch=3D=3D=3D

next3: snapshot hooks - move data blocks

Before every regular file data buffer write,
the function next3_get_block() is called to map the buffer to disk.
We use this hook to call the snapshot API snapshot_get_move_access(),
to optionally move the block to the snapshot file.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
=A0inode.c =A0 =A0| =A0213 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++++-
=A0snapshot.h | =A0 47 ++++++++++++
=A02 files changed, 257 insertions(+), 3 deletions(-)

diff -Nuarp a/fs/next3/inode.c b/fs/next3/inode.c
--- a/fs/next3/inode.c =A02010-11-24 17:53:53.586859439 +0200
+++ b/fs/next3/inode.c =A02010-11-24 17:53:53.276859434 +0200
@@ -827,6 +827,43 @@ int next3_get_blocks_handle(handle_t *ha

=A0 =A0 =A0 =A0partial =3D next3_get_branch(inode, depth, offsets, chai=
n, &err);

+ =A0 =A0 =A0 if (!partial && create && buffer_move_data(bh_result)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!next3_snapshot_should_move_data(i=
node));
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_block =3D le32_to_cpu(chain[depth -=
 1].key);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks_to_boundary =3D 0;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* should move 1 data block to snapshot? =
*/
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D next3_snapshot_get_move_access(ha=
ndle, inode,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_blo=
ck, 0);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* do not map found block=
 */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 partial =3D chain + depth=
 - 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err < 0)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* cleanup the whole chai=
n and exit */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_direct_io(bh_result)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* suppress direct I/O wr=
ite to block that
needs to be moved */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err > 0)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check again under trun=
cate_mutex */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EAGAIN;
+ =A0 =A0 =A0 }
+ =A0 =A0 =A0 if (partial && create && buffer_direct_io(bh_result)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* suppress direct I/O write to holes */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t end =3D ((iblock + maxblocks - 1) =
<< inode->i_blkbits) + 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we do not know the original write le=
ngth, but it
has to be at least
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* 1 byte into the last requested block=
=2E if the
minimal length write
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* isn't going to extend i_size, we mus=
t be cautious
and assume that
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* direct I/O is async and refuse to fi=
ll the hole.
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (end <=3D inode->i_size) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0/* Simplest case - block found, no allocation needed */
=A0 =A0 =A0 =A0if (!partial) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0first_block =3D le32_to_cpu(chain[depth =
- 1].key);
@@ -883,6 +920,20 @@ int next3_get_blocks_handle(handle_t *ha
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0partial--;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0partial =3D next3_get_branch(inode, dept=
h, offsets, chain, &err);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!partial && =A0buffer_move_data(bh_re=
sult)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!next3_snapshot_sh=
ould_move_data(inode));
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 first_block =3D le32_to_c=
pu(chain[depth - 1].key);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 blocks_to_boundary =3D 0;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* should move 1 data blo=
ck to snapshot? */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D next3_snapshot_ge=
t_move_access(handle, inode,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 first_block, 0);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* re-all=
ocate 1 data block */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 partial =3D=
 chain + depth - 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err < 0)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* cleanu=
p the whole chain and exit */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_=
mutex;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!partial) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0count++;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ei->trunca=
te_mutex);
@@ -919,6 +970,43 @@ int next3_get_blocks_handle(handle_t *ha
=A0 =A0 =A0 =A0if (err)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_mutex;

+ =A0 =A0 =A0 if (*(partial->p)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* old block is being replaced with a new=
 block */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_partial_write(bh_result) &&
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !buffer_u=
ptodate(bh_result)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* read old block data be=
fore moving it to snapshot */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 map_bh(bh_result, inode->=
i_sb,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 le32_to_cpu(*(partial->p)));
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ll_rw_block(READ, 1, &bh_=
result);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_on_buffer(bh_result)=
;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* clear old block mappin=
g */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_mapped(bh_re=
sult);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!buffer_uptodate(bh_r=
esult)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -=
EIO;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_=
mutex;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_partial_write(bh_result))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* prevent zero out of pa=
ge in block_write_begin() */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SetPageUptodate(bh_result=
->b_page);
+
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* move old block to snapshot */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D next3_snapshot_get_move_access(ha=
ndle, inode,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to_c=
pu(*(partial->p)), 1);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 1) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* failed to move to snap=
shot - free new block */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next3_free_blocks(handle,=
 inode,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 le32_to_cpu(partial->key), 1);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D ret ? : -EIO;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_mutex;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* block moved to snapshot - continue to =
splice new block */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
+ =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0/*
=A0 =A0 =A0 =A0 * The next3_splice_branch call will free and forget any=
 buffers
=A0 =A0 =A0 =A0 * on the new chain if there is a failure, but that risk=
s using
@@ -981,6 +1069,13 @@ static int next3_get_block(struct inode
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0started =3D 1;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* signal next3_get_blocks_handle() to =
return unmapped
block if block
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is not allocated or if it needs to b=
e moved to snapshot.
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_direct_io(bh_result);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (next3_snapshot_should_move_data(inode=
))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_move_data(bh_r=
esult);
=A0 =A0 =A0 =A0}

=A0 =A0 =A0 =A0ret =3D next3_get_blocks_handle(handle, inode, iblock,
@@ -1166,6 +1261,71 @@ static void next3_truncate_failed_write(
=A0 =A0 =A0 =A0next3_truncate(inode);
=A0}

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
+ =A0 =A0 =A0 return !buffer_jbd(bh);
+}
+
+static int set_move_data(handle_t *handle, struct buffer_head *bh)
+{
+ =A0 =A0 =A0 BUG_ON(buffer_move_data(bh));
+ =A0 =A0 =A0 clear_buffer_mapped(bh);
+ =A0 =A0 =A0 set_buffer_move_data(bh);
+ =A0 =A0 =A0 return 0;
+}
+
+static int set_partial_write(handle_t *handle, struct buffer_head *bh)
+{
+ =A0 =A0 =A0 BUG_ON(buffer_partial_write(bh));
+ =A0 =A0 =A0 set_buffer_partial_write(bh);
+ =A0 =A0 =A0 return 0;
+}
+
+static void set_page_move_data(struct page *page, unsigned from, unsig=
ned to)
+{
+ =A0 =A0 =A0 struct buffer_head *page_bufs =3D page_buffers(page);
+
+ =A0 =A0 =A0 BUG_ON(!page_has_buffers(page));
+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* make sure that get_block() is called even for mapped=
 buffers,
+ =A0 =A0 =A0 =A0* but not if all buffers were written since last snaps=
hot take.
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 if (walk_page_buffers(NULL, page_bufs, from, to,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, buf=
fer_first_write)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* signal get_block() to move-on-write */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 walk_page_buffers(NULL, page_bufs, from, =
to,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, set=
_move_data);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (from > 0 || to < PAGE_CACHE_SIZE)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* signal get_block() to =
update page before
move-on-write */
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 walk_page_buffers(NULL, p=
age_bufs, from, to,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 NULL, set_partial_write);
+ =A0 =A0 =A0 }
+}
+
+static int clear_move_data(handle_t *handle, struct buffer_head *bh)
+{
+ =A0 =A0 =A0 clear_buffer_partial_write(bh);
+ =A0 =A0 =A0 clear_buffer_move_data(bh);
+ =A0 =A0 =A0 return 0;
+}
+
+static void clear_page_move_data(struct page *page)
+{
+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* partial_write/move_data flags are used to pass the m=
ove data block
+ =A0 =A0 =A0 =A0* request to next3_get_block() and should be cleared a=
t all
other times.
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 BUG_ON(!page_has_buffers(page));
+ =A0 =A0 =A0 walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE=
_SIZE,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, clear_move_data);
+}
+
=A0static int next3_write_begin(struct file *file, struct address_space=
 *mapping,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t p=
os, unsigned len, unsigned flags,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct p=
age **pagep, void **fsdata)
@@ -1198,8 +1358,21 @@ retry:
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D PTR_ERR(handle);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
=A0 =A0 =A0 =A0}
+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* only data=3Dordered mode is supported with snapshots=
, so the
+ =A0 =A0 =A0 =A0* buffer heads are going to be attached sooner or late=
r anyway.
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 if (!page_has_buffers(page))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_empty_buffers(page, inode->i_sb->s=
_blocksize, 0);
+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* Check if blocks need to be moved-on-write. if they d=
o, unmap buffers
+ =A0 =A0 =A0 =A0* and call block_write_begin() to remap them.
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 if (next3_snapshot_should_move_data(inode))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_move_data(page, from, to);
=A0 =A0 =A0 =A0ret =3D block_write_begin(file, mapping, pos, len, flags=
, pagep, fsdata,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next3_get_block);
+ =A0 =A0 =A0 clear_page_move_data(page);
=A0 =A0 =A0 =A0if (ret)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto write_begin_failed;

@@ -1546,6 +1719,12 @@ static int next3_ordered_writepage(struc
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(1 << BH=
_Dirty)|(1 << BH_Uptodate));
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_bufs =3D page_buffers(page);
=A0 =A0 =A0 =A0} else {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Check if blocks need to be moved-on-=
write. if they
do, unmap buffers
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* and fall through to get_block() path=
=2E
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (next3_snapshot_should_move_data(inode=
))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_move_data(page, =
0, PAGE_CACHE_SIZE);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page_bufs =3D page_buffers(page);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!walk_page_buffers(NULL, page_bufs, =
0, PAGE_CACHE_SIZE,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 NULL, buffer_unmapped)) {
@@ -1565,6 +1744,7 @@ static int next3_ordered_writepage(struc
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0PAGE_CACHE_SIZE, NULL, b=
get_one);

=A0 =A0 =A0 =A0ret =3D block_write_full_page(page, next3_get_block, wbc=
);
+ =A0 =A0 =A0 clear_page_move_data(page);

=A0 =A0 =A0 =A0/*
=A0 =A0 =A0 =A0 * The page can become unlocked at any point now, and
@@ -1754,6 +1934,19 @@ static ssize_t next3_direct_IO(int rw, s
=A0 =A0 =A0 =A0int orphan =3D 0;
=A0 =A0 =A0 =A0size_t count =3D iov_length(iov, nr_segs);
=A0 =A0 =A0 =A0int retries =3D 0;
+ =A0 =A0 =A0 int flags;
+
+ =A0 =A0 =A0 /*
+ =A0 =A0 =A0 =A0* suppress DIO_SKIP_HOLES to make sure that direct I/O=
 writes
always call
+ =A0 =A0 =A0 =A0* next3_get_block() with create=3D1, so that we can fa=
ll back to buffered
+ =A0 =A0 =A0 =A0* I/O when data blocks need to be moved to snapshot.
+ =A0 =A0 =A0 =A0*/
+ =A0 =A0 =A0 if (NEXT3_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NEXT3_FEA=
TURE_RO_COMPAT_HAS_SNAPSHOT))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D DIO_LOCKING;
+ =A0 =A0 =A0 else
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D DIO_LOCKING | DIO_SKIP_HOLES;
+
=A0 =A0 =A0 =A0if (rw =3D=3D WRITE) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t final_size =3D offset + count;

@@ -1776,9 +1969,8 @@ static ssize_t next3_direct_IO(int rw, s
=A0 =A0 =A0 =A0}

=A0retry:
- =A0 =A0 =A0 ret =3D blockdev_direct_IO(rw, iocb, inode, inode->i_sb->=
s_bdev, iov,
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset=
, nr_segs,
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0next3_=
get_block, NULL);
+ =A0 =A0ret =3D __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_b=
dev, iov,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 offset, nr_segs, next3_ge=
t_block, NULL, NULL, flags);
=A0 =A0 =A0 =A0if (ret =3D=3D -ENOSPC && next3_should_retry_alloc(inode=
->i_sb, &retries))
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retry;

@@ -1964,6 +2156,21 @@ static int next3_block_truncate_page(han
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto unlock;
=A0 =A0 =A0 =A0}

+ =A0 =A0 =A0 /* check if block needs to be moved to snapshot before ze=
roing */
+ =A0 =A0 =A0 if (next3_snapshot_should_move_data(inode) &&
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buffer_first_write(NULL, =
bh)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_buffer_move_data(bh);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D next3_get_block(inode, iblock, bh=
, 1);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_move_data(bh);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unlock;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (buffer_new(bh)) {
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unmap_underlying_metadata=
(bh->b_bdev,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 bh->b_blocknr);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_buffer_new(bh);
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
+ =A0 =A0 =A0 }
+
=A0 =A0 =A0 =A0if (next3_should_journal_data(inode)) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUFFER_TRACE(bh, "get write access");
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D next3_journal_get_write_access(h=
andle, bh);
diff -Nuarp a/fs/next3/snapshot.h b/fs/next3/snapshot.h
--- a/fs/next3/snapshot.h =A0 =A0 =A0 2010-11-24 17:53:53.626859575 +02=
00
+++ b/fs/next3/snapshot.h =A0 =A0 =A0 2010-11-24 17:53:53.366859486 +02=
00
@@ -97,6 +97,15 @@
=A0#define SNAPSHOT_SET_DISABLED(inode) =A0 =A0 =A0 =A0 =A0 \
=A0 =A0 =A0 =A0i_size_write((inode), 0)

+enum next3_bh_state_bits {
+ =A0 =A0 =A0 BH_Partial_Write =3D 29, =A0/* Buffer should be uptodate =
before write */
+ =A0 =A0 =A0 BH_Direct_IO =3D 30, =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Buffer=
 is under direct I/O */
+ =A0 =A0 =A0 BH_Move_Data =3D 31, =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Data b=
lock may need to be
moved-on-write */
+};
+
+BUFFER_FNS(Partial_Write, partial_write)
+BUFFER_FNS(Direct_IO, direct_io)
+BUFFER_FNS(Move_Data, move_data)


=A0#define next3_snapshot_cow(handle, inode, bh, cow) 0
@@ -158,6 +167,31 @@ static inline int next3_snapshot_get_cre
=A0}

=A0/*
+ * get_move_access() - move block to snapshot
+ * @handle: =A0 =A0JBD handle
+ * @inode: =A0 =A0 owner of @block
+ * @block: =A0 =A0 address of @block
+ * @move: =A0 =A0 =A0if false, only test if @block needs to be moved
+ *
+ * Called from next3_get_blocks_handle() before overwriting a data blo=
ck,
+ * when buffer_move() is true. =A0Specifically, only data blocks of
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
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode, next3_fsblk_t block,=
 int move)
+{
+ =A0 =A0 =A0 return next3_snapshot_move(handle, inode, block, 1, move)=
;
+}
+
+/*
=A0* get_delete_access() - move count blocks to snapshot
=A0* @handle: =A0 =A0JBD handle
=A0* @inode: =A0 =A0 owner of blocks
@@ -216,6 +250,19 @@ extern next3_fsblk_t next3_get_inode_blo



+/*
+ * check if the data blocks of @inode should be moved-on-write
+ */
+static inline int next3_snapshot_should_move_data(struct inode *inode)
+{
+ =A0 =A0 =A0 if (!NEXT3_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NEXT3_FEA=
TURE_RO_COMPAT_HAS_SNAPSHOT))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
+ =A0 =A0 =A0 /* when a data block is journaled, it is already COWed as=
 metadata */
+ =A0 =A0 =A0 if (next3_should_journal_data(inode))
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
+ =A0 =A0 =A0 return 1;
+}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
