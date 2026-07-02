Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB3B3F787E
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 11:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992086; cv=none; b=PUXtQn75rmA+f/LDl0u7XOm7kNkDkWfViVl15oiBxauX88BAEU/8T90hUzDpI0mBY1AZdLkw724OqsuOnojUC7KTMHXsNGGUos8ggUnVsdHWXRydCY19Wzt82XCRCeavaPmaIMBJODRNpQls6D5wVHTCn6FuISfGXKX/WRsIHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992086; c=relaxed/simple;
	bh=ollp1v/Hli2U525da/k6AvpxFr+hE5vvyCeC/MTDjUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLX4hpCMvkJ3arNoFzgWR0rHREQmeCX9shG0zWcsJBtnneuW8kYWtNsOA2bNauxsmGUVmU1Mfaj+0N1ZkjL0t3KpCeNLcFkMA0IsQR4q8Y4djzbQScZdzf8Ts8Qh84w4NL5to7p+c8c62Lwy7hy/x8V5Ebc/k8WmNBVZtmjtyu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xSrn9gfN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=K64RcmmA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qPlMjH0M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/h0aisVZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xSrn9gfN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="K64RcmmA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qPlMjH0M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/h0aisVZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 76DEB7418A;
	Thu,  2 Jul 2026 11:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782992081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSXAcfKGFmeWsJNeJKN/Hdw1etO7JNgMn9BwelizpMk=;
	b=xSrn9gfNIAbhKF8CVMOMAlnTPCKvhUmbWFryg0ApJHE1OTdgNrVEIjDiJFzkk07uSVVXXo
	j0abD/6G/ieqjKpIay8Lr7gxKFPDp+35aYlATkSJrzLvDGswp5xYE/V0EOcdWcqdWafzKv
	dKQqAn3GOfdjeW93O92xZtafYQDPx0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782992081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSXAcfKGFmeWsJNeJKN/Hdw1etO7JNgMn9BwelizpMk=;
	b=K64RcmmA5CUcwviRbzeltgR5HzOoAr39mli20JY7y/Cf/s+b9isA7eGNaRmj0vwNHVP8kP
	kOaHcEL1YrLIgTCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qPlMjH0M;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/h0aisVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782992080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSXAcfKGFmeWsJNeJKN/Hdw1etO7JNgMn9BwelizpMk=;
	b=qPlMjH0Mlr1x5XRN9G7VurfPEvMF0y2nWx1OEy/pILckVSqEhaTEQcNrrMvDrbkzR5US5Z
	wGJXW489QOA8RihelV0Qb+lZD7y/YA5CDkwtEndKPLKLt04doogwwVc+XRNfgpPMsqnYWI
	qAYArwPLu4CgQOSjz0VsChFKBBWMbgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782992080;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSXAcfKGFmeWsJNeJKN/Hdw1etO7JNgMn9BwelizpMk=;
	b=/h0aisVZpEliUZpEopdEXsnxsxvIZzMWykQraaeMe4L1+4Xhb7RsDFoVK49MPylXDoLw85
	d3J+RoW1tVcLT3BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59A9A779AC;
	Thu,  2 Jul 2026 11:34:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zf2QFdBMRmq1ewAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 11:34:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4F88BA12AD; Thu, 02 Jul 2026 13:34:38 +0200 (CEST)
Date: Thu, 2 Jul 2026 13:34:38 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: use fsdata to track inline data write state and
 fix race
Message-ID: <zwfhyqxdxfigm5nced3hgsp4mygwxgwc4cxzeyl7glrmie73rm@r66bdrw7fjsj>
References: <20260702050724.1658-1-aditya.ansh182@gmail.com>
 <3sbocdflzeajcievmbdwprrgzkztd7ogn7mmjx4quptorotwak@rlzklako3yht>
 <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ssPOM-rddJR6=QJ4RSCeQvamKKAbJS+NCOLbsC2eSODydkQ@mail.gmail.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[13];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,iloc.bh:url,appspotmail.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 76DEB7418A
X-Spam-Score: -2.51

Hi Aditya!

