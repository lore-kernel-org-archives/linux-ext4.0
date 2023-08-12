Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 926BAC0015E
	for <linux-ext4@archiver.kernel.org>; Sat, 12 Aug 2023 02:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbjHLClt (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 11 Aug 2023 22:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjHLClt (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Aug 2023 22:41:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E79C268C;
        Fri, 11 Aug 2023 19:41:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ADD06422F;
        Sat, 12 Aug 2023 02:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C349C433C8;
        Sat, 12 Aug 2023 02:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691808107;
        bh=Qf0UrKAKMrDNExp3AQ1BgZvKh1gbqbBiuVEpYRftFYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M6JQnBlN6gPmRaJcxSle3PgLqulDOpl6MrlQtLwU2djzM9v6MFqzrfW6iIL/vNYkq
         gyUqetOQzUya+qHJC1Iib0L83q+CcCH1k5F0DSldK6nDNEtrIm27bd0u+0BmbqdIGO
         kqvHWyLhLuGQhhLVgSA4mHpu4ROacoNAnqfDXILsLNG1hjjPOpvUSvIDMNpGRTFuD7
         yDNPaTg+KF2/Mp7m0iQuw7WQo00MtYitS4Dya2TPmbQz9WA/y2cVFyaMaJKoaWLdU5
         mf8dAbv724oV7pG6f+83UyqYnnPVW5Y+lNKTuUqt7yJwDVqxZMZ94P9itFMgTBbM3h
         Ru3S/R+5TgO/A==
Date:   Fri, 11 Aug 2023 19:41:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     viro@zeniv.linux.org.uk, brauner@kernel.org, tytso@mit.edu,
        jaegeuk@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [PATCH v5 06/10] libfs: Validate negative dentries in
 case-insensitive directories
Message-ID: <20230812024145.GD971@sol.localdomain>
References: <20230812004146.30980-1-krisman@suse.de>
 <20230812004146.30980-7-krisman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230812004146.30980-7-krisman@suse.de>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, Aug 11, 2023 at 08:41:42PM -0400, Gabriel Krisman Bertazi wrote:
> +	/*
> +	 * Filesystems will call into d_revalidate without setting
> +	 * LOOKUP_ flags even for file creation (see lookup_one*
> +	 * variants).  Reject negative dentries in this case, since we
> +	 * can't know for sure it won't be used for creation.
> +	 */
> +	if (!flags)
> +		return 0;
> +
> +	/*
> +	 * If the lookup is for creation, then a negative dentry can
> +	 * only be reused if it's a case-sensitive match, not just a
> +	 * case-insensitive one.  This is needed to make the new file be
> +	 * created with the name the user specified, preserving case.
> +	 */
> +	if (flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET)) {
> +		/*
> +		 * ->d_name won't change from under us in the creation
> +		 * path only, since d_revalidate during creation and
> +		 * renames is always called with the parent inode
> +		 * locked.  It isn't the case for all lookup callpaths,
> +		 * so ->d_name must not be touched outside
> +		 * (LOOKUP_CREATE|LOOKUP_RENAME_TARGET) context.
> +		 */
> +		if (dentry->d_name.len != name->len ||
> +		    memcmp(dentry->d_name.name, name->name, name->len))
> +			return 0;
> +	}

This is still really confusing to me.  Can you consider the below?  The code is
the same except for the reordering, but the explanation is reworked to be much
clearer (IMO).  Anything I am misunderstanding?

	/*
	 * If the lookup is for creation, then a negative dentry can only be
	 * reused if it's a case-sensitive match, not just a case-insensitive
	 * one.  This is needed to make the new file be created with the name
	 * the user specified, preserving case.
	 *
	 * LOOKUP_CREATE or LOOKUP_RENAME_TARGET cover most creations.  In these
	 * cases, ->d_name is stable and can be compared to 'name' without
	 * taking ->d_lock because the caller holds dir->i_rwsem for write.
	 * (This is because the directory lock blocks the dentry from being
	 * concurrently instantiated, and negative dentries are never moved.)
	 *
	 * All other creations actually use flags==0.  These come from the edge
	 * case of filesystems calling functions like lookup_one() that do a
	 * lookup without setting the lookup flags at all.  Such lookups might
	 * or might not be for creation, and if not don't guarantee stable
	 * ->d_name.  Therefore, invalidate all negative dentries when flags==0.
	 */
	if (flags & (LOOKUP_CREATE | LOOKUP_RENAME_TARGET)) {
		if (dentry->d_name.len != name->len ||
		    memcmp(dentry->d_name.name, name->name, name->len))
			return 0;
	}
	if (!flags)
		return 0;
