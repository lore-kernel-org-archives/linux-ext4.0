From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] EXT3: Change all super.c messages to print the device
Date: Wed, 20 May 2009 18:00:47 +0200
Message-ID: <20090520160047.GI8684@one.firstfloor.org>
References: <20090426184900.GA15038@basil.nowhere.org> <20090519171430.GA26480@atrey.karlin.mff.cuni.cz> <20090519174901.GB9053@mit.edu> <4A130022.6090807@redhat.com> <20090520113047.GC8684@one.firstfloor.org> <4A1426BE.2010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Theodore Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:54043 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZETPyt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 May 2009 11:54:49 -0400
Content-Disposition: inline
In-Reply-To: <4A1426BE.2010101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Just a one I guess:
> 
> $ grep '^+' patch | grep 'KERN[_A-Z]\+[ $]'
> +			ext3_msg(sb, KERN_ERR "(no)acl options not supported");
> +	printk(KERN_INFO "EXT3-FS (%s): ", sb->s_id);

Ok thanks. Not sure how grep missed that one

Here's a updated patch with that fixed.

---


EXT3: Change all super.c messages to print the device v2

I had a problem where it was unclear to which device a ext3 message belonged.

This patch changes ext3 super.c to include the device name with all 
warning/error messages, by using a new utility function ext3_msg. 
It's a rather large patch, but very mechanic. I left debug printks
alone.

v2: Add a missing comma (Eric Sandeen)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext3/super.c         |  355 ++++++++++++++++++++++++------------------------
 include/linux/ext3_fs.h |    2 
 2 files changed, 184 insertions(+), 173 deletions(-)

Index: linux-2.6.30-rc3-ak/fs/ext3/super.c
===================================================================
--- linux-2.6.30-rc3-ak.orig/fs/ext3/super.c	2009-04-29 21:03:21.000000000 +0200
+++ linux-2.6.30-rc3-ak/fs/ext3/super.c	2009-05-01 10:03:49.000000000 +0200
@@ -175,7 +175,7 @@
 			journal_abort(journal, -EIO);
 	}
 	if (test_opt (sb, ERRORS_RO)) {
-		printk (KERN_CRIT "Remounting filesystem read-only\n");
+		ext3_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		sb->s_flags |= MS_RDONLY;
 	}
 	ext3_commit_super(sb, es, 1);
@@ -269,8 +269,6 @@
 {
 	va_list args;
 
-	printk (KERN_CRIT "ext3_abort called.\n");
-
 	va_start(args, fmt);
 	printk(KERN_CRIT "EXT3-fs error (device %s): %s: ",sb->s_id, function);
 	vprintk(fmt, args);
@@ -283,7 +281,7 @@
 	if (sb->s_flags & MS_RDONLY)
 		return;
 
-	printk(KERN_CRIT "Remounting filesystem read-only\n");
+	ext3_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 	sb->s_flags |= MS_RDONLY;
 	EXT3_SB(sb)->s_mount_opt |= EXT3_MOUNT_ABORT;
@@ -291,6 +289,18 @@
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
 }
 
