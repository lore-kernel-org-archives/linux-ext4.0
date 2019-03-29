Return-Path: <SRS0=q+9q=SA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE49C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 14:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370502183F
	for <linux-ext4@archiver.kernel.org>; Fri, 29 Mar 2019 14:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbfC2Osi (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 29 Mar 2019 10:48:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:46136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728848AbfC2Osi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 29 Mar 2019 10:48:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 60EF7AF74;
        Fri, 29 Mar 2019 14:48:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 6F52C1E423E; Fri, 29 Mar 2019 15:48:36 +0100 (CET)
Date:   Fri, 29 Mar 2019 15:48:36 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove incorrect comment for NEXT_ORPHAN()
Message-ID: <20190329144836.GC16759@quack2.suse.cz>
References: <20190319203818.34159-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319203818.34159-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 19-03-19 13:38:18, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The comment above NEXT_ORPHAN() was meant for ext4_encrypted_inode(),
> which was moved by commit a7550b30ab70 ("ext4 crypto: migrate into vfs's
> crypto engine") but the comment was accidentally left in place.  Since
> ext4_encrypted_inode() has now been removed, just remove the comment.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 82ffdacdc7fac..2a2e6ed9aab4f 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1592,9 +1592,6 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>  #define EXT4_SB(sb)	(sb)
>  #endif
>  
> -/*
> - * Returns true if the inode is inode is encrypted
> - */
>  #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
>  
>  /*
> -- 
> 2.21.0.225.g810b269d1ac-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
