Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72347B425;
	Wed,  2 Sep 2026 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361171; cv=none; b=pKh17dpIXBbDlVDV6mvzd+k86YeB4peKAbKoOVbIPUyRVZzv2p0gR6zzIF1/V+s0DuSUo/I/5oW39icNZtGxfvd2R8yQYe222UXuk6kSmy5Xl2hyihZsp0WQVpu9EiayAmgGsOw2Alo7MnQktpvx6UeOHzH9F8g1LlfPFsk2dBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361171; c=relaxed/simple;
	bh=79ZxtgMv4NtZbp2/OToanKGcKXjFhCALuvVZpUrfRRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0jDyBcuDgeyrhReNiMqRjuaR7xeONrW2nIrWRcSGzEqNV7NiN5u1lI9hl3UYm8KrgugDD/g94aUQ3dxKHBY4AK+u/FMsQ1KcSmSGR+IPqKPeHlNhYdRH3HxQ7NXNGodjmNqp/r1MofH154m2CdbXHy+91Qc9a/nHg6iLs+1JmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ye+KcZzH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=8LHFpd4D; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=il77Q9/Q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PQMq6emw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ye+KcZzH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="8LHFpd4D";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="il77Q9/Q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PQMq6emw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8299D21DE5;
	Wed,  2 Sep 2026 14:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rrq0m+HpGXXCKOHD8vYL63/0Jp51xgD11AWzQyOtLh4=;
	b=Ye+KcZzH6C25h2rb12yiRsA33cCyesJCa4EPOnzh0s7RSpONffDqMgANPguqT03npvVSdP
	MDWPG6l9zGF+1VrMQlJVAwpYH59T0byU+/czyJTGDl8RVz1L730vvUwpcKEf1eAzdcHHgh
	64Xrb7j1GhRinD5XICsvQsrRyRm/aJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361156;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rrq0m+HpGXXCKOHD8vYL63/0Jp51xgD11AWzQyOtLh4=;
	b=8LHFpd4DpKfQ4VV2Fh1MBbbffLaJayqqXrTp8ZAMEI35tkBYNC0NXDU8k0RrdeH7eQy2dv
	h52SpK4g2/soYbCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788361152; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rrq0m+HpGXXCKOHD8vYL63/0Jp51xgD11AWzQyOtLh4=;
	b=il77Q9/QcJi2QRCjtr8DfcjCAs53huDVRyJp/ohg7Kwadxuq+Qru2064JwKUiw9vj7LLV6
	YNliM1flKCQ1ki4mw1eRias0q6DXUslVI0UVwMWSeHl7o/9WaF+Np2Trtr7pL1lY9EsiFA
	8PkgdmOnF7ohETkD93PQRFFyGyCXtL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788361152;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rrq0m+HpGXXCKOHD8vYL63/0Jp51xgD11AWzQyOtLh4=;
	b=PQMq6emwpFzRUYNqla/u/fcB1VH4fFl0BQ+i+xFR9kTNbKZbZ/otbd7zKw/HjYy4EmrRbj
	gm81YZ8GZQgJIlAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62BC713736;
	Wed,  2 Sep 2026 14:59:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qjsgGMA5mGqENQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 02 Sep 2026 14:59:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0861BA13B5; Wed, 02 Sep 2026 16:59:08 +0200 (CEST)
Date: Wed, 2 Sep 2026 16:59:08 +0200
From: Jan Kara <jack@suse.cz>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4, doc: remove unnecessary bracket
Message-ID: <j2ygt4o6ydaa7htu6q5oiady244tniyojbk7xbqth2ggqkx5da@e6aiky7cuyhk>
References: <20260902143254.702971-2-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902143254.702971-2-manuelebnerli@mailbox.org>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,lwn.net,linuxfoundation.org,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mailbox.org:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]

On Wed 02-09-26 16:32:53, Manuel Ebner wrote:
> Remove needless '('.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/ext4/directory.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation/filesystems/ext4/directory.rst
> index 9b003a4d4..f3eeca844 100644
> --- a/Documentation/filesystems/ext4/directory.rst
> +++ b/Documentation/filesystems/ext4/directory.rst
> @@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used to store a
>  ``count`` entries in the dx_root/dx_node structures are adjusted as
>  necessary to fit the dx_tail into the block. If there is no space for
>  the dx_tail, the user is notified to run e2fsck -D to rebuild the
> -directory index (which will ensure that there's space for the checksum.
> +directory index which will ensure that there's space for the checksum.
>  The dx_tail structure is 8 bytes long and looks like this:
>  
>  .. list-table::
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
