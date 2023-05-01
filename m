Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486A2C77B73
	for <linux-ext4@archiver.kernel.org>; Mon,  1 May 2023 17:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjEARl4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 1 May 2023 13:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjEARlz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 1 May 2023 13:41:55 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB560CD
        for <linux-ext4@vger.kernel.org>; Mon,  1 May 2023 10:41:53 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 341Hf6LN027263
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 1 May 2023 13:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1682962870; bh=F8mPLUpzYq9FXgfU34ODx2TFLG9oNO4BkBYe2At5wkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=GnZW1wJD0mD2WeDyoPYk023ADE1084KwPEBM2KXMnqNoBfYuTGPdZ+IPHCjyLVOeg
         MjWE7XxSbKO2zs3o5/he668LFkxDhDXd/rpnYwkqioRpGAFFO0m5a6+rf0fyTqxFpz
         YepMa6EQE1GU2pHpIgHCsd8mJTB0XG7pDsfQMIHAxR/y2rdWkQPNgLZLAdPiT3dd50
         uQzm3zZFMjgtmRgkcomQXGcRrVHUEGE6/ae6tzAVD+Lz15HxuLpHbFJhzItMMUUH48
         lTNoSfhv430XyLE/Msccscv7gnGuNK+2R9CXt6/KYtyu8zd6j0yrZrwic8xuxRisDa
         7Y5sA6gebqHCQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 5EC0715C02E2; Mon,  1 May 2023 13:41:06 -0400 (EDT)
Date:   Mon, 1 May 2023 13:41:06 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     adilger.kernel@dilger.ca, jack@suse.cz, lczerner@redhat.com,
        linux-ext4@vger.kernel.org, ritesh.list@gmail.com,
        yanaijie@huawei.com, kernel-team@cloudflare.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] ext4: unbreak build with CONFIG_QUOTA=n
Message-ID: <20230501174106.GA603086@mit.edu>
References: <20230501132619.161735-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501132619.161735-1-jakub@cloudflare.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, May 01, 2023 at 03:26:19PM +0200, Jakub Sitnicki wrote:
> Commit dcbf87589d90 ("ext4: factor out ext4_flex_groups_free()") made some
> loop count variables unused when CONFIG_QUOTA is unset.
> 
> Make the unused counters local to the loop scope to fix the build.
> 
> Fixes: dcbf87589d90 ("ext4: factor out ext4_flex_groups_free()")
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202303240449.6Cg6YXJO-lkp@intel.com/
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Thanks, pull request which includes a fix for this problem has already
been sent out to Linus.

						- Ted
