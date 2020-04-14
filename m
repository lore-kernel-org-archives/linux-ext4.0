Return-Path: <SRS0=nKcX=56=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37DCAC2BBC7
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 01:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2067F2072A
	for <linux-ext4@archiver.kernel.org>; Tue, 14 Apr 2020 01:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbgDNB4c (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:56:32 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42026 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727867AbgDNB40 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2020 21:56:26 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 03E1uGjY031358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Apr 2020 21:56:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 1C2CF42013D; Mon, 13 Apr 2020 21:56:16 -0400 (EDT)
Date:   Mon, 13 Apr 2020 21:56:16 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ext4: remove set but not used variable 'es' in
 ext4_jbd2.c
Message-ID: <20200414015616.GC90651@mit.edu>
References: <20200402034759.29957-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402034759.29957-1-yanaijie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 02, 2020 at 11:47:59AM +0800, Jason Yan wrote:
> Fix the following gcc warning:
> 
> fs/ext4/ext4_jbd2.c:341:30: warning: variable 'es' set but not used [-Wunused-but-set-variable]
>      struct ext4_super_block *es;
>                               ^~
> 
> Fixes: 2ea2fc775321 ("ext4: save all error info in save_error_info() and drop ext4_set_errno()")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied, thanks.

					- Ted
