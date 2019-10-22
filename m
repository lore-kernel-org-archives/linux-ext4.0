Return-Path: <SRS0=nKtQ=YP=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23EE9CA9EA0
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Oct 2019 09:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9B3D2064B
	for <linux-ext4@archiver.kernel.org>; Tue, 22 Oct 2019 09:18:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="KhS+Heno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJVJSK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 22 Oct 2019 05:18:10 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21126 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730312AbfJVJSK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Oct 2019 05:18:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1571735883; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=XKm257dJnE9rowdkJA1vNfP24A/MQUOyNGkYMBcJYznlaqGeqNbXjiEdLNerIerd/UeCWRN0GorA3UggYqwgjfUPONMw/2/TSFMv4klmQCWh+QdwzaJIzET+U+D3Ff6KkB/wOUg8bA3o5x1567VvPonEn/bu1UqpCaJTBoO1zBs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1571735883; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To:ARC-Authentication-Results; 
        bh=SSeqQAIyu9lTUOzZcdJU7QZGCnYru9Mj3e50DPH0g+o=; 
        b=afh2jBPHeHz4EuYKzs+e8U7BJ9ZH3QuU8dHPEYe8Uh80ATQ/peY4uHNHRaY2FYna0RIm62ivrk3XYNcaJUv9zViWwnRDPnODCCiJXYOsWIXJaWx6XTdaHSO6zeAr/PArgvZAGpoCJs8kAGRpZ1vcMNbNXOEclqSoGft9qWUukm8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1571735883;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        l=1082; bh=SSeqQAIyu9lTUOzZcdJU7QZGCnYru9Mj3e50DPH0g+o=;
        b=KhS+HenoYJwK2iEgtvR13RhTYGSFU8Mk+3gNqWHGLy6HopN6j+pA1E2Z6qPIxs/e
        MMPeO4xvKWtO91KyOT1uWP8u0+uGD1RgezEyLFgHDsyaORrFxkr2nEVFVmuAlrBeoUx
        ioulTAN++3z2Ph+JRbR9sKd9AE3i5D3snWNnbPqo=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1571735880251635.85345516198; Tue, 22 Oct 2019 17:18:00 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     jack@suse.com
Cc:     linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191022091738.9160-1-cgxu519@mykernel.net>
Subject: [PATCH v2] ext2: add missing brelse in ext2_new_blocks()
Date:   Tue, 22 Oct 2019 17:17:38 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

There is a missing brelse of bitmap_bh in the
case of retry.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Add comment to explain why the fix is needed.

 fs/ext2/balloc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 924c1c765306..18e75adcd2f6 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -1313,6 +1313,13 @@ ext2_fsblk_t ext2_new_blocks(struct inode *inode, ex=
t2_fsblk_t goal,
 =09if (free_blocks > 0) {
 =09=09grp_target_blk =3D ((goal - le32_to_cpu(es->s_first_data_block)) %
 =09=09=09=09EXT2_BLOCKS_PER_GROUP(sb));
+=09=09/*
+=09=09 * In a special case that allocated blocks are in system zone,
+=09=09 * we will retry block allocation due to failing to pass sanity
+=09=09 * check. In this case, the bitmap_bh is non-null pointer and we
+=09=09 * have to release it before calling read_block_bitmap().
+=09=09 */
+=09=09brelse(bitmap_bh);
 =09=09bitmap_bh =3D read_block_bitmap(sb, group_no);
 =09=09if (!bitmap_bh)
 =09=09=09goto io_error;
--=20
2.20.1



