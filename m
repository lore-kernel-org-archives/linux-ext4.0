From: akpm@linux-foundation.org
Subject: + jbd2-use-non-racy-method-for-proc-entries-creation.patch added to -mm tree
Date: Tue, 15 Apr 2008 16:56:07 -0700
Message-ID: <200804152356.m3FNu7Lf022506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: den@openvz.org, adobriyan@gmail.com, ebiederm@xmission.com,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     jbd2: use non-racy method for proc entries creation
has been added to the -mm tree.  Its filename is
     jbd2-use-non-racy-method-for-proc-entries-creation.patch

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
Subject: jbd2: use non-racy method for proc entries creation
From: "Denis V. Lunev" <den@openvz.org>

Use proc_create()/proc_create_data() to make sure that ->proc_fops and ->data
be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-use-non-racy-method-for-proc-entries-creation fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-use-non-racy-method-for-proc-entries-creation
+++ a/fs/jbd2/journal.c
@@ -904,19 +904,10 @@ static void jbd2_stats_proc_init(journal
 	snprintf(name, sizeof(name) - 1, "%s", bdevname(journal->j_dev, name));
 	journal->j_proc_entry = proc_mkdir(name, proc_jbd2_stats);
 	if (journal->j_proc_entry) {
-		struct proc_dir_entry *p;
-		p = create_proc_entry("history", S_IRUGO,
-				journal->j_proc_entry);
-		if (p) {
-			p->proc_fops = &jbd2_seq_history_fops;
-			p->data = journal;
-			p = create_proc_entry("info", S_IRUGO,
-						journal->j_proc_entry);
-			if (p) {
-				p->proc_fops = &jbd2_seq_info_fops;
-				p->data = journal;
-			}
-		}
+		proc_create_data("history", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_history_fops, journal);
+		proc_create_data("info", S_IRUGO, journal->j_proc_entry,
+				 &jbd2_seq_info_fops, journal);
 	}
 }
 
_

Patches currently in -mm which might be from den@openvz.org are

git-net.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
nfsd-use-proc_create-to-setup-de-proc_fops.patch
nfs-use-proc_create-to-setup-de-proc_fops.patch
afs-use-non-racy-method-for-proc-entries-creation.patch
ext4-use-non-racy-method-for-proc-entries-creation.patch
reiserfs-use-non-racy-method-for-proc-entries-creation.patch
jbd2-use-non-racy-method-for-proc-entries-creation.patch
sysvipc-use-non-racy-method-for-proc-entries-creation.patch
mm-use-non-racy-method-for-proc-swaps-creation.patch
sound-use-non-racy-method-for-proc-driver-snd-page-alloc-creation.patch
zorro-use-non-racy-method-for-proc-entries-creation.patch
samples-use-non-racy-method-for-proc-marker-example-creation.patch
scsi-use-non-racy-method-for-proc-entries-creation.patch
usb-use-non-racy-method-for-proc-entries-creation.patch
s390-use-non-racy-method-for-proc-entries-creation.patch
arm-use-non-racy-method-for-proc-davinci_clocks-creation.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
cris-use-non-racy-method-for-proc-system_profile-creation.patch
ia64-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-pcxl_dma-creation.patch
powerpc-use-non-racy-method-for-proc-entries-creation.patch
acpi-use-non-racy-method-for-proc-entries-creation.patch
netdev-use-non-racy-method-for-proc-entries-creation.patch
isdn-use-non-racy-method-for-proc-entries-creation.patch
kernel-use-non-racy-method-for-proc-entries-creation.patch
parisc-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation.patch
drivers-use-non-racy-method-for-proc-entries-creation-2.patch
sysctl-merge-equal-proc_sys_read-and-proc_sys_write.patch
sysctl-clean-from-unneeded-extern-and-forward-declarations.patch
sysctl-add-the-permissions-callback-on-the-ctl_table_root.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

