Return-Path: <SRS0=HQ1C=RE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1611C43381
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D84420850
	for <linux-ext4@archiver.kernel.org>; Fri,  1 Mar 2019 14:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZI1y76p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388074AbfCAOGg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 1 Mar 2019 09:06:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39863 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387689AbfCAOGg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2019 09:06:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id b65so8521905plb.6;
        Fri, 01 Mar 2019 06:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zpwCPRdnJq6ElD9Kz34k/4tJCBlLgKa4MTlc6SrUaRA=;
        b=JZI1y76pLYbFcPbjXPaDHuBZYAfKoFmRr0B6EnR8FzoEvfs4Zt9cyId/jvXi+5kti5
         nR0f5wkdHszHXfVTs54pmrf7G7Ujz3IvvxPf0wzJtXDsyIep8B0thbWhBYvSK7yAvylL
         eOrYRMD6H2g8bOyu+/RJV7uRpIjbD7ZWumz1rCstYpWBzGMESLTBm8fzUz/nmEuva5/Z
         R+peRrWnNa/0LHhdozRAAmp8CiSVbxuEmzhCjP5PKsHXq2HIoM4WDVzYpsn4fWKThrDx
         NVpht04hXa+wXeW806A9yUd0mgw2m/JYuuj30U4zGMUTo2iz6ygenLspRWx38C6bxkbM
         uzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zpwCPRdnJq6ElD9Kz34k/4tJCBlLgKa4MTlc6SrUaRA=;
        b=sjKmN9OqaeDtgIBaigKfSzyJobaMWd3Z2uryJw3KjCNR9vGQfgtThMfPYR51/UL/KQ
         aeRFlbLItPA0lO2k0C+KB202q55lexuzIa9XjrI818S14Laobkg997JR6agaS+QNf8zz
         WLa909WwqDSJp8oS5SmbrQvrh3gPkjP761+QkwZ7kCzV5KAULLXQyHHR8zRxm80HsRt4
         xaebCRWAq7K4lJpwS0U70q+bhmPa/JiQZXbMNhzD6EmveHZquv4XaPwisVthdx73ZA8R
         O0TDCS5gUGfdNGGLiyTvrg/hoH4VGnR8ZPIPeesxxGx8yGl8kOEvlh1RhM7WsZQfcJqT
         KLaA==
X-Gm-Message-State: APjAAAWFKSdfXDsJTFkhkX6Js/6D86+apS0/Nwdn4jQ1xxcUsSxk+1a9
        9yLczlzB1jgJ/DPQNHdbmAkszx7I
X-Google-Smtp-Source: APXvYqxbSHkUMb6fpdPfEhSvXmnfuCUU2PA/be3XwrOz/5l/MG8ueEZTws6pOdKXLHiZm9IWIHEEoA==
X-Received: by 2002:a17:902:f096:: with SMTP id go22mr5455952plb.172.1551449194662;
        Fri, 01 Mar 2019 06:06:34 -0800 (PST)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id o2sm36534917pfa.76.2019.03.01.06.06.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 06:06:34 -0800 (PST)
From:   Wang Shilong <wangshilong1991@gmail.com>
X-Google-Original-From: Wang Shilong <wshilong1991@gmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>,
        fstests@vger.kernel.org
Subject: [PATCH] statx: test statx support for project
Date:   Fri,  1 Mar 2019 23:06:23 +0900
Message-Id: <1551449184-7942-2-git-send-email-wshilong1991@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
References: <1551449184-7942-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Wang Shilong <wshilong@ddn.com>

From: Wang Shilong <wshilong@ddn.com>

CC: fstests@vger.kernel.org
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 src/stat_test.c   | 11 ++++++++++-
 src/statx.h       | 19 ++++++++++++++++++-
 tests/generic/423 |  9 ++++++---
 tests/generic/424 | 23 ++++++++++++++++++-----
 4 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/src/stat_test.c b/src/stat_test.c
index 95cfdc4f..9105ff89 100644
--- a/src/stat_test.c
+++ b/src/stat_test.c
@@ -13,10 +13,12 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <sys/types.h>
-#include <sys/stat.h>
 #include <sys/sysmacros.h>
 #include "statx.h"
 
+int fstatat(int dirfd, const char *pathname, struct stat *statbuf,
+	    int flags);
+
 static bool failed = false;
 static bool is_verbose = 0;
 static const char *prog;
