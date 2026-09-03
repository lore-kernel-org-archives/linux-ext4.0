Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C2B3932E9;
	Thu,  3 Sep 2026 10:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788431156; cv=none; b=VHZN15L4CHlNtgzWTcrgVYw06gs3CjR0BqiadENCBUDcDcxhbIwawhGrPAgxFwGdRsA/ezRWQbtPgZEHHRUSEMOnyhjTviAjPAPKDHimee5ogio/p8KLDytdfwqjToNPeSrEEFAGmPINVTV1iwHa2xQ5VwcL7EcEoI1UZ1EGRl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788431156; c=relaxed/simple;
	bh=dn4Sgwmpr5+4wxAlMytNjbzCVUelUT+8zMth4S90I08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q9Idvq/oT7hmTgjrqvk1j+NeV7Pd63CMYWA1UwLA6sJrAoe1clwcaStr1zOTxkbvOa95YKcQ3+99XsH+JPdRPCBfURIoRJ2ccBn3YuGxZXhGzfb0nOUplQ79bDNiGVIlmWEJIngBWCKcARM9/ow0aLa4YLf4nqj5eTaX/aWGRO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lOumFYOA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aWSieyxQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l1pbuWT4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DV1G6IDL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lOumFYOA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aWSieyxQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l1pbuWT4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DV1G6IDL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECFA721E69;
	Thu,  3 Sep 2026 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788431142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qg9vXYILjfDtWeW2JNNNrWDGqb+uYP4KptRYOsrAsp4=;
	b=lOumFYOAIOTc7PemuAZzMQv3/DOgjtwn9NgsJG64GTY3B+gprNonxumjitoV691WmKE9eO
	Tuhd3IhzuAQPPhFFabYNcygof9wTLxvOMXkT+DL7RP1EQ046WGfSGs+OLgLkJsedmMaJi6
	4hAvlnSRV1EMIlvrEcm4lEMXeqqXAps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788431142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qg9vXYILjfDtWeW2JNNNrWDGqb+uYP4KptRYOsrAsp4=;
	b=aWSieyxQ1Wtc6k1NU3QszEUMZGxvpNnKbSJzomXr7iBNPvT3G33i6IWmiNYwxOtz/xVxRz
	45ooSdpqvU7T0pCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l1pbuWT4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DV1G6IDL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788431138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qg9vXYILjfDtWeW2JNNNrWDGqb+uYP4KptRYOsrAsp4=;
	b=l1pbuWT4fC7CrqP9gMNkXSJErlUgR+wj6d3J6EOQTG2xELs7FNpsgEVxJX8gZXHth3bghA
	z3pHMyzlBFfcG6/++N5jHSMNmi02rfppblTW2N6B/QmgMW0culyqKHj4kSyhWOiA5kr5qs
	YPSZDMQT+uo9zG9d/N62jd41+c7aI9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788431138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qg9vXYILjfDtWeW2JNNNrWDGqb+uYP4KptRYOsrAsp4=;
	b=DV1G6IDLS1mt2FaPheON/ljeeYAiJ5hG1+9B07ApRgypYQXImIDgLXorM54VC0J1PdeTup
	4iO7DinFUC8zdtCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBEF1136D9;
	Thu,  3 Sep 2026 10:25:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rX/DMSFLmWqwHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 03 Sep 2026 10:25:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6A8C4A13AC; Thu, 03 Sep 2026 12:25:37 +0200 (CEST)
Date: Thu, 3 Sep 2026 12:25:37 +0200
From: Jan Kara <jack@suse.cz>
To: JonasZhou-oc <jonaszhou-oc@zhaoxin.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org, jonaszhou@zhaoxin.com, 
	louisqi@zhaoxin.com, jianhuizzzzz@gmail.com
Subject: Re: [PATCH] ext4: isolate s_orphan_lock from read-mostly fields
Message-ID: <tf24u75hmpjhb2iqabyx6n3qur2kyda7vwz2eo5zcc2ek7utwp@m5sepatzqx2x>
References: <20260903021836.962624-1-jonaszhou-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903021836.962624-1-jonaszhou-oc@zhaoxin.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: ECFA721E69
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zhaoxin.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

On Thu 03-09-26 10:18:35, JonasZhou-oc wrote:
> From: Jonas Zhou <jonaszhou@zhaoxin.com>
> 
> s_orphan_lock is modified by orphan-list operations, but currently shares
> a cache line with s_journal and s_ext4_flags.  The latter fields are read
> from common ext4 paths, so unrelated accesses can cause the line containing
> the lock to bounce between CPUs.
> 
> On a two-socket Intel Xeon Silver 4208 system with 16 workers, throughput
> improved by 4.6% for stress-ng.dnotify and 1.7% for stress-ng.unlink.  Perf
> c2c showed that HITM events on the affected fields decreased from 3,699 to
> 3,125 (-15.5%) for stress-ng.dnotify and from 1,368 to 571 (-58.3%) for
> stress-ng.unlink.  Remote HITM events decreased by 45.1% and 65.5%,
> respectively.  The journal/flags line had no remote HITM events after the
> change; the remaining remote HITM events were on the orphan-lock line.
> 
> Signed-off-by: Jonas Zhou <jonaszhou@zhaoxin.com>

Ok, that makes some sense. But I have some comments:

1) If you used orphan_file filesystem feature, you'd see much larger wins
(as the orphan lock would get completely out of the picture).

2) You could just place orphan handling related entries to some other place
in the sb which is not so frequently read. That would reduce the contention
as well without wasting space for padding in struct ext4_sb_info.

3) Your patch drops a comment at s_orphan_lock.

In particular given point 1) above, I'm not sure this is really worth it -
if you care about orphan handling scalability, you should just enable
orphan_file feature.

								Honza

> ---
>  fs/ext4/ext4.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..a3f16a981664 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1644,7 +1644,7 @@ struct ext4_sb_info {
>  	/* Journaling */
>  	struct journal_s *s_journal;
>  	unsigned long s_ext4_flags;		/* Ext4 superblock flags */
> -	struct mutex s_orphan_lock;	/* Protects on disk list changes */
> +	struct mutex s_orphan_lock ____cacheline_aligned_in_smp;
>  	struct list_head s_orphan;	/* List of orphaned inodes in on disk
>  					   list */
>  	struct ext4_orphan_info s_orphan_info;
> -- 
> 2.25.1
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
