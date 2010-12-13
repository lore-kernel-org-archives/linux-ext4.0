From: Ted Ts'o <tytso@mit.edu>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Sun, 12 Dec 2010 21:06:57 -0500
Message-ID: <20101213020657.GB4513@thunk.org>
References: <20101210023852.GB3059@thunk.org>
 <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org>
 <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
 <20101212124354.GA4513@thunk.org>
 <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>, Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jon Nelson <jnelson@jamponi.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44636 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab0LMCHR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Dec 2010 21:07:17 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 12, 2010 at 07:11:28AM -0600, Jon Nelson wrote:
> I'm glad you've been able to reproduce the problem! If you should need
> any further assistance, please do not hesitate to ask.

This patch seems to fix the problem for me.  (Unless the partition is
mounted with mblk_io_submit.)

Could you confirm that it fixes it for you as well?

Thanks!

					- Ted

commit a8649d85bd0ab3be6014918bd9eae319a0ffc691
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Dec 12 20:57:19 2010 -0500

    ext4: Turn off multiple page-io submission by default
    
    Jon Nelson has found a test case which causes postgresql to fail with
    the error:
    
    psql:t.sql:4: ERROR: invalid page header in block 38269 of relation base/16384/16581
    
    Under memory pressure, it looks like part of a file can end up getting
    replaced by zero's.  Until we can figure out the cause, we'll roll
    back the change and use block_write_full_page() instead of
    ext4_bio_write_page().  The new, more efficient writing function can
    be used via the mount option mblk_io_submit, so we can test and fix
    the new page I/O code.
    
    To reproduce the problem, install postgres 8.4 or 9.0, and pin enough
    memory such that the system just at the end of triggering writeback
    before running the following sql script:
    
    begin;
    create temporary table foo as select x as a, ARRAY[x] as b FROM
    generate_series(1, 10000000 ) AS x;
    create index foo_a_idx on foo (a);
    create index foo_b_idx on foo USING GIN (b);
    rollback;
    
    If the temporary table is created on a hard drive partition which is
    encrypted using dm_crypt, then under memory pressure, approximately
    30-40% of the time, pgsql will issue the above failure.
    
    This patch should fix this problem, and the problem will come back if
    the file system is mounted with the mblk_io_submit mount option.
    
    Reported-by: Jon Nelson <jnelson@jamponi.net>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6a5edea..6eb598b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -910,6 +910,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
+#define EXT4_MOUNT_MBLK_IO_SUBMIT	0x4000000
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_DATA_ERR_ABORT	0x10000000 /* Abort on file data write */
 #define EXT4_MOUNT_BLOCK_VALIDITY	0x20000000 /* Block validity checking */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bdbe699..e659597 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2125,9 +2125,12 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 			 */
 			if (unlikely(journal_data && PageChecked(page)))
 				err = __ext4_journalled_writepage(page, len);
-			else
+			else if (test_opt(inode->i_sb, MBLK_IO_SUBMIT))
 				err = ext4_bio_write_page(&io_submit, page,
 							  len, mpd->wbc);
+			else
+				err = block_write_full_page(page,
+					noalloc_get_block_write, mpd->wbc);
 
 			if (!err)
 				mpd->pages_written++;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e32195d..fb15c9c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1026,6 +1026,8 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	    !(def_mount_opts & EXT4_DEFM_NODELALLOC))
 		seq_puts(seq, ",nodelalloc");
 
+	if (test_opt(sb, MBLK_IO_SUBMIT))
+		seq_puts(seq, ",mblk_io_submit");
 	if (sbi->s_stripe)
 		seq_printf(seq, ",stripe=%lu", sbi->s_stripe);
 	/*
@@ -1239,8 +1241,8 @@ enum {
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
 	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
 	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
-	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
-	Opt_block_validity, Opt_noblock_validity,
+	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
+	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard,
@@ -1304,6 +1306,8 @@ static const match_table_t tokens = {
 	{Opt_resize, "resize"},
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
+	{Opt_mblk_io_submit, "mblk_io_submit"},
+	{Opt_nomblk_io_submit, "nomblk_io_submit"},
 	{Opt_block_validity, "block_validity"},
 	{Opt_noblock_validity, "noblock_validity"},
 	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
@@ -1725,6 +1729,12 @@ set_qf_format:
 		case Opt_nodelalloc:
 			clear_opt(sbi->s_mount_opt, DELALLOC);
 			break;
+		case Opt_mblk_io_submit:
+			set_opt(sbi->s_mount_opt, MBLK_IO_SUBMIT);
+			break;
+		case Opt_nomblk_io_submit:
+			clear_opt(sbi->s_mount_opt, MBLK_IO_SUBMIT);
+			break;
 		case Opt_stripe:
 			if (match_int(&args[0], &option))
 				return 0;
