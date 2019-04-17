Return-Path: <SRS0=kK5Q=ST=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7BBC282DD
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 16:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3F32173C
	for <linux-ext4@archiver.kernel.org>; Wed, 17 Apr 2019 16:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbfDQQlz (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 17 Apr 2019 12:41:55 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48102 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730463AbfDQQlz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2019 12:41:55 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3HGfbC6004544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Apr 2019 12:41:38 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 6913B420497; Wed, 17 Apr 2019 12:41:37 -0400 (EDT)
Date:   Wed, 17 Apr 2019 12:41:37 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 1/2] vfs: use READ_ONCE() to access ->i_link
Message-ID: <20190417164137.GH4686@mit.edu>
References: <20190410202115.64501-1-ebiggers@kernel.org>
 <20190410202115.64501-2-ebiggers@kernel.org>
 <20190410210657.GA2217@ZenIV.linux.org.uk>
 <20190410231547.GC120258@gmail.com>
 <20190411022514.GC2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411022514.GC2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 11, 2019 at 03:25:15AM +0100, Al Viro wrote:
> On Wed, Apr 10, 2019 at 04:15:48PM -0700, Eric Biggers wrote:
> > On Wed, Apr 10, 2019 at 10:06:57PM +0100, Al Viro wrote:
> > > On Wed, Apr 10, 2019 at 01:21:14PM -0700, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > > 
> > > > Use 'READ_ONCE(inode->i_link)' to explicitly support filesystems caching
> > > > the symlink target in ->i_link later if it was unavailable at iget()
> > > > time, or wasn't easily available.  I'll be doing this in fscrypt, to
> > > > improve the performance of encrypted symlinks on ext4, f2fs, and ubifs.
> > > > 
> > > > ->i_link will start NULL and may later be set to a non-NULL value by a
> > > > smp_store_release() or cmpxchg_release().  READ_ONCE() is needed on the
> > > > read side.  smp_load_acquire() is unnecessary because only a data
> > > > dependency barrier is required.  (Thanks to Al for pointing this out.)
> > > 
> > > You've missed vfs_readlink()...
> > 
> > How so?  The patch already updates vfs_readlink().
> 
> Huh?  Right you are - fsck knows how have I managed to misread that...
> Anyway, I can pick that READ_ONCE() patch through vfs.git if you wish,
> or it can go through your tree with my Acked-by - up to you...

Al, I'll take it through the fscrypt tree with your Acked-by, if you
don't mind.

					- Ted
