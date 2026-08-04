Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96BD4477F1
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 10:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785840087; cv=none; b=TI4s2ip521Wr7h2ddyIxi2M+YmZHDzQ3ttlPTb6f3eg6ICM2awlf5XYsZuEjzjNE4pbHwNixCwrTNGH89r8RQTQpKRvGcf7PSt44ZRoV5fChay+B2MSenNNpmTcd/dKlSEIqTqeXGhoFpgPYSS+Pbo/e7XCW8rXzujYihFlrHO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785840087; c=relaxed/simple;
	bh=pwQJuEyqKa6MkGpb3/fgKufvugCS40czbuTDZqd8Ea4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emC9nUIxMxskUguL22KH0uZMpFmQTL1kyt7Ui7cI/NLxPl6Vmj0a9djJ2otClp/2VB0m2LsN+cNtzmCKM7hrnHCgYriWfkaV5qTdREt0xNRP6O/hRlFkOSg2rMLiwpZyrZqPWMGgnQ+9DE6mw91zbiuVgNEw5stWOFBFIogcJfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jSEokNdj; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JhvmhxKg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=YqTzN7p1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=y4FXSNCd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jSEokNdj";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JhvmhxKg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="YqTzN7p1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="y4FXSNCd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 297783EC7;
	Tue,  4 Aug 2026 10:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785840075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGzZDx92G8v3MOeHfZ+Q3oPRrY/fsrYJBQEw/pqA1Bs=;
	b=jSEokNdjUfGpExF6Bx6qV/oyVjV7prMIlxVc17f7X/DZdFyx4nkQ32z1o/iKsGJzzbSEPi
	ZppT2Ld7zLLiPA7OqHTUWL/oNkTZNG5uT+5esEm7tndzP/cu1XbvG9+IYjHL7t69VMuCWK
	q1ZKSlzPPh39OzGy8ba89yidKzPgdnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785840075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGzZDx92G8v3MOeHfZ+Q3oPRrY/fsrYJBQEw/pqA1Bs=;
	b=JhvmhxKgncEo0cnWEdEpqZOPn11P1GS+mnnW7v6pVYVOEDu41FhIBgfwUvtVL8qQ5IJ6bF
	ZYvMWEhlq4wO69Bw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YqTzN7p1;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=y4FXSNCd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785840071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGzZDx92G8v3MOeHfZ+Q3oPRrY/fsrYJBQEw/pqA1Bs=;
	b=YqTzN7p1jwUNK8geyjLlFrjHmcb85tiuLRNcSTAEH97bnLa/PVM7MpiioWM9SSW6faq8zE
	fBw52ufgpyoDj9lkBblZ2y00FC51Pz4YSqtLoSRB5UPSTAxbKm6+D2zryvsEUMh3365ZXZ
	LZUUVojp3rXBb+bBqcx7MO+W95KZ0Nw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785840071;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGzZDx92G8v3MOeHfZ+Q3oPRrY/fsrYJBQEw/pqA1Bs=;
	b=y4FXSNCdZ/mXo6H9TydfuxNpi5XGNNsyiXd13e96tkOE4l4/IL653NfEKRIWkhLRe2GYnm
	eKNks6yywqIqMWAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDC7C779BB;
	Tue,  4 Aug 2026 10:41:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V7o1MsbBcWoOXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 10:41:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BCD26A13A6; Tue, 04 Aug 2026 12:41:09 +0200 (CEST)
Date: Tue, 4 Aug 2026 12:41:09 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, 
	linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: NULL/invalid pointer dereference in
 ext4_writepages() during generic/039
Message-ID: <yythlv3m2yv3ezxaw3vu3q7wasrmme4jjtjlgpck2dzx3tah5s@unp5f6beyk3w>
References: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
 <anA6s9L-cpsifqgU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <anDwoVwYf8EBCm6-@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anDwoVwYf8EBCm6-@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 297783EC7
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hello!

