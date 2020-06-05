Return-Path: <SRS0=5ES6=7S=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C92C433DF
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Jun 2020 15:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BC992074B
	for <linux-ext4@archiver.kernel.org>; Fri,  5 Jun 2020 15:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgFEP0M (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:26:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:60732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgFEP0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 5 Jun 2020 11:26:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 41675AC6C;
        Fri,  5 Jun 2020 15:26:14 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 79F081E1281; Fri,  5 Jun 2020 17:26:10 +0200 (CEST)
Date:   Fri, 5 Jun 2020 17:26:10 +0200
From:   Jan Kara <jack@suse.cz>
To:     cgxu <cgxu519@mykernel.net>
Cc:     jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [RFC PATCH] ext2: drop cached block when detecting corruption
Message-ID: <20200605152610.GF13248@quack2.suse.cz>
References: <20200603094417.6143-1-cgxu519@mykernel.net>
 <398a6fd8-37ee-c323-b606-c8679067e540@mykernel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <398a6fd8-37ee-c323-b606-c8679067e540@mykernel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu 04-06-20 14:26:49, cgxu wrote:
> On 6/3/20 5:44 PM, Chengguang Xu wrote:
> > Currently ext2 uses mdcache for deduplication of extended
> > attribution blocks. However, there is lack of handling for
> > corrupted blocks, so newly created EAs may still links to
> > corrupted blocks. This patch tries to drop cached block
> > when detecting corruption to mitigate the effect.
> 
> ext2_xattr_cmp() will carefully check every entry in the block,
> so there is no chance to link to corrupted block, maybe we can
> improve the speed of cache related operations by dropping
> corrupted blocks.

Thanks for the back but as you write, I don't see the point of your patch
because corrupted blocks shouldn't get to mbcache in the first place (and
we check block consistency only when loading block from disk, not from
mbcache). And performance in case of corrupted xattr block doesn't really
matter much so I don't want to complicate the code for that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
