Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D02EF67A
	for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 09:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776590622; cv=none; b=CyeszMZQqU3IljBo+7L+RFxfqg676T8B4R3YJnfy2mx+KGHQQ7A9QtdgoX0g5O7sSB8WiVRmP8DeXu3fFK6hON7WEr8W/9b6AKEddWMYRw+3Fa6p0ODTUeEDmQOzz+OQnJ++A7Lx/lJ/BrMlO1//Qfq5Fm0TlV2QTQ+RyiNiv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776590622; c=relaxed/simple;
	bh=3pp+c3tzR2d87RtpFI0X6AM0u1qzqce8RXAPLee4bH8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=calwUUv+F8bZ91vDHuABrP8lua6vZ020Eevvb7B3VdR2c/CZBmJ4DzGvCjZ1sEcLPuBV2R52jf+yfd9ekG64us6ukHFwTqxaFbhlD/b1xRlZsYSj0r2ZILyp+vnMIEVnueiGxLFl6gMdRQpe6h7y9xkyWwKMfDTeqffif2ejOJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=S0PgM7wO; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="S0PgM7wO"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-82cebbdbdccso1215459b3a.1
        for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 02:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776590620; x=1777195420; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gOUWrqsyRpCd9PAGKMrJksgAQbF12lDol5Ql3gvkMhA=;
        b=S0PgM7wOEKaxTYuVuosKOMgXGS6HUC4bbjaCQ2VvcaMdD1rnMzZJBcVks44S4pQAxR
         XBnw2gIOjR9Jj4UgDx59/brKgaZ5/okhuG1asja0IxylYPqTA49EVCl3koPCibR3L1uT
         bJv0MhtVLQN/7tMI/UkGxthevRmS/LWxFuR/Hd0dJ9f7wptQtJ1n+Pyu6nsOm+dw3nL2
         8aMrcypsU3K4/4JN7WRtUS5Z8evmA6ejbAAy6nJfFND3nMh5ZN2LgxQc5tn4IPJQ/1aX
         nfTxjgC4CyaoB8TqgoLui2miwUNSbIargZNZgxwnWhnNwkH04d6yhVRDDpw5hfZ4KR2O
         egfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776590620; x=1777195420;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gOUWrqsyRpCd9PAGKMrJksgAQbF12lDol5Ql3gvkMhA=;
        b=sfxxgvQ8x89RjfWdBWdCIRfUj5BKNnDRRVhazvzzDOmOfjr8HFYwKczyhF+llR344k
         cqe86uvv2vRzz7PZIulJacCDZGPPhxQCTG2+w/vlkKV+Hs2le1IJn7fRUkOpKh1Crwn4
         7prSgaIK7fWdgZ2qR12dcPu6vIiysczdU6LVGnEA7mrpbDPYv8UFSvb+N5I3JM9j/Y/D
         M/+KRLwbh4Uq32LNeKMiCD5HGvk30g8PUriLwCvZ9k07NxzoVEAGWk+y7nqFOLqnzcCX
         O68kGyM97M2m2Y4NgTRQxxMHyjDK6yb6iJaV1vRJw40hmath1OzVfHJvhouXa6pjifG8
         Gj7g==
X-Forwarded-Encrypted: i=1; AFNElJ/UDsNVeWEvbuBDLMtcKSAuvoS29igrFpAw5LkT7Qm8FB1lBCThVP13e3GM0QBRRgz9UwSSCZgWj1zi@vger.kernel.org
X-Gm-Message-State: AOJu0YxxtuDI/HrNMtmAC5pwyKWKmEczv7E7Qz+o9UpbF5ANs4X9zhW4
	KQFUY6NpDXNjGd5N+jtv6kehw35KyqGJuorZFJx7j7+NEstlzA+b44C2xnQ/FzUjT78=
X-Gm-Gg: AeBDievfHqGx+OH+RUEwAAiH77GaoKBgAcpqqQ7PWXg9BPgV1p1DfZJl8E0x8ww+Cef
	lBZ+0WbOUZDa61Pt2hRNd60PHYXYlemkX3OmI6gjo3XtiVyGMwaog4w95vqxdxncZAwarax444y
	LWQV/2E0TfHnc7PRDwMYgJlYFOLI4zu9PvyDPeRBm7TNSK5Na08DKdvK+lI9hYxKWbgm6iy7Kji
	RTSSblh11lsYWgVj6BRfeI6BKgK3J+2o/240q4VRVItOnZQTJT5TSS2jdmUAyNm8cijf5aQj3KP
	33jncXSxxLMAKYYDc5kRv6XWfEycWJXIWLd+vMxH1RcQJImaxnG96fDzTkGZpbOjCcKQOxVQw93
	EI54yFXp77nNAKShy18u9XTqeBto62slIVSyyj3rvvuRt+GPX1Bpzdi3GFdIBktWrTsNgHxP894
	X4VQt3YSJm0gwDKtA8R2qu7o303r9sqcye7Qg1agIn/72g1PCnMVPf6db/unKZbBFFdinlNhZgV
	/DF8uLefXEY4L5k
X-Received: by 2002:a05:6a00:4c82:b0:82f:6aee:7d5c with SMTP id d2e1a72fcca58-82f8b380817mr7638409b3a.9.1776590620113;
        Sun, 19 Apr 2026 02:23:40 -0700 (PDT)
Received: from smtpclient.apple (S0106a0ff70715ac6.ek.shawcable.net. [174.0.84.146])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e9cbb28sm6768935b3a.13.2026.04.19.02.23.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2026 02:23:39 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v2 v2 2/2] ext4: allow clearing mballoc stats through
 mb_stats
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260419063436.17999-3-liubaolin12138@163.com>
Date: Sun, 19 Apr 2026 03:23:28 -0600
Cc: tytso@mit.edu,
 wangguanyu@vivo.com,
 yi.zhang@huaweicloud.com,
 ritesh.list@gmail.com,
 ojaswin@linux.ibm.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <17C103A5-EE44-4762-AE7C-BA5E84F83D58@dilger.ca>