On Thu 02-07-26 16:19:56, Aditya Prakash Srivastava wrote:
> I have been thinking about the VFS retry case where if we do
> not reset the fsdata, we might end up in an infinite loop.

Indeed, good spotting. I have also realized that after your patch
CONVERT_INLINE_DATA is effectively unused and can be deleted along with
passing fsdata to ext4_generic_write_inline_data() and
ext4_da_convert_inline_data_to_extent(). So that would be a good cleanup
patch on top of your fix.

> The proposed fix from my side is to reintroduce setting
> fsdata = NULL in the beginning of ext4_write_begin,
> of course we should be careful not to overwrite it if it
> has some other value. Sample code like below
> 
> if (unlikely(ret))
> return ret;
> 
> /*
>  * Reset fsdata for a vfs retry case
> */
> if (*fsdata != (void *)FALL_BACK_TO_NONDELALLOC)
> *fsdata = NULL;

Hum, thinking more about this I think we should use fsdata more as flags
than enum. So ext4_write_begin() should be doing

  *fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);

and ext4_write_end() should be doing (unconditionally on exit):

  *fsdata = (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);

to unroll the state back. Otherwise the interactions with
FALL_BACK_TO_NONDELALLOC and delalloc path get too tedious to verify and
they *are* in fact independent states of the write path.

								Honza

