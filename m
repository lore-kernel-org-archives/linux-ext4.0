Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E48EB64DD
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Aug 2023 03:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbjHPDXc (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Aug 2023 23:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241598AbjHPDXa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Aug 2023 23:23:30 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E026E94
        for <linux-ext4@vger.kernel.org>; Tue, 15 Aug 2023 20:23:28 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-114-154.bstnma.fios.verizon.net [173.48.114.154])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 37G3NILY011068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 23:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1692156200; bh=LHBU+C50HbcjO5gX9YU6kdFHCs/ZCwk5dQLSRBu/HPg=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=kP2t128Ba7/yENhO7HfiKbCgK3Rf3BjqKO5LgJJFfvc0QHFzesH1ywQRda/AzMdAm
         0bZyN/sbKX0uEZyzO8iDvlz+AoXrmM87vkTiW+uA/oAhPgK4m5BQhFfIjvHdUFdUwe
         BbdUdRhZ6m13kXkyrL4G3YQBgAuHwYo8diuWHHhcYgV6uvaTgRfU5lAea1U28B8/6w
         I+5PNdkSf3/lWToN2MW29xTAIlqn+SjDTe20ZkEADyJ2Eq7882b3DPLwDMTKGqwk95
         JMOFMt9SS3vtC4w7/cqPdFomM8g3p5NjYt76sxKFH06H/TCApon6NjzAHsF6EVW7YS
         igP/LtsOWyT0g==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C3C0D15C0292; Tue, 15 Aug 2023 23:23:18 -0400 (EDT)
Date:   Tue, 15 Aug 2023 23:23:18 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kemeng Shi <shikemeng@huaweicloud.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] ext4: remove EXT4FS_DEBUG defination in resize.c
Message-ID: <20230816032318.GQ2247938@mit.edu>
References: <20230629120044.1261968-1-shikemeng@huaweicloud.com>
 <20230629120044.1261968-10-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629120044.1261968-10-shikemeng@huaweicloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 29, 2023 at 08:00:40PM +0800, Kemeng Shi wrote:
> Remove EXT4FS_DEBUG defination in resize.c for following reasons:
> 1. EXT4FS_DEBUG will enable debug messages, it should only be defined
> when debugging.
> 2. ext4.h included from ext4_jbd2.h after EXT4FS_DEBUG defination will
> "#undef EXT4FS_DEBUG", then EXT4FS_DEBUG defination in resize.c can't
> actually turn on ext4_debug messages.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
