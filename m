Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C647604A;
	Tue, 13 Oct 2026 12:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893823; cv=none; b=mXrXKgyGHTI6QtC0EKavM3d2bxR/3NSFXPZAtEf+M8A88zezyF2qpo6hI4bGBfFYMMVng0hP9W/i+R8mI2vofwlaVFYb0BWbjvVk+Cpr5rUVVKCQbU8puZ6Fhkf3HXtydom/5CE6zKJAzb6tiAAWvrqXcLOqxRVmyuL7+q0riW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893823; c=relaxed/simple;
	bh=G8PGqIrQ5k77evT2wG7WUTBFPlNbw5frBEVT5qJlGVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N8OwECyJNDThwT0pXxPNsX+xsr6ZXhqwfhhFBpvt2gORpxk4J+yeYb4cyeM+kNq+vcDR+BD252SvbT5Kv/TspYaW27xoBQwMVVjNA3MEW6dDG1iT4lrfHxNdTLZeggtfCoLqqcwhZRTJlx0Ql3VaTircKyJsBz95Li6xBwgWWY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0sKq94An; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6p47P9iC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0sKq94An; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6p47P9iC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0sKq94An";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6p47P9iC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0sKq94An";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6p47P9iC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 38DB51F452;
	Tue, 13 Oct 2026 12:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791893819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIWtiPrsYf/toAj2P9j+sTaCeU3Ul60tHOhLtN5agvw=;
	b=0sKq94AnOavcl7gDRZOyLluSHmY5g71LY5JROosKZsO1N1IdLZlZBrRfVzCXSFJQOBTuN3
	w9hKyDiEaoNm/F8NtqM9TT018p4WsZRQe8/4iA7QLDAqvxDqi+o3U0+3gwS4TgI26JZhLv
	fFN6wG9dXmft+KkzK2+FPGchHHt8dPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791893819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIWtiPrsYf/toAj2P9j+sTaCeU3Ul60tHOhLtN5agvw=;
	b=6p47P9iCrndYpS5aCQ79HN/DuH3C4+9dKrkHYxNlLiQk0K6p8z9D4Jwwo1wlBB5G/l1AOE
	lglU1CzvRYmwp6Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791893819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIWtiPrsYf/toAj2P9j+sTaCeU3Ul60tHOhLtN5agvw=;
	b=0sKq94AnOavcl7gDRZOyLluSHmY5g71LY5JROosKZsO1N1IdLZlZBrRfVzCXSFJQOBTuN3
	w9hKyDiEaoNm/F8NtqM9TT018p4WsZRQe8/4iA7QLDAqvxDqi+o3U0+3gwS4TgI26JZhLv
	fFN6wG9dXmft+KkzK2+FPGchHHt8dPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791893819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIWtiPrsYf/toAj2P9j+sTaCeU3Ul60tHOhLtN5agvw=;
	b=6p47P9iCrndYpS5aCQ79HN/DuH3C4+9dKrkHYxNlLiQk0K6p8z9D4Jwwo1wlBB5G/l1AOE
	lglU1CzvRYmwp6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 10B7813341;
	Tue, 13 Oct 2026 12:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6fCqNzohzmoPIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:16:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 940F0A1407; Tue, 13 Oct 2026 14:16:54 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:16:54 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-afs@lists.infradead.org, v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	ntfs3@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH 6/8] unicode: free the map after a grace period
