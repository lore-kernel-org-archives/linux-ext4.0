Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A0EC677F1
	for <linux-ext4@archiver.kernel.org>; Thu, 12 Jan 2023 10:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239665AbjALKMC (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 12 Jan 2023 05:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbjALKLW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jan 2023 05:11:22 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CDB28E
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jan 2023 02:10:10 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 47CF73F828;
        Thu, 12 Jan 2023 10:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673518208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DTyMIl/jTSJG3hjSJ49TkkhFlzWbIGSxucI29ckZ1BY=;
        b=E5/5shr/QrkJvhY9k/fQFcRI54dqEmYih+OSHxb0fUSwVoykjMuA1xaebFlkZ3DZ3zVeV0
        6WQodF21UGwVrKLE3lvkDzZSh6yWkdkcZ6dDNLrsNhu4LPkEi0jh/XCqgZw2vNd8as2bUE
        mlSgRjlUb1E2Xv3II7gIzYTYBc1aY8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673518208;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DTyMIl/jTSJG3hjSJ49TkkhFlzWbIGSxucI29ckZ1BY=;
        b=2G059nktAz2TpQsr0ypyd0/GmXH3AhtxBI+4xQO/n0LODPW8UoqQvd/MxLb2qdk9zFnBp5
        qKjCACPWDCagLWDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3994813585;
        Thu, 12 Jan 2023 10:10:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K+sKDoDcv2PLIgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 12 Jan 2023 10:10:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id AE560A0744; Thu, 12 Jan 2023 11:10:07 +0100 (CET)
Date:   Thu, 12 Jan 2023 11:10:07 +0100
From:   Jan Kara <jack@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Ye Bin <yebin10@huawei.com>
Subject: Re: [PATCH] ext4: use ext4_fc_tl_mem in fast-commit replay path
Message-ID: <20230112101007.d5ic6uzvj6noh4q7@quack3>
References: <20221217050212.150665-1-ebiggers@kernel.org>
 <20230111144327.gb6p3foqj23mby7w@quack3>
 <Y78AO7WX5Q6Zju3p@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y78AO7WX5Q6Zju3p@sol.localdomain>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 11-01-23 10:30:19, Eric Biggers wrote:
> On Wed, Jan 11, 2023 at 03:43:27PM +0100, Jan Kara wrote:
> > On Fri 16-12-22 21:02:12, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > To avoid 'sparse' warnings about missing endianness conversions, don't
> > > store native endianness values into struct ext4_fc_tl.  Instead, use a
> > > separate struct type, ext4_fc_tl_mem.
> > > 
> > > Fixes: dcc5827484d6 ("ext4: factor out ext4_fc_get_tl()")
> > > Cc: Ye Bin <yebin10@huawei.com>
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Looks good to me. Just one nit below:
> > 
> > > -static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
> > > +static inline void ext4_fc_get_tl(struct ext4_fc_tl_mem *tl, u8 *val)
> > >  {
> > > -	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
> > > -	tl->fc_len = le16_to_cpu(tl->fc_len);
> > > -	tl->fc_tag = le16_to_cpu(tl->fc_tag);
> > > +	struct ext4_fc_tl tl_disk;
> > > +
> > > +	memcpy(&tl_disk, val, EXT4_FC_TAG_BASE_LEN);
> > > +	tl->fc_len = le16_to_cpu(tl_disk.fc_len);
> > > +	tl->fc_tag = le16_to_cpu(tl_disk.fc_tag);
> > >  }
> > 
> > So why not just:
> > 
> > 	struct ext4_fc_tl *tl_disk = (struct ext4_fc_tl *)val;
> > 
> > instead of memcpy?
> 
> That would result in unaligned memory accesses.

Indeed. Thanks for explanation! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
