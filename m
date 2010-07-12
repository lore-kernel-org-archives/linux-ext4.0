From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: relax requirements for -P output a bit
Date: Mon, 12 Jul 2010 13:27:44 -0500
Message-ID: <4C3B5EA0.3040904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab0GLS1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jul 2010 14:27:45 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o6CIRixq022657
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 12 Jul 2010 14:27:45 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o6CIRi9o021590
	for <linux-ext4@vger.kernel.org>; Mon, 12 Jul 2010 14:27:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Requiring an immediate pre-fsck before printing a minimum
resize size seems a bit draconian; if the fs isn't clean or marked
with error, then certainly, but for an informational minimum
size, I don't think we need to require a fsck since last mount.

I had simply copied the checks from the actual resize path,
previously.

Installers use this option (-P) to gather minimum resize info,
and requiring an actual fsck before use just seems to go too far.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/main.c b/resize/main.c
index 7c4f4dd..7d8b287 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -345,8 +345,7 @@ int main (int argc, char ** argv)
 	min_size = calculate_minimum_resize_size(fs);
 
 	if (print_min_size) {
-		if (!force && ((fs->super->s_lastcheck < fs->super->s_mtime) ||
-			       (fs->super->s_state & EXT2_ERROR_FS) ||
+		if (!force && ((fs->super->s_state & EXT2_ERROR_FS) ||
 			       ((fs->super->s_state & EXT2_VALID_FS) == 0))) {
 			fprintf(stderr,
 				_("Please run 'e2fsck -f %s' first.\n\n"),

