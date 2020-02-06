Return-Path: <SRS0=cg8q=32=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C6FC2D0B1
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 14:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2134720838
	for <linux-ext4@archiver.kernel.org>; Thu,  6 Feb 2020 14:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgBFOsG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Feb 2020 09:48:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:57094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbgBFOsG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 6 Feb 2020 09:48:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 39944ADFF;
        Thu,  6 Feb 2020 14:48:05 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 2AFFD1E0DEB; Thu,  6 Feb 2020 15:48:04 +0100 (CET)
Date:   Thu, 6 Feb 2020 15:48:04 +0100
From:   Jan Kara <jack@suse.cz>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, ted <tytso@mit.edu>
Subject: Re: ext4 support iopoll
Message-ID: <20200206144804.GC26114@quack2.suse.cz>
References: <e1df9ed9-763a-d3a8-0159-782a8a6d6844@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1df9ed9-763a-d3a8-0159-782a8a6d6844@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hello,

On Thu 06-02-20 21:29:15, Xiaoguang Wang wrote:
> While testing iouring in ext4, we find ext4 does not support .iopoll yet, since
> commit "ext4: introduce direct I/O write using iomap infrastructure", seems that
> ext4 can support iopoll as well, just add a ".iopoll = iomap_dio_iopoll,".
> So I wonder is there any special reason that ext4 does not have have this iopoll
> interface? Thanks.

I'm not aware of any so feel free to submit a patch :)

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
