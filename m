From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: Don't attempt to calculate minimum size on fs
 with errors
Date: Wed, 04 Jun 2014 16:12:47 -0500
Message-ID: <538F8BCF.7090405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbaFDVMt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 17:12:49 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s54LCnvR003583
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 4 Jun 2014 17:12:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

My old patch:

	resize2fs: don't print minimum size if fs is not clean

almost did this, but it still calculated the size; it just didn't print
it.  Which is a bit silly.

Jes had a pretty badly corrupted image which made the minimum size
calculation go off into the weeds.  It was corrupted, and also marked
as having an error.

We'll eventually bail out for an unmounted filesystem if it's marked
as being in an error state anyway; just move that test & bail-out
to a much earlier point, and remove the now-duplicate one under the
print_min_size block.

This will catch & block all resize operations on an offline filesystem
with errors, in one central place.

Reported-by: Jes Sorensen <Jes.Sorensen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/main.c b/resize/main.c
index 2b7abff..e65c8e4 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -319,6 +319,17 @@ int main (int argc, char ** argv)
 		exit (1);
 	}
 
+	if (!(mount_flags & EXT2_MF_MOUNTED)) {
+		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
+			       (fs->super->s_state & EXT2_ERROR_FS) ||
+			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
+			fprintf(stderr,
+				_("Please run 'e2fsck -f %s' first.\n\n"),
+				device_name);
+			exit(1);
+		}
+	}
+
 	/*
 	 * Check for compatibility with the feature sets.  We need to
 	 * be more stringent than ext2fs_open().
@@ -332,13 +343,6 @@ int main (int argc, char ** argv)
 	min_size = calculate_minimum_resize_size(fs, flags);
 
 	if (print_min_size) {
-		if (!force && ((fs->super->s_state & EXT2_ERROR_FS) ||
-			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
-			fprintf(stderr,
-				_("Please run 'e2fsck -f %s' first.\n\n"),
-				device_name);
-			exit(1);
-		}
 		printf(_("Estimated minimum size of the filesystem: %llu\n"),
 		       min_size);
 		exit(0);
@@ -444,14 +448,6 @@ int main (int argc, char ** argv)
 		bigalloc_check(fs, force);
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
-		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
-			       (fs->super->s_state & EXT2_ERROR_FS) ||
-			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
-			fprintf(stderr,
-				_("Please run 'e2fsck -f %s' first.\n\n"),
-				device_name);
-			exit(1);
-		}
 		bigalloc_check(fs, force);
 		printf(_("Resizing the filesystem on "
 			 "%s to %llu (%dk) blocks.\n"),

