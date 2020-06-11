Return-Path: <SRS0=jwhx=7Y=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9462AC433E1
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jun 2020 15:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4DE2075E
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Jun 2020 15:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgFKPAK (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Jun 2020 11:00:10 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:47186 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728059AbgFKPAK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Jun 2020 11:00:10 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05BEw2xl023972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Jun 2020 10:58:02 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 2ED884200DD; Thu, 11 Jun 2020 10:58:02 -0400 (EDT)
Date:   Thu, 11 Jun 2020 10:58:02 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     enwlinux@gmail.com, linux-ext4@vger.kernel.org,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] ext4: fix partial cluster initialization when splitting
 extent
Message-ID: <20200611145802.GM1347934@mit.edu>
References: <1590121124-37096-1-git-send-email-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590121124-37096-1-git-send-email-jefflexu@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, May 22, 2020 at 12:18:44PM +0800, Jeffle Xu wrote:
> Fix the bug when calculating the physical block number of the first
> block in the split extent.
> 
> This bug will cause xfstests shared/298 failure on ext4 with bigalloc
> enabled occasionally. Ext4 error messages indicate that previously freed
> blocks are being freed again, and the following fsck will fail due to
> the inconsistency of block bitmap and bg descriptor.

Applied, thanks.

	 					- Ted
