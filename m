From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: kernel BUG at fs/ext4/inode.c:3709! (Re: open bugs found by
 fuzzing)
Date: Sat, 16 Jul 2016 18:15:00 +0200
Message-ID: <578A5D84.2050207@oracle.com>
References: <5787FFBA.70406@oracle.com> <5788E787.106@oracle.com>
 <20160715172453.GA18010@thunk.org> <578923EF.1020305@oracle.com>
 <20160715194933.GE26465@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070408000007050402020801"
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23639 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbcGPQPN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Jul 2016 12:15:13 -0400
In-Reply-To: <20160715194933.GE26465@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070408000007050402020801
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 07/15/2016 09:49 PM, Theodore Ts'o wrote:
> The problem is fixing this is messy.  The problem is if we just set
> i_size without zeroing out the bytes between i_size and the end of the
> page, we're asking for trouble.  For example, you could think that
> it's enough to have ext4_readpage() care of doing the zeroing after
> the block is read from disk and then decrypted, but what if the user
> does a sparse write beyond i_size?
>
> So either we allow truncate(2) to be non-atomic with respect to
> crashes for encrypted files, or alternatively we would have to set a
> flag in the inode indicating that the bytes between i_size and the end
> of the page must be zeroed before the file can be modified in any way,
> or before an attempted O_DIRECT read of the last block, and then when
> we read the inode from diks into the inode cache, if the bit is set
> and we have the encryption key (which we would need if we want to
> modify the file), we could take zeroing the tail end of the file then.

Can we delay the truncation/cleanup of that inode until the correct key
gets loaded? It's not like anybody could open (or otherwise operate on
the data of) that inode anyway until they key is present, right?

Something like the attached (very hacky) patch seems to allow my fuzzed
filesystem to mount without error and keeps the inode in question on the
on-disk orphan list:

+ mount (...)
EXT4-fs (loop0): 1 encrypted truncate delayed
EXT4-fs (loop0): recovery complete
EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: 
errors=remount-ro

You'd of course have to check whether the inode needs the
cleanup/truncate if it's ever accessed and return an error or something.
Maybe in ext4_iget()/ext4_lookup()?

It's probably a stupid idea for a number of reasons, but I'd be happy to
learn exactly why :-)


Vegard

--------------070408000007050402020801
Content-Type: text/x-patch;
 name="ext4-encrypted-orphans.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ext4-encrypted-orphans.patch"

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c13a4e4..f7b662a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2303,10 +2303,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 				struct ext4_super_block *es)
 {
 	unsigned int s_flags = sb->s_flags;
-	int nr_orphans = 0, nr_truncates = 0;
+	int nr_orphans = 0, nr_truncates = 0, nr_encrypted = 0;
 #ifdef CONFIG_QUOTA
 	int i;
 #endif
+	LIST_HEAD(encrypted_orphans);
+
 	if (!es->s_last_orphan) {
 		jbd_debug(4, "no orphan inodes to clean up\n");
 		return;
@@ -2374,6 +2376,19 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 			break;
 		}
 
+		if (inode->i_nlink && ext4_encrypted_inode(inode)) {
+			if (fscrypt_get_encryption_info(inode)
+				|| !fscrypt_has_encryption_key(inode))
+			{
+				/* Can't cleanup this yet */
+				list_add(&EXT4_I(inode)->i_orphan, &encrypted_orphans);
+				es->s_last_orphan = cpu_to_le32(NEXT_ORPHAN(inode));
+				NEXT_ORPHAN(inode) = 0;
+				nr_encrypted++;
+				continue;
+			}
+		}
+
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 		dquot_initialize(inode);
 		if (inode->i_nlink) {
@@ -2400,6 +2415,24 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 		iput(inode);  /* The delete magic happens here! */
 	}
 
+	{
+		/*
+		 * Put the delayed orphans back on the on-disk list. In order
+		 * to do the final cleanup of these inodes, the filesystem
+		 * must (currently) be remounted with the corresponding
+		 * encryption keys loaded.
+		 */
+		struct ext4_inode_info *ei, *tmp;
+		list_for_each_entry_safe(ei, tmp, &encrypted_orphans, i_orphan) {
+			struct inode *inode = &ei->vfs_inode;
+
+			NEXT_ORPHAN(inode) = es->s_last_orphan;
+			es->s_last_orphan = cpu_to_le32(inode->i_ino);
+			INIT_LIST_HEAD(&ei->i_orphan);
+			iput(inode);
+		}
+	}
+
 #define PLURAL(x) (x), ((x) == 1) ? "" : "s"
 
 	if (nr_orphans)
@@ -2408,6 +2441,10 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	if (nr_truncates)
 		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
 		       PLURAL(nr_truncates));
+	if (nr_encrypted)
+		ext4_msg(sb, KERN_INFO, "%d encrypted truncate%s delayed",
+		       PLURAL(nr_encrypted));
+
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
 	for (i = 0; i < EXT4_MAXQUOTAS; i++) {

--------------070408000007050402020801--
