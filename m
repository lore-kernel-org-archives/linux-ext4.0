Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118C23BED11;
	Mon, 27 Jul 2026 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785183223; cv=none; b=XYPGSEYquHVuxmdvNZFtjhGrLeoWZiYi/b7nbm+4C9u+/bHZP7PGebLmjf2LdJrr2A9FXd832vbLk06hee1/nt3SS2os6+EDjG2TTa5K7By2BPROt1oTpaUlrraYTolcsK+mgmpUwJZkddt5M+cv1nN2cHfPsS4gAfyhrcknIYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785183223; c=relaxed/simple;
	bh=JyJajv7ypRVB97a4lg9EHymN1lI1zY4F0HB23gS0iX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hfjItsqVZ5KKdNJZRGPTyN9mLPpBaS+n4OXOGQV1AS6HlkRaDkHmY3ccjBVL/R9upiPw3Yf8/DQtoDS5BbKoEwDEs0n1KQhM6eY4LxDC6NUO1nF079O+6491I5xWr7BBZfOnWOTrgBuG6K/O1ATL3OBBxi0TSRcBzGQmnCRm+io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsLFXkau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsLFXkau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E121F000E9;
	Mon, 27 Jul 2026 20:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785183221;
	bh=U4qhSK5NtkFYAAUbEPeaE20RlHxWcVudd2tKbsEQeyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fsLFXkaud9Q/caSgsdgHSDv35JXS9fsaDY2XMLDfGTqwSNMibZMLy0zZ0HJaoUORa
	 by8QAccBVJ1cLSrib1a9Uo5N8YUuASuoe7jgcnHjNwDPwGNZcUU+pZ9QSmnoawmMPN
	 ozuYj196tNmMewZj9l1w1eb6Ay8eDnCpILC6XT6Eg8At4SDn7+tI/G+dS8teU9FL5/
	 QG1jdQlOlUJEV2rksWuyj0GvX5+WVagKO0ZyTevT1oY0J1gF+5mM1nSRDJnRwgLbe5
	 pczx8S5rPsN1RWFTAB15sbmbdYjX1YogIgSoWN1YrUfdNwWcppUbXy+qeVTK8VY/FC
	 z9bLgPEiDjhJA==
Date: Mon, 27 Jul 2026 20:13:39 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org,
	Baokun Li <libaokun@linux.alibaba.com>,
	Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <20260727201339.GD1021387@google.com>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
 <20260727194350.GC1021387@google.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727194350.GC1021387@google.com>

On Mon, Jul 27, 2026 at 07:43:50PM +0000, Eric Biggers wrote:
> On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> > On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > > flag. This is because the newly created inode ends up with the following:
> > > 
> > >   __ext4_new_inode()
> > >     ext4_set_inode_flags(init=true) // sets S_DAX
> > >       fscrypt_set_context()
> > >         ext4_set_context()
> > >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> > >                                               doesn't clears S_DAX
> > >       ext4_set_aops
> > >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > > 
> > > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > > silently ends up bypassing encryption completely. This is reflected in
> > > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > > is safe to change DAX state there because ext4_set_aops() later can
> > > correctly detect S_DAX unset and assign the correct aops.
> > > 
> > > The fix was actually the intended behavior however it seemed to have
> > > silently changed in 043546e46dc7.
> > > 
> > > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > ---
> > >  fs/ext4/crypto.c | 15 +++++++++++----
> > >  fs/ext4/inode.c  | 10 ++++++----
> > >  2 files changed, 17 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > > index f41f320f4437..2d409114e02e 100644
> > > --- a/fs/ext4/crypto.c
> > > +++ b/fs/ext4/crypto.c
> > > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > >  {
> > >  	handle_t *handle = fs_data;
> > >  	int res, res2, credits, retries = 0;
> > > +	bool init = S_ISREG(inode->i_mode);
> > 
> > Hum, I have some comments: IMHO the change is confusing because the meaning
> > of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> > of flags any longer. And the reliance on ext4_set_context() getting called
> > in a safe place exactly for regular files is rather subtle as well.
> > 
> > Also does the change to ext4_set_inode_flags() really work? As far as I'm
> > reading the ext4 crypto implementation, I don't see where we'd be setting
> > EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> > load the context from xattrs through ext4_get_context()) and thus DAX would
> > still get enabled for such inodes? What am I missing?
> 
> Maybe __ext4_new_inode() should set the encryption flag on the inode
> earlier?  Currently it decides whether the inode will be encrypted, then
> calls ext4_set_inode_flags(), then calls fscrypt_set_context() (and thus
> ext4_set_context()).  That last step sets the flag and calls
> ext4_set_inode_flags() *again*.
> 
> I don't remember if there's a reason for that redundancy, but it might
> just be for historical reasons.  ext4_set_context() is called in two
> different cases: when a new inode is created and it's encrypted from the
> beginning, and when FS_IOC_SET_ENCRYPTION_POLICY is executed on an empty
> directory.  The latter does have to set the encrypt flag there.
>  
> - Eric

Here's an idea.  I haven't tested it though.

Note that this would align ext4 closer with f2fs, which already sets the
encrypt flag before it calls fscrypt_set_context().

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f41f320f4437..c4bfe18fd527 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -144,7 +144,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (inode->i_ino == EXT4_ROOT_INO)
 		return -EPERM;
 
-	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+	if (WARN_ON_ONCE(IS_DAX(inode)))
 		return -EINVAL;
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
@@ -163,6 +163,14 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	 */
 
 	if (handle) {
+		/*
+		 * ext4 should have set the encrypt flag on the inode already,
+		 * and it should not have enabled inline data.
+		 */
+		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
+			return -EINVAL;
+		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)))
+			return -EINVAL;
 		/*
 		 * Since the inode is new it is ok to pass the
 		 * XATTR_CREATE flag. This is necessary to match the
@@ -170,21 +178,10 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 		 * function with the credits allocated for the new
 		 * inode.
 		 */
-		res = ext4_xattr_set_handle(handle, inode,
-					    EXT4_XATTR_INDEX_ENCRYPTION,
-					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
-					    ctx, len, XATTR_CREATE);
-		if (!res) {
-			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
-			ext4_clear_inode_state(inode,
-					EXT4_STATE_MAY_INLINE_DATA);
-			/*
-			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
-			 * S_DAX may be disabled
-			 */
-			ext4_set_inode_flags(inode, false);
-		}
-		return res;
+		return ext4_xattr_set_handle(handle, inode,
+					     EXT4_XATTR_INDEX_ENCRYPTION,
+					     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+					     ctx, len, XATTR_CREATE);
 	}
 
 	res = dquot_initialize(inode);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a40cb27f8116..3848244af77a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -997,6 +997,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
 		if (err)
 			goto out;
+		if (encrypt)
+			i_flags |= EXT4_ENCRYPT_FL;
 	}
 
 	err = dquot_initialize(inode);
@@ -1306,6 +1308,7 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 	ei->i_extra_isize = sbi->s_want_extra_isize;
 	ei->i_inline_off = 0;
 	if (ext4_has_feature_inline_data(sb) &&
+	    !(ei->i_flags & EXT4_ENCRYPT_FL) &&
 	    (!(ei->i_flags & (EXT4_DAX_FL|EXT4_EA_INODE_FL)) || S_ISDIR(mode)))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 	ret = inode;
