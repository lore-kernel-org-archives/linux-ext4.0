Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793903407;
	b=nc7Kek4wKJ438pzsLrDrc4NYiW+iNNfnFXv8G+zivArwDmkEAQsiC7IE2eRQ0Tz0zzHj
	 p4ivHbzr8SbgbK7n3KVPbmsaowzZJerWbJY85inmL+gwSz/eoYQKB0ZTxh9A+K0ViZLHB
	 sXEmmAfh/9TdB0kxkRVh0fZZCCkrVFBEzgGxqZ590W7CvW2GBheoZcxLGkey6xuKCVPPB
	 6ioxmsHGrD1W2t/1I9E3bff/XXCY2MQ06aa1mjdqAOD/JHiJosE51ILiaPY4saA8EGhOJ
	 nqzagSI+V5FxZbWImprWvmE8W1qa4GETqJZcJ9LJ2Hkn7QXNbkHQ9NIPevoCIX3/x7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793903407;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=dKAVEUZfk/rWKWdFpJ2rZqQA7SNePVsYzwAVLNjYZck=;
	b=1dClCLmyVfXsrUq7TiWQT0geHcW2zDG3HPd6c8Gc6R5lAXp8/5Usmb3rYJJ58Ah6Dqhn
	 iBBMF8B71IVQW84tPET1GXSpar9zWpoIVXnPaX91Ufv/18YRSGZV1Q/mmD22oEjjvqoBp
	 BGpU1XKMYWXCDZQr+NxFu+Dmc62Hwj0ucz3H2P2qSrndy+pefFkfu/rngo8UGByvfOsO/
	 lCM22oHKQ1PSwbR8j2qbvUJHU8QG/5xCwje914K9ZXMieIhDPssIqsgZlVX2Rn6xXFHft
	 t9PkRC2tShv2nGz0K5tRW45oS9lTddaW7aSjEBomk/w5z1CvJqnDzicOiiDEkZORszw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZvNcjhdf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=r27LTYuL;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zwAbWFKE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wANjwfZk;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AC0606A32D;
	Thu,  5 Nov 2026 18:30:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37AC0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZvNcjhdf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=r27LTYuL;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=zwAbWFKE;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wANjwfZk
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04EC421F91;
	Thu,  5 Nov 2026 18:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793903404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKAVEUZfk/rWKWdFpJ2rZqQA7SNePVsYzwAVLNjYZck=;
	b=ZvNcjhdfrU5LGt8mvgauc05n6wOXrd1+1eC4mHnmw8h5ZjE3Fn9r+pSBTr0jFI+xokFrsj
	Os84xtP6ACgRJ9ALub7zBiuHTZpGqfA9qlO7rFk59x4X/7uCkwibR1Ke9WZ2+NF2+w1kJu
	szLZaXHN9deh7RlTRCZGFMG32Eoee4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793903404;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKAVEUZfk/rWKWdFpJ2rZqQA7SNePVsYzwAVLNjYZck=;
	b=r27LTYuLApuUZfuzQ6+fx6km1uDQ0FeC3rUoztkaJUrQzyKBY2qngAKGl1d4L6xnpemcX6
	xXblI7LGBqHSxoBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793903403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKAVEUZfk/rWKWdFpJ2rZqQA7SNePVsYzwAVLNjYZck=;
	b=zwAbWFKELyEKdGdXvEYyP5tO7oUnDv8gC1yBYgRyLdyfNJ5U4ECHbXeH0TYKv4x7saofup
	4wD5kr+s1fgQnrK/MegCRLY7JBb04qisZMn58hITZNbM7pZIGPRdqCzEWJLaQJXnrJ1Pwa
	CKf/ifUyGclcQx9USz7ua53xHXwDab0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793903403;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dKAVEUZfk/rWKWdFpJ2rZqQA7SNePVsYzwAVLNjYZck=;
	b=wANjwfZkAy8hG8vOHw6ygHEucy82GZZG3TndWS2/FRkMlhY7B70k8g85GmyQDj/cTxBq9q
	uwnvL9d+gCVBd9BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6DA1133F6;
	Thu,  5 Nov 2026 18:30:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id koUGHyrL7Gr1IQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 18:30:02 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 325C8B820; Thu, 05 Nov 2026 19:30:02 +0100 (CET)
Date: Thu, 5 Nov 2026 19:30:02 +0100
From: Jan Kara <jack@suse.cz>
To: Jianping Liu <frankljpliu@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, frankjpliu@tencent.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix soft lockup while shrinking the extent
 status cache
Message-ID: <rszreimkiwsu3yrksfrjvalosmvhsybnfrabups7dv2jfmrkdc@qvzzx3sw67rp>
References: <20261104033539.3031910-1-frankljpliu@gmail.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104033539.3031910-1-frankljpliu@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,tencent.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email,tencent.com:email]
X-Spam-Score: -11.30

On Wed 04-11-26 11:35:39, Jianping Liu wrote:
> From: Jianping Liu <frankjpliu@tencent.com>
> 
> __es_shrink() walks sbi->s_es_list and reclaims extents from each
> inode. On a non-preemptible kernel that walk never gives up the CPU.
> 
> There is a soft lockup report on our company's machine. The machine
> with millions of active inodes, 256 CPUs, and heavy memory pressure,
> concurrent shrinkers run too long.
> 
> i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
> taken again until the next inode. When nr_to_scan remains, call
> cond_resched_tasks_rcu_qs() before continuing the scan.
> 
> cond_resched() does not report the RCU quiescent state needed here.
> It is compiled out when CONFIG_PREEMPTION=y. Otherwise it schedules
> through preempt_schedule(), and RCU records that switch as a
> preemption. An RCU-tasks read-side section ends only at a voluntary
> context switch, cond_resched_tasks_rcu_qs(), idle, or return to
> userspace. The helper reports that voluntary quiescent state and still
> lets a non-preemptible kernel reschedule.
> 
> Changes from v1:
> - Delete time out logic.
> - Change "cond_resched" to "cond_resched_tasks_rcu_qs".

These three lines belong below the ---. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Link: https://patchwork.ozlabs.org/project/linux-ext4/patch/20261028061628.1209508-1-frankljpliu@gmail.com/
> Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
> ---
>  fs/ext4/extents_status.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 018b6146b9d8..62346eaf4350 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1721,6 +1721,16 @@ static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
>  
>  		if (nr_to_scan <= 0)
>  			goto out;
> +
> +		/*
> +		 * Report a voluntary RCU-tasks quiescent state before continuing.
> +		 * cond_resched() is not enough: it is compiled out under
> +		 * CONFIG_PREEMPTION, and otherwise switches via preemption, which
> +		 * does not end an RCU-tasks read-side section.
> +		 * This also lets a non-preemptible kernel reschedule.
> +		 */
> +		cond_resched_tasks_rcu_qs();
> +
>  		spin_lock(&sbi->s_es_lock);
>  	}
>  	spin_unlock(&sbi->s_es_lock);
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
