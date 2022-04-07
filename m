Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FCBC433F5
	for <linux-ext4@archiver.kernel.org>; Thu,  7 Apr 2022 15:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244411AbiDGPDz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 7 Apr 2022 11:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiDGPDy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Apr 2022 11:03:54 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06DF270E;
        Thu,  7 Apr 2022 08:01:53 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 237F1h7G022667
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 7 Apr 2022 11:01:43 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 3466715C3EE7; Thu,  7 Apr 2022 11:01:43 -0400 (EDT)
Date:   Thu, 7 Apr 2022 11:01:43 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     cgel.zte@gmail.com
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] ext4: remove redundant judgment
Message-ID: <Yk7819rrn4MZlGog@mit.edu>
References: <20220406090501.2488853-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406090501.2488853-1-lv.ruyi@zte.com.cn>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 06, 2022 at 09:05:01AM +0000, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> iput() has already handled null and non-null parameter. so there is no
> need to use if().
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>

I'd use the word "conditional" instead of "judgment", so I'd suggest rewording it as:

>ext4: remove unnecessary conditional
>
>
>iput() already tests to see if it is called with a NULL argument, so
>there is no need to check if the inode is NULL before calling iput().

I've noticed that you've submitted this for other subsystems, so I'd
thought I'd mention it before just applying the patch and quietly
adjusting the commit description for clarity.

					- Ted
