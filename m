Return-Path: <SRS0=j74E=DN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB423C41604
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Oct 2020 10:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE9620757
	for <linux-ext4@archiver.kernel.org>; Tue,  6 Oct 2020 10:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJFKd2 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:33:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:57004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKd2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Oct 2020 06:33:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E45A0AED8;
        Tue,  6 Oct 2020 10:33:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 5342F1E1305; Tue,  6 Oct 2020 12:33:26 +0200 (CEST)
Date:   Tue, 6 Oct 2020 12:33:26 +0200
From:   Jan Kara <jack@suse.cz>
To:     =?utf-8?B?5bi45Yek5qWg?= <changfengnan@qq.com>
Cc:     tytso <tytso@mit.edu>, jack <jack@suse.com>,
        adilger <adilger@dilger.ca>,
        "darrick.wong" <darrick.wong@oracle.com>,
        Fengnan Chang <changfengnan@hikvision.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH v2] jbd2: avoid transaction reuse after reformatting
Message-ID: <20201006103326.GA6984@quack2.suse.cz>
References: <tencent_84E12D61F93979D8E588E980751B80B40B08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_84E12D61F93979D8E588E980751B80B40B08@qq.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sat 03-10-20 14:30:24, 常凤楠 wrote:
> When format ext4 with lazy_journal_init=1, the previous transaction is still on disk,
> it is possible that the previous transaction will be used again during jbd2 recovery.
> Because the seed is changed, the CRC check will fail.
> 
> Signed-off-by: Fengnan Chang <changfengnan@hikvision.com&gt;

I've submitted v3 of the patch [1] which should not be mangled as this one...

								Honza

[1] https://lore.kernel.org/linux-ext4/20201006103154.7130-1-jack@suse.cz

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
