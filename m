Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9303F263F34
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602437; cv=none; b=I7M2LzhrhERaRhO1OAcxYiYelV4XIyrDrHNSA7LXpEW5f6mB1fVOkySNKKawm3gRcaGWojuuqIz5dJXACxg1ebbH1FAdz3iadV1IoY4kucz5wBxTZrSHM1oxlHLK1A+m0/xvdA283BQVyswE43b2Up8iG4qFAiU+2aBSykFyC+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602437; c=relaxed/simple;
	bh=gmqroTXGB0yWziQKTgkysxRmfqA2brsXW9mTvieIBEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X126AyrZaa2qDjQTbKgFRAIh862oRyvqqpupbYsDemChEGO1y6fCT21Gh/XC01oz3txLdnmzsPuENtZ6RTAVA5D1e8bZcdOExBiwEa4c7N6Ya7Db1xc+DjeozQVOfrUn/n2XiMNdIVDW7qxIFEFajtmm/sjMsY19EWLjQdX0BKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H2oLcLgD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Zc+o6Din; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=a1Ag9C6j; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UapJLC3c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H2oLcLgD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Zc+o6Din";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="a1Ag9C6j";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UapJLC3c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 360A5761EF;
	Thu,  9 Jul 2026 13:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783602432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0844geh6ZMhXSB+w7btZHfyO0hTjHHopZLDBcN9ng8M=;
	b=H2oLcLgD5yU6Z3X4DbJPCtKcetBPCyR3E+/BsC8+DJTBXkZGJv3bpoXZR26CSFLY9DyK9E
	HjhZcsei8p6fZQAArqiQ4JjkbmiQojgRaY75vBzq+rCUOdwAb/3sWK2uDTCipTafwngQfS
	KNz2tpgYxFEBa0HuTizm9YZ6Ja2vQvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783602432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0844geh6ZMhXSB+w7btZHfyO0hTjHHopZLDBcN9ng8M=;
	b=Zc+o6DinfwsNb02InFjj/5pz9VFp+QoFICEaN42PT51cmCc3qG7YRGiHJeY4rkzX5gCncY
	bCFiaOKsc2toUxBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783602431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0844geh6ZMhXSB+w7btZHfyO0hTjHHopZLDBcN9ng8M=;
	b=a1Ag9C6jDdC/TgzqolVR/Gd63iKsqGb8IgMtC6C6+i9gTbEAVwKR77+YTa+pDlKWFvyn4v
	K8ZEGW1759MWMNoAIy/9Mc8nf/qtRKto1E2yEthB1BNFfi+kV5RxrMbMdkZqZRvfg0wF+5
	dGyo9AfBXpxXNzvjMdHIEmUpu81f4B4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783602431;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0844geh6ZMhXSB+w7btZHfyO0hTjHHopZLDBcN9ng8M=;
	b=UapJLC3ccmfewaBTpAmMw44p3YSfz/F6OHGXKyYP0UhubWyiAwXd+MPwuQySo0Hs/qx+FT
	puDzrndyPgl076AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CAE7779AA;
	Thu,  9 Jul 2026 13:07:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ICrkCv+cT2pNHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:07:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CE9C4A12D7; Thu, 09 Jul 2026 15:07:06 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:07:06 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, adilger.kernel@dilger.ca, brauner@kernel.org, 
	libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com, ritesh.list@gmail.com, tytso@mit.edu, 
	viro@zeniv.linux.org.uk, yi.zhang@huawei.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, syzbot ci <syzbot+ciadd810ddf4701c1b@syzkaller.appspotmail.com>
Subject: Re: [syzbot ci] Re: ext4: deferred iput framework for EA inodes
Message-ID: <7gqptufc6arv6ichvx63rzrawxmb2mvlvn463xripjo3snhjgt@dc7bvpkrmogp>
References: <20260702152225.4071746-1-yun.zhou@windriver.com>
 <6a46ecbd.52c20a74.1f8b39.000b.GAE@google.com>
 <j6ftvy7a3w7js4whqps3fipbah452xhro37kxvkruoeobtlonb@zrp2pwoif3pc>
 <9bb5dbfe-bb82-4ca6-8a14-5c434bd54051@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bb5dbfe-bb82-4ca6-8a14-5c434bd54051@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[ciadd810ddf4701c1b];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,dilger.ca,kernel.org,linux.alibaba.com,vger.kernel.org,linux.ibm.com,gmail.com,mit.edu,zeniv.linux.org.uk,huawei.com,lists.linux.dev,googlegroups.com,syzkaller.appspotmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

Hi Yun,

On Tue 07-07-26 19:00:47, Zhou, Yun wrote:
> On 7/3/26 22:02, Jan Kara wrote:
> > 
> > On Thu 02-07-26 15:57:01, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > > 
> > > [v13] ext4: deferred iput framework for EA inodes
> > > https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.com
> > > * [PATCH v13 1/4] fs: add iput_if_not_last() helper
> > > * [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
> > > * [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
> > > * [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
> > > 
> > > and found the following issue:
> > > WARNING in ext4_journal_check_start
> > 
> > Good catch. We need to flush the pending work with iputs also in
> > ext4_sync_fs() which should also take care of this race with remount
> > read-only (and the same issue with filesystem freezing etc.).
> > 
> 
> Sorry for the late reply—I missed it because I receive too many emails from
> syzbot. I've now reconfigured my filtering rules.
> 
> Regarding the issue reported by syzbot CI, would it be better to add
> flush_delayed_work in __ext4_remount before sb->s_flags |= SB_RDONLY? That
> would make the race window smaller.

Well, if there is remount read-only happening, the operations modifying
filesystem are blocked or made to fail (see mnt_get_write_access() /
sb_prepare_remount_readonly()). So it doesn't really matter where in
ext4_reconfigure() / __ext4_remount() we flush the work - no new items that
are deleting any xattr inodes should be added.

And placing the flushing into ext4_sync_fs() handles multiple similar
problems - sync(2) should make sure all pending deletions are finished,
remount needs to do this (and it calls sync_filesystem() which will end up
calling ext4_sync_fs()), fsfreeze needs to do this (it calls
sync_filesystem() as well).
 
> Also, should I resend the v14 series, or submit a separate patch
> specifically for this fix?

I think you can resend with the fixup. Ted didn't merge the series yet.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
