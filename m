Return-Path: <SRS0=Quj2=DK=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC82C4363D
	for <linux-ext4@archiver.kernel.org>; Sat,  3 Oct 2020 05:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E902C206C3
	for <linux-ext4@archiver.kernel.org>; Sat,  3 Oct 2020 05:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCFYH (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:24:07 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60179 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725730AbgJCFYH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Oct 2020 01:24:07 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0935NxQZ002033
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 3 Oct 2020 01:24:00 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 95E7442003C; Sat,  3 Oct 2020 01:23:59 -0400 (EDT)
Date:   Sat, 3 Oct 2020 01:23:59 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: limit entries returned when counting fsmap records
Message-ID: <20201003052359.GO23474@mit.edu>
References: <20201001222148.GA49520@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001222148.GA49520@magnolia>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Oct 01, 2020 at 03:21:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If userspace asked fsmap to try to count the number of entries, we cannot
> return more than UINT_MAX entries because fmh_entries is u32.
> Therefore, stop counting if we hit this limit or else we will waste time
> to return truncated results.
> 
> Fixes: 0c9ec4beecac ("ext4: support GETFSMAP ioctls")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
