Return-Path: <SRS0=tO+/=SD=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DAEC43381
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 07:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A48C420830
	for <linux-ext4@archiver.kernel.org>; Mon,  1 Apr 2019 07:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PBm5Ntvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbfDAHBX (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:01:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48848 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfDAHBX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Apr 2019 03:01:23 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x316wgul175435;
        Mon, 1 Apr 2019 07:01:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gexLmQGsVaCo1Yl+8gWMSHGGIveA9gqiMWP2FfO+esk=;
 b=PBm5NtvfN0+VHAuO8h5el/p0X9A14nQp8g2ge6d9dKPBloNzO2HiqJ560ZVb25CCUT1Z
 LMqkF6BA9KB7WRwMqTaE0E/tjESy/8wioJ7kHnZAV/YPkNr3z+sTzxaT1cpbqkJkEW+2
 5Vt2DbVIl+O/D+M4Tv8N2iG2s3nLdse3zV9KrSO+I81cUWp2/UeH2jKhRcgaXotol93h
 ImbK/EaSFJo3TjGY8mAWXCssuz24WbKkyaZtzSdwGoFXKwxpOaX8c6OG+PiOkQBOGaXG
 8ZMr4J/84CPJikVq1uYU+j5zCANdMEVEltuxH8lcuNHzbni1a1rNjLMoWypASrbybSkz Jw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2rhwycw57x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Apr 2019 07:01:21 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x3171K8L003449
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Apr 2019 07:01:21 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3171KbE020549;
        Mon, 1 Apr 2019 07:01:20 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Apr 2019 00:01:20 -0700
Date:   Mon, 1 Apr 2019 00:01:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] e2fsprogs: create tools for formatting and fscking bootfs
Message-ID: <20190401070118.GB1177@magnolia>
References: <20190401070001.GJ1173@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401070001.GJ1173@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9213 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904010052
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create tools and documentation for our new simple bootloader filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/Makefile.in  |    4 ++--
 misc/Makefile.in    |    8 ++++----
 misc/ext4.5.in      |    5 +++++
 misc/mke2fs.conf.in |    3 +++
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/e2fsck/Makefile.in b/e2fsck/Makefile.in
index 9799274fa..69bd244d7 100644
--- a/e2fsck/Makefile.in
+++ b/e2fsck/Makefile.in
@@ -196,7 +196,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
 		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(root_sbindir)/fsck.$$i"; \
 		(cd $(DESTDIR)$(root_sbindir); \
 			$(LN) $(LINK_INSTALL_FLAGS) e2fsck fsck.$$i); \
@@ -215,7 +215,7 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs
 		$(ES) "	INSTALL_DATA $(man5dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(man8dir)/fsck.$$i.8"; \
 		(cd $(DESTDIR)$(man8dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) e2fsck.8 fsck.$$i.8); \
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 22c984893..c961f26fd 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -545,7 +545,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(ES) "	INSTALL $(sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(sbindir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK $(root_sbindir)/mkfs.$$i"; \
 		(cd $(DESTDIR)$(root_sbindir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs mkfs.$$i); \
@@ -576,7 +576,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	done
 	$(Q) $(RM) -f $(DESTDIR)$(man8dir)/mkfs.ext2.8.gz \
 		$(DESTDIR)$(man8dir)/mkfs.ext3.8.gz
-	$(Q) for i in ext2 ext3 ext4; do \
+	$(Q) for i in ext2 ext3 ext4 bootfs; do \
 		$(ES) "	LINK mkfs.$$i.8"; \
 		(cd $(DESTDIR)$(man8dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) mke2fs.8 mkfs.$$i.8); \
@@ -595,7 +595,7 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		$(ES) "	INSTALL_DATA $(man5dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3; do \
+	$(Q) for i in ext2 ext3 bootfs; do \
 		$(ES) "	LINK $$i.5"; \
 		(cd $(DESTDIR)$(man5dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) ext4.5 $$i.5); \
@@ -674,7 +674,7 @@ uninstall:
 	for i in $(FMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man5dir)/$$i; \
 	done
-	$(Q) for i in ext2 ext3; do \
+	$(Q) for i in ext2 ext3 bootfs; do \
 		$(ES) "	LINK $$i.5"; \
 		$(RM) -f $(DESTDIR)$(man5dir)/$$i.5; \
 	done
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index ee5e17097..7eff9c1d1 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -9,6 +9,8 @@ ext2 \- the second extended file system
 ext3 \- the third extended file system
 .br
 ext4 \- the fourth extended file system
+.br
+bootfs \- the simple bootloader file system
 .SH DESCRIPTION
 The second, third, and fourth extended file systems, or ext2, ext3, and
 ext4 as they are commonly known, are Linux file systems that have
@@ -19,6 +21,9 @@ previously intended for use with the ext2 and ext3 file systems can be
 mounted using the ext4 file system driver, and indeed in many modern
 Linux distributions, the ext4 file system driver has been configured
 to handle mount requests for ext2 and ext3 file systems.
+bootfs is a simple bootloader filesystem that trades thirty years' worth of
+filesystem design and speed improvements for safety in the face of poorly
+written userspace software and bootloaders; it is basically ext3 with extents.
 .SH FILE SYSTEM FEATURES
 A file system formatted for ext2, ext3, or ext4 can have some
 collection of the following file system feature flags enabled.  Some of
diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 00afd9128..b60f86f6d 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -10,6 +10,9 @@
 	ext3 = {
 		features = has_journal
 	}
+	bootfs = {
+		features = has_journal,extent
+	}
 	ext4 = {
 		features = has_journal,extent,huge_file,flex_bg,metadata_csum,64bit,dir_nlink,extra_isize
 		inode_size = 256
