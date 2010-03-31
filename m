From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: don't print minimum size if fs is not clean
Date: Wed, 31 Mar 2010 14:28:42 -0500
Message-ID: <4BB3A26A.9080405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab0CaT2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Mar 2010 15:28:46 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2VJSjtK003012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 15:28:45 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2VJSgEn006653
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 15:28:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Right now, resize2fs -P on a dirty filesystem will give you a number;
however, it's probably wrong if the fs is not clean:

# resize2fs -P myimage.img
resize2fs 1.41.9 (22-Aug-2009)
Estimated minimum size of the filesystem: 75623

# e2fsck -fy myimage.img
e2fsck 1.41.9 (22-Aug-2009)
myimage.img: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

myimage.img: ***** FILE SYSTEM WAS MODIFIED *****
myimage.img: 9530/53760 files (0.1% non-contiguous), 24737/98304 blocks

# resize2fs -P myimage.img
resize2fs 1.41.9 (22-Aug-2009)
Estimated minimum size of the filesystem: 32165

We should issue the same "Please run e2fsck ..." message for
-P as we do for an actual resize request.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/main.c b/resize/main.c
index fd85d90..f5ffb0f 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -345,6 +345,14 @@ int main (int argc, char ** argv)
 	min_size = calculate_minimum_resize_size(fs);
 
 	if (print_min_size) {
+		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
+			       (fs->super->s_state & EXT2_ERROR_FS) ||
+			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
+			fprintf(stderr,
+				_("Please run 'e2fsck -f %s' first.\n\n"),
+				device_name);
+			exit(1);
+		}
 		printf(_("Estimated minimum size of the filesystem: %u\n"),
 		       min_size);
 		exit(0);

