Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E22C433C1
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8666206F6
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:08:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgLCOIE (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Dec 2020 09:08:04 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56076 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726257AbgLCOIE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2020 09:08:04 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B3E7De7022832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Dec 2020 09:07:14 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 51E9F420136; Thu,  3 Dec 2020 09:07:13 -0500 (EST)
Date:   Thu, 3 Dec 2020 09:07:13 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Roman Anufriev <dotdot@yandex-team.ru>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz,
        dmtrmonakhov@yandex-team.ru
Subject: Re: [PATCH v4 1/2] ext4: add helpers for checking whether quota can
 be enabled/is journalled
Message-ID: <20201203140713.GD441757@mit.edu>
References: <1603336860-16153-1-git-send-email-dotdot@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603336860-16153-1-git-send-email-dotdot@yandex-team.ru>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Oct 22, 2020 at 06:20:59AM +0300, Roman Anufriev wrote:
> Right now, there are several places, where we check whether fs is
> capable of enabling quota or if quota is journalled with quite long
> and non-self-descriptive condition statements.
> 
> This patch wraps these statements into helpers for better readability
> and easier usage.
> 
> Signed-off-by: Roman Anufriev <dotdot@yandex-team.ru>

Applied, thanks.

					- Ted
