Return-Path: <SRS0=bDK7=XG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6053FC49ED6
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Sep 2019 10:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD5420CC7
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Sep 2019 10:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfIKKzV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 11 Sep 2019 06:55:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:50900 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726724AbfIKKzV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 11 Sep 2019 06:55:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEE35AF70;
        Wed, 11 Sep 2019 10:55:19 +0000 (UTC)
Date:   Wed, 11 Sep 2019 05:55:16 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     Andres Freund <andres@anarazel.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
        jack@suse.com, hch@infradead.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Odd locking pattern introduced as part of "nowait aio support"
Message-ID: <20190911105516.l2iqes7dngj6w27o@fiona>
References: <20190910223327.mnegfoggopwqqy33@alap3.anarazel.de>
 <20190911040420.GB27547@dread.disaster.area>
 <20190911093926.pfkkx25mffzeuo32@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911093926.pfkkx25mffzeuo32@alap3.anarazel.de>
User-Agent: NeoMutt/20180716
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On  2:39 11/09, Andres Freund wrote:
> 
> Ok.  Goldwyn, do you want to write a patch, or do you want me to write
> one up?

I'll post one shortly. Thanks for bringing this up.

-- 
Goldwyn
