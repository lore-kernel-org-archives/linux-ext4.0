From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] mke2fs: prevent creation of filesystem with unsupported
 revision
Date: Thu, 01 May 2014 15:39:33 -0500
Message-ID: <5362B105.9080702@redhat.com>
References: <5362A6A2.7040504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Frank Sorenson <fsorenso@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbaEAUjb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 May 2014 16:39:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s41KdVh5024963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 1 May 2014 16:39:31 -0400
In-Reply-To: <5362A6A2.7040504@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frank Sorenson <fsorenso@redhat.com>

Don't create a filesystem with an unsupported revision number

Signed-off-by: Frank Sorenson <fsorenso@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Frank did this independently, and it's better.  I forgot about
using com_err here.

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
