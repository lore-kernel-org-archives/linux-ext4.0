Return-Path: <SRS0=x6sY=UT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E87C43613
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 03:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A648D20B1F
	for <linux-ext4@archiver.kernel.org>; Thu, 20 Jun 2019 03:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbfFTDm3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 19 Jun 2019 23:42:29 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43817 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726419AbfFTDm3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Jun 2019 23:42:29 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5K3gHPx000943
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jun 2019 23:42:18 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 32202420484; Wed, 19 Jun 2019 23:42:17 -0400 (EDT)
Date:   Wed, 19 Jun 2019 23:42:17 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     jinshui zhang <leozhangjs@gmail.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhangjs <zachary@baishancloud.com>
Subject: Re: [PATCH] ext4: make __ext4_get_inode_loc plug
Message-ID: <20190620034217.GA15783@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        jinshui zhang <leozhangjs@gmail.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangjs <zachary@baishancloud.com>
References: <20190617155712.51339-1-leozhangjs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617155712.51339-1-leozhangjs@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 17, 2019 at 11:57:12PM +0800, jinshui zhang wrote:
> From: zhangjs <zachary@baishancloud.com>
> 
> If the task is unplugged when called, the inode_readahead_blks may not be merged, 
> these will cause small pieces of io, It should be plugged.
> 
> Signed-off-by: zhangjs <zachary@baishancloud.com>

Thanks, applied.

I cleaned up the commit description a little, and I removed some of
the extra empty lines added by the patch.

Cheers,

					- Ted
