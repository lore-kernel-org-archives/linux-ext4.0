From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: don't accept too-high revision levels
Date: Thu, 01 May 2014 14:55:14 -0500
Message-ID: <5362A6A2.7040504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaEATzN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 May 2014 15:55:13 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s41JtC8D010456
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 May 2014 15:55:13 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s41JtBcZ026148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 1 May 2014 15:55:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's a bit strange to accept revision levels higher than
the code creating the filesystem can understand, so don't
allow it.

At least the kernel will mount the fs readonly if it's too
high, but no other utility will touch it, so you can't
fix the error.

Just reject anything > EXT2_MAX_SUPP_REV at mkfs time.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aecd5d5..82019dc 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1679,9 +1679,10 @@ profile_error:
 			break;
 		case 'r':
 			r_opt = strtoul(optarg, &tmp, 0);
-			if (*tmp) {
+			if (*tmp || (r_opt > EXT2_MAX_SUPP_REV)) {
 				com_err(program_name, 0,
-					_("bad revision level - %s"), optarg);
+					_("bad revision level - %s (max %d)"),
+					   optarg, EXT2_MAX_SUPP_REV);
 				exit(1);
 			}
 			fs_param.s_rev_level = r_opt;

