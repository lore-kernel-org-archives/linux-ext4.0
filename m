Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457127;
	b=dTmlaAXuaT205wql01y//hIwmj9GAIgfKsnUlKVWIx6vZvWhcT3DT+KeASxrx2mtea2+
	 QiO7XzfwBXHz4GjRhHrRGwo3t5A8ez0Ko9w68vTXVkb99rHZ3AsgzaP3NNjwRUTBy0ubi
	 jkD8OHqtBhqk0p0WksAlFx1r4C2Yt0LcLFZDj0psnagpRIVeZi3/xg4qwKomikFEOOI8e
	 jvG0L1vMbas93kOG5ESrkLVFeslsqeo5DRsyKnhvsXVz9+mv/t4Vm5aKVK0rpHFNwWuBp
	 GeMomUk7drpKx4T6037W5S9exntygs5OAI/PBYlvEyOa76Bhp8q1Gqhdd3RuqylCBEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457127;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wZv9tAeskUhOqSnthi/sqQ5HlhkGkZfLywGMeVR8sSY=;
	b=4rX71RNfUbXuvH1HpgBEupJnOylXPMjVaFBT9XBjv+spKXF9KjqMdhFH/rtuERobLeYC
	 xmLoAHrgcsDgfZplUWaHxAi2RAaZeWZSGTFCUds11OdOC7/piD9nv8gq/pBdGU3O2dOhv
	 NB+/kybtVSU0zBr0qr5TgYzmEtvi16xiaBKEky9uLgLYywYbLIJRvQfZVDGgzSBFlMuk2
	 cK8bfSU1dTtLaTzDFebsxEyQVZuBjFiqVHLPFF/fWDIeVO8Ok/jfMAkjm98xOuXil5Aos
	 oO5VDcPRUCV9u1tR6jXS4hhKiMQJ5atAmFtogbMB3PlMtM12f7FaKXSifuSewqyVEXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhGzEd7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9A3606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 04:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhGzEd7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB41D1F00A05;
	Thu, 12 Nov 2026 04:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794457127;
	bh=wZv9tAeskUhOqSnthi/sqQ5HlhkGkZfLywGMeVR8sSY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=mhGzEd7LSBGpu1Li2XxL17fzPeQIoEOWeD431eCvdTAt5rK5FcsLXbql+G0jgJIaH
	 jL0KMpzAYutur7dgYTEf8jQ/SoXuZM/t1DCa+2+3oWUpl9t2kP+G2Ar3ai52ZrriMv
	 1jt+Kov+w1lh4VrWPqP/EtHMsP+BNm7I8ypzzy3C9Kh2hVR/iLUATf9+uYhcEFk72N
	 9BEeiNk/+bN96VyZ7ZF3Q8rOf3a1yIzTL+EiVwNAA+HXWf3OLAwvOSoyi+L/RRTb7G
	 kbImPYiRf7JrJTjQl1gpOBEhp0Sb6n89KMrc8LHmvQy2E4NrV3t1B4Tp7YLsyYctjE
	 mrPglI1/LWSRA==
Message-ID: <sashiko-outbox-210324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/27] ext4: add KUinit tests for
 fs/ext4/extents_status.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261112040638.1576836-2-tytso@mit.edu>
References: <20261112040638.1576836-1-tytso@mit.edu>
 <20261112040638.1576836-2-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 04:18:46 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] ext4: data race in __es_shrink() [1]
--

commit 45574cf43b458dd12781bdd04f9e4dfbf9ef71c4
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUinit tests for fs/ext4/extents_status.c

This commit adds KUnit tests for the ext4 extent status tree and bigalloc
pending reservations, and exports the required symbols for the test module.

> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 6e4a191e82191..64bac0c4c1fa0 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -2390,3 +2390,22 @@ static int __revise_pending(struct inode *inode, e=
xt4_lblk_t lblk,
>  out:
>  	return (ret < 0) ? ret : pendings;
>  }
> +
> +#if IS_ENABLED(CONFIG_EXT4_KUNIT_TESTS)
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_init_tree);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_insert_extent);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_cache_extent);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_remove_extent);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_find_extent_range);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_lookup_extent);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_scan_range);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_scan_clu);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_register_shrinker);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_es_unregister_shrinker);
> +EXPORT_SYMBOL_FOR_EXT4_TEST(ext4_seq_es_shrinker_info_show);

[Severity: Medium]
This problem wasn't introduced by this patch, but can concurrent shrinker
runs race on the 64-bit statistics fields in sbi->s_es_stats [1]?

fs/ext4/extents_status.c:__es_shrink() {
    ...
	spin_unlock(&sbi->s_es_lock);
    ...
out:
	scan_time =3D ktime_to_ns(ktime_sub(ktime_get(), start_time));
	if (likely(es_stats->es_stats_scan_time))
		es_stats->es_stats_scan_time =3D (scan_time +
				es_stats->es_stats_scan_time*3) / 4;
	else
		es_stats->es_stats_scan_time =3D scan_time;
	if (scan_time > es_stats->es_stats_max_scan_time)
		es_stats->es_stats_max_scan_time =3D scan_time;
	if (likely(es_stats->es_stats_shrunk))
		es_stats->es_stats_shrunk =3D (nr_shrunk +
				es_stats->es_stats_shrunk*3) / 4;
	else
		es_stats->es_stats_shrunk =3D nr_shrunk;
}

__es_shrink() drops sbi->s_es_lock before reaching the out label, so
concurrent memory reclaim threads can update es_stats_scan_time,
es_stats_max_scan_time, and es_stats_shrunk simultaneously without
synchronization.  On 32-bit architectures, these plain 64-bit read-modify-w=
rite
accesses can tear and corrupt the shrinker metrics.

[1] https://sashiko.dev/#/bug/linux-ffbda43a-8d25-4cbd-be48-64c4f05ffa5f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112040638.1576=
836-1-tytso@mit.edu?part=3D1
