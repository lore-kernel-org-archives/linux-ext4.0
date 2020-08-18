Return-Path: <SRS0=ae04=B4=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE2EC433DF
	for <linux-ext4@archiver.kernel.org>; Tue, 18 Aug 2020 18:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97FAF20657
	for <linux-ext4@archiver.kernel.org>; Tue, 18 Aug 2020 18:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgHRSQN (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 18 Aug 2020 14:16:13 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:45129 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726435AbgHRSQM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Aug 2020 14:16:12 -0400
Received: from callcc.thunk.org (pool-108-49-65-20.bstnma.fios.verizon.net [108.49.65.20])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 07IIG8Ob012313
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 14:16:09 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5F48E420DC0; Tue, 18 Aug 2020 14:16:08 -0400 (EDT)
Date:   Tue, 18 Aug 2020 14:16:08 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     brookxu <brookxu.cn@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: delete invalid comments near ext4_mb_check_limits()
Message-ID: <20200818181608.GC34125@mit.edu>
References: <c49faf0c-d5d5-9c51-6911-9e0ff57c6bfa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c49faf0c-d5d5-9c51-6911-9e0ff57c6bfa@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 07, 2020 at 10:01:33PM +0800, brookxu wrote:
> These comments do not seem to be related to ext4_mb_check_limits(),
> it may be invalid.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>

Thanks, applied.

					- Ted
