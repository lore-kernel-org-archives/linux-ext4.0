Return-Path: <SRS0=++eR=3F=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAA2C33CB1
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 12:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE057206E6
	for <linux-ext4@archiver.kernel.org>; Thu, 16 Jan 2020 12:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgAPMh0 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 16 Jan 2020 07:37:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:40248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgAPMh0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 16 Jan 2020 07:37:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7A034AE2A;
        Thu, 16 Jan 2020 12:37:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0A92B1E06F1; Thu, 16 Jan 2020 13:37:24 +0100 (CET)
Date:   Thu, 16 Jan 2020 13:37:24 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Naoto Kobayashi <naoto.kobayashi4c@gmail.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ext4: Rename ext4_kvmalloc() to
 ext4_kvmalloc_nofs() and drop its flags argument
Message-ID: <20200116123724.GD8446@quack2.suse.cz>
References: <20191227080523.31808-1-naoto.kobayashi4c@gmail.com>
 <20191227080523.31808-3-naoto.kobayashi4c@gmail.com>
 <20200113223237.GL76141@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113223237.GL76141@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon 13-01-20 17:32:37, Theodore Y. Ts'o wrote:
> On Fri, Dec 27, 2019 at 05:05:22PM +0900, Naoto Kobayashi wrote:
> > Rename ext4_kvmalloc() to ext4_kvmalloc_nofs() and drop
> > its flags argument, because ext4_kvmalloc() callers must be
> > under GFP_NOFS (otherwise, they should use generic kvmalloc()
> > helper function).
> > 
> > Signed-off-by: Naoto Kobayashi <naoto.kobayashi4c@gmail.com>
> 
> Thanks, applied.

Ted, I don't think this patch is needed at all - see my email [1]. Sadly
Naoto didn't reply to my question whether he really saw any deadlock /
lockdep splat or whether it was just a theoretical concern he had...

								Honza

[1] https://lore.kernel.org/linux-ext4/20200109100007.GC27035@quack2.suse.cz

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
