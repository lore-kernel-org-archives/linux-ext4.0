Return-Path: <SRS0=y8r3=S3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CEFC43218
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 17:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB7A206BF
	for <linux-ext4@archiver.kernel.org>; Thu, 25 Apr 2019 17:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfDYRYA (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 25 Apr 2019 13:24:00 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:42433 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726884AbfDYRYA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2019 13:24:00 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3PHNlbf009542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Apr 2019 13:23:48 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6D9DC420EEC; Thu, 25 Apr 2019 13:23:47 -0400 (EDT)
Date:   Thu, 25 Apr 2019 13:23:47 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kirill Tkhai <ktkhai@virtuozzo.com>
Cc:     jack@suse.cz, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Actually request zeroing of inode table after grow
Message-ID: <20190425172347.GD4739@mit.edu>
References: <155592139208.19009.5887870564232862529.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155592139208.19009.5887870564232862529.stgit@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Apr 22, 2019 at 11:23:20AM +0300, Kirill Tkhai wrote:
> It is never possible, that number of block groups decreases,
> since only online grow is supported.
> 
> But after a growing occured, we have to zero inode tables
> for just created new block groups.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied, thanks.

				- Ted
