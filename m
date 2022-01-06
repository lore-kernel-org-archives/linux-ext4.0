Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E69C433F5
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jan 2022 04:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbiAFEmA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 5 Jan 2022 23:42:00 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39510 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230283AbiAFEl7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jan 2022 23:41:59 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2064fttA003546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jan 2022 23:41:55 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0568615C00E1; Wed,  5 Jan 2022 23:41:55 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     cgel.zte@gmail.com
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] ext4: Remove redundant 'offset' assignment
Date:   Wed,  5 Jan 2022 23:41:49 -0500
Message-Id: <164144408579.468293.12549141212550282802.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211208075307.404703-1-luo.penghao@zte.com.cn>
References: <20211208075307.404703-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 8 Dec 2021 07:53:07 +0000, cgel.zte@gmail.com wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> Although it is in the loop, offset is reassigned at the beginning of the
> while loop. And know that the function ends, the value will not be used
> 
> The clang_analyzer complains as follows:
> 
> [...]

Applied, thanks!

[1/1] ext4: Remove redundant 'offset' assignment
      commit: e81dca082197eed04b89a7c511b454a3c8dd55fb

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