> 
> trace_ext4_write_begin(inode, pos, len);
> /*
>  * Reserve one block more for addition to orphan list in case
> 
> This should take care of the retry case not getting into
> an infinite loop.
> What do you think? I shall send you a revised version if we
> agree on this.
> 
> Thanks,
> Aditya
> 
> On Thu, Jul 2, 2026 at 4:05 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Thu 02-07-26 05:07:24, Aditya Srivastava wrote:
> > > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> > >
> > > Instead of checking the live inode state (ext4_has_inline_data(inode)
> > > and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
> > > write_end handlers, use the fsdata parameter of the address space
> > > operations to explicitly pass down the state in which write_begin
> > > prepared the write.
> > >
> > > A concurrent thread (such as ext4_page_mkwrite()) can convert the
> > > inline data to an extent between write_begin and write_end. If this
> > > happens, the write_end handlers would previously miss the inline
> > > write_end path and fall through to extent-based write_end logic.
> > > However, since block buffers were never allocated in write_begin,
> > > this resulted in NULL pointer dereferences or data loss because
> > > folio_buffers(folio) was NULL.
> > >
> > > Define EXT4_WRITE_DATA_INLINE (3) and communicate this state via
> > > fsdata:
> > > 1) ext4_write_begin() and ext4_da_write_begin() explicitly set
> > >    *fsdata to EXT4_WRITE_DATA_INLINE when an inline write is
> > >    successfully prepared.
> > > 2) ext4_write_end(), ext4_journalled_write_end(), and
> > >    ext4_da_write_end() rely solely on fsdata / write_mode to
> > >    invoke ext4_write_inline_data_end().
> > >
> > > Furthermore, during a buffered write, ext4_write_inline_data_end()
> > > acquires the xattr lock after preparing the write. If a concurrent
> > > page fault (ext4_page_mkwrite()) converts the inline data to an extent
> > > after the write_end handlers check the state but before
> > > ext4_write_inline_data_end() acquires the xattr write lock, the
> > > subsequent check will trigger a kernel panic via
> > > BUG_ON(!ext4_has_inline_data(inode)).
> > >
> > > Replace the BUG_ON check in ext4_write_inline_data_end() with a graceful
> > > error-handling retry path. If the inline data is cleared after locking
> > > the xattr, we safely release all resources (releasing iloc.bh,
> > > unlocking/putting the folio, stopping the active journal transaction
> > > handle) and return 0 (VFS retry) to let the generic write path retry
> > > the operation safely.
> > >
> > > Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
> > > Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
> > > Suggested-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > Looks good! Feel free to add:
> >
> > Reviewed-by: Jan Kara <jack@suse.cz>
> >
> >                                                                 Honza
> >
> > > ---
> > > Changes in v2:
> > > - Folded the BUG_ON fix from the second patch into the first one to
> > >   ensure bisectability across git history, as suggested by Jan Kara.
> > > - Removed the pointless initialization `*fsdata = NULL` on entry to
> > >   `ext4_write_begin()`.
> > > - Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.
> > >
> > >  fs/ext4/ext4.h   |  1 +
> > >  fs/ext4/inline.c | 14 +++++++++++++-
> > >  fs/ext4/inode.c  | 18 +++++++++---------
> > >  3 files changed, 23 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > index b37c136ea3ab..521bd5d6321c 100644
> > > --- a/fs/ext4/ext4.h
> > > +++ b/fs/ext4/ext4.h
> > > @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
> > >  void ext4_set_inode_mapping_order(struct inode *inode);
> > >  #define FALL_BACK_TO_NONDELALLOC 1
> > >  #define CONVERT_INLINE_DATA   2
> > > +#define EXT4_WRITE_DATA_INLINE        3
> > >
> > >  typedef enum {
> > >       EXT4_IGET_NORMAL =      0,
> > > diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> > > index 8045e4ff270c..cfd591dc1d9c 100644
> > > --- a/fs/ext4/inline.c
> > > +++ b/fs/ext4/inline.c
> > > @@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
> > >                       goto out;
> > >               }
> > >               ext4_write_lock_xattr(inode, &no_expand);
> > > -             BUG_ON(!ext4_has_inline_data(inode));
> > > +             /*
> > > +              * We could have raced with ext4_page_mkwrite() converting
> > > +              * the inode and clearing the inline data flag, so we just
> > > +              * release resources and retry the whole write.
> > > +              */
> > > +             if (unlikely(!ext4_has_inline_data(inode))) {
> > > +                     ext4_write_unlock_xattr(inode, &no_expand);
> > > +                     brelse(iloc.bh);
> > > +                     folio_unlock(folio);
> > > +                     folio_put(folio);
> > > +                     ext4_journal_stop(handle);
> > > +                     return 0;
> > > +             }
> > >
> > >               /*
> > >                * ei->i_inline_off may have changed since
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index ce99807c5f5b..d3d9e1999670 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1316,8 +1316,10 @@ static int ext4_write_begin(const struct kiocb *iocb,
> > >                                                   foliop);
> > >               if (ret < 0)
> > >                       return ret;
> > > -             if (ret == 1)
> > > +             if (ret == 1) {
> > > +                     *fsdata = (void *)EXT4_WRITE_DATA_INLINE;
> > >                       return 0;
> > > +             }
> > >       }
> > >
> > >       /*
> > > @@ -1450,8 +1452,7 @@ static int ext4_write_end(const struct kiocb *iocb,
> > >
> > >       trace_ext4_write_end(inode, pos, len, copied);
> > >
> > > -     if (ext4_has_inline_data(inode) &&
> > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > > +     if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
> > >               return ext4_write_inline_data_end(inode, pos, len, copied,
> > >                                                 folio);
> > >
> > > @@ -1560,8 +1561,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
> > >
> > >       BUG_ON(!ext4_handle_valid(handle));
> > >
> > > -     if (ext4_has_inline_data(inode) &&
> > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> > > +     if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
> > >               return ext4_write_inline_data_end(inode, pos, len, copied,
> > >                                                 folio);
> > >
> > > @@ -3161,8 +3161,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
> > >                                                    foliop, fsdata, true);
> > >               if (ret < 0)
> > >                       return ret;
> > > -             if (ret == 1)
> > > +             if (ret == 1) {
> > > +                     *fsdata = (void *)EXT4_WRITE_DATA_INLINE;
> > >                       return 0;
> > > +             }
> > >       }
> > >
> > >  retry:
> > > @@ -3299,9 +3301,7 @@ static int ext4_da_write_end(const struct kiocb *iocb,
> > >
> > >       trace_ext4_da_write_end(inode, pos, len, copied);
> > >
> > > -     if (write_mode != CONVERT_INLINE_DATA &&
> > > -         ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
> > > -         ext4_has_inline_data(inode))
> > > +     if (write_mode == EXT4_WRITE_DATA_INLINE)
> > >               return ext4_write_inline_data_end(inode, pos, len, copied,
> > >                                                 folio);
> > >
> > > --
> > > 2.47.3
> > >
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
