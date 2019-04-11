Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8A0C282CE
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 02:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A22B20818
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 02:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfDKCZR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:25:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47258 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDKCZR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Apr 2019 22:25:17 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hEPOt-0002JD-BR; Thu, 11 Apr 2019 02:25:15 +0000
Date:   Thu, 11 Apr 2019 03:25:15 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 1/2] vfs: use READ_ONCE() to access ->i_link
Message-ID: <20190411022514.GC2217@ZenIV.linux.org.uk>
References: <20190410202115.64501-1-ebiggers@kernel.org>
 <20190410202115.64501-2-ebiggers@kernel.org>
 <20190410210657.GA2217@ZenIV.linux.org.uk>
 <20190410231547.GC120258@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410231547.GC120258@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 04:15:48PM -0700, Eric Biggers wrote:
> On Wed, Apr 10, 2019 at 10:06:57PM +0100, Al Viro wrote:
> > On Wed, Apr 10, 2019 at 01:21:14PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Use 'READ_ONCE(inode->i_link)' to explicitly support filesystems caching
> > > the symlink target in ->i_link later if it was unavailable at iget()
> > > time, or wasn't easily available.  I'll be doing this in fscrypt, to
> > > improve the performance of encrypted symlinks on ext4, f2fs, and ubifs.
> > > 
> > > ->i_link will start NULL and may later be set to a non-NULL value by a
> > > smp_store_release() or cmpxchg_release().  READ_ONCE() is needed on the
> > > read side.  smp_load_acquire() is unnecessary because only a data
> > > dependency barrier is required.  (Thanks to Al for pointing this out.)
> > 
> > You've missed vfs_readlink()...
> 
> How so?  The patch already updates vfs_readlink().

Huh?  Right you are - fsck knows how have I managed to misread that...
Anyway, I can pick that READ_ONCE() patch through vfs.git if you wish,
or it can go through your tree with my Acked-by - up to you...
