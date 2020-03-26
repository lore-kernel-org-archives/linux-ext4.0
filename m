Return-Path: <SRS0=QBe5=5L=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED29C43331
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Mar 2020 14:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3A6E2073E
	for <linux-ext4@archiver.kernel.org>; Thu, 26 Mar 2020 14:27:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgCZO1f (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:27:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:45394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgCZO1f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 26 Mar 2020 10:27:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 862CFAE38;
        Thu, 26 Mar 2020 14:27:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 157CC1E10FD; Thu, 26 Mar 2020 15:27:34 +0100 (CET)
Date:   Thu, 26 Mar 2020 15:27:34 +0100
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 7/7] tune2fs: Update dir checksums when clearing
 dir_index feature
Message-ID: <20200326142734.GA16506@quack2.suse.cz>
References: <20200213101602.29096-1-jack@suse.cz>
 <20200213101602.29096-8-jack@suse.cz>
 <20200315171520.GT225435@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315171520.GT225435@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun 15-03-20 13:15:20, Theodore Y. Ts'o wrote:
> On Thu, Feb 13, 2020 at 11:16:02AM +0100, Jan Kara wrote:
> > When clearing dir_index feature while metadata_csum is enabled, we have
> > to rewrite checksums of all indexed directories to update checksums of
> > internal tree nodes.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Thanks, applied.

Hum, I'm still not seeing this series in e2fsprogs git. Did it get stuck
somewhere?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
