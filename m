Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF5E390989
	for <linux-ext4@vger.kernel.org>; Mon,  1 Jun 2026 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780306198; cv=none; b=OIIl8kjhdvwKjBtcTazCyv9RPplCcEJQ4tLQ4/xpSOObMj1lAOA8KfqTs3Si4sfmLoNNuj4796KZmm5lsB3QzqVGJcOoSuGuvTXtMuuBp6cG+FY8EC92PVIoPv9XLW7ioRDmb6kMpYgs7c75llM2PGc/n9FLU9L2OHmfEv1lMa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780306198; c=relaxed/simple;
	bh=gcL11uWBi7+521a/swSLxsPdFD2yXU9/tDxeGdKh5o0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TauROgLdGDGo8jO0wLT5Nsw0kcjx8NipKvZkLR/oQd0rS/x0Shz3sS/ueWS+ZekqmnGpQ3dZsBZttWomt9cu6GsVX6geFZuLU9nGIDExTuOhICZH7L1Yum1Ro4VRFmZcmWHS5l7TfaYTkcGS4A/8c6oVJNgBseQwuNneXO2PUes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fT7eOk2/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LwwhhpTX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fT7eOk2/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=LwwhhpTX; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fT7eOk2/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LwwhhpTX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fT7eOk2/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="LwwhhpTX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C2B1F66D2E;
	Mon,  1 Jun 2026 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780306193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DapO5g55BWAO53IfVTKZC7bT6Fm/+2GfVus0svtSJFk=;
	b=fT7eOk2/+UsyVlLrozFsMvCcWnr9ZXOHcM+uKQhDqBNPvbLUcYpVin6v6zuzS2AbHFdCRX
	1aiUj6rU/IbIhziR7gUdOdTr3wW3FuyRC8pFyB0C5g8XNhtMk/aCAZtO87d4Y/ohaDfvaA
	vUWieYv/CteBaU3ojBdGa0BJ6bLQoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780306193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DapO5g55BWAO53IfVTKZC7bT6Fm/+2GfVus0svtSJFk=;
	b=LwwhhpTXUFUQlTN5Sf45zrIoZT92R2K9DJJT4orI9YSAJEJeUE8jb/NSB3nFI6g5HLH6ru
	vXqVgTQBI8SlpRCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fT7eOk2/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LwwhhpTX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780306193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DapO5g55BWAO53IfVTKZC7bT6Fm/+2GfVus0svtSJFk=;
	b=fT7eOk2/+UsyVlLrozFsMvCcWnr9ZXOHcM+uKQhDqBNPvbLUcYpVin6v6zuzS2AbHFdCRX
	1aiUj6rU/IbIhziR7gUdOdTr3wW3FuyRC8pFyB0C5g8XNhtMk/aCAZtO87d4Y/ohaDfvaA
	vUWieYv/CteBaU3ojBdGa0BJ6bLQoT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780306193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DapO5g55BWAO53IfVTKZC7bT6Fm/+2GfVus0svtSJFk=;
	b=LwwhhpTXUFUQlTN5Sf45zrIoZT92R2K9DJJT4orI9YSAJEJeUE8jb/NSB3nFI6g5HLH6ru
	vXqVgTQBI8SlpRCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADBD1779A7;
	Mon,  1 Jun 2026 09:29:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hhRpKhFRHWqyUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 01 Jun 2026 09:29:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 54F76A0EBE; Mon, 01 Jun 2026 11:29:53 +0200 (CEST)
Date: Mon, 1 Jun 2026 11:29:53 +0200
From: Jan Kara <jack@suse.cz>
To: Ashwin Gundarapu <linuxuser509@zohomail.in>
Cc: kernel test robot <lkp@intel.com>, jack <jack@suse.com>, 
	oe-kbuild-all <oe-kbuild-all@lists.linux.dev>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] ext2: Remove deprecated DAX support
Message-ID: <mcagjzg2lqxqvhbfschylrc345m33367fue24vfuh6cuh6vybr@khd5lm7ur34p>
References: <19e5aa07c9b.3a2e576d130187.5289857983023045470@zohomail.in>
 <202605281203.e91xvDyr-lkp@intel.com>
 <19e6db0f597.25d55d43200914.4102954258751814923@zohomail.in>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e6db0f597.25d55d43200914.4102954258751814923@zohomail.in>
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C2B1F66D2E
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,git-scm.com:url,01.org:url,suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Thu 28-05-26 13:56:14, Ashwin Gundarapu wrote:
> This indentation warning is from pre-existing code (originally written in
> 2010) that my patch did not touch. I prefer to keep this patch focused
> solely on removing deprecated DAX support. A separate cleanup patch can
> be submitted later if desired.

