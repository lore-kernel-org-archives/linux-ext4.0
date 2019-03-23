Return-Path: <SRS0=oERZ=R2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0515C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 15:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFC0206BA
	for <linux-ext4@archiver.kernel.org>; Sat, 23 Mar 2019 15:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfCWP7P (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 23 Mar 2019 11:59:15 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:49442 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726118AbfCWP7P (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2019 11:59:15 -0400
Received: from callcc.thunk.org ([70.42.157.31])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2NFwwNa025011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 23 Mar 2019 11:59:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 18818421A01; Sat, 23 Mar 2019 11:58:51 -0400 (EDT)
Date:   Sat, 23 Mar 2019 11:58:50 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     "zhangyi (F)" <yi.zhang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, jack@suse.cz, adilger.kernel@dilger.ca,
        miaoxie@huawei.com
Subject: Re: [PATCH v2 2/2] ext4: cleanup bh release code in
 ext4_ind_remove_space()
Message-ID: <20190323155850.GD5675@mit.edu>
References: <1552633813-42832-1-git-send-email-yi.zhang@huawei.com>
 <1552633813-42832-3-git-send-email-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552633813-42832-3-git-send-email-yi.zhang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Mar 15, 2019 at 03:10:13PM +0800, zhangyi (F) wrote:
> Currently, we are releasing the indirect buffer where we are done with
> it in ext4_ind_remove_space(), so we can see the brelse() and
> BUFFER_TRACE() everywhere. It seems fragile and hard to read, and we
> may probably forget to release the buffer some day. This patch do some
> cleanup stuff, put all the releasing code together to the end of this
> function.
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Thanks, applied.

					- Ted
