Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525878;
	b=xFYCO/TKr/djcGU/o5t4XiJMx8yHBEbZvFQ0HWeXL3agwHG3Nh3ar8tm+CT+sZPJ3k7K
	 CKmVmATIrhq0kf0jhiE4SZ6jFklh9jJZax7jzERfkH4iCYC3bjFBzcoa2fnp/7fZzuhKl
	 I82xCyvNmnMl3ihHwYAXfeIEu3RRArqJ3itr0Lbv2E0Yiv66l4l0EsX3QxmIRuYkobrnf
	 L1JhcishqnI8LuvAkfcTlo876lgZQNMMF50L2vImPTMK/VlvsZmzC+bkUhEaz9UIDeAAM
	 VfDBnwW+Fk2J+OLvDDfPgb2zYjgfaTqZTxWiZ4BiJ/1f2RKQiwum1aOzeDHSBcOv1uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525878;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=kImpN243il/m6cW85e/gH4bVqjy4IhF4ylFKjsc2Ui/juirsceKl5rrKkUjiNKCRMzvP
	 xF0QAX5Yr3GlNvJmu6bROjtLIZhSMckrgoVKM1iM60ST9Ua/RCpXxq/8JqRyQNwIkdq84
	 m5+0SMHATQYGmMu/O6lXQV73j7WopB8iz7OQLEey8DykYa9llWQ7RGBbtRxrlEBUniJ3Y
	 w/foR/zn92Rdrm8rLM2t30oHv5lG5dR6ilPwdSr31jN2vOLADLjoQadNIUOsMHTi1fqKS
	 L96pcYGcXZ+SxacsPjPy5rpKAGZ2hSMaOuYFMVag1Tzo0qivxjstUP2hziLYNQZUtIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B098606A31E;
	Tue, 24 Nov 2026 13:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B098606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rb5wOvWb;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EeUYJByg
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F40C21FDD;
	Tue, 24 Nov 2026 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=rb5wOvWbiiQFQufaaSQ6BhFGSvCEohd4nZR+CQo4KfMnxUX/jKgoquVwMwELJj2awY61aH
	siLKadWiKTIL8cEQ1IA5VX1COpvGbtTnMb/YwAc698svrqR3Ex6JetzQyK1eq26CquRo+x
	kTqpmWj4804vqch1ZhSuPS240hA90po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=EeUYJBygel5fY8HrGoffaBTuMuyzXz8uIOK6uwho7Wcybt9v6VWfU/4ukG+s5rFwn4sayM
	3KpicyNzRDxErmDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=rb5wOvWbiiQFQufaaSQ6BhFGSvCEohd4nZR+CQo4KfMnxUX/jKgoquVwMwELJj2awY61aH
	siLKadWiKTIL8cEQ1IA5VX1COpvGbtTnMb/YwAc698svrqR3Ex6JetzQyK1eq26CquRo+x
	kTqpmWj4804vqch1ZhSuPS240hA90po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un7OFeotv/cgwVEZk3ji5A5Uvj3bLR4SzF33G0c+QYI=;
	b=EeUYJBygel5fY8HrGoffaBTuMuyzXz8uIOK6uwho7Wcybt9v6VWfU/4ukG+s5rFwn4sayM
	3KpicyNzRDxErmDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 016BF13505;
	Tue, 24 Nov 2026 13:11:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Imu+MPOMBWvkMwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 13:11:15 +0000
Date: Tue, 24 Nov 2026 13:11:14 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yi Wen <shicenci@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [BUG] mm/gup: WARNING: mm/page-writeback.c:2678 at
 __folio_mark_dirty on v7.4-rc3
Message-ID: <awWMsf-5RMa-TdGu@pedro-suse.tail5790ac.ts.net>
References: <CAPHJ_V+_=Av8pAM+N+oc4JRmtqBjhcimh3B_pSy_N+5qecm6Mg@mail.gmail.com>
 <f8cc1652-7577-4ace-97ed-081ecd65a031@kernel.org>
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
In-Reply-To: <f8cc1652-7577-4ace-97ed-081ecd65a031@kernel.org>
X-Spamd-Result: default: False [-13.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kvack.org,vger.kernel.org,suse.cz,nvidia.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.30
X-Spam-Level: 
X-Spam-Flag: NO

On Sat, Nov 21, 2026 at 05:44:34PM +0100, David Hildenbrand (Arm) wrote:
> On 11/21/26 15:49, Yi Wen wrote:
> > Hi,
> > 
> > I am reporting a kernel WARNING triggered by a syzkaller reproducer on
> > Linux v7.4-rc3.
> > 
> > The reproducer triggers a WARNING in ext4_dirty_folio() when
> > process_vm_writev() writes to a file-backed mapping.
> > 
> > The call trace shows that the warning occurs during the GUP page
> > unpinning and dirtying path:
> > 
> > process_vm_writev()
> >   -> process_vm_rw_core()
> >     -> unpin_user_pages_dirty_lock()
> >       -> folio_mark_dirty()
> >         -> ext4_dirty_folio()
> > 
> > A second WARNING is subsequently triggered in __folio_mark_dirty() in
> > mm/page-writeback.c.
> > 
> > This appears to be related to the interaction between GUP-based page
> > dirtying and filesystem-managed folio metadata. In particular, the GUP
> > dirtying path may mark a file-backed folio dirty without ensuring that
> > the filesystem-specific metadata required by its dirty_folio()
> > implementation remains available.
> > 
> > This may be related to the known issue where GUP-based page dirtying
> > does not properly notify the filesystem through page_mkwrite(), as
> > well as the interaction between GUP dirtying and
> > filemap_release_folio().
> > 
> > Before these warnings, all four ext4 loop devices also report delayed
> > block allocation errors and abnormal free block accounting. These
> > errors may indicate an additional filesystem inconsistency and are
> > included in the console log for further investigation.
> > 
> 
> Hi,
> 
> thanks for the report.
> 
> Did you only find this through syzcaller or by the help of an LLM?
> 
> I'm asking because the timing is interesting; this should be one of the problems
> discussed by:
> 
> https://lore.kernel.org/r/20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de
> 
> CCing Pedro, John und Jan.

Yep, looks likely to be the same bug.

-- 
Pedro
