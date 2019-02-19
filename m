Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913EFC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 04:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55BAE217D7
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 04:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h3Fa/xw6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbfBSEEv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 23:04:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfBSEEv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2019 23:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yStBRN7uCRG6HFsxTqm08lH/ntiOfVcyQb3tXzbow14=; b=h3Fa/xw6RRAakQWjSDAtXpJ13
        GSZMbORvEJsWCmWhwS4tmGmeC8RqgljxHFKdQSdfAbsONErgYRxAo2zZNOP+LVP+heA4Ufq4WGlvy
        wGVjuNOO1Wvj4Wizh1nN3YSDZnQzzfbNxeQd8U5onVptm5vXTBxAvjdMsiu0nMXnzj5Ebt7c578BI
        GUerkZwnhJ/XumzTLq6dBp/ChubBlq+rdqhK+An1vDPqLfxSzQ8wd2h9c8TEraLAR76lcNvv/DMnn
        Bpslca+GysOi1lVhL+9Ve5iYxGqOLf2B2roCzw57dbFXBYo85NcnHXj+vhJbNk/k8iUFo3F8A2CU4
        1KIZ9FLMw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvweF-000343-Ld; Tue, 19 Feb 2019 04:04:47 +0000
Date:   Mon, 18 Feb 2019 20:04:47 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Boaz Harrosh <openosd@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Omar Sandoval <osandov@osandov.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190219040447.GX12668@bombadil.infradead.org>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
 <20190217175450.psaesabv3vlzvjv4@angband.pl>
 <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 17, 2019 at 12:40:09PM -0800, Andy Lutomirski wrote:
> So I'm highly in favor of this patch.  If XFS wants to disallow
> writing the birth time, fine, but I think that behavior should be
> overridable.

Please, no.  We need to have consistent behaviour between at least
Linux local filesystems.  Not "Chris thinks this is a good idea,
while Dave and Ted think its a bad idea, so btrfs supports it and
XFS and ext4 disallow it".
