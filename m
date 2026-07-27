Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884C03D7D9B;
	Mon, 27 Jul 2026 19:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785181434; cv=none; b=SEpCfoseYZ3HKt0cGZOR9/MT72JnvMem2mQ5hzQp4hpFKBfGc8pE/+xO0pABj4pSPswnfp3IQHniUKu7Mem7HHlLmATdeyuyhKAOuSvAnKW1Q37vRlvxuubSYBM5CL21aAf5it3aCfgKygJSPCf+jSlCDk8tlKaQUUu84tkxuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785181434; c=relaxed/simple;
	bh=AkOQ/iZ/ZaWpax4LsVixymcinc/mRpebKUrzQlFNxgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxKYOYP0Ccq2EbZBHw3hhj9qfsgbYCA634qcH1dtnsXPLho1V37btILS/6pKkgBEAqxRirmgbPigOc4EGGQeoxFFLyINq4Ppnty0WO+/IwcrsYVwKeFnxgTm0KuFk74tDI0nY1JNXK3Vl4GxiEnD9YNByl7ijlo+u1zltDcS6xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n5llgdCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5llgdCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E501F000E9;
	Mon, 27 Jul 2026 19:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785181432;
	bh=WjlEr0ZKzmcSJVgMzqSHa/nBA4GEKZiR8WHha0Z/2WA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n5llgdCYNMVqjfmJH/Xhfb2VZiieXdvuapt02FOTswP6skMrLiaeqUr07u1w/giJ+
	 lLWX53NcxECMhIL2j1LOOrJnb89KxipCfCWCkSot6jhmI1mk64tZ70sIVKXNrH5ebf
	 a4C6izaJj9BBDdmATD9eKPBpZfVCxTH78OfsXyzdeqVxd6Qqrh6DTEWdmgMgRsWSDN
	 nlp83bRv5f4J643YvC/6wSAnDSkXCpBtbYC7j2ypJfEP1Rj+HNUJNdtWCZVxUyck5Z
	 HhAtXaYg4l+xiK6avHbzb2jvc4O8o309kVlLdGmGcktXv7pNRi4sCoIjISHS9/rVQg
	 yg1Khghg0dkkA==
Date: Mon, 27 Jul 2026 19:43:50 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
	Baokun Li <libaokun@linux.alibaba.com>,
	Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <20260727194350.GC1021387@google.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>

On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > flag. This is because the newly created inode ends up with the following:
> > 
> >   __ext4_new_inode()
> >     ext4_set_inode_flags(init=true) // sets S_DAX
> >       fscrypt_set_context()
> >         ext4_set_context()
> >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> >                                               doesn't clears S_DAX
> >       ext4_set_aops
> >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > 
> > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > silently ends up bypassing encryption completely. This is reflected in
> > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > is safe to change DAX state there because ext4_set_aops() later can
> > correctly detect S_DAX unset and assign the correct aops.
> > 
> > The fix was actually the intended behavior however it seemed to have
> > silently changed in 043546e46dc7.
> > 
> > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > ---
> >  fs/ext4/crypto.c | 15 +++++++++++----
> >  fs/ext4/inode.c  | 10 ++++++----
> >  2 files changed, 17 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > index f41f320f4437..2d409114e02e 100644
> > --- a/fs/ext4/crypto.c
> > +++ b/fs/ext4/crypto.c
> > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> >  {
> >  	handle_t *handle = fs_data;
> >  	int res, res2, credits, retries = 0;
> > +	bool init = S_ISREG(inode->i_mode);
> 
> Hum, I have some comments: IMHO the change is confusing because the meaning
> of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> of flags any longer. And the reliance on ext4_set_context() getting called
> in a safe place exactly for regular files is rather subtle as well.
> 
> Also does the change to ext4_set_inode_flags() really work? As far as I'm
> reading the ext4 crypto implementation, I don't see where we'd be setting
> EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> load the context from xattrs through ext4_get_context()) and thus DAX would
> still get enabled for such inodes? What am I missing?

Maybe __ext4_new_inode() should set the encryption flag on the inode
earlier?  Currently it decides whether the inode will be encrypted, then
calls ext4_set_inode_flags(), then calls fscrypt_set_context() (and thus
ext4_set_context()).  That last step sets the flag and calls
ext4_set_inode_flags() *again*.

I don't remember if there's a reason for that redundancy, but it might
just be for historical reasons.  ext4_set_context() is called in two
different cases: when a new inode is created and it's encrypted from the
beginning, and when FS_IOC_SET_ENCRYPTION_POLICY is executed on an empty
directory.  The latter does have to set the encrypt flag there.
 
- Eric
