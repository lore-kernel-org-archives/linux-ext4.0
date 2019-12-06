Return-Path: <SRS0=sm/n=Z4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB9DC43603
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Dec 2019 05:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB0132245C
	for <linux-ext4@archiver.kernel.org>; Fri,  6 Dec 2019 05:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="TyMrBEFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfLFFni (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 6 Dec 2019 00:43:38 -0500
Received: from sender3-of-o52.zoho.com.cn ([124.251.121.247]:21930 "EHLO
        sender3-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbfLFFni (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2019 00:43:38 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1575611010; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=EnAaEkuGTTP/L3WjdbMbHjR3fMDpsUThsYS44c0Bn9slt2rpuRoiu2aRnx4iKmJqJT42E+OFDj/zCNlH3cTWTPgzbVgii/E1jW2vowwQnnzUn/oeJNqQGP1dCm5FJO5dIoe+Uk01RXDMD1GH9b+FD/uFNz91sraKWtBpZxze8Wo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1575611010; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=qMjz0gwsl/SZhuHolPZtRDe479E79pKBqoTZbhGlrUY=; 
        b=INGOxfLwU0occwPK/pP0QHUYbjJwRiXMr6E2PXmx4rwLj6Wynuj8daiDeuoyFnjFczrY0IlNThue830lz1aZDbU/feFMkECnr7+wMsrtskWqFlx8VsaxQd45MmiPr+cqPLGw4MMXfSS+mLPjPbeic2aN5x8c/FbldzjHtDanw44=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1575611010;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=662; bh=qMjz0gwsl/SZhuHolPZtRDe479E79pKBqoTZbhGlrUY=;
        b=TyMrBEFFZgBP0sAD67zO4aGBea5vpG7I8yUBCC92xMb8b5H2WrsC0DDdkmP8VCKr
        DkXaHSk7o5Xy8KGfjuq72joTpa287dfgB48jF6p2cSUCJMK7CI4q2DB3n0g7pOtVqqc
        FI69v/jPrzCroS7RcEoxQ5DygGKGESqs5C2U+hQ0=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1575611008148625.6889963843007; Fri, 6 Dec 2019 13:43:28 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191206054317.3107-1-cgxu519@mykernel.net>
Subject: [PATCH] ext4: remove unnecessary assignment in ext4_htree_store_dirent()
Date:   Fri,  6 Dec 2019 13:43:17 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

We have allocated memory using kzalloc() so don't have
to set 0 again in last byte.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/ext4/dir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9fdd2b269d61..5923c9147ae7 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -458,7 +458,6 @@ int ext4_htree_store_dirent(struct file *dir_file, __u3=
2 hash,
 =09new_fn->name_len =3D ent_name->len;
 =09new_fn->file_type =3D dirent->file_type;
 =09memcpy(new_fn->name, ent_name->name, ent_name->len);
-=09new_fn->name[ent_name->len] =3D 0;
=20
 =09while (*p) {
 =09=09parent =3D *p;
--=20
2.20.1



