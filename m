Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973648;
	b=rfOm/lvZhWoQK9c2lPKKDAFL6lpTq0LWhbT29AmcO8YPwli2SwSK+SJOdNNLPVXlHmp1
	 d48LRvZV38TSJFpjRCpmvrHU+7fNVpdUyAXQZJWzW309ndO70LWrHlKLAkHQtWZWOh/+O
	 mZTr8dAQhrNk6JLnIHghxdmYH2SMeYYL/KlM+RaujaFREPLDpLGDnhFPOH0LtBcaqNq8S
	 yKoIwZBFEUAZHdnhjhYdj9+vRC6emTPflOx0waj/9RlDJyM+kTHpyq+0IGG8OrNbgiBh0
	 QOWE4wD/di9pzKK7dn8UbJKtd76d0jX4GYC1hU1O/bhTQJ7OqO03VDEP7L/gk1dDLcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973648;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=jPlpJWdi7NyNryjJIwCr2HHmGQ0FuOccYfUi3UFq+5o=;
	b=ik/YtXLEdNQPlJR/9v17RgbSgiFiAa+g1l9KM3KZudVAVXBBF37PQzA31m0t0/7FuYVT
	 ynam/UCqInyc+nohttdcmwmfjOTiKpd1KvyPvBovI14Tq1otr14aO6i5rqnou4nC6I9MK
	 m/FQiKRXyGjIxDGv6rWZrIalYQD+oYzkQuLHC1tx9PVA+DB4EUJ0peFPapO1OMfXTdZM4
	 se30SN3ggWcPuLktaIYjpuo1Oh6KssCjLGzx3N7t8R1bBaDM6GHUG+/d8r99TaAuaZ01I
	 Q6NtTAeqlWSc7uleJlXQWtGg5X2ntyc2Ujisk1VNkz0u54GlpY4oJG09dzlEbTPEAdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=J7CPtgIX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zE4I49ov;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vF9wScOA;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8GBbK90+;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8476082BD9;
	Fri,  6 Nov 2026 14:00:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B8476082BD9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=J7CPtgIX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=zE4I49ov;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vF9wScOA;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8GBbK90+
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CDB71F45A;
	Fri,  6 Nov 2026 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793973646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jPlpJWdi7NyNryjJIwCr2HHmGQ0FuOccYfUi3UFq+5o=;
	b=J7CPtgIX3F1KLC4py2du8N5yRmVc7UY13zzOMImTEEJZWqktaFiVSsRAwdWwBDB6yO2fPP
	KPWViBWoF0kB04qebr/crlVlWb9k8fGE6BV8ZWC/9wURmrDcgw2fesilTZpu7AkyKNKM0i
	HEjrBwynK76kGTz/uAKsWKODqdbNtNw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793973646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jPlpJWdi7NyNryjJIwCr2HHmGQ0FuOccYfUi3UFq+5o=;
	b=zE4I49ovzsSHXOfiydju5AMwvBouJyc7dM5/2X5gChkv7t6bTf4mWn+vbU2GJXgbsFnbja
	CzHJMM8WejTOU9CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793973645; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jPlpJWdi7NyNryjJIwCr2HHmGQ0FuOccYfUi3UFq+5o=;
	b=vF9wScOAy2oQfm/2zL0kmIjrfxH0T0E+vqegP3ICx/kklBMRBmuPYf9t7QblXxPUWHarlW
	Yhmdf+PXwllU44vOJkaJtFdwIXrNy3YUasZ5R0GTyNi0DtddtMB+0iTwRjvu3iQ7EU0l8U
	J13vJq/PWSCJwy3yX6ILDfrDB964zkg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793973645;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jPlpJWdi7NyNryjJIwCr2HHmGQ0FuOccYfUi3UFq+5o=;
	b=8GBbK90+lZlb+hJNDtdWj86zEx+2WJmvzcp0oXp6Z7YzxDRZAqQBax9RbLAiFoEqBR2Du0
	vYEBdG4su5dYT/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E610E134E9;
	Fri,  6 Nov 2026 14:00:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uN1PLYzd7Wr1VgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:00:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6A58921B74; Fri, 06 Nov 2026 15:00:29 +0100 (CET)
Date: Fri, 6 Nov 2026 15:00:29 +0100
From: Jan Kara <jack@suse.cz>
To: Jianping Liu <frankljpliu@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, frankjpliu@tencent.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix soft lockup while shrinking the extent
 status cache
Message-ID: <d3in4smnhaax2qin65hbxmdylpup4sahdpowkshcgpatxozzxy@6szn2sqo2sva>
References: <20261106033141.1509656-1-frankljpliu@gmail.com>
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
In-Reply-To: <20261106033141.1509656-1-frankljpliu@gmail.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,ozlabs.org:url,suse.cz:email,suse.com:email,tencent.com:email]
X-Spam-Score: -11.30

On Fri 06-11-26 11:31:41, Jianping Liu wrote:
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
> ---
> Changes from v1:
> - Delete time out logic.
> - Change "cond_resched" to "cond_resched_tasks_rcu_qs".
> ---
> ====================

Please, the changes since v1 should not be in the part of email that goes
to commit log. Next time please put it below diffstat. Otherwise feel free
to add:

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
