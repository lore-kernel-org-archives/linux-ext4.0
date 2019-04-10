Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458BDC10F11
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 23:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0974C217D9
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554938152;
	bh=1gxdAOnNojCmWwSJ0r0v7Nz8pxGPPrn4uqvTyWoyzj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=c3cY20XNk8zb+/AVnCyEDlAhH+1DSnh64+Ro6pAOIBt6fNAmH/vNI7lXh/vC3EBK2
	 +B6Kqo/uJgY0ZhlGMWbFjsOZGb3ZR9TH2VCVZS/5qtVyg3NUJ7UqLhEpwA2B0b4I+k
	 UaIx/4SsFF8T1ydCRljR/CVkXD0ZVE0/5FGrs2Sc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfDJXPv (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 10 Apr 2019 19:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfDJXPu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 Apr 2019 19:15:50 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E03D20820;
        Wed, 10 Apr 2019 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554938149;
        bh=1gxdAOnNojCmWwSJ0r0v7Nz8pxGPPrn4uqvTyWoyzj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OxyQkFX684C7eZmJwptSahUQ6Wbb6ZK4wZtvbcsutr0tFJjQ/W8lk55uWFGIghziA
         C8nWLHF5D1l4fg/KzPfKa/PAFmoGv/Mmp3WmNrsh7YmxX7JuXi0IK40U5AUltPI0oR
         8+A435xGUwMS1PsigLo/PgxVTeG454qdYDNzEVhk=
Date:   Wed, 10 Apr 2019 16:15:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v2 1/2] vfs: use READ_ONCE() to access ->i_link
Message-ID: <20190410231547.GC120258@gmail.com>
References: <20190410202115.64501-1-ebiggers@kernel.org>
 <20190410202115.64501-2-ebiggers@kernel.org>
 <20190410210657.GA2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410210657.GA2217@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 10, 2019 at 10:06:57PM +0100, Al Viro wrote:
> On Wed, Apr 10, 2019 at 01:21:14PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Use 'READ_ONCE(inode->i_link)' to explicitly support filesystems caching
> > the symlink target in ->i_link later if it was unavailable at iget()
> > time, or wasn't easily available.  I'll be doing this in fscrypt, to
> > improve the performance of encrypted symlinks on ext4, f2fs, and ubifs.
> > 
> > ->i_link will start NULL and may later be set to a non-NULL value by a
> > smp_store_release() or cmpxchg_release().  READ_ONCE() is needed on the
> > read side.  smp_load_acquire() is unnecessary because only a data
> > dependency barrier is required.  (Thanks to Al for pointing this out.)
> 
> You've missed vfs_readlink()...

How so?  The patch already updates vfs_readlink().

- Eric
