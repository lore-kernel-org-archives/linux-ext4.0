Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86265C25B0C
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Aug 2022 14:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiHKOdw (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Aug 2022 10:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbiHKOdf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2022 10:33:35 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1A995E42
        for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2022 07:32:50 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-49-209-117.bstnma.fios.verizon.net [108.49.209.117])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 27BEWdvi008256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 10:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1660228361; bh=+3VNwVuLK7wspFPcbMz8CVBGm59zXZE+YgvEo0Boha4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XwcmjKZ/k4emKVUvmG7/1wy3y/hAMXZXtx0fbo6sWTJqY5qSBNEjmKKKtPfKqxLUd
         ZM0DGxuGoDkCHSDxHFwYQGDny1ZHq1mPp26+GPVXR1GRgpXY5oUr9r9xL7pAMwvJiK
         ZCoSB2G0BLO+sX82jK2utdY83FCffWXXzuVb+L7gn90Z/fbIN1gWeFm78Gu3H852jm
         YI7SvfbUes3rDF0vKvq3iSMVOCw2BjuzqXuCCbY2zl/bPcUebJqCKx7HgrD6688cQq
         C4/zpg0LLasXMsRCKbtDecO0KcpwYql/3LKDT4FbtY53LmyvQvaym3rkLdFf3NIkAx
         SmK/u5L5BfSzA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7E75C15C00E4; Thu, 11 Aug 2022 10:32:38 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     adilger@dilger.ca
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] misc: quiet unused variable warnings
Date:   Thu, 11 Aug 2022 10:32:33 -0400
Message-Id: <166022767027.3024810.6504487680102686784.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220804171832.69266-1-adilger@dilger.ca>
References: <20220804171832.69266-1-adilger@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 4 Aug 2022 11:18:32 -0600, Andreas Dilger wrote:
> Quiet compiler warnings about unreferenced or unset variables.
> 

Applied, thanks!

[1/1] misc: quiet unused variable warnings
      commit: 9d8b56b3b5d59691f16a8b8ae5fb763bc6be3d15

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
