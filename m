Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D37C433E0
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Jan 2021 07:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795E123123
	for <linux-ext4@archiver.kernel.org>; Wed, 13 Jan 2021 07:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAMHHs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Jan 2021 02:07:48 -0500
Received: from verein.lst.de ([213.95.11.211]:58743 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbhAMHHs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Jan 2021 02:07:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 60C2267373; Wed, 13 Jan 2021 08:07:05 +0100 (CET)
Date:   Wed, 13 Jan 2021 08:07:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 11/11] ext4: simplify i_state checks in
 __ext4_update_other_inode_time()
Message-ID: <20210113070705.GA13551@lst.de>
References: <20210112190253.64307-1-ebiggers@kernel.org> <20210112190253.64307-12-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112190253.64307-12-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
