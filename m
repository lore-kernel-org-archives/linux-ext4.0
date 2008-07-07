From: "Stoyan Gaydarov" <stoyboyker@gmail.com>
Subject: replace __FUNCTION__ occurrences in ext4
Date: Sun, 6 Jul 2008 23:36:56 -0500
Message-ID: <6d291e080807062136q4ece9368y6c747b90bd0de8e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:12743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYGGEhC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 00:37:02 -0400
Received: by nf-out-0910.google.com with SMTP id d3so601387nfc.21
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jul 2008 21:36:56 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

__FUNCTION__ is gcc-specific, use __func__ instead

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>

diff -uprN linux-2.6.26-rc9/fs/ext4/ext4.h devel/fs/ext4/ext4.h
--- linux-2.6.26-rc9/fs/ext4/ext4.h     2008-07-05 17:53:22.000000000 -0500
+++ devel/fs/ext4/ext4.h        2008-07-06 23:35:08.000000000 -0500
@@ -45,7 +45,7 @@
 #define ext4_debug(f, a...)                                            \
        do {                                                            \
                printk (KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",       \
-                       __FILE__, __LINE__, __FUNCTION__);              \
+                       __FILE__, __LINE__, __func__);          \
                printk (KERN_DEBUG f, ## a);                            \
        } while (0)
 #else
@@ -1162,7 +1162,7 @@ struct ext4_group_info *ext4_get_group_i
 #define ext4_std_error(sb, errno)                              \
 do {                                                           \
        if ((errno))                                            \
-               __ext4_std_error((sb), __FUNCTION__, (errno));  \
+               __ext4_std_error((sb), __func__, (errno));      \
 } while (0)

 /*
diff -uprN linux-2.6.26-rc9/fs/ext4/ext4_jbd2.h devel/fs/ext4/ext4_jbd2.h
--- linux-2.6.26-rc9/fs/ext4/ext4_jbd2.h        2008-07-05
17:53:22.000000000 -0500
+++ devel/fs/ext4/ext4_jbd2.h   2008-07-06 23:35:08.000000000 -0500
@@ -142,17 +142,17 @@ int __ext4_journal_dirty_metadata(const
                                handle_t *handle, struct buffer_head *bh);

 #define ext4_journal_get_undo_access(handle, bh) \
-       __ext4_journal_get_undo_access(__FUNCTION__, (handle), (bh))
+       __ext4_journal_get_undo_access(__func__, (handle), (bh))
 #define ext4_journal_get_write_access(handle, bh) \
-       __ext4_journal_get_write_access(__FUNCTION__, (handle), (bh))
+       __ext4_journal_get_write_access(__func__, (handle), (bh))
 #define ext4_journal_revoke(handle, blocknr, bh) \
-       __ext4_journal_revoke(__FUNCTION__, (handle), (blocknr), (bh))
+       __ext4_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext4_journal_get_create_access(handle, bh) \
-       __ext4_journal_get_create_access(__FUNCTION__, (handle), (bh))
+       __ext4_journal_get_create_access(__func__, (handle), (bh))
 #define ext4_journal_dirty_metadata(handle, bh) \
-       __ext4_journal_dirty_metadata(__FUNCTION__, (handle), (bh))
+       __ext4_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext4_journal_forget(handle, bh) \
-       __ext4_journal_forget(__FUNCTION__, (handle), (bh))
+       __ext4_journal_forget(__func__, (handle), (bh))

 int ext4_journal_dirty_data(handle_t *handle, struct buffer_head *bh);

@@ -165,7 +165,7 @@ static inline handle_t *ext4_journal_sta
 }

 #define ext4_journal_stop(handle) \
-       __ext4_journal_stop(__FUNCTION__, (handle))
+       __ext4_journal_stop(__func__, (handle))

 static inline handle_t *ext4_journal_current_handle(void)
 {
