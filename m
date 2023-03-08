Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271A2C678D5
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Mar 2023 04:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCHEdq (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 7 Mar 2023 23:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjCHEdk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Mar 2023 23:33:40 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF0C9887D
        for <linux-ext4@vger.kernel.org>; Tue,  7 Mar 2023 20:33:36 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3284XVKk021552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 Mar 2023 23:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1678250012; bh=jM+CeGJETG6tHHcSFWSXuokokOH10VGCFF29bqpb0zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OZ8tFUlDkJ08YQE/HjxCuFh/ncZkXEHXAfZduwI9ygJb1eFSzbx4byMukHD/9pMok
         dzaeWKOpy15K4mBtqznoWe9de16jSBuCCJz5vY865UQ87RzLLfBeQhxv+IwMlBIk+K
         4zwOM9EBLJampym/uavTWpCZwBvsfdjvoN3L41ivEnJs31+fqdl3DwoNEj1IPBmywi
         rhdiAHfnVQ7NoyAa0XO4mhCuS3uGv9eOqQdabtFcJQ1Y0DIlA/is3ZS/XEfRg8WP/5
         ltRwH+KovY3424QqwD1CjLKCkVfREfqG2MuDvPmpKVkmnSA1PmNqtMl18Nuqg3+PmU
         WyPHfsTpRjrGA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D6A0B15C348E; Tue,  7 Mar 2023 23:33:29 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4: Fix comment about the 64BIT feature
Date:   Tue,  7 Mar 2023 23:33:26 -0500
Message-Id: <167824999282.2129363.16805187093249173797.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230301133842.671821-1-tudor.ambarus@linaro.org>
References: <20230301133842.671821-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 1 Mar 2023 13:38:42 +0000, Tudor Ambarus wrote:
> 64BIT is part of the incompatible feature set, update the comment
> accordingly.
> 
> 

Applied, thanks!

[1/1] ext4: Fix comment about the 64BIT feature
      commit: 7fc1f5c28ae4c615ccc5346f39a7bf4c4e0900ac

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
