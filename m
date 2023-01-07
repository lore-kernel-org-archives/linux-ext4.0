Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E7EC54EBC
	for <linux-ext4@archiver.kernel.org>; Sat,  7 Jan 2023 20:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbjAGUa5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 7 Jan 2023 15:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjAGUa4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2023 15:30:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D2534D77;
        Sat,  7 Jan 2023 12:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6261F60B8C;
        Sat,  7 Jan 2023 20:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18CDC433D2;
        Sat,  7 Jan 2023 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673123453;
        bh=+TMstKL07xUTqVoajbbWQM6ZllvJrtB36POH82uCwM8=;
        h=Date:From:To:Cc:Subject:From;
        b=ZMpu0EjUyIunqxcZlJXQcS2tFD80bxcL7mMagAxdfVNlbTV6gk5OAlBujpAYgb1Bj
         S2Qn7lZTEpLXSa+pHb33Glh9Jn5aJeehip9HILwLFgwIUQeJwJ+qUrzZJkxuPUZeIl
         yFMENo7LPrbcVNmb/Vby+lm1kDpQ61mukYFIccedcnkgL/mnt6GKwg9bLS5+0A/H2N
         hdw92bKG26QbSGOnZb0Dlr2dpgD/2W+esP/NdTEJGxgDeeSVDfWWYuzRa2Jr9ZobuO
         UM524fmJzaAhTZwuH2U8kGSaxTDleaGWrWke6tkVo4HsmqIQAVPmq7dQyBE8jq3sYZ
         WT0TuWSidzlDQ==
Date:   Sat, 7 Jan 2023 12:30:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org
Subject: Please apply "ext4: don't allow journal inode to have encrypt flag"
 to 5.15 and earlier
Message-ID: <Y7nWexWBpMWKwdeB@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Please apply commit 105c78e12468 ("ext4: don't allow journal inode to have
encrypt flag") to the 5.15, 5.10, 5.4, and 4.19 LTS kernels, where it applies
cleanly.

It didn't get applied automatically because for the Fixes tag, I used a commit
in 5.18.  However, that was the commit that exposed the problem, not the root
cause.  IMO it makes sense to apply this to earlier kernels too, especially
because some people have backported the 5.18 commit.

- Eric
