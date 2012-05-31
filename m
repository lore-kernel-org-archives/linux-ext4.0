From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mke2fs: enable bigalloc if -C is specified
Date: Thu, 31 May 2012 11:52:37 -0500
Message-ID: <4FC7A1D5.3040805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab2EaRHY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 13:07:24 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VH7KCj028921
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 13:07:24 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4VGqbWE027943
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 12:52:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If -C is specified w/o -O bigalloc it has no effect and generates
no error.  If a cluster size is specified, that should imply
bigalloc.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..d1944dc 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1351,6 +1351,8 @@ profile_error:
 					optarg);
 				exit(1);
 			}
+			fs_param.s_feature_ro_compat |=
+					EXT4_FEATURE_RO_COMPAT_BIGALLOC;
 			break;
 		case 'D':
 			direct_io = 1;


