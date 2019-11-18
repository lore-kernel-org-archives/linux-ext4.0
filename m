Return-Path: <SRS0=fzoK=ZK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832E4C432C0
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 01:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52039206D6
	for <linux-ext4@archiver.kernel.org>; Mon, 18 Nov 2019 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574041819;
	bh=l+xL4RuRZUr/qi6KpRTmvEftCVSHa1g/fAE74XJ5VwI=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=s5O1eHgRjJ3FDozBYn9IAG4mOP7TKisNyVAVh+oae7yaR0VB0MXYs2xIO68PXHsjn
	 2ghkF0ZS2NZeTwIU3J9uq/S5LYa5V+z7oh+cn2JglmfZPv3JnLg9umSqb1fq2TkTK6
	 g8kYu3HdVFGTeBhBrCyJ9AGVEd+0cpZahGw8E3U4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfKRBuS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Nov 2019 20:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfKRBuR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Nov 2019 20:50:17 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18980206D9
        for <linux-ext4@vger.kernel.org>; Mon, 18 Nov 2019 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574041817;
        bh=l+xL4RuRZUr/qi6KpRTmvEftCVSHa1g/fAE74XJ5VwI=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=zrykNCDHBSnW62g4EeCHR6vNnFzK6salSEEezEvFZuJpU4Rk+MrGKUTUmCVIbjIfm
         h3aAq4gBn5pj22IXJn7g0DLbG1DrbFLm9HRE0k2k+3a/+fFTqAYwdQw1CqBGjiXqlo
         zOAbMBre86ZCC7NOfKNaUc23ARi8/oppxeyiskg8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Subject: [PATCH 5/6] chattr.1: clarify that ext4 doesn't support tail-merging either
Date:   Sun, 17 Nov 2019 17:48:51 -0800
Message-Id: <20191118014852.390686-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191118014852.390686-1-ebiggers@kernel.org>
References: <20191118014852.390686-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This old text was never updated to mention ext4 in addition to ext2 and
ext3.  Do so now.  Also don't bother to mention old unmerged patches.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/chattr.1.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index cc751fe8..870397ae 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -171,8 +171,8 @@ A file with the 't' attribute will not have a partial block fragment at
 the end of the file merged with other files (for those filesystems which
 support tail-merging).  This is necessary for applications such as LILO
 which read the filesystem directly, and which don't understand tail-merged
-files.  Note: As of this writing, the ext2 or ext3 filesystems do not
-(yet, except in very experimental patches) support tail-merging.
+files.  Note: As of this writing, the ext2, ext3, and ext4 filesystems do
+not support tail-merging.
 .PP
 A directory with the 'T' attribute will be deemed to be the top of
 directory hierarchies for the purposes of the Orlov block allocator.
-- 
2.24.0

