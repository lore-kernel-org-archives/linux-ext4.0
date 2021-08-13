Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE4FC4338F
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Aug 2021 16:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5148610CF
	for <linux-ext4@archiver.kernel.org>; Fri, 13 Aug 2021 16:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhHMQu3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 13 Aug 2021 12:50:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44372 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236813AbhHMQu1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Aug 2021 12:50:27 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 17DGnrsi025190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 12:49:54 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 7650B15C37C1; Fri, 13 Aug 2021 12:49:53 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] tests: check quota file space usage does not get accounted
Date:   Fri, 13 Aug 2021 12:49:51 -0400
Message-ID: <162886682604.316310.8444293605338818617.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210804121652.25833-1-jack@suse.cz>
References: <20210804121652.25833-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
Message-ID: <20210813164951.lHjv2bgrXRpCgr5-xo33m7jHzYMLzVyqJW_b57AQrf4@z>

On Wed, 4 Aug 2021 14:16:52 +0200, Jan Kara wrote:
> Check that space used by quota files themselves does not get accounted
> into the space tracked by quota subsystem.

Applied, thanks!

[1/1] tests: check quota file space usage does not get accounted
      commit: 958b95eb0b37de5e3a52cb7abbfdfeed79635727

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
