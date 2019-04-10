Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730B0C10F14
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 20:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3866B21741
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 20:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554927972;
	bh=gyyZYzbbhDHtMy/kZVs0+EooltdNhiZvXVja1enYQsY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=L3W1nrDmVHcqTx3DFGDWW44J0+5PktYrVsl6lvKplgQ9ZW3ByfHJRlhjbmnWHGH7Q
	 WcmBWbIXnoZK9iOR1sv7nUhl0Di2O3BYL4IGPX/FVmzh57DiTkl71WfyXMzRZk67m2
	 tp2yVrM0w/uxnE+Y5hDNSEs4HkflTnHpiiB4I41o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfDJU0K (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 16:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfDJU0J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 16:26:09 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F83D2082E;
        Wed, 10 Apr 2019 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554927968;
        bh=gyyZYzbbhDHtMy/kZVs0+EooltdNhiZvXVja1enYQsY=;
        h=From:To:Cc:Subject:Date:From;
        b=rThJbB1AmEh0utqHL2XB2L12FFyNirVTjT3zMUnaXB49hGdmpbsBO7533r9Zx9kq2
         LTGJ8t0ssNylib0mcoFKorsMooQ816+rvConipvpSpACwj+GAN1pNIg2HlXKLQWTWW
         ml7uJUHUYeT/PB2/psPq+p9hLYHzJjNbOD88EJ88=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH v2 0/2] fscrypt: improve encrypted symlink performance
Date:   Wed, 10 Apr 2019 13:21:13 -0700
Message-Id: <20190410202115.64501-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series improves the performance of following encrypted symlinks on
ext4, f2fs, and ubifs.

Eric Biggers (2):
  vfs: use READ_ONCE() to access ->i_link
  fscrypt: cache decrypted symlink target in ->i_link

 fs/crypto/hooks.c       | 40 +++++++++++++++++++++++++++++++++-------
 fs/crypto/keyinfo.c     | 21 +++++++++++++++++++++
 fs/ext4/super.c         |  3 +++
 fs/f2fs/super.c         |  3 +++
 fs/namei.c              |  4 ++--
 fs/ubifs/super.c        |  3 +++
 include/linux/fscrypt.h |  5 +++++
 7 files changed, 70 insertions(+), 9 deletions(-)

-- 
2.21.0.392.gf8f6787159e-goog

