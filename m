Return-Path: <SRS0=MJ+t=6V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A1BC47247
	for <linux-ext4@archiver.kernel.org>; Thu,  7 May 2020 15:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C98208DB
	for <linux-ext4@archiver.kernel.org>; Thu,  7 May 2020 15:02:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgEGPCY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 May 2020 11:02:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:44455 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726356AbgEGPCY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 May 2020 11:02:24 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 047F1EeC022765
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 7 May 2020 11:01:14 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 237DE421C7D; Thu,  7 May 2020 11:01:14 -0400 (EDT)
Date:   Thu, 7 May 2020 11:01:14 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     xiakaixu1987@gmail.com
Cc:     linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] ext4: remove unnecessary test_opt for DIOREAD_NOLOCK
Message-ID: <20200507150114.GL404484@mit.edu>
References: <1586751862-19437-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586751862-19437-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 13, 2020 at 12:24:22PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The DIOREAD_NOLOCK flag has been cleared when doing the test_opt
> that is meaningless, so remove the unnecessary test_opt for DIOREAD_NOLOCK.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Applied, thanks.

					- Ted
