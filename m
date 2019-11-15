Return-Path: <SRS0=LoK8=ZH=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C5FC432C3
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Nov 2019 03:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 961C9206E1
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Nov 2019 03:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKODQc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Nov 2019 22:16:32 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49044 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbfKODQc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Nov 2019 22:16:32 -0500
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xAF3GHPp000938
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 22:16:18 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 900094202FD; Thu, 14 Nov 2019 22:16:17 -0500 (EST)
Date:   Thu, 14 Nov 2019 22:16:17 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: code cleanup for get_next_id
Message-ID: <20191115031617.GA30179@mit.edu>
References: <20191006103028.31299-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006103028.31299-1-cgxu519@mykernel.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Oct 06, 2019 at 06:30:28PM +0800, Chengguang Xu wrote:
> Now the checks in ext4_get_next_id() and dquot_get_next_id()
> are almost the same, so just call dquot_get_next_id() instead
> of ext4_get_next_id().
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

Thanks, applied.

					- Ted
