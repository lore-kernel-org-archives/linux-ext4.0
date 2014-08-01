From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/19] e2fsck: always ask to fix an inode that fails
 checksum verification
Date: Fri, 01 Aug 2014 11:13:00 -0700
Message-ID: <20140801181300.12496.48122.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33452 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaHASNF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:13:05 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If an inode fails checksum verification during pass 1 and the user
doesn't fix or clear the inode as part of the regular inode checks,
ensure that e2fsck remembers to ask the user if he simply wants to
correct the checksum.

We weren't capturing all the ways out of an interation of the inode
scanning loop, which means that not all errors were caught.  Also,
we might as well clear the 'failed csum' flag if we write the inode
directly from the inode scanning loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                          |   65 +++++++++++++++++++++++--------
 tests/f_deleted_inode_bad_csum/expect.1 |   11 +++++
 tests/f_deleted_inode_bad_csum/expect.2 |    7 +++
 tests/f_deleted_inode_bad_csum/image.gz |  Bin
 tests/f_deleted_inode_bad_csum/name     |    1 
 5 files changed, 67 insertions(+), 17 deletions(-)
 create mode 100644 tests/f_deleted_inode_bad_csum/expect.1
 create mode 100644 tests/f_deleted_inode_bad_csum/expect.2
 create mode 100644 tests/f_deleted_inode_bad_csum/image.gz
 create mode 100644 tests/f_deleted_inode_bad_csum/name

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 39ebaae..5c72f48 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -594,10 +594,7 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 
 	retval = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
 					 sizeof(inode));
-	if (retval)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 static void reserve_block_for_root_repair(e2fsck_t ctx)
@@ -636,6 +633,29 @@ static void reserve_block_for_lnf_repair(e2fsck_t ctx)
 	ctx->lnf_repair_block = blk;
 }
 
+static void finish_processing_inode(e2fsck_t ctx, ext2_ino_t ino,
+				    struct problem_context *pctx,
+				    int failed_csum)
+{
+	if (!failed_csum)
+		return;
+
+	/*
+	 * If the inode failed the checksum and the user didn't
+	 * clear the inode, test the checksum again -- if it still
+	 * fails, ask the user if the checksum should be corrected.
+	 */
+	pctx->errcode = recheck_bad_inode_checksum(ctx->fs, ino, ctx, pctx);
+	if (pctx->errcode)
+		ctx->flags |= E2F_FLAG_ABORT;
+}
+#define FINISH_INODE_LOOP(ctx, ino, pctx, failed_csum) \
+	do { \
+		finish_processing_inode((ctx), (ino), (pctx), (failed_csum)); \
+		if ((ctx)->flags & E2F_FLAG_ABORT) \
+			return; \
+	} while (0)
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -898,6 +918,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				inlinedata_fs = 1;
 			} else if (!fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
 				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+				/* skip FINISH_INODE_LOOP */
 				continue;
 			}
 		}
@@ -932,6 +953,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				if (ino == EXT2_BAD_INO)
 					ext2fs_mark_inode_bitmap2(ctx->inode_used_map,
 								 ino);
+				/* skip FINISH_INODE_LOOP */
 				continue;
 			}
 		}
@@ -968,6 +990,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				       sizeof(inode->i_block));
 #endif
 				e2fsck_write_inode(ctx, ino, inode, "pass1");
+				failed_csum = 0;
 			}
 		}
 
@@ -982,6 +1005,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				memset(inode, 0, sizeof(struct ext2_inode));
 				e2fsck_write_inode(ctx, ino, inode,
 						   "clear bad inode");
+				failed_csum = 0;
 			}
 
 			pctx.errcode = ext2fs_copy_bitmap(ctx->block_found_map,
@@ -1016,6 +1040,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			clear_problem_context(&pctx);
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		} else if (ino == EXT2_ROOT_INO) {
 			/*
@@ -1041,6 +1066,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_dtime = 0;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
+					failed_csum = 0;
 				}
 			}
 		} else if (ino == EXT2_JOURNAL_INO) {
@@ -1052,8 +1078,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_mode = LINUX_S_IFREG;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
+					failed_csum = 0;
 				}
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 			if ((inode->i_links_count ||
@@ -1065,6 +1093,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 						    ino, 0);
 				e2fsck_write_inode_full(ctx, ino, inode,
 							inode_size, "pass1");
+				failed_csum = 0;
 			}
 		} else if ((ino == EXT4_USR_QUOTA_INO) ||
 			   (ino == EXT4_GRP_QUOTA_INO)) {
@@ -1079,8 +1108,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_mode = LINUX_S_IFREG;
 					e2fsck_write_inode(ctx, ino, inode,
 							"pass1");
+					failed_csum = 0;
 				}
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 			if ((inode->i_links_count ||
@@ -1092,6 +1123,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 						    ino, 0);
 				e2fsck_write_inode_full(ctx, ino, inode,
 							inode_size, "pass1");
+				failed_csum = 0;
 			}
 		} else if (ino < EXT2_FIRST_INODE(fs->super)) {
 			problem_t problem = 0;
@@ -1113,9 +1145,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_mode = 0;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
+					failed_csum = 0;
 				}
 			}
 			check_blocks(ctx, &pctx, block_buf);
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		}
 
@@ -1143,6 +1177,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					0 : ctx->now;
 				e2fsck_write_inode(ctx, ino, inode,
 						   "pass1");
+				failed_csum = 0;
 			}
 		}
 
@@ -1157,8 +1192,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_dtime = ctx->now;
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
+					failed_csum = 0;
 				}
 			}
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		}
 		/*
@@ -1175,6 +1212,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if (fix_problem(ctx, PR_1_SET_DTIME, &pctx)) {
 				inode->i_dtime = 0;
 				e2fsck_write_inode(ctx, ino, inode, "pass1");
+				failed_csum = 0;
 			}
 		}
 
@@ -1211,6 +1249,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					inode->i_flags &= ~EXT2_IMAGIC_FL;
 					e2fsck_write_inode(ctx, ino,
 							   inode, "pass1");
+					failed_csum = 0;
 				}
 			}
 		}
@@ -1228,6 +1267,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    fix_problem(ctx, PR_1_FAST_SYMLINK_EXTENT_FL, &pctx)) {
 			inode->i_flags &= ~EXT4_EXTENTS_FL;
 			e2fsck_write_inode(ctx, ino, inode, "pass1");
+			failed_csum = 0;
 		}
 
 		if (LINUX_S_ISDIR(inode->i_mode)) {
@@ -1253,10 +1293,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_immutable(ctx, &pctx);
 			ctx->fs_symlinks_count++;
 			if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			} else if (ext2fs_inode_data_blocks(fs, inode) == 0) {
 				ctx->fs_fast_symlinks_count++;
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 		}
@@ -1293,19 +1335,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else
 			check_blocks(ctx, &pctx, block_buf);
 
-		/*
-		 * If the inode failed the checksum and the user didn't
-		 * clear the inode, test the checksum again -- if it still
-		 * fails, ask the user if the checksum should be corrected.
-		 */
-		if (failed_csum) {
-			pctx.errcode = recheck_bad_inode_checksum(fs, ino, ctx,
-								  &pctx);
-			if (pctx.errcode) {
-				ctx->flags |= E2F_FLAG_ABORT;
-				return;
-			}
-		}
+		FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto endit;
@@ -1410,6 +1440,7 @@ endit:
 	if ((ctx->flags & E2F_FLAG_SIGNAL_MASK) == 0)
 		print_resource_track(ctx, _("Pass 1"), &rtrack, ctx->fs->io);
 }