+void ext3_msg (struct super_block * sb, const char *prefix,
+		   const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	printk("%sEXT3-fs (%s): ", prefix, sb->s_id);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+}
+
 void ext3_warning (struct super_block * sb, const char * function,
 		   const char * fmt, ...)
 {
@@ -332,7 +342,7 @@
 /*
  * Open the external journal device
  */
-static struct block_device *ext3_blkdev_get(dev_t dev)
+static struct block_device *ext3_blkdev_get(dev_t dev, struct super_block *sb)
 {
 	struct block_device *bdev;
 	char b[BDEVNAME_SIZE];
@@ -343,7 +353,7 @@
 	return bdev;
 
 fail:
-	printk(KERN_ERR "EXT3: failed to open journal device %s: %ld\n",
+	ext3_msg(sb, "failed to open journal device %s: %ld",
 			__bdevname(dev, b), PTR_ERR(bdev));
 	return NULL;
 }
@@ -850,7 +860,7 @@
 	{Opt_err, NULL},
 };
 
-static ext3_fsblk_t get_sb_block(void **data)
+static ext3_fsblk_t get_sb_block(void **data, struct super_block *sb)
 {
 	ext3_fsblk_t	sb_block;
 	char		*options = (char *) *data;
@@ -861,7 +871,7 @@
 	/*todo: use simple_strtoll with >32bit ext3 */
 	sb_block = simple_strtoul(options, &options, 0);
 	if (*options && *options != ',') {
-		printk("EXT3-fs: Invalid sb specification: %s\n",
+		ext3_msg(sb, "Invalid sb specification: %s",
 		       (char *) *data);
 		return 1;
 	}
@@ -961,7 +971,7 @@
 #else
 		case Opt_user_xattr:
 		case Opt_nouser_xattr:
-			printk("EXT3 (no)user_xattr options not supported\n");
+			ext3_msg(sb, KERN_ERR, "(no)user_xattr options not supported");
 			break;
 #endif
 #ifdef CONFIG_EXT3_FS_POSIX_ACL
@@ -974,7 +984,7 @@
 #else
 		case Opt_acl:
 		case Opt_noacl:
-			printk("EXT3 (no)acl options not supported\n");
+			ext3_msg(sb, KERN_ERR, "(no)acl options not supported");
 			break;
 #endif
 		case Opt_reservation:
@@ -990,16 +1000,16 @@
 			   user to specify an existing inode to be the
 			   journal file. */
 			if (is_remount) {
-				printk(KERN_ERR "EXT3-fs: cannot specify "
-				       "journal on remount\n");
+				ext3_msg(sb, KERN_ERR,
+					"Cannot specify journal on remount");
 				return 0;
 			}
 			set_opt (sbi->s_mount_opt, UPDATE_JOURNAL);
 			break;
 		case Opt_journal_inum:
 			if (is_remount) {
-				printk(KERN_ERR "EXT3-fs: cannot specify "
-				       "journal on remount\n");
+				ext3_msg(sb, KERN_ERR,
+					"Cannot specify journal on remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option))
@@ -1008,8 +1018,8 @@
 			break;
 		case Opt_journal_dev:
 			if (is_remount) {
-				printk(KERN_ERR "EXT3-fs: cannot specify "
-				       "journal on remount\n");
+				ext3_msg(sb, KERN_ERR,
+					"Cannot specify journal on remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option))
@@ -1040,9 +1050,8 @@
 			if (is_remount) {
 				if ((sbi->s_mount_opt & EXT3_MOUNT_DATA_FLAGS)
 						!= data_opt) {
-					printk(KERN_ERR
-						"EXT3-fs: cannot change data "
-						"mode on remount\n");
+					ext3_msg(sb, KERN_ERR,
+						"Cannot change data mode on remount");
 					return 0;
 				}
 			} else {
@@ -1065,31 +1074,31 @@
 set_qf_name:
 			if (sb_any_quota_loaded(sb) &&
 			    !sbi->s_qf_names[qtype]) {
-				printk(KERN_ERR
-					"EXT3-fs: Cannot change journaled "
-					"quota options when quota turned on.\n");
+				ext3_msg(sb, KERN_ERR,
+					"Cannot change journaled "
+					"quota options when quota turned on");
 				return 0;
 			}
 			qname = match_strdup(&args[0]);
 			if (!qname) {
-				printk(KERN_ERR
-					"EXT3-fs: not enough memory for "
-					"storing quotafile name.\n");
+				ext3_msg(sb, KERN_ERR,
+					"Not enough memory for "
+					"storing quotafile name");
 				return 0;
 			}
 			if (sbi->s_qf_names[qtype] &&
 			    strcmp(sbi->s_qf_names[qtype], qname)) {
-				printk(KERN_ERR
-					"EXT3-fs: %s quota file already "
-					"specified.\n", QTYPE2NAME(qtype));
+				ext3_msg(sb, KERN_ERR,
+					"%s quota file already "
+					"specified", QTYPE2NAME(qtype));
 				kfree(qname);
 				return 0;
 			}
 			sbi->s_qf_names[qtype] = qname;
 			if (strchr(sbi->s_qf_names[qtype], '/')) {
-				printk(KERN_ERR
-					"EXT3-fs: quotafile must be on "
-					"filesystem root.\n");
+				ext3_msg(sb, KERN_ERR,
+					"quotafile must be on "
+					"filesystem root");
 				kfree(sbi->s_qf_names[qtype]);
 				sbi->s_qf_names[qtype] = NULL;
 				return 0;
@@ -1104,9 +1113,9 @@
 clear_qf_name:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_qf_names[qtype]) {
-				printk(KERN_ERR "EXT3-fs: Cannot change "
+				ext3_msg(sb, KERN_ERR, "Cannot change "
 					"journaled quota options when "
-					"quota turned on.\n");
+					"quota turned on");
 				return 0;
 			}
 			/*
@@ -1123,9 +1132,9 @@
 set_qf_format:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
-				printk(KERN_ERR "EXT3-fs: Cannot change "
+				ext3_msg(sb, KERN_ERR, "Cannot change "
 					"journaled quota options when "
-					"quota turned on.\n");
+					"quota turned on");
 				return 0;
 			}
 			sbi->s_jquota_fmt = qfmt;
@@ -1141,8 +1150,8 @@
 			break;
 		case Opt_noquota:
 			if (sb_any_quota_loaded(sb)) {
-				printk(KERN_ERR "EXT3-fs: Cannot change quota "
-					"options when quota turned on.\n");
+				ext3_msg(sb, KERN_ERR, "Cannot change quota "
+					"options when quota turned on");
 				return 0;
 			}
 			clear_opt(sbi->s_mount_opt, QUOTA);
@@ -1153,8 +1162,8 @@
 		case Opt_quota:
 		case Opt_usrquota:
 		case Opt_grpquota:
-			printk(KERN_ERR
-				"EXT3-fs: quota options not supported.\n");
+			ext3_msg(sb, KERN_ERR,
+				"quota options not supported");
 			break;
 		case Opt_usrjquota:
 		case Opt_grpjquota:
@@ -1162,9 +1171,8 @@
 		case Opt_offgrpjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
-			printk(KERN_ERR
-				"EXT3-fs: journaled quota options not "
-				"supported.\n");
+			ext3_msg(sb, KERN_ERR,
+				"journaled quota options not supported");
 			break;
 		case Opt_noquota:
 			break;
@@ -1184,8 +1192,9 @@
 			break;
 		case Opt_resize:
 			if (!is_remount) {
-				printk("EXT3-fs: resize option only available "
-					"for remount\n");
+				ext3_msg(sb, KERN_ERR,
+					"resize option only available "
+					"for remount");
 				return 0;
 			}
 			if (match_int(&args[0], &option) != 0)
@@ -1199,9 +1208,9 @@
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
 		default:
-			printk (KERN_ERR
-				"EXT3-fs: Unrecognized mount option \"%s\" "
-				"or missing value\n", p);
+			ext3_msg(sb, KERN_ERR,
+				"Unrecognized mount option \"%s\" "
+				"or missing value", p);
 			return 0;
 		}
 	}
@@ -1219,21 +1228,21 @@
 				(sbi->s_mount_opt & EXT3_MOUNT_GRPQUOTA)) ||
 		    (sbi->s_qf_names[GRPQUOTA] &&
 				(sbi->s_mount_opt & EXT3_MOUNT_USRQUOTA))) {
-			printk(KERN_ERR "EXT3-fs: old and new quota "
-					"format mixing.\n");
+			ext3_msg(sb, KERN_ERR, "old and new quota "
+					"format mixing");
 			return 0;
 		}
 
 		if (!sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT3-fs: journaled quota format "
-					"not specified.\n");
+			ext3_msg(sb, KERN_ERR, "journaled quota format "
+					"not specified");
 			return 0;
 		}
 	} else {
 		if (sbi->s_jquota_fmt) {
-			printk(KERN_ERR "EXT3-fs: journaled quota format "
+			ext3_msg(sb, KERN_ERR, "journaled quota format "
 					"specified with no journaling "
-					"enabled.\n");
+					"enabled");
 			return 0;
 		}
 	}
@@ -1248,31 +1257,31 @@
 	int res = 0;
 
 	if (le32_to_cpu(es->s_rev_level) > EXT3_MAX_SUPP_REV) {
-		printk (KERN_ERR "EXT3-fs warning: revision level too high, "
-			"forcing read-only mode\n");
+		ext3_msg(sb, KERN_ERR, "warning: revision level too high, "
+			"forcing read-only mode");
 		res = MS_RDONLY;
 	}
 	if (read_only)
 		return res;
 	if (!(sbi->s_mount_state & EXT3_VALID_FS))
-		printk (KERN_WARNING "EXT3-fs warning: mounting unchecked fs, "
-			"running e2fsck is recommended\n");
+		ext3_msg(sb, KERN_WARNING, "warning: mounting unchecked fs, "
+			"running e2fsck is recommended");
 	else if ((sbi->s_mount_state & EXT3_ERROR_FS))
-		printk (KERN_WARNING
-			"EXT3-fs warning: mounting fs with errors, "
-			"running e2fsck is recommended\n");
+		ext3_msg(sb, KERN_WARNING,
+			"warning: mounting fs with errors, "
+			"running e2fsck is recommended");
 	else if ((__s16) le16_to_cpu(es->s_max_mnt_count) >= 0 &&
 		 le16_to_cpu(es->s_mnt_count) >=
 		 (unsigned short) (__s16) le16_to_cpu(es->s_max_mnt_count))
-		printk (KERN_WARNING
-			"EXT3-fs warning: maximal mount count reached, "
-			"running e2fsck is recommended\n");
+		ext3_msg (sb, KERN_WARNING,
+			"warning: maximal mount count reached, "
+			"running e2fsck is recommended");
 	else if (le32_to_cpu(es->s_checkinterval) &&
 		(le32_to_cpu(es->s_lastcheck) +
 			le32_to_cpu(es->s_checkinterval) <= get_seconds()))
-		printk (KERN_WARNING
-			"EXT3-fs warning: checktime reached, "
-			"running e2fsck is recommended\n");
+		ext3_msg(sb, KERN_WARNING,
+			"warning: checktime reached, "
+			"running e2fsck is recommended");
 #if 0
 		/* @@@ We _will_ want to clear the valid bit if we find
                    inconsistencies, to force a fsck at reboot.  But for
@@ -1297,7 +1306,7 @@
 			EXT3_INODES_PER_GROUP(sb),
 			sbi->s_mount_opt);
 
-	printk(KERN_INFO "EXT3 FS on %s, ", sb->s_id);
+	printk(KERN_INFO "EXT3-FS (%s): ", sb->s_id);
 	if (EXT3_SB(sb)->s_journal->j_inode == NULL) {
 		char b[BDEVNAME_SIZE];
 
@@ -1398,8 +1407,8 @@
 	}
 
 	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT3-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+		ext3_msg(sb, KERN_ERR, "write access "
+			"unavailable, skipping orphan cleanup");
 		return;
 	}
 
@@ -1413,8 +1422,7 @@
 	}
 
 	if (s_flags & MS_RDONLY) {
-		printk(KERN_INFO "EXT3-fs: %s: orphan cleanup on readonly fs\n",
-		       sb->s_id);
+		ext3_msg(sb, KERN_INFO, "orphan cleanup on readonly fs");
 		sb->s_flags &= ~MS_RDONLY;
 	}
 #ifdef CONFIG_QUOTA
@@ -1425,9 +1433,9 @@
 		if (EXT3_SB(sb)->s_qf_names[i]) {
 			int ret = ext3_quota_on_mount(sb, i);
 			if (ret < 0)
-				printk(KERN_ERR
-					"EXT3-fs: Cannot turn on journaled "
-					"quota: error %d\n", ret);
+				ext3_msg(sb, KERN_ERR,
+					"Cannot turn on journaled "
+					"quota: error %d", ret);
 		}
 	}
 #endif
@@ -1465,11 +1473,11 @@
 #define PLURAL(x) (x), ((x)==1) ? "" : "s"
 
 	if (nr_orphans)
-		printk(KERN_INFO "EXT3-fs: %s: %d orphan inode%s deleted\n",
-		       sb->s_id, PLURAL(nr_orphans));
+		ext3_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
+			PLURAL(nr_orphans));
 	if (nr_truncates)
-		printk(KERN_INFO "EXT3-fs: %s: %d truncate%s cleaned up\n",
-		       sb->s_id, PLURAL(nr_truncates));
+		ext3_msg(sb, KERN_INFO, "%5d truncate%s cleaned up",
+		       PLURAL(nr_truncates));
 #ifdef CONFIG_QUOTA
 	/* Turn quotas off */
 	for (i = 0; i < MAXQUOTAS; i++) {
@@ -1553,7 +1561,7 @@
 	struct ext3_super_block *es = NULL;
 	struct ext3_sb_info *sbi;
 	ext3_fsblk_t block;
-	ext3_fsblk_t sb_block = get_sb_block(&data);
+	ext3_fsblk_t sb_block = get_sb_block(&data, sb);
 	ext3_fsblk_t logic_sb_block;
 	unsigned long offset = 0;
 	unsigned int journal_inum = 0;
@@ -1589,7 +1597,7 @@
 
 	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
 	if (!blocksize) {
-		printk(KERN_ERR "EXT3-fs: unable to set blocksize\n");
+		ext3_msg(sb, KERN_ERR, "unable to set blocksize");
 		goto out_fail;
 	}
 
@@ -1605,7 +1613,7 @@
 	}
 
 	if (!(bh = sb_bread(sb, logic_sb_block))) {
-		printk (KERN_ERR "EXT3-fs: unable to read superblock\n");
+		ext3_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
 	/*
@@ -1664,9 +1672,9 @@
 	    (EXT3_HAS_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
 	     EXT3_HAS_INCOMPAT_FEATURE(sb, ~0U)))
-		printk(KERN_WARNING
-		       "EXT3-fs warning: feature flags set on rev 0 fs, "
-		       "running e2fsck is recommended\n");
+		ext3_msg(sb, KERN_WARNING,
+		       "warning: feature flags set on rev 0 fs, "
+		       "running e2fsck is recommended");
 	/*
 	 * Check feature flags regardless of the revision level, since we
 	 * previously didn't change the revision level when setting the flags,
@@ -1674,25 +1682,27 @@
 	 */
 	features = EXT3_HAS_INCOMPAT_FEATURE(sb, ~EXT3_FEATURE_INCOMPAT_SUPP);
 	if (features) {
-		printk(KERN_ERR "EXT3-fs: %s: couldn't mount because of "
-		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		ext3_msg(sb, KERN_ERR,
+			"Couldn't mount because of "
+		       "unsupported optional features (%x)",
+		       le32_to_cpu(features));
 		goto failed_mount;
 	}
 	features = EXT3_HAS_RO_COMPAT_FEATURE(sb, ~EXT3_FEATURE_RO_COMPAT_SUPP);
 	if (!(sb->s_flags & MS_RDONLY) && features) {
-		printk(KERN_ERR "EXT3-fs: %s: couldn't mount RDWR because of "
-		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		ext3_msg(sb, KERN_ERR,
+			"Couldn't mount RDWR because of "
+		       "unsupported optional features (%x)",
+		       le32_to_cpu(features));
 		goto failed_mount;
 	}
 	blocksize = BLOCK_SIZE << le32_to_cpu(es->s_log_block_size);
 
 	if (blocksize < EXT3_MIN_BLOCK_SIZE ||
 	    blocksize > EXT3_MAX_BLOCK_SIZE) {
-		printk(KERN_ERR
-		       "EXT3-fs: Unsupported filesystem blocksize %d on %s.\n",
-		       blocksize, sb->s_id);
+		ext3_msg(sb, KERN_ERR,
+		       "Unsupported filesystem blocksize %d",
+		       blocksize);
 		goto failed_mount;
 	}
 
@@ -1703,14 +1713,14 @@
 		 * than the hardware sectorsize for the machine.
 		 */
 		if (blocksize < hblock) {
-			printk(KERN_ERR "EXT3-fs: blocksize %d too small for "
-			       "device blocksize %d.\n", blocksize, hblock);
+			ext3_msg(sb, KERN_ERR, "blocksize %d too small for "
+			       "device blocksize %d", blocksize, hblock);
 			goto failed_mount;
 		}
 
 		brelse (bh);
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT3-fs: bad blocksize %d.\n",
+			ext3_msg(sb, KERN_ERR, "bad blocksize %d.\n",
 				blocksize);
 			goto out_fail;
 		}
@@ -1718,15 +1728,15 @@
 		offset = (sb_block * EXT3_MIN_BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
 		if (!bh) {
-			printk(KERN_ERR
-			       "EXT3-fs: Can't read superblock on 2nd try.\n");
+			ext3_msg(sb, KERN_ERR,
+			       "Can't read superblock on 2nd try");
 			goto failed_mount;
 		}
 		es = (struct ext3_super_block *)(((char *)bh->b_data) + offset);
 		sbi->s_es = es;
 		if (es->s_magic != cpu_to_le16(EXT3_SUPER_MAGIC)) {
-			printk (KERN_ERR
-				"EXT3-fs: Magic mismatch, very weird !\n");
+			ext3_msg(sb, KERN_ERR,
+				"Magic mismatch, very weird!");
 			goto failed_mount;
 		}
 	}
@@ -1742,8 +1752,8 @@
 		if ((sbi->s_inode_size < EXT3_GOOD_OLD_INODE_SIZE) ||
 		    (!is_power_of_2(sbi->s_inode_size)) ||
 		    (sbi->s_inode_size > blocksize)) {
-			printk (KERN_ERR
-				"EXT3-fs: unsupported inode size: %d\n",
+			ext3_msg(sb, KERN_ERR,
+				"unsupported inode size: %d",
 				sbi->s_inode_size);
 			goto failed_mount;
 		}
@@ -1751,8 +1761,8 @@
 	sbi->s_frag_size = EXT3_MIN_FRAG_SIZE <<
 				   le32_to_cpu(es->s_log_frag_size);
 	if (blocksize != sbi->s_frag_size) {
-		printk(KERN_ERR
-		       "EXT3-fs: fragsize %lu != blocksize %u (unsupported)\n",
+		ext3_msg(sb, KERN_ERR,
+		       "fragsize %lu != blocksize %u (unsupported)",
 		       sbi->s_frag_size, blocksize);
 		goto failed_mount;
 	}
@@ -1789,28 +1799,28 @@
 	}
 
 	if (sbi->s_blocks_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT3-fs: #blocks per group too big: %lu\n",
+		ext3_msg(sb, KERN_ERR,
+			"#blocks per group too big: %lu",
 			sbi->s_blocks_per_group);
 		goto failed_mount;
 	}
 	if (sbi->s_frags_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT3-fs: #fragments per group too big: %lu\n",
+		ext3_msg(sb, KERN_ERR,
+			"#fragments per group too big: %lu",
 			sbi->s_frags_per_group);
 		goto failed_mount;
 	}
 	if (sbi->s_inodes_per_group > blocksize * 8) {
-		printk (KERN_ERR
-			"EXT3-fs: #inodes per group too big: %lu\n",
+		ext3_msg(sb, KERN_ERR,
+			"#inodes per group too big: %lu",
 			sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 
 	if (le32_to_cpu(es->s_blocks_count) >
 		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
-		printk(KERN_ERR "EXT3-fs: filesystem on %s:"
-			" too large to mount safely\n", sb->s_id);
+		ext3_msg(sb, KERN_ERR, "filesystem"
+			" too large to mount safely");
 		if (sizeof(sector_t) < 8)
 			printk(KERN_WARNING "EXT3-fs: CONFIG_LBD not "
 					"enabled\n");
@@ -1827,7 +1837,7 @@
 	sbi->s_group_desc = kmalloc(db_count * sizeof (struct buffer_head *),
 				    GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
-		printk (KERN_ERR "EXT3-fs: not enough memory\n");
+		ext3_msg(sb, KERN_ERR, "not enough memory");
 		goto failed_mount;
 	}
 
@@ -1837,14 +1847,14 @@
 		block = descriptor_loc(sb, logic_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread(sb, block);
 		if (!sbi->s_group_desc[i]) {
-			printk (KERN_ERR "EXT3-fs: "
-				"can't read group descriptor %d\n", i);
+			ext3_msg (sb, KERN_ERR,
+				"can't read group descriptor %d", i);
 			db_count = i;
 			goto failed_mount2;
 		}
 	}
 	if (!ext3_check_descriptors (sb)) {
-		printk(KERN_ERR "EXT3-fs: group descriptors corrupted!\n");
+		ext3_msg(sb, KERN_ERR, "group descriptors corrupted!");
 		goto failed_mount2;
 	}
 	sbi->s_gdb_count = db_count;
@@ -1862,7 +1872,7 @@
 				ext3_count_dirs(sb));
 	}
 	if (err) {
-		printk(KERN_ERR "EXT3-fs: insufficient memory\n");
+		ext3_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount3;
 	}
 
@@ -1910,9 +1920,7 @@
 			goto failed_mount3;
 	} else {
 		if (!silent)
-			printk (KERN_ERR
-				"ext3: No journal on filesystem on %s\n",
-				sb->s_id);
+			ext3_msg(sb, KERN_ERR, "No journal on filesystem");
 		goto failed_mount3;
 	}
 
@@ -1934,8 +1942,8 @@
 	case EXT3_MOUNT_WRITEBACK_DATA:
 		if (!journal_check_available_features
 		    (sbi->s_journal, 0, 0, JFS_FEATURE_INCOMPAT_REVOKE)) {
-			printk(KERN_ERR "EXT3-fs: Journal does not support "
-			       "requested data journaling mode\n");
+			ext3_msg(sb, KERN_ERR, "Journal does not support "
+			       "requested data journaling mode");
 			goto failed_mount4;
 		}
 	default:
@@ -1944,8 +1952,8 @@
 
 	if (test_opt(sb, NOBH)) {
 		if (!(test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)) {
-			printk(KERN_WARNING "EXT3-fs: Ignoring nobh option - "
-				"its supported only with writeback mode\n");
+			ext3_msg(sb, KERN_WARNING, "Ignoring nobh option - "
+				"its supported only with writeback mode");
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
@@ -1956,18 +1964,18 @@
 
 	root = ext3_iget(sb, EXT3_ROOT_INO);
 	if (IS_ERR(root)) {
-		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
+		ext3_msg(sb, KERN_ERR, "get root inode failed");
 		ret = PTR_ERR(root);
 		goto failed_mount4;
 	}
 	if (!S_ISDIR(root->i_mode) || !root->i_blocks || !root->i_size) {
 		iput(root);
-		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
+		ext3_msg(sb, KERN_ERR, "corrupt root inode, run e2fsck");
 		goto failed_mount4;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
-		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
+		ext3_msg(sb, KERN_ERR, "get root dentry failed");
 		iput(root);
 		ret = -ENOMEM;
 		goto failed_mount4;
@@ -1986,9 +1994,9 @@
 	ext3_orphan_cleanup(sb, es);
 	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
 	if (needs_recovery)
-		printk (KERN_INFO "EXT3-fs: recovery complete.\n");
+		ext3_msg(sb, KERN_INFO, "recovery complete");
 	ext3_mark_recovery_complete(sb, es);
-	printk (KERN_INFO "EXT3-fs: mounted filesystem with %s data mode.\n",
+	ext3_msg(sb, KERN_INFO, "mounted filesystem with %s data mode",
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
 		"writeback");
@@ -2065,27 +2073,27 @@
 
 	journal_inode = ext3_iget(sb, journal_inum);
 	if (IS_ERR(journal_inode)) {
-		printk(KERN_ERR "EXT3-fs: no journal found.\n");
+		ext3_msg(sb, KERN_ERR, "no journal found");
 		return NULL;
 	}
 	if (!journal_inode->i_nlink) {
 		make_bad_inode(journal_inode);
 		iput(journal_inode);
-		printk(KERN_ERR "EXT3-fs: journal inode is deleted.\n");
+		ext3_msg(sb, KERN_ERR, "journal inode is deleted");
 		return NULL;
 	}
 
 	jbd_debug(2, "Journal inode found at %p: %Ld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	if (!S_ISREG(journal_inode->i_mode)) {
-		printk(KERN_ERR "EXT3-fs: invalid journal inode.\n");
+		ext3_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;
 	}
 
 	journal = journal_init_inode(journal_inode);
 	if (!journal) {
-		printk(KERN_ERR "EXT3-fs: Could not load journal inode\n");
+		ext3_msg(sb, KERN_ERR, "Could not load journal inode");
 		iput(journal_inode);
 		return NULL;
 	}
@@ -2094,6 +2102,8 @@
 	return journal;
 }
 
+/* RED-PEN should we print the external journal device here? */
+
 static journal_t *ext3_get_dev_journal(struct super_block *sb,
 				       dev_t j_dev)
 {
@@ -2107,13 +2117,13 @@
 	struct ext3_super_block * es;
 	struct block_device *bdev;
 
-	bdev = ext3_blkdev_get(j_dev);
+	bdev = ext3_blkdev_get(j_dev, sb);
 	if (bdev == NULL)
 		return NULL;
 
 	if (bd_claim(bdev, sb)) {
-		printk(KERN_ERR
-		        "EXT3: failed to claim external journal device.\n");
+		ext3_msg(sb, KERN_ERR,
+		        "failed to claim external journal device");
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE);
 		return NULL;
 	}
@@ -2121,8 +2131,8 @@
 	blocksize = sb->s_blocksize;
 	hblock = bdev_hardsect_size(bdev);
 	if (blocksize < hblock) {
-		printk(KERN_ERR
-			"EXT3-fs: blocksize too small for journal device.\n");
+		ext3_msg(sb, KERN_ERR,
+			"blocksize too small for journal device");
 		goto out_bdev;
 	}
 
@@ -2130,8 +2140,8 @@
 	offset = EXT3_MIN_BLOCK_SIZE % blocksize;
 	set_blocksize(bdev, blocksize);
 	if (!(bh = __bread(bdev, sb_block, blocksize))) {
-		printk(KERN_ERR "EXT3-fs: couldn't read superblock of "
-		       "external journal\n");
+		ext3_msg(sb, KERN_ERR, "couldn't read superblock of "
+		       "external journal");
 		goto out_bdev;
 	}
 
@@ -2139,14 +2149,14 @@
 	if ((le16_to_cpu(es->s_magic) != EXT3_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-		printk(KERN_ERR "EXT3-fs: external journal has "
-					"bad superblock\n");
+		ext3_msg(sb, KERN_ERR, "external journal has "
+					"bad superblock");
 		brelse(bh);
 		goto out_bdev;
 	}
 
 	if (memcmp(EXT3_SB(sb)->s_es->s_journal_uuid, es->s_uuid, 16)) {
-		printk(KERN_ERR "EXT3-fs: journal UUID does not match\n");
+		ext3_msg(sb, KERN_ERR, "journal UUID does not match");
 		brelse(bh);
 		goto out_bdev;
 	}
@@ -2158,18 +2168,18 @@
 	journal = journal_init_dev(bdev, sb->s_bdev,
 					start, len, blocksize);
 	if (!journal) {
-		printk(KERN_ERR "EXT3-fs: failed to create device journal\n");
+		ext3_msg(sb, KERN_ERR, "failed to create device journal");
 		goto out_bdev;
 	}
 	journal->j_private = sb;
 	ll_rw_block(READ, 1, &journal->j_sb_buffer);
 	wait_on_buffer(journal->j_sb_buffer);
 	if (!buffer_uptodate(journal->j_sb_buffer)) {
-		printk(KERN_ERR "EXT3-fs: I/O error on journal device\n");
+		ext3_msg(sb, KERN_ERR, "I/O error on journal device");
 		goto out_journal;
 	}
 	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
-		printk(KERN_ERR "EXT3-fs: External journal has more than one "
+		ext3_msg(sb, KERN_ERR, "External journal has more than one "
 					"user (unsupported) - %d\n",
 			be32_to_cpu(journal->j_superblock->s_nr_users));
 		goto out_journal;
@@ -2196,8 +2206,8 @@
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
-		printk(KERN_INFO "EXT3-fs: external journal device major/minor "
-			"numbers have changed\n");
+		ext3_msg(sb, KERN_INFO, "external journal device major/minor "
+			"numbers have changed");
 		journal_dev = new_decode_dev(journal_devnum);
 	} else
 		journal_dev = new_decode_dev(le32_to_cpu(es->s_journal_dev));
@@ -2212,21 +2222,21 @@
 
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER)) {
 		if (sb->s_flags & MS_RDONLY) {
-			printk(KERN_INFO "EXT3-fs: INFO: recovery "
-					"required on readonly filesystem.\n");
+			ext3_msg(sb, KERN_INFO, "INFO: recovery "
+					"required on readonly filesystem");
 			if (really_read_only) {
-				printk(KERN_ERR "EXT3-fs: write access "
-					"unavailable, cannot proceed.\n");
+				ext3_msg(sb, KERN_ERR, "write access "
+					"unavailable, cannot proceed");
 				return -EROFS;
 			}
-			printk (KERN_INFO "EXT3-fs: write access will "
-					"be enabled during recovery.\n");
+			ext3_msg(sb, KERN_INFO, "write access will "
+					"be enabled during recovery");
 		}
 	}
 
 	if (journal_inum && journal_dev) {
-		printk(KERN_ERR "EXT3-fs: filesystem has both journal "
-		       "and inode journals!\n");
+		ext3_msg(sb, KERN_ERR, "Filesystem has both journal "
+		       "and inode journals!");
 		return -EINVAL;
 	}
 
@@ -2241,7 +2251,7 @@
 	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
 		err = journal_update_format(journal);
 		if (err)  {
-			printk(KERN_ERR "EXT3-fs: error updating journal.\n");
+			ext3_msg(sb, KERN_ERR, "error updating journal");
 			journal_destroy(journal);
 			return err;
 		}
@@ -2253,7 +2263,7 @@
 		err = journal_load(journal);
 
 	if (err) {
-		printk(KERN_ERR "EXT3-fs: error loading journal.\n");
+		ext3_msg(sb, KERN_ERR, "error loading journal");
 		journal_destroy(journal);
 		return err;
 	}
@@ -2281,8 +2291,8 @@
 	int err;
 
 	if (sb->s_flags & MS_RDONLY) {
-		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
-				"create journal.\n");
+		ext3_msg(sb, KERN_ERR, "readonly filesystem when trying to "
+				"create journal");
 		return -EROFS;
 	}
 
@@ -2290,12 +2300,12 @@
 	if (!journal)
 		return -EINVAL;
 
-	printk(KERN_INFO "EXT3-fs: creating new journal on inode %u\n",
+	ext3_msg(sb, KERN_INFO, "Creating new journal on inode %u",
 	       journal_inum);
 
 	err = journal_create(journal);
 	if (err) {
-		printk(KERN_ERR "EXT3-fs: error creating journal.\n");
+		ext3_msg(sb, KERN_ERR, "error creating journal");
 		journal_destroy(journal);
 		return -EIO;
 	}
@@ -2572,10 +2582,10 @@
 			__le32 ret;
 			if ((ret = EXT3_HAS_RO_COMPAT_FEATURE(sb,
 					~EXT3_FEATURE_RO_COMPAT_SUPP))) {
-				printk(KERN_WARNING "EXT3-fs: %s: couldn't "
+				ext3_msg(sb, KERN_WARNING, "Couldn't "
 				       "remount RDWR because of unsupported "
-				       "optional features (%x).\n",
-				       sb->s_id, le32_to_cpu(ret));
+				       "optional features (%x)",
+				       le32_to_cpu(ret));
 				err = -EROFS;
 				goto restore_opts;
 			}
@@ -2586,11 +2596,10 @@
 			 * require a full umount/remount for now.
 			 */
 			if (es->s_last_orphan) {
-				printk(KERN_WARNING "EXT3-fs: %s: couldn't "
+				ext3_msg(sb, KERN_WARNING, "Couldn't "
 				       "remount RDWR because of unprocessed "
 				       "orphan inode list.  Please "
-				       "umount/remount instead.\n",
-				       sb->s_id);
+				       "umount/remount instead");
 				err = -EINVAL;
 				goto restore_opts;
 			}
@@ -2837,9 +2846,9 @@
 	if (EXT3_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not of fs root? */
 		if (path.dentry->d_parent != sb->s_root)
-			printk(KERN_WARNING
-				"EXT3-fs: Quota file not on filesystem root. "
-				"Journaled quota will not work.\n");
+			ext3_msg(sb, KERN_WARNING,
+				"Quota file not on filesystem root. "
+				"Journaled quota will not work");
 	}
 
 	/*
@@ -2921,8 +2930,8 @@
 	handle_t *handle = journal_current_handle();
 
 	if (!handle) {
-		printk(KERN_WARNING "EXT3-fs: Quota write (off=%Lu, len=%Lu)"
-			" cancelled because transaction is not started.\n",
+		ext3_msg(sb, KERN_WARNING, "Quota write (off=%Lu, len=%Lu)"
+			" cancelled because transaction is not started",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
Index: linux-2.6.30-rc3-ak/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.30-rc3-ak.orig/include/linux/ext3_fs.h	2009-04-29 21:03:21.000000000 +0200
+++ linux-2.6.30-rc3-ak/include/linux/ext3_fs.h	2009-05-01 10:03:49.000000000 +0200
@@ -918,6 +918,8 @@
 	__attribute__ ((format (printf, 3, 4)));
 extern void ext3_warning (struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
+extern void ext3_msg (struct super_block *, const char *, const char *, ...)
+	__attribute__ ((format (printf, 3, 4)));
 extern void ext3_update_dynamic_rev (struct super_block *sb);
 
 #define ext3_std_error(sb, errno)				\
-- 
ak@linux.intel.com -- Speaking for myself only.
