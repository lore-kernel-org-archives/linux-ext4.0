Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C652BC433DB
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC1D2368A
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Jan 2021 03:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbhANDdp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 13 Jan 2021 22:33:45 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36411 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726469AbhANDdo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2021 22:33:44 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 10E3WpCu017056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jan 2021 22:32:51 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 16F3D15C3453; Wed, 13 Jan 2021 22:32:51 -0500 (EST)
Date:   Wed, 13 Jan 2021 22:32:51 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Yi Li <yili@winhong.com>, yilikernel@gmail.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use IS_ERR instead of IS_ERR_OR_NULL and set inode null
 when IS_ERR.
Message-ID: <X/+7Y5Cuj0IfKedA@mit.edu>
References: <20201230033827.3996064-1-yili@winhong.com>
 <20210106130211.GB29271@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106130211.GB29271@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Jan 06, 2021 at 02:02:11PM +0100, Jan Kara wrote:
> On Wed 30-12-20 11:38:27, Yi Li wrote:
> > 1: ext4_iget/ext4_find_extent never returns NULL, use IS_ERR
> > instead of IS_ERR_OR_NULL to fix this.
> > 
> > 2: ext4_fc_replay_inode should set the inode to NULL when IS_ERR.
> > and go to call iput properly.
> > 
> > Signed-off-by: Yi Li <yili@winhong.com>
> 
> Thanks for the patch! It looks good to me. You can add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
