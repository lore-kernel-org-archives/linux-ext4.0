Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CAD3F9263
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2026 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725396; cv=none; b=kzAwgOTyRJNJvTMmhIuKbr824xzxm9dSGHDy/2cTT3wMKIEVhEk+Op4rpTRMFF+i3M+jcqS4pp7pT7LCnwVfVtmyqM3fDBx/AeH9MTtBgFT67q+mvP9CECqISvwEeyOO/e/IY8B5ACA/XhhXWAUqXUlfrixQHVRl+OlxNl3G75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725396; c=relaxed/simple;
	bh=VxGyG4p9IOnFXWxy++Pd1AoFVACVfXbvkn0D1DvNCPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kkw8cey68n3C4lSLX1gqcwZWbSS4h8BunWY0EITjypoH84KCJhKj9qDXDMOvZraw1nclFFnzp/gaBWr+gOdEOZPRl0aUQX85/6hSe+Mw0LrEAPMgXgtusOZFA9igcjlmc7AsyElRiabkLtVjRN9vvKM44QTmucEc5HLe02dBmdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ID/I4i4C; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tDuU6I9z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=xx9Z3uXh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IaggPmqy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ID/I4i4C";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tDuU6I9z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="xx9Z3uXh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IaggPmqy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D942872FC4;
	Mon, 29 Jun 2026 09:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782725393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1iy7OV2tRyNTPjGcBzvpOAFg/23ekXQpGVfLav98/k=;
	b=ID/I4i4Cxqmqk3MnxqazPTBRTdGAvt4/nGesImoji8ShFkwlwF5lJ/9pHiEVHzYaJ52ju/
	kJUSwXAMtGQ89AcUHK8222ko7hkuxUaU+MXKaQO14cx7xFlwZD3dEMzqLgH/YGdcfjtTyy
	HAMkQ/HTjVtRXbHFtDfblqPyToWPBJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782725393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1iy7OV2tRyNTPjGcBzvpOAFg/23ekXQpGVfLav98/k=;
	b=tDuU6I9zmRcPqKRJ40tCQ3/r3XkW/UB/W2Wir0bymK69c80r+2LYlngBoraZHuvNrNf3YV
	ffQdNyGKhKuvHMDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782725391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1iy7OV2tRyNTPjGcBzvpOAFg/23ekXQpGVfLav98/k=;
	b=xx9Z3uXhfUxrGgUZ+kf3OLU0J3SqaIX6O3e+zk473TdBcKYe/CZIQPPeAI9iu2wA97jCDw
	HbAjlCoc0VjzKXAGcR8ZzObuOg1aAjrH8/7gitk2U90dVie0dp/eF7kxw0HOnEmvlu94Nc
	rQTFdTQ8JYQQFCA6rJQdU5/pZABWFZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782725391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S1iy7OV2tRyNTPjGcBzvpOAFg/23ekXQpGVfLav98/k=;
	b=IaggPmqyicNsbQ7lKV1GoCVocuZhgIJaCMPf+Kh2JI3XxcvvNreBS5Yi3Vs28692o/KBJR
	VQWbJTwvhFkdRJAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C81E9779A8;
	Mon, 29 Jun 2026 09:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v8nXMA87QmrnXAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 29 Jun 2026 09:29:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54F79A10B5; Mon, 29 Jun 2026 11:29:51 +0200 (CEST)
Date: Mon, 29 Jun 2026 11:29:51 +0200
From: Jan Kara <jack@suse.cz>
To: Xianying Wang <wangxianying546@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel BUG in __ext4_journal_stop
Message-ID: <ftl6dnudrvbwux7ptcv7l4az3cygysyaigpcik62uj6wdvxq6u@pzabzi5sgby4>
References: <CAOU40uDfHk-8FxOuHO=rWcfjN0cV4psXhgdxckYhgaoaGZ51qg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOU40uDfHk-8FxOuHO=rWcfjN0cV4psXhgdxckYhgaoaGZ51qg@mail.gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,pastebin.com:url]
X-Spam-Level: 

Hi!

On Mon 29-06-26 14:43:55, Xianying Wang wrote:
> I would like to report that this bug has been reported before, but it
> can still be triggered on Linux 7.1-rc5 by a syzkaller reproducer.
> 
> The issue is a kernel BUG in the ext4 inline-data write path. Before
> the crash, ext4 reports corrupted block allocation metadata:
> 
> EXT4-fs error: ext4_mb_generate_buddy: group 0, block bitmap and bg
> descriptor inconsistent
> 
> The crash happens while the reproducer is writing to an ext4 file
> through sendfile64(). The write path reaches the ext4 buffered write
> and inline-data write-end code, and then triggers a BUG when stopping
> the journal handle.

Thanks for report but frankly, we have no capacity to analyze every fuzzing
report somebody comes with. We generally look with higher priority at
Syzbot produced fuzzing results because it provides environment for
tracking of reproducers, easy access to artifacts, etc. which significantly
speeds up analysis.

For example in this case I couldn't even access the console log at
pastebin to check the exact BUG message.

								Honza

> Based on the execution context, the issue appears to be related to the
> interaction between corrupted ext4 block allocation metadata and the
> inline-data buffered write path. After ext4 detects that the block
> bitmap and block group descriptor are inconsistent, the sendfile64()
> write still proceeds into ext4_write_inline_data_end(). During this
> phase, ext4 needs to update inline-data/inode metadata and stop the
> journal transaction. However, the journal handle or the inline-data
> write state appears to be inconsistent, and __ext4_journal_stop()
> eventually hits an internal BUG_ON().
> 
> So the suspected problem is that the ext4 error handling path after
> detecting corrupted allocation metadata does not fully prevent the
> inline-data write-end path from continuing with an invalid or
> unexpected journal handle state. This results in a kernel BUG in
> __ext4_journal_stop().
> 
> This can be reproduced on:
> 
> HEAD commit:
> 
> e7ae89a0c97ce2b68b0983cd01eda67cf373517d
> 
> report: https://pastebin.com/raw/1aWWc2Uj
> 
> console output : https://pastebin.com/raw/MS8YxkTn
> 
> kernel config : https://pastebin.com/raw/fUwrL2uz
> 
> C reproducer : https://pastebin.com/raw/HgPfLbKs
> 
> Let me know if you need more details or testing.
> 
> Best regards,
> 
> Xianying
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
