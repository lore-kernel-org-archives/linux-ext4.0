Return-Path: <SRS0=PW1K=T6=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FF5C28CC0
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 18:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E694626057
	for <linux-ext4@archiver.kernel.org>; Thu, 30 May 2019 18:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE3S7n (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 30 May 2019 14:59:43 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41215 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726031AbfE3S7n (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 May 2019 14:59:43 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x4UIxVmT004154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 May 2019 14:59:32 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 28D9D420481; Thu, 30 May 2019 14:59:31 -0400 (EDT)
Date:   Thu, 30 May 2019 14:59:31 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v2] ext4: Gracefully handle ext4_break_layouts() failure
 during truncate
Message-ID: <20190530185931.GF2998@mit.edu>
References: <20190528080545.10444-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528080545.10444-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, May 28, 2019 at 10:05:45AM +0200, Jan Kara wrote:
> ext4_break_layouts() may fail e.g. due to a signal being delivered.
> Thus we need to handle its failure gracefully and not by taking the
> filesystem down. Currently ext4_break_layouts() failure is rare but it
> may become more common once RDMA uses layout leases for handling
> long-term page pins for DAX mappings.
> 
> To handle the failure we need to move ext4_break_layouts() earlier
> during setattr handling before we do hard to undo changes such as
> modifying inode size. To be able to do that we also have to move some
> other checks which are better done without holding i_mmap_sem earlier.
> 
> Reported-and-tested-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks!

					- Ted
