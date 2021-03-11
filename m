Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77C4C433DB
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Mar 2021 15:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 700F364ECD
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Mar 2021 15:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhCKPr5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:47:57 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:52062 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234169AbhCKPrw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Mar 2021 10:47:52 -0500
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 12BFleC0005955
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 10:47:40 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1197E15C3AA0; Thu, 11 Mar 2021 10:47:40 -0500 (EST)
Date:   Thu, 11 Mar 2021 10:47:40 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: [PATCH] ext4: do not try to set xattr into ea_inode if value is
 empty
Message-ID: <YEo7nEuVpqLmIeLz@mit.edu>
References: <20210305120508.298465-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305120508.298465-1-yi.zhang@huawei.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 05, 2021 at 08:05:08PM +0800, zhangyi (F) wrote:
> Syzbot report a warning that ext4 may create an empty ea_inode if set
> an empty extent attribute to a file on the file system which is no free
> blocks left.

I'll apply this, but can you tell us which syzbot warning this
addresses so we can mark the commit appropriately?

Many thanks!!

					- Ted