@@ -49,6 +51,7 @@ enum fields {
 	stx_mtime_tv_nsec,
 	stx_mtime_tv_sec,
 	stx_nlink,
+	stx_projid,
 	stx_rdev_major,
 	stx_rdev_minor,
 	stx_size,
@@ -84,6 +87,7 @@ static const struct field field_list[nr__fields] = {
 	[stx_mtime_tv_nsec]	= { "stx_mtime.tv_nsec",	STATX_MTIME },
 	[stx_mtime_tv_sec]	= { "stx_mtime.tv_sec",		STATX_MTIME },
 	[stx_nlink]		= { "stx_nlink",		STATX_NLINK },
+	[stx_projid]		= { "stx_projid",		STATX_PROJID },
 	[stx_rdev_major]	= { "stx_rdev_major",		0 },
 	[stx_rdev_minor]	= { "stx_rdev_minor",		0 },
 	[stx_size]		= { "stx_size",			STATX_SIZE },
@@ -113,6 +117,7 @@ static const struct attr_name attr_list[] = {
 	{ "encrypted",	STATX_ATTR_ENCRYPTED },
 	{ "immutable",	STATX_ATTR_IMMUTABLE },
 	{ "nodump",	STATX_ATTR_NODUMP },
+	{ "projinherit",STATX_ATTR_PROJINHERIT },
 };
 
 static int attr_name_cmp(const void *_key, const void *_p)
@@ -155,6 +160,7 @@ void format(void)
 	fprintf(stderr, "\t\tencrypted -- The file is marked as encrypted\n");
 	fprintf(stderr, "\t\timmutable -- The file is marked as immutable\n");
 	fprintf(stderr, "\t\tnodump -- The file is marked as no-dump\n");
+	fprintf(stderr, "\t\tprojinherit -- The file inherit attribute is set\n");
 	fprintf(stderr, "\tcmp_ref -- check that the reference file has identical stats\n");
 	fprintf(stderr, "\tref=<file> -- get reference stats from file\n");
 	fprintf(stderr, "\tstx_<field>=<val> -- statx field value check\n");
@@ -460,6 +466,7 @@ static void cmp_ref(const struct statx *stx, unsigned int mask)
 	cmp("%llu", stx_rdev_minor);
 	cmp("%llu", stx_dev_major);
 	cmp("%llu", stx_dev_minor);
+	cmp("%llu", stx_projid);
 }
 
 /*
@@ -506,6 +513,7 @@ static void check_field(const struct statx *stx, char *arg)
 	case stx_rdev_minor:	uval = stx->stx_rdev_minor;	break;
 	case stx_dev_major:	uval = stx->stx_dev_major;	break;
 	case stx_dev_minor:	uval = stx->stx_dev_minor;	break;
+	case stx_projid:	uval = stx->stx_projid;		break;
 
 	case stx_atime_tv_sec:	sval = stx->stx_atime.tv_sec;	break;
 	case stx_atime_tv_nsec:	sval = stx->stx_atime.tv_nsec;	break;
@@ -562,6 +570,7 @@ static void check_field(const struct statx *stx, char *arg)
 	case stx_rdev_minor:
 	case stx_dev_major:
 	case stx_dev_minor:
+	case stx_projid:
 		ucheck = strtoull(val, &p, 0);
 		if (*p)
 			bad_arg("Field '%s' requires unsigned integer\n", key);
diff --git a/src/statx.h b/src/statx.h
index 3f239d79..db212304 100644
--- a/src/statx.h
+++ b/src/statx.h
@@ -49,6 +49,7 @@ struct statx_timestamp {
 	__s32	tv_nsec;
 	__s32	__reserved;
 };
+#endif /* STATX_TYPE */
 
 /*
  * Structures for the extended file attribute retrieval system call
@@ -87,6 +88,9 @@ struct statx_timestamp {
  * will have values installed for compatibility purposes so that stat() and
  * co. can be emulated in userspace.
  */
+/* walkaround to overide system definition */
+#define statx statx2
+#undef statx
 struct statx {
 	/* 0x00 */
 	__u32	stx_mask;	/* What results were written [uncond] */
@@ -114,10 +118,13 @@ struct statx {
 	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
 	__u32	stx_dev_minor;
 	/* 0x90 */
-	__u64	__spare2[14];	/* Spare space for future expansion */
+	__u32	stx_projid;	/* Project ID of file */
+	__u32	__spare3[1];
+	__u64	__spare2[13];	/* Spare space for future expansion */
 	/* 0x100 */
 };
 
+#ifndef STATX_TYPE
 /*
  * Flags to be stx_mask
  *
@@ -139,7 +146,9 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#ifndef STATX_ALL
 #define STATX_ALL		0x00000fffU	/* All currently supported flags */
+#endif
 
 /*
  * Attributes to be found in stx_attributes
@@ -161,6 +170,14 @@ struct statx {
 #define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
 #endif /* STATX_TYPE */
 
+#ifndef STATX_PROJID
+#define STATX_PROJID		0x00001000U	/* Want/got stx_projid */
+#undef STATX_ALL
+#define STATX_ALL		0x00001fffU	/* All currently supported flags */
+#define STATX_ATTR_PROJINHERIT	0x00002000 /* [I] File project inherit is set */
+#endif /* STATX_PROJID */
+
+
 static inline
 int xfstests_statx(int dfd, const char *filename, unsigned flags,
 		   unsigned int mask, struct statx *buffer)
diff --git a/tests/generic/423 b/tests/generic/423
index b61d5de0..a9577fdb 100755
--- a/tests/generic/423
+++ b/tests/generic/423
@@ -89,7 +89,8 @@ check_stat $TEST_DIR/$seq-dir \
 	   stx_type=dir \
 	   stx_mode=0755 \
 	   stx_rdev_major=0 \
-	   stx_rdev_minor=0
+	   stx_rdev_minor=0 \
+	   stx_projid=0
 
 echo "Test statx on a blockdev"
 mknod -m 0600 $TEST_DIR/$seq-loopy b 7 123
@@ -115,7 +116,8 @@ check_stat $TEST_DIR/$seq-file \
 	   stx_size=20480 \
 	   stx_rdev_major=0 \
 	   stx_rdev_minor=0 \
-	   stx_nlink=1
+	   stx_nlink=1 \
+	   stx_projid=0
 
 echo "Test statx on a symlink"
 ln -s $TEST_DIR/$seq-nowhere $TEST_DIR/$seq-symlink
@@ -127,7 +129,8 @@ check_stat $TEST_DIR/$seq-symlink \
 	   stx_type=sym \
 	   stx_rdev_major=0 \
 	   stx_rdev_minor=0 \
-	   stx_nlink=1
+	   stx_nlink=1 \
+	   stx_projid=0
 
 echo "Test statx on an AF_UNIX socket"
 create_af_unix $TEST_DIR/$seq-sock
diff --git a/tests/generic/424 b/tests/generic/424
index ec1b0035..57aacf40 100755
--- a/tests/generic/424
+++ b/tests/generic/424
@@ -52,10 +52,12 @@ a_supported=""
 c_supported=""
 d_supported=""
 i_supported=""
+P_supported=""
 a_list="0"
 c_list="0"
 d_list="0"
 i_list="0"
+P_list="0"
 
 if $CHATTR_PROG +a $testfile >&/dev/null; then
     a_supported=1
@@ -77,10 +79,15 @@ if $CHATTR_PROG +i $testfile >&/dev/null; then
     i_list="+i -i"
 fi
 
-echo "a=$a_supported d=$d_supported c=$c_supported i=$i_supported" >>$seqres.full
+if $CHATTR_PROG +P $testfile >&/dev/null; then
+    P_supported=1
+    P_list="+P"
+fi
+
+echo "a=$a_supported d=$d_supported c=$c_supported i=$i_supported P=$P_supported" >>$seqres.full
 
-if [ "$a_supported$c_supported$d_supported$i_supported" = "" ]; then
-	_notrun "file system doesn't support any of $CHATTR_PROG +a/+c/+d/+i"
+if [ "$a_supported$c_supported$d_supported$i_supported$P_supported" = "" ]; then
+	_notrun "file system doesn't support any of $CHATTR_PROG +a/+c/+d/+i/+P"
 fi
 
 $CHATTR_PROG -a -c -d -i $testfile
@@ -96,6 +103,7 @@ $CHATTR_PROG -a -c -d -i $testfile
 #	+c		STATX_ATTR_COMPRESSED
 #	+d		STATX_ATTR_NODUMP
 #	+i		STATX_ATTR_IMMUTABLE
+#	+P		STATX_ATTR_PROJINHERIT
 #
 # Note, however, that if the filesystem doesn't paste this information into
 # stx_attributes, there's no way to tell the difference between cleared and
@@ -108,24 +116,29 @@ function try () {
 	       ${c_supported:+$2} \
 	       ${d_supported:+$3} \
 	       ${i_supported:+$4} \
+	       ${P_supported:+$5} \
 	       $testfile
 	check_stat $testfile \
 	       ${a_supported:+attr=${1/a/append}} \
 	       ${c_supported:+attr=${2/c/compressed}} \
 	       ${d_supported:+attr=${3/d/nodump}} \
 	       ${i_supported:+attr=${4/i/immutable}} \
+	       ${P_supported:+attr=${5/p/projinherit}} \
 	       stx_type=file \
 	       stx_size=0 \
 	       stx_rdev_major=0 \
 	       stx_rdev_minor=0 \
-	       stx_nlink=1
+	       stx_nlink=1 \
+	       stx_projid=0
 }
 
 for a in $a_list; do
 	for c in $c_list; do
 		for d in $d_list; do
 			for i in $i_list; do
-				try $a $c $d $i
+				for P in $p_list; do
+					try $a $c $d $i $P
+				done
 			done
 		done
 	done
-- 
2.19.1