Actually no, your patch indeed introduced several indentation problems (by
removing some conditions but not reindenting internal blocks). Also there
were some spurious empty lines added. No need to resend, I've fixed that up
on commit. Thanks for the patch.

								Honza


> Regards,
> Ashwin Gundarapu
> 
> From: kernel test robot <lkp@intel.com>
> To: "Ashwin Gundarapu"<linuxuser509@zohomail.in>, "jack"<jack@suse.com>
> Cc: <oe-kbuild-all@lists.linux.dev>, "linux-ext4"<linux-ext4@vger.kernel.org>, "linux-kernel"<linux-kernel@vger.kernel.org>
> Date: Thu, 28 May 2026 09:46:32 +0530
> Subject: Re: [PATCH v4] ext2: Remove deprecated DAX support
> 
>  > Hi Ashwin, 
>  >  
>  > kernel test robot noticed the following build warnings: 
>  >  
>  > [auto build test WARNING on jack-fs/for_next] 
>  > [also build test WARNING on linus/master v7.1-rc5 next-20260527] 
>  > [If your patch is applied to the wrong git tree, kindly drop us a note. 
>  > And when submitting patch, we suggest to use '--base' as documented in 
>  > https://git-scm.com/docs/git-format-patch#_base_tree_information] 
>  >  
>  > url: https://github.com/intel-lab-lkp/linux/commits/Ashwin-Gundarapu/ext2-Remove-deprecated-DAX-support/20260524-233631 
>  > base: https://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_next 
>  > patch link: https://lore.kernel.org/r/19e5aa07c9b.3a2e576d130187.5289857983023045470%40zohomail.in 
>  > patch subject: [PATCH v4] ext2: Remove deprecated DAX support 
>  > config: arm-randconfig-r071-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281203.e91xvDyr-lkp@intel.com/config) 
>  > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261) 
>  > smatch: v0.5.0-9185-gbcc58b9c 
>  >  
>  > If you fix the issue in a separate patch/commit (i.e. not just a new version of 
>  > the same patch/commit), kindly add following tags 
>  > | Reported-by: kernel test robot <lkp@intel.com> 
>  > | Closes: https://lore.kernel.org/oe-kbuild-all/202605281203.e91xvDyr-lkp@intel.com/ 
>  >  
>  > smatch warnings: 
>  > fs/ext2/inode.c:1251 ext2_setsize() warn: inconsistent indenting 
>  >  
>  > vim +1251 fs/ext2/inode.c 
>  >  
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1236 
>  > 2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1237  static int ext2_setsize(struct inode *inode, loff_t newsize) 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1238  { 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1239      int error; 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1240 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1241      if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) || 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1242          S_ISLNK(inode->i_mode))) 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1243          return -EINVAL; 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1244      if (ext2_inode_is_fast_symlink(inode)) 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1245          return -EINVAL; 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1246      if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1247          return -EPERM; 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1248 
>  > 562c72aa57c36b1 Christoph Hellwig 2011-06-24  1249      inode_dio_wait(inode); 
>  > 562c72aa57c36b1 Christoph Hellwig 2011-06-24  1250 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27 @1251              error = block_truncate_page(inode->i_mapping, 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1252                                  newsize, ext2_get_block); 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1253      if (error) 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1254          return error; 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1255 
>  > 70f3bad8c3154ba Jan Kara          2021-04-12  1256      filemap_invalidate_lock(inode->i_mapping); 
>  > 2c27c65ed0696f0 Christoph Hellwig 2010-06-04  1257      truncate_setsize(inode, newsize); 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1258      __ext2_truncate_blocks(inode, newsize); 
>  > 70f3bad8c3154ba Jan Kara          2021-04-12  1259      filemap_invalidate_unlock(inode->i_mapping); 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1260 
>  > 5cdc59fce617a2e Jeff Layton       2023-10-04  1261      inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode)); 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1262      if (inode_needs_sync(inode)) { 
>  > b0439bbc29f0201 Jan Kara          2026-03-26  1263          mmb_sync(&EXT2_I(inode)->i_metadata_bhs); 
>  > c37650161a53c01 Christoph Hellwig 2010-10-06  1264          sync_inode_metadata(inode, 1); 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1265      } else { 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1266          mark_inode_dirty(inode); 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1267      } 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1268 
>  > 737f2e93b9724a3 Nicholas Piggin   2010-05-27  1269      return 0; 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1270  } 
>  > ^1da177e4c3f415 Linus Torvalds    2005-04-16  1271 
>  >  
>  > -- 
>  > 0-DAY CI Kernel Test Service 
>  > https://github.com/intel/lkp-tests/wiki 
>  >  
>  > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
