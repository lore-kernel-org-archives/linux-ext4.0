Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F148C6FD1D
	for <linux-ext4@archiver.kernel.org>; Tue, 21 Mar 2023 14:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCUOIe (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 21 Mar 2023 10:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCUOId (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2023 10:08:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBBEFF19;
        Tue, 21 Mar 2023 07:08:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7524C200F3;
        Tue, 21 Mar 2023 14:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679407709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hgrs5y/VT6hs8tD8O+b0+N8lxESgNGz+bZqlsP/eYdY=;
        b=kRYbpSlJ4pyRc3CR2IHW95PvKXmJU4aod4jop8LU47EaMiucFXqciubn19PvNNezl7rL6d
        4Hs+phZL2D4Qc5PZ8VS8wxCi8TICZqz7REmiOAd5bI+uKcdzv/C+x/lQny2iCW6CZpbMok
        7eNxWaOjvB6wIoRLGNryTyXjZ0U0U5c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679407709;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hgrs5y/VT6hs8tD8O+b0+N8lxESgNGz+bZqlsP/eYdY=;
        b=RyfmP/oXoleLf0eBNhRV/1ISQ3cD7VnsYSkbwhWGLWOqksZC24+lMtuvORLoKe/5pZmeUR
        CH0qgdQuLFXZ/TAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B4A013451;
        Tue, 21 Mar 2023 14:08:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4GtAFl26GWSuJwAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 21 Mar 2023 14:08:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id DA892A071C; Tue, 21 Mar 2023 15:08:28 +0100 (CET)
Date:   Tue, 21 Mar 2023 15:08:28 +0100
From:   Jan Kara <jack@suse.cz>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] ext2: remove redundant assignment to pointer end
Message-ID: <20230321140828.5h6x4rccey4gktkr@quack3>
References: <20230317143420.419005-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317143420.419005-1-colin.i.king@gmail.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri 17-03-23 14:34:20, Colin Ian King wrote:
> Pointer is assigned a value that is never read, the assignment is
> redundant and can be removed.
> 
> Cleans up clang-scan warning:
> fs/ext2/xattr.c:555:3: warning: Value stored to 'end' is never read [deadcode.DeadStores]
>                 end = (char *)header + sb->s_blocksize;
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

Thanks. I've picked the patch to my tree.

								Honza

> ---
>  fs/ext2/xattr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index b126af5f8b15..8906ba479aaf 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -552,7 +552,6 @@ ext2_xattr_set(struct inode *inode, int name_index, const char *name,
>  		error = -ENOMEM;
>  		if (header == NULL)
>  			goto cleanup;
> -		end = (char *)header + sb->s_blocksize;
>  		header->h_magic = cpu_to_le32(EXT2_XATTR_MAGIC);
>  		header->h_blocks = header->h_refcount = cpu_to_le32(1);
>  		last = here = ENTRY(header+1);
> -- 
> 2.30.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
