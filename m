From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH e2fsprogs] libblkid: detect squashfs
Date: Tue, 25 Sep 2007 12:02:50 -0500
Message-ID: <46F93F3A.7080406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbXIYRCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 13:02:51 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l8PH2o8E015174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 13:02:51 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8PH2o1h031985
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 13:02:50 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l8PH2n2k028126
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 13:02:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

libblkid: recognize squashfs filesystems

squashfs has no uuid or labels, so all we need is the magic.

Addresses-Red-Hat-Bugzilla: #305151
    
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-1.40.2/lib/blkid/probe.c
===================================================================
--- e2fsprogs-1.40.2.orig/lib/blkid/probe.c
+++ e2fsprogs-1.40.2/lib/blkid/probe.c
@@ -898,6 +898,7 @@ static struct blkid_magic type_array[] =
   { "ocfs2",	 4,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "ocfs2",	 8,	 0,  6,	"OCFSV2",		probe_ocfs2 },
   { "crypt_LUKS", 0,	 0,  6,	"LUKS\xba\xbe",		probe_luks },
+  { "squashfs",	 0,	 0,  4,	"hsqs",			0 },
   {   NULL,	 0,	 0,  0, NULL,			NULL }
 };
 