References: <20260419063436.17999-1-liubaolin12138@163.com>
 <20260419063436.17999-3-liubaolin12138@163.com>
To: Baolin Liu <liubaolin12138@163.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 19, 2026, at 00:34, Baolin Liu <liubaolin12138@163.com> wrote:
>=20
> From: Baolin Liu <liubaolin@kylinos.cn>
>=20
> Make /proc/fs/ext4/<dev>/mb_stats writable and clear the runtime
> mballoc statistics when 0 is written.
>=20
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/ext4/ext4.h    |  1 +
> fs/ext4/mballoc.c | 29 +++++++++++++++++++++++++++++
> fs/ext4/sysfs.c   | 40 ++++++++++++++++++++++++++++++++++++++--
> 3 files changed, 68 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 293f698b7042..3223e73612ae 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2994,6 +2994,7 @@ int ext4_fc_record_regions(struct super_block =
*sb, int ino,
> extern const struct seq_operations ext4_mb_seq_groups_ops;
> extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
> extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
> +extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
> extern int ext4_mb_init(struct super_block *);
> extern void ext4_mb_release(struct super_block *);
> extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 1e13ef62cb9d..79ddfa935813 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4723,6 +4723,35 @@ static void ext4_mb_collect_stats(struct =
ext4_allocation_context *ac)
> trace_ext4_mballoc_prealloc(ac);
> }
>=20
> +void ext4_mb_stats_clear(struct ext4_sb_info *sbi)
> +{
> +	int i;
> +
> +	atomic_set(&sbi->s_bal_reqs, 0);
> +	atomic_set(&sbi->s_bal_success, 0);
> +	atomic_set(&sbi->s_bal_allocated, 0);
> +	atomic_set(&sbi->s_bal_groups_scanned, 0);
> +
> +	for (i =3D 0; i < EXT4_MB_NUM_CRS; i++) {
> +		atomic64_set(&sbi->s_bal_cX_hits[i], 0);
> +		atomic64_set(&sbi->s_bal_cX_groups_considered[i], 0);
> +		atomic_set(&sbi->s_bal_cX_ex_scanned[i], 0);
> +		atomic64_set(&sbi->s_bal_cX_failed[i], 0);
> +	}
> +
> +	atomic_set(&sbi->s_bal_ex_scanned, 0);
> +	atomic_set(&sbi->s_bal_goals, 0);
> +	atomic_set(&sbi->s_bal_stream_goals, 0);
> +	atomic_set(&sbi->s_bal_len_goals, 0);
> +	atomic_set(&sbi->s_bal_2orders, 0);
> +	atomic_set(&sbi->s_bal_breaks, 0);
> +	atomic_set(&sbi->s_mb_lost_chunks, 0);
> +	atomic_set(&sbi->s_mb_buddies_generated, 0);
> +	atomic64_set(&sbi->s_mb_generation_time, 0);
> +	atomic_set(&sbi->s_mb_preallocated, 0);
> +	atomic_set(&sbi->s_mb_discarded, 0);
> +}
> +
> /*
>  * Called on failure; free up any blocks from the inode PA for this
>  * context.  We don't need this for MB_GROUP_PA because we only change
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index b87d7bdab06a..e90885d470ab 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -52,6 +52,42 @@ typedef enum {
> static const char proc_dirname[] =3D "fs/ext4";
> static struct proc_dir_entry *ext4_proc_root;
>=20
> +static int ext4_mb_stats_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, ext4_seq_mb_stats_show, =
pde_data(inode));
> +}
> +
> +static ssize_t ext4_mb_stats_write(struct file *file, const char =
__user *buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct super_block *sb =3D pde_data(file_inode(file));
> +	char kbuf[2];
> +
> +	if (count =3D=3D 0 || count > sizeof(kbuf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(kbuf, buf, count))
> +		return -EFAULT;
> +
> +	if (count =3D=3D 2) {
> +		if (kbuf[0] !=3D '0' || kbuf[1] !=3D '\n')
> +			return -EINVAL;
> +	} else if (kbuf[0] !=3D '0') {
> +		return -EINVAL;
> +	}
> +
> +	ext4_mb_stats_clear(EXT4_SB(sb));
> +	return count;
> +}
> +
> +static const struct proc_ops ext4_mb_stats_proc_ops =3D {
> +	.proc_open	=3D ext4_mb_stats_open,
> +	.proc_read	=3D seq_read,
> +	.proc_lseek	=3D seq_lseek,
> +	.proc_release	=3D single_release,
> +	.proc_write	=3D ext4_mb_stats_write,
> +};
> +
>  struct ext4_attr {
>  	struct attribute attr;
>  	short attr_id;
> @@ -630,8 +666,8 @@ int ext4_register_sysfs(struct super_block *sb)
>  					ext4_fc_info_show, sb);
>  		proc_create_seq_data("mb_groups", S_IRUGO, sbi->s_proc,
>  				&ext4_mb_seq_groups_ops, sb);
> -		proc_create_single_data("mb_stats", 0444, sbi->s_proc,
> -				ext4_seq_mb_stats_show, sb);
> +		proc_create_data("mb_stats", 0644, sbi->s_proc,
> +				 &ext4_mb_stats_proc_ops, sb);
>  		proc_create_seq_data("mb_structs_summary", 0444, =
sbi->s_proc,
>  				&ext4_mb_seq_structs_summary_ops, sb);
> }
> --=20
> 2.51.0
>=20


Cheers, Andreas





