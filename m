Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4304C433F5
	for <linux-ext4@archiver.kernel.org>; Sun, 13 Mar 2022 04:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232987AbiCMEq6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 12 Mar 2022 23:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCMEq5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Mar 2022 23:46:57 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ED7606F0
        for <linux-ext4@vger.kernel.org>; Sat, 12 Mar 2022 20:45:50 -0800 (PST)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 22D4jkHg009260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 12 Mar 2022 23:45:46 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 044C515C3E99; Sat, 12 Mar 2022 23:45:46 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Warn when dirtying page without buffers in data=journal mode
Date:   Sat, 12 Mar 2022 23:45:39 -0500
Message-Id: <164714672856.1260831.8397472020365050278.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220310101832.5645-1-jack@suse.cz>
References: <20220310101832.5645-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, 10 Mar 2022 11:18:32 +0100, Jan Kara wrote:
> Recently I've got a report of BUG_ON trigerring during transaction
> commit in ext4_journalled_writepage_callback() because we've spotted a
> dirty page without buffers. Add WARN_ON_ONCE to
> ext4_journalled_set_page_dirty() to catch the problematic condition
> earlier where we have better chance of understanding which code path is
> creating dirty data without preparing the page properly. Also update the
> comment with current information when we are at it.
> 
> [...]

Applied, thanks!

[1/1] ext4: Warn when dirtying page without buffers in data=journal mode
      commit: 2bb8dd401a4f96973d6a9de4218d7f01fbd497ee

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
