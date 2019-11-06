Return-Path: <SRS0=U68d=Y6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0BBC5DF64
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Nov 2019 10:15:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B5852173E
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Nov 2019 10:15:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5Oh0FIO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731172AbfKFKP2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Nov 2019 05:15:28 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731035AbfKFKP2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Nov 2019 05:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573035327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dH+t1U/UF6rK5can7CNVglcRdgd1n4tQApYeDnu0ZX8=;
        b=M5Oh0FIOvA5ufGEbHEqJ7Se9vdfE6bcdwiyS7UfYPftKKU9WhhOJw9DOdwd9RQa0PxkvxQ
        3dL3I+pI4e/qXsriPGhfr+qcQtCPm9/IAHvye2xoBDp7ZLQHIyHlEzM7xGEAlMGyNIoJq+
        wP5Zzj2QOJnMVMtVS3BysAQMjIXlmTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-B_Tl2ZoDMnKrOoq0OliGnA-1; Wed, 06 Nov 2019 05:15:26 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F96C1800D53;
        Wed,  6 Nov 2019 10:15:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.205.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E6CE19756;
        Wed,  6 Nov 2019 10:15:24 +0000 (UTC)
From:   Lukas Czerner <lczerner@redhat.com>
To:     linux-ext4@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 07/17] ext4: check ext2/3 compatibility outside handle_mount_opt()
Date:   Wed,  6 Nov 2019 11:14:47 +0100
Message-Id: <20191106101457.11237-8-lczerner@redhat.com>
In-Reply-To: <20191106101457.11237-1-lczerner@redhat.com>
References: <20191106101457.11237-1-lczerner@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: B_Tl2ZoDMnKrOoq0OliGnA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

At the parsing phase of mount in the new mount api sb will not be
available so move ext2/3 compatibility check outside handle_mount_opt().
Unfortunately we will lose the ability to show exactly which option is
not compatible.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/super.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index affcdaf63b6e..d515506d18a0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -89,8 +89,8 @@ static void ext4_clear_request_list(void);
 static struct inode *ext4_get_journal_inode(struct super_block *sb,
 =09=09=09=09=09    unsigned int journal_inum);
 static int ext4_validate_options(struct fs_context *fc);
-static int ext4_check_quota_consistency(struct fs_context *fc,
-=09=09=09=09=09struct super_block *sb);
+static int ext4_check_opt_consistency(struct fs_context *fc,
+=09=09=09=09      struct super_block *sb);
 static void ext4_apply_quota_options(struct fs_context *fc,
 =09=09=09=09     struct super_block *sb);
=20
@@ -1845,6 +1845,7 @@ struct ext4_fs_context {
 =09unsigned short=09qname_spec;
 =09unsigned long=09journal_devnum;
 =09unsigned int=09journal_ioprio;
+=09unsigned int=09opt_flags;=09/* MOPT flags */
 };
=20
 #ifdef CONFIG_QUOTA
@@ -1965,25 +1966,14 @@ static int handle_mount_opt(struct fs_context *fc, =
struct fs_parameter *param)
 =09=09if (token =3D=3D m->token)
 =09=09=09break;
=20
+=09ctx->opt_flags |=3D m->flags;
+
 =09if (m->token =3D=3D Opt_err) {
 =09=09ext4_msg(NULL, KERN_ERR, "Unrecognized mount option \"%s\" "
 =09=09=09 "or missing value", param->key);
 =09=09return -EINVAL;
 =09}
=20
-=09if ((m->flags & MOPT_NO_EXT2) && IS_EXT2_SB(sb)) {
-=09=09ext4_msg(NULL, KERN_ERR,
-=09=09=09 "Mount option \"%s\" incompatible with ext2",
-=09=09=09 param->string);
-=09=09return -EINVAL;
-=09}
-=09if ((m->flags & MOPT_NO_EXT3) && IS_EXT3_SB(sb)) {
-=09=09ext4_msg(NULL, KERN_ERR,
-=09=09=09 "Mount option \"%s\" incompatible with ext3",
-=09=09=09 param->string);
-=09=09return -EINVAL;
-=09}
-
 =09if (m->flags & MOPT_EXPLICIT) {
 =09=09if (m->mount_opt & EXT4_MOUNT_DELALLOC) {
 =09=09=09set_opt2(sb, EXPLICIT_DELALLOC);
@@ -2212,7 +2202,7 @@ static int parse_options(char *options, struct super_=
block *sb,
 =09if (ret < 0)
 =09=09return 0;
=20
-=09ret =3D ext4_check_quota_consistency(&fc, sb);
+=09ret =3D ext4_check_opt_consistency(&fc, sb);
 =09if (ret < 0)
 =09=09return 0;
=20
@@ -2305,6 +2295,25 @@ static int ext4_check_quota_consistency(struct fs_co=
ntext *fc,
 #endif
 }
=20
+static int ext4_check_opt_consistency(struct fs_context *fc,
+=09=09=09=09      struct super_block *sb)
+{
+=09struct ext4_fs_context *ctx =3D fc->fs_private;
+
+=09if ((ctx->opt_flags & MOPT_NO_EXT2) && IS_EXT2_SB(sb)) {
+=09=09ext4_msg(NULL, KERN_ERR,
+=09=09=09 "Mount option(s) incompatible with ext2");
+=09=09return -EINVAL;
+=09}
+=09if ((ctx->opt_flags & MOPT_NO_EXT3) && IS_EXT3_SB(sb)) {
+=09=09ext4_msg(NULL, KERN_ERR,
+=09=09=09 "Mount option(s) incompatible with ext3");
+=09=09return -EINVAL;
+=09}
+
+=09return ext4_check_quota_consistency(fc, sb);
+}
+
 static int ext4_validate_options(struct fs_context *fc)
 {
 =09struct ext4_sb_info *sbi =3D fc->s_fs_info;
--=20
2.21.0

