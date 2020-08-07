Return-Path: <SRS0=FVYV=BR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E50C433DF
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 05:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 600DE2075A
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Aug 2020 05:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgHGFGC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:06:02 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:58009 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725263AbgHGFGC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Aug 2020 01:06:02 -0400
Received: from callcc.thunk.org (pool-96-230-252-158.bstnma.fios.verizon.net [96.230.252.158])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 07755uga016451
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Aug 2020 01:05:57 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4CB81420263; Fri,  7 Aug 2020 01:05:56 -0400 (EDT)
Date:   Fri, 7 Aug 2020 01:05:56 -0400
From:   tytso@mit.edu
To:     brookxu <brookxu.cn@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: rename journal_dev to s_journal_dev inside
 ext4_sb_info
Message-ID: <20200807050556.GT7657@mit.edu>
References: <74c2a122-5a6c-ac97-614a-043038d61623@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74c2a122-5a6c-ac97-614a-043038d61623@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jul 29, 2020 at 02:19:20PM +0800, brookxu wrote:
> Rename journal_dev to s_journal_dev inside ext4_sb_info, keep
> the naming rules consistent with other variables, which is
> convenient for code reading and writing.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>

This patch series is badly white-space damaged.  Can you please resend
it using a different e-mail client which doesn't mangle whitespace?

Please see:

https://www.kernel.org/doc/html/latest/process/email-clients.html

						- Ted
