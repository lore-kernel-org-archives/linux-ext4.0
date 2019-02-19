Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78C1C10F00
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 04:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8863E21900
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 04:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfBSE2X (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 18 Feb 2019 23:28:23 -0500
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:64413 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbfBSE2X (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 18 Feb 2019 23:28:23 -0500
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail01.adl2.internode.on.net with ESMTP; 19 Feb 2019 14:58:19 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gvx11-0004Qa-1P; Tue, 19 Feb 2019 15:28:19 +1100
Date:   Tue, 19 Feb 2019 15:28:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Adam Borowski <kilobyte@angband.pl>,
        Boaz Harrosh <openosd@gmail.com>,
        Omar Sandoval <osandov@osandov.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
Message-ID: <20190219042818.GH14116@dastard>
References: <cover.1550136164.git.osandov@fb.com>
 <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com>
 <20190217175450.psaesabv3vlzvjv4@angband.pl>
 <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
 <20190219040447.GX12668@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190219040447.GX12668@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Feb 18, 2019 at 08:04:47PM -0800, Matthew Wilcox wrote:
> On Sun, Feb 17, 2019 at 12:40:09PM -0800, Andy Lutomirski wrote:
> > So I'm highly in favor of this patch.  If XFS wants to disallow
> > writing the birth time, fine, but I think that behavior should be
> > overridable.
> 
> Please, no.  We need to have consistent behaviour between at least
> Linux local filesystems.  Not "Chris thinks this is a good idea,
> while Dave and Ted think its a bad idea, so btrfs supports it and
> XFS and ext4 disallow it".

And, quite frankly, this is the entire reason xattrs exist. i.e.
so that generic file attributes can be stored persitently without
each individual having to support them in their on-disk format.

I wish people would stop trying to implement stuff like this in
filesystem code and instead added it to the VFS and stored it in VFS
defined system xattrs so that it is common across all filesystems.
It also means that backup applications can preserve them during file
copies without really even being aware of their meaning, simply by
copying all the xattrs on the file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
