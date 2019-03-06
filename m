Return-Path: <SRS0=J2/x=RJ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CED3C43381
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 01:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D237020684
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Mar 2019 01:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X1p8t2D6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfCFBr5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Mar 2019 20:47:57 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:58452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfCFBr5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Mar 2019 20:47:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x261iKNG011422
        for <linux-ext4@vger.kernel.org>; Wed, 6 Mar 2019 01:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=nv2P6BCHMkFNltG1W00tvXFO4U9BcGajLIpuy3miA9A=;
 b=X1p8t2D6aY2zANk1RKQzikoZwJEjGN3YEY5lYF/3qI1nU8MYxrXuH4gxqYlHdvg2xJu3
 xzQy7dQhZkkHRyuHTChCJvb4kWIoHpw6O7/fKIftOxO8XdykvnZScSgjqLfv1+IHExn5
 DsxKfrrTDxPkdPRxY/6Ld35JZw2Hk51/1UlL2AvNZJ3sXpUf4B3LHuvwdM746ng2iaCK
 qSRVLR7JRet/9UQ3L0qMxSfSdnJdDRBYdizEPVYRseSpMZWzSWE/RQsSQwahG4n9OJhw
 bS859JVih6+zeX0SBEZoXTodUgzquwiKYUY/2UhpWXqXGBo38IkkiNDigHP02/j0vU8x 4w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2qyjfrgw97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2019 01:47:55 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x261lsfe006167
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-ext4@vger.kernel.org>; Wed, 6 Mar 2019 01:47:55 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x261lsuf002940
        for <linux-ext4@vger.kernel.org>; Wed, 6 Mar 2019 01:47:54 GMT
Received: from ol6u9ext3.cn.oracle.com (/10.182.70.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Mar 2019 17:47:54 -0800
From:   Shuning Zhang <sunny.s.zhang@oracle.com>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH] ext2: Adjust the comment of function ext2_alloc_branch
Date:   Wed,  6 Mar 2019 09:47:35 +0800
Message-Id: <1551836855-10316-1-git-send-email-sunny.s.zhang@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9186 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903060009
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

The name of argument is error in the header comment.
@num should be @indirect_blks.
At the same time, there was a lack of description of the two parameters
@blks and @goal.
This commit therefore fixes this header comment.

Signed-off-by: Shuning Zhang <sunny.s.zhang@oracle.com>
---
 fs/ext2/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index e4bb938..3f404c3 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -451,7 +451,9 @@ static int ext2_alloc_blocks(struct inode *inode,
 /**
  *	ext2_alloc_branch - allocate and set up a chain of blocks.
  *	@inode: owner
- *	@num: depth of the chain (number of blocks to allocate)
+ *	@indirect_blks: depth of the chain (number of blocks to allocate)
+ *	@blks: number of allocated direct blocks
+ *	@goal: preferred place for allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
  *
-- 
2.7.4