On Tue 04-08-26 01:18:49, Ojaswin Mujoo wrote:
> On Mon, Aug 03, 2026 at 12:22:35PM +0530, Ojaswin Mujoo wrote:
...
> > > Meanwhile, I will attempt bisection.
> > > 
> > > If you happen to fix this issue, please add below tag.
> > > 
> > > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > > 
> > 
> > Hey thanks for reporting this Venkat, I'll try to replicate this at my
> > end.
> > 
> > In the meantime, can you please share the complete Oops message and also
> > your local.config. 
> > 
> > Thanks,
> > ojaswin
> 
> (+cc Jan, Christian)
> 
> Okay so I'm able to replicate this in an x86 machine as well with 4kb
> block size. The issue is replicable in vfs/vfs.all and is occurring
> after Jan's change to nojournal mode writeout [1], with fast_commit.
> 
> The issue is as follows:
> 
>   __ext4_fill_super
>     ext4_load_and_init_journal
>       ...
>       jbd2_journal_recover
>         do_one_pass
>           fc_do_one_pass
>             ...
>             ext4_fc_replay_unlink
>               __ext4_unlink
>                 __ext4_mark_iloc_dirty
>                   if (sbi->s_journal == NULL)  // s_journal is not set yet
>                     set_inode_metadata_writeback(inode); // sets I_METADATA_WRITEBACK
>               iput(inode)
>                 iput_final(inode)
>                   ...
>                   writeback_single_inode
>                     __writeback_single_inode  // since I_METADATA_WRITEBACK is set
>                       ...
>                       ext4_writepages
>                         ext4_writepages_down_read
>                           percpu_down_read(sbi->s_writepages_rwsem)
>                              <--- OOPS because this is initialized
>                                   later in ext4_percpu_param_init()
> 
> A simple fix seems to be to move ext4_percpu_param_init() call before
> ext4_load_journal() so that we can safely call ext4_writepages(). The
> below diff seems to be fixing the issue for me, does this look okay to
> you Jan?

Thanks for report and the analysis! I didn't realize fastcommit replay
actually runs in nojournal mode. I don't think moving
ext4_percpu_param_init() is really correct - it initializes also directory,
free blocks and other counters and those depend on filesystem already being
in consistent state (i.e., after journal replay). We would have to move
just s_writepages_rwsem initialization.

That being said I think a nicer fix is to just avoid setting
I_METADATA_WRITEBACK flag during fastcommit replay. We don't really need
it for anything during replay (it flushes the whole bdev anyway), it just
slows things down by more frequent buffer writeout. I've tested that change
and it fixes the problem for me. I'll post it officially shortly.

								Honza 

> Also, venkat can you please help test this in your system:
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 2877a6cf6d09..6e05f191542c 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5511,6 +5511,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>                         goto failed_mount3a;
>         }
> 
> +       err = ext4_percpu_param_init(sbi);
> +       if (err)
> +               goto failed_mount3a;
> +
>         err = -EINVAL;
>         /*
>          * The first inode we look at is the journal inode.  Don't try
> @@ -5659,10 +5663,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>                         clear_opt2(sb, MB_OPTIMIZE_SCAN);
>         }
> 
> -       err = ext4_percpu_param_init(sbi);
> -       if (err)
> -               goto failed_mount5;
> -
>         err = ext4_mb_init(sb);
>         if (err) {
>                 ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
> @@ -5764,7 +5764,6 @@ failed_mount8: __maybe_unused
>         ext4_mb_release(sb);
>         ext4_flex_groups_free(sbi);
>  failed_mount5:
> -       ext4_percpu_param_destroy(sbi);
>         ext4_ext_release(sb);
>         ext4_release_system_zone(sb);
>  failed_mount4a:
> @@ -5785,6 +5784,7 @@ failed_mount8: __maybe_unused
>                 ext4_journal_destroy(sbi, sbi->s_journal);
>         }
>  failed_mount3a:
> +       ext4_percpu_param_destroy(sbi);
>         ext4_es_unregister_shrinker(sbi);
>  failed_mount3:
>         /* flush s_sb_upd_work before sbi destroy */
> 
> [1] https://lore.kernel.org/linux-ext4/20260727104923.3828017-37-jack@suse.cz/
> > > 
> > > 
> > > Thanks,
> > > Venkat.
> > > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
