Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B58C4361A
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:51:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAF422D5A
	for <linux-ext4@archiver.kernel.org>; Thu,  3 Dec 2020 14:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387666AbgLCOns (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 3 Dec 2020 09:43:48 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:34599 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730980AbgLCOns (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Dec 2020 09:43:48 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0B3EgwMe004797
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 3 Dec 2020 09:42:59 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5FC86420136; Thu,  3 Dec 2020 09:42:58 -0500 (EST)
Date:   Thu, 3 Dec 2020 09:42:58 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Chunguang Xu <brookxu.cn@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH RESEND 2/8] ext4: remove redundant mb_regenerate_buddy()
Message-ID: <20201203144258.GK441757@mit.edu>
References: <1604764698-4269-1-git-send-email-brookxu@tencent.com>
 <1604764698-4269-2-git-send-email-brookxu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604764698-4269-2-git-send-email-brookxu@tencent.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat, Nov 07, 2020 at 11:58:12PM +0800, Chunguang Xu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> After this patch (163a203), if an abnormal bitmap is detected, we
> will mark the group as corrupt, and we will not use this group in
> the future. Therefore, it should be meaningless to regenerate the
> buddy bitmap of this group, It might be better to delete it.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

					- Ted
