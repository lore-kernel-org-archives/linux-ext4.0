Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE50C7EE2D
	for <linux-ext4@archiver.kernel.org>; Thu, 25 May 2023 12:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbjEYMmP (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 May 2023 08:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbjEYMmN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 May 2023 08:42:13 -0400
X-Greylist: delayed 379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 05:42:11 PDT
Received: from out-3.mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BD0AA
        for <linux-ext4@vger.kernel.org>; Thu, 25 May 2023 05:42:11 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685018149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y/C2o+NUOjPmOevyE1wBh9bW5wgFZ/f5eKZm3vN/Gyo=;
        b=Pp/la4YQSBaft0UhPWDJ1MhIZS81UTPGa4eY2T+SMRxyNL4eKucsAi6PptBLFHulsz8Hlu
        teAcCyySOKsXZbm3ZvZdC/VU46z2STUSdayW3A8QCbSRGmlEC1CEPT4rHpSEqIE90qDjDI
        vTCJeYiweMdrr+hTgdKgy1dq95dec0Q=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     tytso@mit.edu, adilger.kernel@dilger.ca
Cc:     linux-ext4@vger.kernel.org
Subject: [PATCH 0/2] two clean up patches for mballoc
Date:   Thu, 25 May 2023 20:35:35 +0800
Message-Id: <20230525123537.22543-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi,

Please review the two patches which clean up code a bit.

Thanks,
Guoqing

Guoqing Jiang (2):
  ext4: cleanup ext4_issue_discard
  ext4: make ext4_mb_release_group_pa returns void

 fs/ext4/mballoc.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

-- 
2.35.3

