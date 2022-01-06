Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2BDC4332F
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Jan 2022 04:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbiAFEmI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 5 Jan 2022 23:42:08 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39528 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233907AbiAFEmE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jan 2022 23:42:04 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2064ftUu003550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jan 2022 23:41:55 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 0F48015C339C; Wed,  5 Jan 2022 23:41:55 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext4: fix a copy and paste typo
Date:   Wed,  5 Jan 2022 23:41:51 -0500
Message-Id: <164144408579.468293.13378223752682173286.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211215114309.GB14552@kili>
References: <20211215114309.GB14552@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, 15 Dec 2021 14:43:09 +0300, Dan Carpenter wrote:
> This was obviously supposed to be an ext4 struct, not xfs.  GCC
> doesn't care either way so it doesn't affect the build or runtime.
> 
> 

Applied, thanks!

[1/1] ext4: fix a copy and paste typo
      commit: 42e2b7ca9b4d4a9bb350910a2a66628699365572

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
