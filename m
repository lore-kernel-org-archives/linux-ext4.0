Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6FEC77B7E
	for <linux-ext4@archiver.kernel.org>; Fri, 28 Apr 2023 05:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345253AbjD1FWQ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 28 Apr 2023 01:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjD1FWO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Apr 2023 01:22:14 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2146A1BFA
        for <linux-ext4@vger.kernel.org>; Thu, 27 Apr 2023 22:22:12 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 33S5Lh6F008580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 01:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1682659307; bh=WXuHcAHwQLSuZMfXy+lpOO2cfRIYmmZOzDS7AiB/VkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kzGmSqpKyT/E6AHTPiILqWkI/Ia5cfUORbOq6zvSmPsE2y1R14SyGlVR/Sr/9ypLH
         VKJrDtZKo+BhQ2W1Fu7SQIPvfyBMtD7f7Q2NJyzONDzHB9TYax4BD9FrpqRW8OmBd0
         exItLtNnUdc+wiJAW62FXupLsSH6OfLQdFuJPQMBUNEHYFBvdo3b74vsw7jsBD8GOB
         AlEwW8sdgCHkyXmhxvSYsKEbstp2jt3E5Qj8s8dPkSDiBaE4MPmN76Ic9VsblCIPzJ
         MMwbdjEd1ns7xIcmuHpkL9mnnqXlH9cbg5r82/E1eb29W5pbxL6NKEiQeVZIFTmXbZ
         qtRkEJ02W8y/A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id AA06A15C3AC2; Fri, 28 Apr 2023 01:21:43 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     adilger.kernel@dilger.ca, Nathan Chancellor <nathan@kernel.org>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, yanaijie@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix unused iterator variable warnings
Date:   Fri, 28 Apr 2023 01:21:42 -0400
Message-Id: <168265929108.244350.11944078195733675751.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230420-ext4-unused-variables-super-c-v1-1-138b6db6c21c@kernel.org>
References: <20230420-ext4-unused-variables-super-c-v1-1-138b6db6c21c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


On Thu, 20 Apr 2023 09:51:24 -0700, Nathan Chancellor wrote:
> When CONFIG_QUOTA is disabled, there are warnings around unused iterator
> variables:
> 
>   fs/ext4/super.c: In function 'ext4_put_super':
>   fs/ext4/super.c:1262:13: error: unused variable 'i' [-Werror=unused-variable]
>    1262 |         int i, err;
>         |             ^
>   fs/ext4/super.c: In function '__ext4_fill_super':
>   fs/ext4/super.c:5200:22: error: unused variable 'i' [-Werror=unused-variable]
>    5200 |         unsigned int i;
>         |                      ^
>   cc1: all warnings being treated as errors
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix unused iterator variable warnings
      commit: 5b3e67cadf469110068175fb1e088d9bebaa4d7c

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
