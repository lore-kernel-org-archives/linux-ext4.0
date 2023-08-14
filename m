Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D5D2EB64DD
	for <linux-ext4@archiver.kernel.org>; Mon, 14 Aug 2023 18:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjHNS3t (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 14 Aug 2023 14:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjHNS3i (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Aug 2023 14:29:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4963DE6E;
        Mon, 14 Aug 2023 11:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF08617B5;
        Mon, 14 Aug 2023 18:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5FEC433C8;
        Mon, 14 Aug 2023 18:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692037776;
        bh=uVYR89LUMO78W0VjDkqutMqUi2s1NDJcRATsUgnL4s0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZwvgHI6vwkmlHBBx4WcXoMviO24OlBy7Z5cuSa+qxtYZOp878FhM3EK9pO7T355Dh
         SCXTJUF5wK/mC50r3jun/n5+2gEuTgixGwlJocA2kptuuld1sDDNm0EKfoTRdAusEg
         Yn+vGGEIx1hv3qbCr7msdkNvYLNe+KQJef6USeD+TOlXyG6JocFHyyI4i7f+KmszTS
         8qBYH25ngGeEeuaE9XLcN0co1wKA6WF4Eh7oNF5KHxphMeg/WUinY82m9TF3xT5s5N
         JNPccRxQoOftx6FW6v24sf8aTwCibDK7SL2nbezyI8MSqRBFmmkXqrAz2O6k6Oxkor
         ToYEhz9Q5YY4g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH 0/3] Simplify rejection of unexpected casefold inode flag
Date:   Mon, 14 Aug 2023 11:29:00 -0700
Message-ID: <20230814182903.37267-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series makes unexpected casefold flags on inodes be consistently
rejected early on so that additional validation isn't needed later on
during random filesystem operations.  For additional context, refer to
the discussion on patch 1 of
https://lore.kernel.org/linux-fsdevel/20230812004146.30980-1-krisman@suse.de/T/#u

Applies to v6.5-rc6

Eric Biggers (3):
  ext4: reject casefold inode flag without casefold feature
  ext4: remove redundant checks of s_encoding
  libfs: remove redundant checks of s_encoding

 fs/ext4/hash.c  |  2 +-
 fs/ext4/inode.c |  5 ++++-
 fs/ext4/namei.c |  6 +++---
 fs/libfs.c      | 14 ++------------
 4 files changed, 10 insertions(+), 17 deletions(-)


base-commit: 2ccdd1b13c591d306f0401d98dedc4bdcd02b421
-- 
2.41.0

