Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEAA519DE1;
	Wed, 14 Oct 2026 13:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986035; cv=none; b=XnUN5uh1X/KuA2m2DP/hTreqwdwqoU3QwZXrta4Rxm+7scEFlzfsfc5F9Hqo6UPEdwj1yDB2IUn9a3kvuK1KEMoWbHfQIoHzV4A1fYljsnSAMgRnMhHHEx2ePTyUZNfgzKUqWoXoz2tnAclkVjZqwQjjIO4aF1NzX+1k+/C3hec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986035; c=relaxed/simple;
	bh=FY/Y1v2iphqNQXBdfxVM2bdNOoy2eFDzxycsgnfoaOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z+9Kt3kGdHpvsJ8H7mrmFx5Z925tzTHeP/c3Ojte5YyluwDhhQGbVa1xlD6mhJ9Q90j1nCkNPnuSCzXE1kq0Crm8fLzRUFQ9nkhkJi1qP/Rnk7XRB1KAlitbDd8bhfuorobuSvhxvUW47rIaXcqA804p4Npey3CrD7dcW1ZEKa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ThH/PLvo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CEv0Vm+A; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ThH/PLvo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CEv0Vm+A; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ThH/PLvo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CEv0Vm+A";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ThH/PLvo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CEv0Vm+A"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2A3C01FB67;
	Wed, 14 Oct 2026 13:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791986026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m33Hz2F8zGiBvESxxwsmonj/pJ1AncoCvKPtx51EwMU=;
	b=ThH/PLvo9pUHVNc41lZOefyT+F8GPMeD5ZkPd1GDwn/YCn2uhBr+1YfaDv+2BOqu9gt0v7
	3pIEJqBcEylfJItgi77Aw8rh3Yz5HyS4+AWCveSNFJBQ6NZBBxdeI6mcfAFr4fiVUwnCvT
	jimWoXXktTfGczEYSrVuA1SIL+ObSKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791986026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m33Hz2F8zGiBvESxxwsmonj/pJ1AncoCvKPtx51EwMU=;
	b=CEv0Vm+ASRNt9Zk7drNEtvyFSJ8owB/j/x9FvOVYNo4CwrqKnVQvUPAV4llmauSkt6Pxa4
	HKw8SPD9y/TX/MDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ThH/PLvo";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CEv0Vm+A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791986026; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m33Hz2F8zGiBvESxxwsmonj/pJ1AncoCvKPtx51EwMU=;
	b=ThH/PLvo9pUHVNc41lZOefyT+F8GPMeD5ZkPd1GDwn/YCn2uhBr+1YfaDv+2BOqu9gt0v7
	3pIEJqBcEylfJItgi77Aw8rh3Yz5HyS4+AWCveSNFJBQ6NZBBxdeI6mcfAFr4fiVUwnCvT
	jimWoXXktTfGczEYSrVuA1SIL+ObSKk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791986026;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m33Hz2F8zGiBvESxxwsmonj/pJ1AncoCvKPtx51EwMU=;
	b=CEv0Vm+ASRNt9Zk7drNEtvyFSJ8owB/j/x9FvOVYNo4CwrqKnVQvUPAV4llmauSkt6Pxa4
	HKw8SPD9y/TX/MDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D61D2133F1;
	Wed, 14 Oct 2026 13:53:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9hLHK2mJz2ppWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 13:53:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7BB03A140F; Wed, 14 Oct 2026 15:53:36 +0200 (CEST)
Date: Wed, 14 Oct 2026 15:53:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
	v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused
 by non-rcu frees
