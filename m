Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41A7C433F5
	for <linux-ext4@archiver.kernel.org>; Wed,  5 Jan 2022 23:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245421AbiAEXeu (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 5 Jan 2022 18:34:50 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:33190 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S245409AbiAEXet (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Jan 2022 18:34:49 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 205NYff1016203
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jan 2022 18:34:42 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D2CF915C00E1; Wed,  5 Jan 2022 18:34:41 -0500 (EST)
Date:   Wed, 5 Jan 2022 18:34:41 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     cgel.zte@gmail.com
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] ext4: Delete unused statements
Message-ID: <YdYrERUjdpiYJGAd@mit.edu>
References: <20211111091507.159465-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111091507.159465-1-luo.penghao@zte.com.cn>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Nov 11, 2021 at 09:15:07AM +0000, cgel.zte@gmail.com wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The assignment statement is at the end of the function, and
> local variables will not be used.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>

There was a more complete fix-up of this issue that has been applied
from:

https://lore.kernel.org/r/20211025221803.3326-1-nghialm78@gmail.com

					- Ted
