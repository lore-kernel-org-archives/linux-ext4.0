Return-Path: <SRS0=J9+t=YW=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1E4CA9EC3
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Oct 2019 20:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32B132173E
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Oct 2019 20:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572381840;
	bh=QJkibpFmPY+L1l0BTOxPJ+ZzOzC9a95hZioeK/4QcCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VWcBIg0oKKo3AafSrU71o1d8JtNEA3tridvw4U7MCivY4QoYSNPCd0Fdz/2/pd1IP
	 fAlHCWL+iz/XJpvqhTIDZVdS3USjqC49z/s96myH/a09LQiqNqcMaIsC60n83g7vsX
	 Mo9h+nHEmP95BgQb6c03svx8qNDbw5RLiByPuP+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfJ2Un7 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Oct 2019 16:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727518AbfJ2Un4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Oct 2019 16:43:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05878217D9;
        Tue, 29 Oct 2019 20:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572381836;
        bh=QJkibpFmPY+L1l0BTOxPJ+ZzOzC9a95hZioeK/4QcCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLmEHvRFOhMawxj8dbjPdVj9lV+aMT03HEGnZryulKlISNzap/aO3XJvYfT3EcjCg
         7c5nbYz5/ntLx21/L1gFiBGlM9TW4Vxz9Wb37hrufKVX2YRPelOvT2mdzbi15r15h+
         7HuRJZ9V1Cwe2775DkNf1dof2WmVtaUw181Ynp64=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-api@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH 3/4] f2fs: support STATX_ATTR_VERITY
Date:   Tue, 29 Oct 2019 13:41:40 -0700
Message-Id: <20191029204141.145309-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191029204141.145309-1-ebiggers@kernel.org>
References: <20191029204141.145309-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Set the STATX_ATTR_VERITY bit when the statx() system call is used on a
verity file on f2fs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 29bc0a542759a2..6a2e5b7d8fc74c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -726,11 +726,14 @@ int f2fs_getattr(const struct path *path, struct kstat *stat,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
+	if (IS_VERITY(inode))
+		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP);
+				  STATX_ATTR_NODUMP |
+				  STATX_ATTR_VERITY);
 
 	generic_fillattr(inode, stat);
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

