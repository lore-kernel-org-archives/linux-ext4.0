Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388F9C43219
	for <linux-ext4@archiver.kernel.org>; Fri, 30 Sep 2022 03:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiI3DUE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiI3DT6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2022 23:19:58 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C79825E89
        for <linux-ext4@vger.kernel.org>; Thu, 29 Sep 2022 20:19:56 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 28U3JlGK002419
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Sep 2022 23:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1664507989; bh=RNnEUzk72r2UUhbmcnm5zy/8mne8jVwvTdepoA/0vrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=IraIG3Xghe0LreXYjtt6Dxm3SIswy4/JBfkjjAOBZjd4vyY10kcPeQr99lFlzVIAV
         BkV13IKtKClSvE9J2rOAuhSIsPJnm2V6JWf5DOYnZ89MyEOZtJV3WMGxG115RVFjYx
         qELcbJB5y+zF09KVKAaYrlN5KjoE7YGLHGF7ABQb9B/f38XZhU0YQvsMXscEf8fp+M
         XZ9MVrD1Db9DV9AeKt2VUZmVXoze2ifq2hR0MAWQ4tNX2EzSNYBRqSYRJIFUQaBD6q
         T5Cdkabtl6Fx0r6oJKxJCOYfFq4YN9pSsUf/4JXMba48QWJ6L3NfvOYj4JlwieYA2g
         MOK++EnjkxiMw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 8E33515C3443; Thu, 29 Sep 2022 23:19:47 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     adilger.kernel@dilger.ca, guoqing.jiang@linux.dev
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove redundant checking in ext4_ioctl_checkpoint
Date:   Thu, 29 Sep 2022 23:19:34 -0400
Message-Id: <166450797717.256913.6262236365363903982.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220918115219.12407-1-guoqing.jiang@linux.dev>
References: <20220918115219.12407-1-guoqing.jiang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, 18 Sep 2022 19:52:19 +0800, Guoqing Jiang wrote:
> It is already checked after comment "check for invalid bits set",
> so let's remove this one.
> 
> 

Applied, thanks!

[1/1] ext4: remove redundant checking in ext4_ioctl_checkpoint
      commit: 0a13172182a4d896bddfb42c06c85199fc526104

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
