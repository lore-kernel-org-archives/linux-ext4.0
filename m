Return-Path: <SRS0=1MY3=36=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3892EC352A4
	for <linux-ext4@archiver.kernel.org>; Mon, 10 Feb 2020 08:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB6C120733
	for <linux-ext4@archiver.kernel.org>; Mon, 10 Feb 2020 08:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="gYDNzy/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgBJIkU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 10 Feb 2020 03:40:20 -0500
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21146 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726061AbgBJIkU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Feb 2020 03:40:20 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2020 03:40:19 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1581323102;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=3A7kgd9EwxxMVaCsrHVPwN4E1w1q0zJ27JUMCn1+j8I=;
        b=gYDNzy/O4jxLfCBiZ8K3/QwpPIF1VpHqO3T0Vu8/4n3gQhZKFzF2+Q0141VSoCA1
        VG7Ljt525yGdq940vhNk/GjSGDeBo2QY/DPn+S6B5gfVKnfWV5RTHYLmn/f6SuoOmL6
        X52DMQ+eydX3jo7x0LoAFMA1ohoMXzSkSkX+nsX8=
Received: from localhost.localdomain.localdomain (113.88.132.74 [113.88.132.74]) by mx.zoho.com.cn
        with SMTPS id 1581323097919611.4267119995156; Mon, 10 Feb 2020 16:24:57 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200210082445.2379-1-cgxu519@mykernel.net>
Subject: [PATCH] ext4: code cleanup for ext4_statfs_project()
Date:   Mon, 10 Feb 2020 16:24:45 +0800
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Calling min_not_zero() to simplify complicated prjquota
limit comparison in ext4_statfs_project().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/ext4/super.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8434217549b3..5fc1f47f4c6f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5585,13 +5585,8 @@ static int ext4_statfs_project(struct super_block *s=
b,
 =09=09return PTR_ERR(dquot);
 =09spin_lock(&dquot->dq_dqb_lock);
=20
-=09limit =3D 0;
-=09if (dquot->dq_dqb.dqb_bsoftlimit &&
-=09    (!limit || dquot->dq_dqb.dqb_bsoftlimit < limit))
-=09=09limit =3D dquot->dq_dqb.dqb_bsoftlimit;
-=09if (dquot->dq_dqb.dqb_bhardlimit &&
-=09    (!limit || dquot->dq_dqb.dqb_bhardlimit < limit))
-=09=09limit =3D dquot->dq_dqb.dqb_bhardlimit;
+=09limit =3D min_not_zero(dquot->dq_dqb.dqb_bsoftlimit,
+=09=09=09=09dquot->dq_dqb.dqb_bhardlimit);
 =09limit >>=3D sb->s_blocksize_bits;
=20
 =09if (limit && buf->f_blocks > limit) {
@@ -5603,14 +5598,8 @@ static int ext4_statfs_project(struct super_block *s=
b,
 =09=09=09 (buf->f_blocks - curblock) : 0;
 =09}
=20
-=09limit =3D 0;
-=09if (dquot->dq_dqb.dqb_isoftlimit &&
-=09    (!limit || dquot->dq_dqb.dqb_isoftlimit < limit))
-=09=09limit =3D dquot->dq_dqb.dqb_isoftlimit;
-=09if (dquot->dq_dqb.dqb_ihardlimit &&
-=09    (!limit || dquot->dq_dqb.dqb_ihardlimit < limit))
-=09=09limit =3D dquot->dq_dqb.dqb_ihardlimit;
-
+=09limit =3D min_not_zero(dquot->dq_dqb.dqb_isoftlimit,
+=09=09=09=09dquot->dq_dqb.dqb_ihardlimit);
 =09if (limit && buf->f_files > limit) {
 =09=09buf->f_files =3D limit;
 =09=09buf->f_ffree =3D
--=20
2.21.1



