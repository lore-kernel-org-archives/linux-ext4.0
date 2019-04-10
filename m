Return-Path: <SRS0=PpJq=SM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7CEC10F0E
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F7F20874
	for <linux-ext4@archiver.kernel.org>; Wed, 10 Apr 2019 01:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfDJBjg (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 21:39:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56640 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfDJBjg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2019 21:39:36 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hE2D8-0003U6-Ht; Wed, 10 Apr 2019 01:39:34 +0000
Date:   Wed, 10 Apr 2019 02:39:34 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Message-ID: <20190410013934.GV2217@ZenIV.linux.org.uk>
References: <20190409233544.156665-1-ebiggers@kernel.org>
 <20190410003346.GT2217@ZenIV.linux.org.uk>
 <20190410004553.GA2454@sol.localdomain>
 <20190410010425.GU2217@ZenIV.linux.org.uk>
 <20190410012247.GB2454@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410012247.GB2454@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 09, 2019 at 06:22:49PM -0700, Eric Biggers wrote:

> > Non-NULL ->get_link() => DCACHE_SYMLINK_TYPE in ->d_flags =>
> > d_is_symlink() true => step_into() progresses to pick_link().
> > 
> > IOW, non-NULL ->get_link() is what tells you that we have
> > a symlink there.
> 
> I think that's pretty unintuitive.  The fact that multiple filesystems including
> ext4 set ->i_link on fast symlinks, then set ->get_link() to a function that
> returns ->i_link, made me assume that's the mechanism by which such symlink
> targets are returned to the VFS.  When in fact fs/namei.c just uses ->i_link,
> and never calls ->get_link().
> 
> Is there any reason why d_flags_for_inode() doesn't check S_ISLNK() instead, and
> then fs/namei.c would call ->get_link() if non-NULL, otherwise use ->i_link?

Extra check and dereference on hot path with no visible benefits of doing it
that way, for starters.  Really, what _is_ the benefit of pessimizing that?  
Most of the symlinks we run into will have ->i_link set; checking ->i_op->get_link
first is extra work for no good reason...

What's more, ->get_link is visible in inode_operations; ->i_link (let alone ->i_mode)
isn't.  As it is, we can easily tell symlink inode_operations from everything else
on the source level.  With your scheme we won't.
