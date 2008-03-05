From: akpm@linux-foundation.org
Subject: + jbd-replace-remaining-__function__-occurrences.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:20:42 -0800
Message-ID: <200803052220.m25MKguK024033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: harvey.harrison@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd: replace remaining __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     jbd-replace-remaining-__function__-occurrences.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c     |   18 +++++++++---------
 fs/jbd/revoke.c      |    2 +-
 fs/jbd/transaction.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/jbd/journal.c~jbd-replace-remaining-__function__-occurrences fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/journal.c
@@ -534,7 +534,7 @@ int log_wait_commit(journal_t *journal, 
 	if (!tid_geq(journal->j_commit_request, tid)) {
 		printk(KERN_EMERG
 		       "%s: error: j_commit_request=%d, tid=%d\n",
-		       __FUNCTION__, journal->j_commit_request, tid);
+		       __func__, journal->j_commit_request, tid);
 	}
 	spin_unlock(&journal->j_state_lock);
 #endif
@@ -599,7 +599,7 @@ int journal_bmap(journal_t *journal, uns
 
 			printk(KERN_ALERT "%s: journal block not found "
 					"at offset %lu on %s\n",
-				__FUNCTION__,
+				__func__,
 				blocknr,
 				bdevname(journal->j_dev, b));
 			err = -EIO;
@@ -727,7 +727,7 @@ journal_t * journal_init_dev(struct bloc
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		journal = NULL;
 		goto out;
@@ -781,7 +781,7 @@ journal_t * journal_init_inode (struct i
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -790,7 +790,7 @@ journal_t * journal_init_inode (struct i
 	/* If that failed, give up */
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -876,7 +876,7 @@ int journal_create(journal_t *journal)
 		 */
 		printk(KERN_EMERG
 		       "%s: creation of journal on external device!\n",
-		       __FUNCTION__);
+		       __func__);
 		BUG();
 	}
 
@@ -1661,7 +1661,7 @@ static struct journal_head *journal_allo
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
-			       __FUNCTION__);
+			       __func__);
 			last_warning = jiffies;
 		}
 		while (ret == NULL) {
@@ -1798,13 +1798,13 @@ static void __journal_remove_journal_hea
 			if (jh->b_frozen_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
diff -puN fs/jbd/revoke.c~jbd-replace-remaining-__function__-occurrences fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/revoke.c
@@ -138,7 +138,7 @@ repeat:
 oom:
 	if (!journal_oom_retry)
 		return -ENOMEM;
-	jbd_debug(1, "ENOMEM in %s, retrying\n", __FUNCTION__);
+	jbd_debug(1, "ENOMEM in %s, retrying\n", __func__);
 	yield();
 	goto repeat;
 }
diff -puN fs/jbd/transaction.c~jbd-replace-remaining-__function__-occurrences fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/transaction.c
@@ -687,7 +687,7 @@ repeat:
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
 					       "%s: OOM for frozen_buffer\n",
-					       __FUNCTION__);
+					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
 					error = -ENOMEM;
 					jbd_lock_bh_state(bh);
@@ -904,7 +904,7 @@ repeat:
 		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
-				__FUNCTION__);
+				__func__);
 			err = -ENOMEM;
 			goto out;
 		}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa.patch
sound-replace-remaining-__function__-occurences.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
powerpc-replace-remaining-__function__-occurences.patch
ppc-replace-remaining-__function__-occurences.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
mips-replace-remaining-__function__-occurences.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
parisc-replace-remaining-__function__-occurences.patch
sh-replace-remaining-__function__-occurences.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
security-replace-remaining-__function__-occurences.patch
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
ext4-replace-remaining-__function__-occurrences.patch
nfs-replace-remaining-__function__-occurrences.patch
xfs-replace-remaining-__function__-occurrences.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cifs-replace-remaining-__function__-occurrences.patch
reiserfs-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch

