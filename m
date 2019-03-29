Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98409C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 16:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72033218D8
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 16:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729480AbfC2Q6H (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 12:58:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728936AbfC2Q6H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 12:58:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 09080AC8C;
        Fri, 29 Mar 2019 16:58:06 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 89A211E4273; Fri, 29 Mar 2019 17:58:05 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsprogs: Fix autoheader failure
Date:   Fri, 29 Mar 2019 17:58:03 +0100
Message-Id: <20190329165803.8651-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Autoheader reports:

autoheader: warning: missing template: HAVE_BLKID_PROBE_ENABLE_PARTITIONS
autoheader: Use AC_DEFINE([HAVE_BLKID_PROBE_ENABLE_PARTITIONS], [], [Description])
autoheader: warning: missing template: HAVE_BLKID_PROBE_GET_TOPOLOGY

so provide appropriate descriptions for the defines.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 248b291dd0d2..290f93ebdf2f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1119,9 +1119,9 @@ dnl the functions added after migrating that library to util-linux
 dnl
 if test -n "$BLKID_CMT"; then
   AC_CHECK_LIB(blkid, blkid_probe_get_topology,
-		      AC_DEFINE(HAVE_BLKID_PROBE_GET_TOPOLOGY, 1))
+		      AC_DEFINE(HAVE_BLKID_PROBE_GET_TOPOLOGY, 1, [Define to 1 if blkid library provides blkid_probe_get_topology]))
   AC_CHECK_LIB(blkid, blkid_probe_enable_partitions,
-		      AC_DEFINE(HAVE_BLKID_PROBE_ENABLE_PARTITIONS, 1))
+		      AC_DEFINE(HAVE_BLKID_PROBE_ENABLE_PARTITIONS, 1, [Define to 1 if blkid library provides blkid_probe_enable_partitions]))
 fi
 dnl
 if test -n "$DLOPEN_LIB" ; then
-- 
2.16.4