+#undef FINISH_INODE_LOOP
 
 /*
  * When the inode_scan routines call this callback at the end of the
diff --git a/tests/f_deleted_inode_bad_csum/expect.1 b/tests/f_deleted_inode_bad_csum/expect.1
new file mode 100644
index 0000000..8420361
--- /dev/null
+++ b/tests/f_deleted_inode_bad_csum/expect.1
@@ -0,0 +1,11 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 passes checks, but checksum does not match inode.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 12/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 1
diff --git a/tests/f_deleted_inode_bad_csum/expect.2 b/tests/f_deleted_inode_bad_csum/expect.2
new file mode 100644
index 0000000..eb48b40
--- /dev/null
+++ b/tests/f_deleted_inode_bad_csum/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 18/512 blocks
+Exit status is 0
diff --git a/tests/f_deleted_inode_bad_csum/image.gz b/tests/f_deleted_inode_bad_csum/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..a27e50e85f91e2724e846644729b27faefccc561
GIT binary patch
literal 2676
zcmb2|=3w}~<VG+P^V?g#86x2_3?Iy2%Ux1YO<K5cLesYt!NsBzFGNYbJm}@Xzpz~N
zVw05avT4r(gx<1ebO-Fw*doNSx8g$gl&&AG?zS9Ujw{&xn^q*e^}V@oyD|5!HSKC<
zt7qQN|9SrQ_q4S1f18arzki#@;Skxo+*7rsJn5qXcjA_e^&)}s2{!us=FXC{6H(^g
zdh5esog+sNN31cA)7Cz<Zjq5d_vw$WWns=cj0(P7c8}-V`}OjqvwQ95|9iCl+24qb
z)hS>8pZofzcc1X~cR4lR+ZU>)+y5!fP~vW0xO>w1YP0_7OZDwGiM_pgW5>aj?z8Vk
z)>f@w%)sz;@~-{eNqfTI|L;Fmwe{Y<m#6gizvI6DeP71jzw__dzI?&Rz;NL8!fS!N
z{$gj6Y8e<99!#BH_y0X#<Wl=5|5;z~P4%j;|0jR%=)%pLvd{0kn0otrjp-)cv#a%I
z*9x3APoDGo<fhPlPC!!{!oy@v-@jM!{?e^=%Rc_UJFn&sKhU@{{U86Y-M+ta&OG~f
zg*HHegnfPg!`Ih5E`MAP<Qe>92a?Z@|Bwe##DKW+t@oB$0aY5j|G~yWj1KH-8vZBc
zWL51DEZ%zdWdH5?-~W~tZZbIk|G3g8OKvCky>B|sJH7a0&3!ff+UZx`XU=`yDDdmh
z<lx88?X4y)`e--h=^X1l3-4UNGmZV}x%#8MMbH0#srdapu|~;Hk8j(K|LI5n=0Dpt
z>s4g%-$Nz4{{Jmr@UwV@&intr%}>|<dtVXp?$3FjZT0ec%l@5DSp6?vRY&ia{X*CO
z%cG9u%=uvz`~UU&t)G9*pLODNv+Mo$4~lCK*!*8J@Bf+4cWo<kd{=*q(tY~>_{=Nc
zcke1WeoZ9v_sTi1|LpI+oqObS`Rkj{?LRgBu?}DQr~db!%?ooXl`nk@&U9hJ9t@+R
iqaiRF0;3@?8UmvsFd70BhrpRD`&VBR-p0V7zyJWnQ+oUW

literal 0
HcmV?d00001

diff --git a/tests/f_deleted_inode_bad_csum/name b/tests/f_deleted_inode_bad_csum/name
new file mode 100644
index 0000000..516701a
--- /dev/null
+++ b/tests/f_deleted_inode_bad_csum/name
@@ -0,0 +1 @@
+deleted inode with a bad csum that wasn't getting fixed (metadata_csum)

