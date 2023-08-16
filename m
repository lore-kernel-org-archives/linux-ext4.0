Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 714A9EB64DD
	for <linux-ext4@archiver.kernel.org>; Wed, 16 Aug 2023 03:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241468AbjHPDOt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 15 Aug 2023 23:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241517AbjHPDOY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Aug 2023 23:14:24 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0C41FC8
        for <linux-ext4@vger.kernel.org>; Tue, 15 Aug 2023 20:14:23 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-114-154.bstnma.fios.verizon.net [173.48.114.154])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 37G3EDq2007378
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Aug 2023 23:14:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1692155655; bh=11fFMirtmlzyNHMunrTtQshjI+RpiVwN3aW54ZoIbqk=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=pXnlBXxejSyY2HHgnrij4xFWn6qda7dxgzggC6GDt8hz/SFBdZ7RNadwGSDvIeHja
         zdS3RSpdK3H2yAqRG6VRqcv2v8HsUc324LJ9hq8o4ViCHV4Az0ncDyJfcIg4txbQtu
         jEPw69R1i43b1zEp4ybNpEv+LaWFz7RPuc0+yeOI+77aUeOmVl5Us1YzVTe9y/ale3
         kHtgvuopOUTavQ5oFO+n6IaqcA8ZNE9tZfhHwIA4xqqMXvAPYXTWilNHS+sP0iGadr
         mIcF1PppOTwnvln/+WofxBxaQaKsMuWth0UYRj4cmBT8ArT0bOUmSl3TJqqSwtwPg9
         BvU48p1PoSz/A==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id C18E515C0292; Tue, 15 Aug 2023 23:14:13 -0400 (EDT)
Date:   Tue, 15 Aug 2023 23:14:13 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kemeng Shi <shikemeng@huaweicloud.com>
Cc:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] ext4: remove redundant check of count
Message-ID: <20230816031413.GN2247938@mit.edu>
References: <20230629120044.1261968-1-shikemeng@huaweicloud.com>
 <20230629120044.1261968-7-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230629120044.1261968-7-shikemeng@huaweicloud.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jun 29, 2023 at 08:00:37PM +0800, Kemeng Shi wrote:
> Remove zero check of count which is always non-zero.
> 
> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