Message-ID: <mlo45jj5jwsdysv3jrh6vw64yqzfbrfjbyw4tu54i4gdlgi3qd@56ch32zakgt5>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>
 <20261012-gaukeln-zeltlager-etikettieren-73ae50ccac01@brauner>
 <voobrqryqulmrq7gyt5vdwuiqd3wrhsrgfcadszclcgs6smw64@qb7yne64airm>
 <20261013-tante-unwiederholbar-summieren-de1079d8fb05@brauner>
 <20261013-hektik-kommunal-zischen-f7e37ee3ddff@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-hektik-kommunal-zischen-f7e37ee3ddff@brauner>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 2A3C01FB67
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 13-10-26 21:25:55, Christian Brauner wrote:
> On Tue, Oct 13, 2026 at 09:23:07PM +0200, Christian Brauner wrote:
> > On Tue, Oct 13, 2026 at 12:47:58PM +0200, Jan Kara wrote:
> > > On Mon 12-10-26 12:42:06, Christian Brauner wrote:
> > > > On Mon, Oct 12, 2026 at 12:36:15PM +0200, Jan Kara wrote:
> > > > > On Fri 09-10-26 23:51:50, Christian Brauner wrote:
> > > > > > While working on eliding the grace period in namespace_unlock() I went
> > > > > > through what filesystems free when they're shut down and what a pathwalk
> > > > > > in rcu mode can still read at that point. Since 66a97c2ec953's rcu
> > > > > > pathwalk fixes that's the filesystem's job. Whatever ->permission(),
> > > > > > ->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
> > > > > > rcu mode has to be freed after a grace period. A few filesystems don't
> > > > > > do that.
> > > > > > 
> > > > > > Most of it is hidden by umount(2). namespace_unlock() waits for a grace
> > > > > > period before it drops the mounts, so a walker that was inside the
> > > > > > filesystem is gone by the time the filesystem is shut down.
> > > > > > 
> > > > > > But the last reference to a mount doesn't have to go away in umount(2).
> > > > > > A chdir() out of a lazily unmounted directory or the close() of the last
> > > > > > file on it drops it without a grace period. A walker can then still be
> > > > > > in the filesystem while ->put_super() and ->kill_sb() free what it
> > > > > > reads.
> > > > > 
> > > > > Good catches! But I find it very counter-intuitive that pathname lookups
> > > > > can still be running against a filesystem while its ->put_super is called.
> > > > > People will keep forgetting about that and as a result these UAF bugs will
> > > > > be introduced again. Isn't it feasible we'd guarantee to the filesystem
> > > > > ->put_super() gets called only after all lookups are done (i.e., after RCU
> > > > > grace period expires)?
> > > > > 
> > > > > I understand this is a hairy bussiness because this has userspace visible
> > > > > implications (like when filesystem's sysfs files disappear, when the bdev
> > > > > really gets unused, etc.) but keeping all filesystems safe to run RCU
> > > > > lookup after ->put_super() will be IMHO a headache.
> > > > 
> > > > I don't think delaying put_super() or freeing the superblock helps.
> > > > That's not where the issue is. The issue is with sb->s_fs_info being
> > > > available after a grace period and that can go away in different
> > > > locations ->put_super() or ->kill_sb().
> > > 
> > > So my thinking was: Cannot we separate the teardown of mounts and the
> > > teardown of the sb by an RCU grace period? Then by the time the filesystem
> > > gets to any freeing of filesystem related structures all RCU lookups are
> > > guaranteed to be done so there's no problem with them accessing possibly
> > > freed structures pointed to by the sb.
> > > 
> > > But then I've read more of the changelogs and AFAIU getting rid of the RCU
> > > grace period waiting in the unmount path is actually your point to speedup
> > 
> > So I prototyped your thing and all version I could see working end up
> > penalizing umount and filesystem shutdown quite heavily. Maybe I'm not
> > imagnative enough but everything involving synchronize_rcu* should be
> > kicked in the n*ts. Because if you're going onto big machines your
> > workloads will get said kick.

Thanks for trying! I kind of expected that it won't be acceptable after
reading all those changelogs.

> And one thing I forgot to say: that requirement exists today. It is
> entirely accidental that this wasn't an issue in the umount() path
> because of the synchronize_rcu* in there. But said grace period doesn't
> exist if you e.g., chdir() out of a mount and put the last reference
> while still in lookup. Then said filesystems are fscked today because
> that is a requirement. And various reproducers in this series illustrate
> that.

Yeah, I understood that from your description. The RCU grace period delay
would have to be somehow added to those cases as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