Message-ID: <ytvtvt4ejwcfm63jcmrqz7hdktsmp4tg55ddliwnrgvotuwngm@wljc272orwac>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-work-fixes-rcu-v1-6-7446d2d335e6@kernel.org>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri 09-10-26 23:51:56, Christian Brauner wrote:
> generic_ci_d_hash() and generic_ci_d_compare() read sb->s_encoding and
> dereference the unicode map while a pathwalk in rcu mode holds nothing
> but rcu_read_lock(). The filesystems that use them, ext4, f2fs and
> tmpfs, drop the map with utf8_unload() from ->put_super(), which runs
> when the last reference to the mount goes away. A lookup that is still
> inside such a filesystem at that point reads a freed map.
> 
> With a pathwalk held up in utf8_casefold_hash() while the last reference
> to a casefolded tmpfs goes away:
> 
>   BUG: KASAN: slab-use-after-free in utf8nlookup+0x74c/0x950
>   Read of size 8 at addr ff110001030fe658 by task walker/98
>   Call Trace:
>    <TASK>
>    utf8nlookup+0x74c/0x950
>    utf8byte+0x160/0x1560
>    utf8_casefold_hash+0x167/0x230
>    generic_ci_d_hash+0xdd/0x1c0
>    link_path_walk+0x11ad/0x1d30
>    path_lookupat+0x63/0xb00
>    filename_lookup+0x1f1/0x5b0
>    vfs_statx+0xd7/0x3b0
>   [...]
>   Allocated by task 94:
>    __kmalloc_cache_noprof+0x249/0x560
>    utf8_load+0x4e/0x570
>    shmem_parse_opt_casefold.isra.0+0x92/0x270
>   [...]
>   Freed by task 97:
>    kfree+0x1db/0x5b0
>    shmem_put_super+0x72/0x170
>    generic_shutdown_super+0x14c/0x530
>    kill_anon_super+0x3a/0x60
>    deactivate_locked_super+0x9c/0xf0
>    cleanup_mnt+0x9f/0x130
> 
> So far that has been hard to hit. umount(2) waits for a grace period
> in namespace_unlock() before it drops the mount, so only a mount whose
> last reference goes away elsewhere, like the close of a file or a chdir
> out of a lazily unmounted directory, can race a walker. So it is
> reachable.
> 
> Delay the free until a grace period has passed. The map and the data
> table it holds a reference to then outlive any pathwalk that found the
> superblock before the mount went away. The reference on the data table
> module is dropped from the rcu callback as well. utf8-core is built in
> whenever CONFIG_UNICODE is set, so there is no module exit that would
> have to wait for the callbacks.
> 
> Overlayfs points the s_encoding of an overlay at the map of its first
> layer without taking a reference of its own. That stays correct. The
> layer is held by the overlay, so its map is dropped only after the
> overlay is gone.
> 
> Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Reproducer: delay.c holds a task named walker in utf8_casefold_hash() in
> rcu pathwalk mode for two seconds and repro.c drops the last reference
> to a lazily unmounted casefolded tmpfs meanwhile.
> 
>     mount -t tmpfs -o casefold tmpfs /mnt
>     chattr +F /mnt
>     echo hello > /mnt/Foo
>     insmod delay.ko
>     ./repro
> 
> Without this patch that gives the splat above, with it it runs clean.
> 
> delay.c:
> 
>     #include <linux/delay.h>
>     #include <linux/kprobes.h>
>     #include <linux/module.h>
> 
>     /* keep a task named "walker" in utf8_casefold_hash() in rcu pathwalk */
>     static int pre(struct kprobe *p, struct pt_regs *regs)
>     {
>     	if (!strcmp(current->comm, "walker"))
>     		mdelay(2000);
>     	return 0;
>     }
> 
>     static struct kprobe kp = {
>     	.symbol_name	= "utf8_casefold_hash",
>     	.pre_handler	= pre,
>     };
> 
>     static int __init delay_init(void)
>     {
>     	return register_kprobe(&kp);
>     }
> 
>     static void __exit delay_exit(void)
>     {
>     	unregister_kprobe(&kp);
>     }
> 
>     module_init(delay_init);
>     module_exit(delay_exit);
>     MODULE_LICENSE("GPL");
> 
> repro.c:
> 
>     #define _GNU_SOURCE
>     #include <pthread.h>
>     #include <sched.h>
>     #include <string.h>
>     #include <sys/mman.h>
>     #include <sys/mount.h>
>     #include <sys/prctl.h>
>     #include <sys/stat.h>
>     #include <unistd.h>
> 
>     static void pin(int cpu)
>     {
>     	cpu_set_t set;
> 
>     	CPU_ZERO(&set);
>     	CPU_SET(cpu, &set);
>     	sched_setaffinity(0, sizeof(set), &set);
>     }
> 
>     static void *walker(void *arg)
>     {
>     	struct stat st;
>     	char *p;
> 
>     	/*
>     	 * The delay spins. Empty this cpu's lru batches so that an
>     	 * lru_add_drain_all() on the other side has no work to wait for here.
>     	 */
>     	pin(1);
>     	p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     	memset(p, 1, 4096);
>     	madvise(p, 4096, MADV_COLD);
> 
>     	prctl(PR_SET_NAME, "walker");
>     	stat("FOO", &st);
>     	return NULL;
>     }
> 
>     int main(void)
>     {
>     	struct stat st;
>     	pthread_t t;
> 
>     	pin(0);
>     	chdir("/mnt");
>     	stat("FOO", &st);
>     	/* the cwd now holds the last reference to the mount */
>     	umount2("/mnt", MNT_DETACH);
>     	pthread_create(&t, NULL, walker, NULL);
>     	sleep(1);
>     	/* drop it, ->kill_sb() runs before chdir() returns */
>     	chdir("/");
>     	pthread_join(t, NULL);
>     	return 0;
>     }
> ---
>  fs/unicode/utf8-core.c  | 21 +++++++++++++++++----
>  include/linux/unicode.h |  1 +
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/unicode/utf8-core.c b/fs/unicode/utf8-core.c
> index f313532f5e80..74a74a48dd8b 100644
> --- a/fs/unicode/utf8-core.c
> +++ b/fs/unicode/utf8-core.c
> @@ -3,6 +3,7 @@
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
> +#include <linux/rcupdate.h>
>  #include <linux/parser.h>
>  #include <linux/errno.h>
>  #include <linux/stringhash.h>
> @@ -183,12 +184,24 @@ struct unicode_map *utf8_load(unsigned int version)
>  }
>  EXPORT_SYMBOL(utf8_load);
>  
> +static void utf8_unload_rcu(struct rcu_head *head)
> +{
> +	struct unicode_map *um = container_of(head, struct unicode_map, rcu);
> +
> +	symbol_put(utf8_data_table);
> +	kfree(um);
> +}
> +
> +/*
> + * A pathwalk in rcu mode may still be in ->d_hash() or ->d_compare() of a
> + * filesystem that is being torn down and read the map through its
> + * superblock, so the map and the tables it points to have to outlive the
> + * grace period.
> + */
>  void utf8_unload(struct unicode_map *um)
>  {
> -	if (um) {
> -		symbol_put(utf8_data_table);
> -		kfree(um);
> -	}
> +	if (um)
> +		call_rcu(&um->rcu, utf8_unload_rcu);
>  }
>  EXPORT_SYMBOL(utf8_unload);
>  
> diff --git a/include/linux/unicode.h b/include/linux/unicode.h
> index 64fa44fe180c..3a8cb603eb93 100644
> --- a/include/linux/unicode.h
> +++ b/include/linux/unicode.h
> @@ -53,6 +53,7 @@ struct unicode_map {
>  	unsigned int version;
>  	const struct utf8data *ntab[UTF8_NMAX];
>  	const struct utf8data_table *tables;
> +	struct rcu_head rcu;
>  };
>  
>  int utf8_validate(const struct unicode_map *um, const struct qstr *str);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
