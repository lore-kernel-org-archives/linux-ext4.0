From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V3] mke2fs: prevent creation of filesystem with unsupported
 revision
Date: Thu, 01 May 2014 17:35:00 -0500
Message-ID: <5362CC14.2070902@redhat.com>
References: <5362A6A2.7040504@redhat.com> <5362B105.9080702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Frank Sorenson <fsorenso@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaEAWe6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 May 2014 18:34:58 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s41MYvCh029659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 May 2014 18:34:57 -0400
In-Reply-To: <5362B105.9080702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frank Sorenson <fsorenso@redhat.com>

It's a bit strange to accept revision levels higher than
the code creating the filesystem can understand, so don't
allow it.

At least the kernel will mount the fs readonly if it's too
high, but no other utility will touch it, so you can't
fix the error.

Just reject anything > EXT2_MAX_SUPP_REV at mkfs time.

Signed-off-by: Frank Sorenson <fsorenso@redhat.com>
[sandeen@redhat.com: Add more verbose commit log]
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Frank did this independently, and it's better.  I forgot about
using com_err here.

V3: go back to V1's commit log for Andreas :)

--- a/misc/mke2fs.c	
+++ a/misc/mke2fs.c	
@@ -1684,6 +1684,11 @@ profile_error:
 					_("bad revision level - %s"), optarg);
 				exit(1);
 			}
+			if (r_opt > EXT2_MAX_SUPP_REV) {
+				com_err(program_name, EXT2_ET_REV_TOO_HIGH,
+					_("while trying to create revision %d"), r_opt);
+				exit(1);
+			}
 			fs_param.s_rev_level = r_opt;
 			break;
 		case 's':	/* deprecated */

