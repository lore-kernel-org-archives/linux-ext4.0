Return-Path: <linux-ext4-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C810EC7EE2C
	for <linux-ext4@archiver.kernel.org>; Wed, 24 May 2023 10:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjEXKvx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 24 May 2023 06:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjEXKvv (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 May 2023 06:51:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4E4A3;
        Wed, 24 May 2023 03:51:50 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 71E0E22189;
        Wed, 24 May 2023 10:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1684925509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iw9TySelXxG3UNCA0k4qVCUSDYtKU/y5xgxNuohqpQI=;
        b=1gsfTUyFhZ6FyaAWvaU+Duwu5Dy4snvZ5S1smNUTz8WvTyGZMZZVSF+NdOyv/2lbdqIL/h
        8yab/x42Bve6tnWzm0m/2u9UmBxqQCXC0yQg1C8c1fmOBSbo8Iio3Emsq05lUAuTL3JU/L
        2iz1JkFkFdcBILWI7Z3d/hQxpACkvlo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1684925509;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iw9TySelXxG3UNCA0k4qVCUSDYtKU/y5xgxNuohqpQI=;
        b=+stSb6idZWgRZZzzph8kBjCng2hffY32yActJ2X99htdkg57j2ykTv8Zdx1DCI/6KUVnF7
        aMwS3+xmLQCD8GCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 633BF133E6;
        Wed, 24 May 2023 10:51:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KIkpGEXsbWQ0MAAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 24 May 2023 10:51:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E2A99A075C; Wed, 24 May 2023 12:51:48 +0200 (CEST)
Date:   Wed, 24 May 2023 12:51:48 +0200
From:   Jan Kara <jack@suse.cz>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jan Kara' <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ext4: Fix possible corruption when moving a directory
 with RENAME_EXCHANGE
Message-ID: <20230524105148.wgjj7ayrbeol6cdx@quack3>
References: <20230523131408.13470-1-jack@suse.cz>
 <48d1f20b2fc1418080c96a1736f6249b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d1f20b2fc1418080c96a1736f6249b@AcuMS.aculab.com>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue 23-05-23 13:50:01, David Laight wrote:
> From: Jan Kara
> > Sent: 23 May 2023 14:14
> > 
> > Commit 0813299c586b ("ext4: Fix possible corruption when moving a
> > directory") forgot that handling of RENAME_EXCHANGE renames needs the
> > protection of inode lock when changing directory parents for moved
> > directories. Add proper locking for that case as well.
> > 
> > CC: stable@vger.kernel.org
> > Fixes: 0813299c586b ("ext4: Fix possible corruption when moving a directory")
> > Reported-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/namei.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> > index 45b579805c95..b91abea1c781 100644
> > --- a/fs/ext4/namei.c
> > +++ b/fs/ext4/namei.c
> > @@ -4083,10 +4083,25 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
> >  	if (retval)
> >  		return retval;
> > 
> > +	/*
> > +	 * We need to protect against old.inode and new.inode directory getting
> > +	 * converted from inline directory format into a normal one. The lock
> > +	 * ordering does not matter here as old and new are guaranteed to be
> > +	 * incomparable in the directory hierarchy.
> > +	 */
> > +	if (S_ISDIR(old.inode->i_mode))
> > +		inode_lock(old.inode);
> > +	if (S_ISDIR(new.inode->i_mode))
> > +		inode_lock_nested(new.inode, I_MUTEX_NONDIR2);
> > +
> 
> What happens if there is another concurrent rename from new.inode
> to old.inode?
> That will try to acquire the locks in the other order.

That is not really possible because these two renames cannot happen in
parallel due to VFS locking - either old & new share parent which is locked
by VFS (so there cannot be another rename in that directory) or they have
different parents which are also locked by VFS (so again it is not possible
to race with another rename in these two dirs).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
