Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86686EB64DA
	for <linux-ext4@archiver.kernel.org>; Wed,  5 Jul 2023 21:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjGEV3I (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjGEV3H (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jul 2023 17:29:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA91982;
        Wed,  5 Jul 2023 14:29:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CEDE6173A;
        Wed,  5 Jul 2023 21:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A554DC433C7;
        Wed,  5 Jul 2023 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688592545;
        bh=n7svmHUh1Z6GbwcL6k4hTmYd2sPiWtLOTvwd8wlcx48=;
        h=From:To:Cc:Subject:Date:From;
        b=sb+zENMFLr0TYlhy6muwquT/CgUn1f+YoD+fgTheZs3ZaIo05qoY/oXk7FLYXWLHI
         imptyVlAgYbrhXscBuZJ4ccYhKVhilV/ZaAGXTTasdep6+ZPYz4dqAkqWvXPaSG9S6
         BxNF1CTgsJytitzcZZsA8r1qCY57EAh1knPg/Q03dPdfd+m01uKkyg3EV2ryNQs838
         DyjWgrP4V9RQkq/Wmq3yrcldCMpaQ7vgAKNu9tlHWAuteZFQtzZs+iAethi1wuW8WI
         19VnR7R4s2q/l/6ju2aoXYGbIlsfuko4q68BHDIKq2Zm2EPoK5fDFK7kg6KUFN5uT9
         1WD0NGkvxG+EA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fsverity@lists.linux.dev
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] fsverity: simplify initcall and move sysctl registration
Date:   Wed,  5 Jul 2023 14:27:41 -0700
Message-ID: <20230705212743.42180-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This series simplifies handling of errors during the fsverity_init()
initcall, and moves the sysctl registration out of signature.c so that
it is not unnecessarily tied to the builtin signature feature.

Eric Biggers (2):
  fsverity: simplify handling of errors during initcall
  fsverity: move sysctl registration out of signature.c

 fs/verity/fsverity_private.h | 12 +++----
 fs/verity/init.c             | 56 ++++++++++++++++++++-------------
 fs/verity/open.c             | 18 +++--------
 fs/verity/signature.c        | 61 +++++-------------------------------
 fs/verity/verify.c           | 11 ++-----
 5 files changed, 55 insertions(+), 103 deletions(-)


base-commit: ace1ba1c9038b30f29c5759bc4726bbed7748f15
-- 
2.41.0

