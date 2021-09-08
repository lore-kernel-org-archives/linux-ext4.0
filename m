Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E651CC433F5
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Sep 2021 06:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C513561158
	for <linux-ext4@archiver.kernel.org>; Wed,  8 Sep 2021 06:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347594AbhIHGUU (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 8 Sep 2021 02:20:20 -0400
Received: from verein.lst.de ([213.95.11.211]:38065 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236202AbhIHGUT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 8 Sep 2021 02:20:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2D17367373; Wed,  8 Sep 2021 08:19:10 +0200 (CEST)
Date:   Wed, 8 Sep 2021 08:19:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/11] unicode: pass a UNICODE_AGE() tripple to
 utf8_load
Message-ID: <20210908061909.GA28651@lst.de>
References: <20210818140651.17181-1-hch@lst.de> <20210818140651.17181-6-hch@lst.de> <87h7exfj31.fsf@collabora.com> <87a6kpfiyv.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6kpfiyv.fsf@collabora.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Sep 06, 2021 at 06:16:24PM -0400, Gabriel Krisman Bertazi wrote:
> > ext4_msg("... %u.%u.%u\n", (encoding_info->version>>12) & 0xff,
> > 	 (encoding_info->version>>8) & 0xff), encoding_info->version & 0xff))

I'd rather not open code these shifts and add helpers for them.

> > The rest of the series looks good and I can pick it up for 5.15, unless
> > someone has anything else to say?  It has lived on the list for a while
> > now.
> >
> 
> Ugh, pressed reply too quickly.  Sorry for the multiple email reply.
> 
> In the summary line: tripple -> triple.

Let me resend with the above change.
