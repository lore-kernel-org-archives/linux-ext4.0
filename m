Return-Path: <SRS0=n1bC=44=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7973C18E5A
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Mar 2020 12:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99CB82146E
	for <linux-ext4@archiver.kernel.org>; Wed, 11 Mar 2020 12:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgCKM6D (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 11 Mar 2020 08:58:03 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:40659 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729331AbgCKM6C (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2020 08:58:02 -0400
Received: from callcc.thunk.org (pool-72-93-95-157.bstnma.fios.verizon.net [72.93.95.157])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 02BCvnk4017660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Mar 2020 08:57:49 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 3D70A42045B; Wed, 11 Mar 2020 08:57:49 -0400 (EDT)
Date:   Wed, 11 Mar 2020 08:57:49 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] writeback: avoid double-writing the inode on a lazytime
 expiration
Message-ID: <20200311125749.GA7159@mit.edu>
References: <20200306004555.GB225345@gmail.com>
 <20200307020043.60118-1-tytso@mit.edu>
 <20200311032009.GC46757@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311032009.GC46757@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Mar 10, 2020 at 08:20:09PM -0700, Eric Biggers wrote:
> Thanks Ted!  This fixes the fscrypt test failure.
> 
> However, are you sure this works correctly on all filesystems?  I'm not sure
> about XFS.  XFS only implements ->dirty_inode(), not ->write_inode(), and in its
> ->dirty_inode() it does:
  ...
> 		if (flag != I_DIRTY_SYNC || !(inode->i_state & I_DIRTY_TIME))
> 			return;

That's true, but when the timestamps were originally modified,
dirty_inode() will be called with flag == I_DIRTY_TIME, which will
*not* be a no-op; which is to say, XFS will force the timestamps to be
updated on disk when the timestamps are first dirtied, because it
doesn't support I_DIRTY_TIME.

So I think we're fine.

					- Ted
