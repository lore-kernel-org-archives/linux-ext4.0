Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC45C433EF
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Sep 2021 03:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B03161130
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Sep 2021 03:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhIPDCx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:02:53 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40830 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233979AbhIPDCr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Sep 2021 23:02:47 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 18G31KDe017857
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Sep 2021 23:01:20 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4107715C3427; Wed, 15 Sep 2021 23:01:20 -0400 (EDT)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] tests: update expect files for f_mmp_garbage
Date:   Wed, 15 Sep 2021 23:01:13 -0400
Message-Id: <163176124738.2478144.1832972007129461858.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210824121020.143449-1-lczerner@redhat.com>
References: <20210824121020.143449-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, 24 Aug 2021 14:10:19 +0200, Lukas Czerner wrote:
> Update expect file for f_mmp_garbage test to work correctly with the
> new default 256 inode size.
> 
> 

Applied, thanks!

[1/2] tests: update expect files for f_mmp_garbage
      (no commit info)
[2/2] tests: update expect files for f_large_dir and f_large_dir_csum
      (no commit info)

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
