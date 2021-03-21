Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71589C433E0
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A5AB61943
	for <linux-ext4@archiver.kernel.org>; Sun, 21 Mar 2021 04:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhCUE0k (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 21 Mar 2021 00:26:40 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40878 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229556AbhCUE02 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Mar 2021 00:26:28 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12L4Q8Qq005834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 00:26:09 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id B20E015C39CA; Sun, 21 Mar 2021 00:26:08 -0400 (EDT)
Date:   Sun, 21 Mar 2021 00:26:08 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     Shijie Luo <luoshijie1@huawei.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix potential error in ext4_do_update_inode
Message-ID: <YFbK4JU5k1zAcA2f@mit.edu>
References: <20210312065051.36314-1-luoshijie1@huawei.com>
 <20210312125055.GB31816@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312125055.GB31816@quack2.suse.cz>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 12, 2021 at 01:50:55PM +0100, Jan Kara wrote:
> On Fri 12-03-21 01:50:51, Shijie Luo wrote:
> > If set_large_file = 1 and errors occur in ext4_handle_dirty_metadata(),
> > the error code will be overridden, go to out_brelse to avoid this
> > situation.
> > 
> > Signed-off-by: Shijie Luo <luoshijie1@huawei.com>
> 
> Yeah, looks good. Once ext4_handle_dirty_metadata() fails, the journal is
> aborted anyway so we are unlikely to do anything useful with the
> filesystem. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks, applied.

					- Ted
