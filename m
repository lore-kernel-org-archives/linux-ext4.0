Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1551E9B3A
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 01:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776302092; cv=none; b=ak4vwsBboZmk3CdEeJ7lumD4cH7pIsQdu8+ScrLPzyPJf/r93vt3/Vp3rrxhda6F6iw9vjDNvpQCOXhESmqKyH7DZq0PVgxgJ+h5Iad3Q1nEt8AvXuk4Hui9G2SUl1wXVHKQNVfPqR5ytcBKPIPRFBI1wtkjQFpEK1TUh4zkZvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776302092; c=relaxed/simple;
	bh=7nO/2Avl3a4tzNRmx1loA/73W4Xv1tpW8HPuY+vGN2s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qT+8XB5bA6wMnChbfKM/iWny172QybBvXfBxtsZoeXUVkEZGA/4oRelHIgYofKedOU1h6J8hL+C3FXDO/UprucOSiyLeYwvPe307sMDU3uvHc+SD9nZ606wIeSOZfOf2keDOs9bPhsyCPUpj9WkvnvnTKdTvlz3L4hjCjHw6eZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=PyNJc5+S; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="PyNJc5+S"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35fb16e56efso2800566a91.2
        for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 18:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1776302090; x=1776906890; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtlTlsL6YYv4uiMFp8lCnKNg84sZfclP/UVzyqD0g5k=;
        b=PyNJc5+SyuEIPCw7hhVQbdU4FcJGlGILgNDDGMucuBDcdTvXW70pDwoy9vjVmnmcnV
         bzorNxZs67YKBedAe1dMdaGR+v4KXUiEuaJTt3jnZmGsmhe8Aebbk9NfzvcA5Rm+j38k
         7VBCeUXXCUk3C3BYS4usam9Ngi77uvAtn9P19Tv3H1bjOW8t59ORqEgHB9suUWetiRvV
         8+4l2SdVcXZE9e8DvYVjlNFw9RQCUwXEjq8O4GdmlmjFinT3pwIkgqD+cye7n2J3Aq2N
         X7uZ+EfbwHPukHG1BAlHxlPqdWZmlJElxkvWVLCNEFqDqctmotdBiOQL51CvZ4hXdtVE
         OLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776302090; x=1776906890;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DtlTlsL6YYv4uiMFp8lCnKNg84sZfclP/UVzyqD0g5k=;
        b=EFq5bSYA+1VIte7RF9DxHvhD/T1nGMzw8nXrVQeA7Rigkqok6CNl1oD+J880JxyaCl
         XZPpVhvZgtHNP06vWy3W1XpaJiuLTj64Fz8d9EW+kO+QGYnjaRsR41S2pA05XFfk28zy
         2CCgyUMzglvF5T/yD8KPAoiq0kTqwB8+i4C3FnkCx3Ne1fOUrD3pPoUQ8MR8KrAACfNE
         5+cDWUJxw1U9cw+yK6A7euMbwUZrRglbYHLJqG8xjgDhwn13uFo3yAeaxTcat9dJQLn1
         eDwOiCq+blN3b8LM8ibaZjWr5CWP677pHyyUDeynqXjWOHQVetyLhetXEQwxAW5Suwbn
         9Ngw==
X-Forwarded-Encrypted: i=1; AFNElJ9/4MLt3OxRXQSZ0smJZ/UkvFVcq8AdJZVs+fRPHqV9ZpB2YtvJTzbT2BulITdzebS3NvNoNAXO1GfH@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz1sECEeGYLTVUi9ZBzKtonqIsFpi7yzdyTZxv+SPd+Y+hQ+7T
	Jj0i7sV7LF7axUH5Y4CD9isK1//Pbkb8Bq35fauTT5qdks9svSHRVEAP83F1o5QRNhqAVPshdNm
	bVJMZsOg=
X-Gm-Gg: AeBDieu51E56nD5V5BoeiTI8PShCFxxSIc/aQn/bF8/xcVni8opEt7E+abbLeLUXeR6
	3ghL04XejkUi5PzHbn2YjbwLM2qI3lK1pXPtrPQKlYtsL8EXP5jpyreVz27Ck/I2sOI4Gzp3GAa
	kk7X8ymJD3jR8hJMMzDd7+rfCWhUQl/sGamA7VywXLv3106G4ElfmGKbnWKPqH8gux7FQ3MWek4
	eDJAe0JYuk4/AVTpZ5QF2N7FQxKgtA2x9/TJLNK9Z5mZEijMVALy0GQLWu5Ol+bnhh5BxvZJ/4Z
	b0hcvVeLLVsddcwsnr7cBizqL4b5V1qm1zFcZPWGcHkrNYKF0i6YlATJn63J7VlvhYCysfS8EAD
	5aHdI//ppcWFm2IdIbPeJ5DFUygc3PJ11hhceE9XNoynyVyGK6tk/1QLMyIIuFRFVb3EUbDuR3i
	xwBuFo81SaHR9SCDd/8GnSV/rYTGcLL/NX6nkoe0+W2ykAoF35wviZEHphITSX3mQPISY07xJ1x
	9rtSLkWWa80XyOPuQ==
X-Received: by 2002:a17:90b:2e0c:b0:35f:c729:de9b with SMTP id 98e67ed59e1d1-35fc729e0ffmr7982616a91.20.1776302090036;
        Wed, 15 Apr 2026 18:14:50 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132c87817sm315519a91.2.2026.04.15.18.14.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2026 18:14:49 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260414100212.95209-1-liubaolin12138@163.com>
Date: Wed, 15 Apr 2026 19:14:38 -0600
Cc: tytso@mit.edu,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C713AA9C-D640-4C5B-98BF-A5D88AE3B2A0@dilger.ca>
References: <20260414100212.95209-1-liubaolin12138@163.com>
To: Baolin Liu <liubaolin12138@163.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On Apr 14, 2026, at 04:02, Baolin Liu <liubaolin12138@163.com> wrote:
>=20
> From: Baolin Liu <liubaolin@kylinos.cn>
>=20
> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
> runtime statistics. This makes it easier to inspect allocator
> activity for a specific workload instead of using counters
> accumulated since mount.

Rather than having a read-only "mb_stats" procfs file and a separate
write-only "mb_stats_clear" sysfs file to clear "mb_stats", IMHO it
would be more obvious to write directly to "/proc/fs/ext4/DEV/mb_stats"
file to clear it.  Writing "0" would be logical to zero out the stats.

Cheers, Andreas

>=20
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> ---
> fs/ext4/ext4.h    |  1 +
> fs/ext4/mballoc.c | 31 +++++++++++++++++++++++++++++++
> fs/ext4/sysfs.c   | 24 ++++++++++++++++++++++++
> 3 files changed, 56 insertions(+)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 7617e2d454ea..3a32e1a515dd 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2995,6 +2995,7 @@ int ext4_fc_record_regions(struct super_block =
*sb, int ino,
> extern const struct seq_operations ext4_mb_seq_groups_ops;
> extern const struct seq_operations ext4_mb_seq_structs_summary_ops;
> extern int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset);
> +extern void ext4_mb_stats_clear(struct ext4_sb_info *sbi);
> extern int ext4_mb_init(struct super_block *);
> extern void ext4_mb_release(struct super_block *);
> extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index bb58eafb87bc..382c91586b26 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3219,6 +3219,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, =
void *offset)
> }
> seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
> seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
> + seq_printf(seq, "\tblocks_allocated: %u\n",
> +   atomic_read(&sbi->s_bal_allocated));
>=20
> seq_printf(seq, "\tgroups_scanned: %u\n",
>   atomic_read(&sbi->s_bal_groups_scanned));
> @@ -4721,6 +4723,35 @@ static void ext4_mb_collect_stats(struct =
ext4_allocation_context *ac)
> trace_ext4_mballoc_prealloc(ac);
> }
>=20
> +void ext4_mb_stats_clear(struct ext4_sb_info *sbi)
> +{
> + int i;
> +
> + atomic_set(&sbi->s_bal_reqs, 0);
> + atomic_set(&sbi->s_bal_success, 0);
> + atomic_set(&sbi->s_bal_allocated, 0);
> + atomic_set(&sbi->s_bal_groups_scanned, 0);
> +
> + for (i =3D 0; i < EXT4_MB_NUM_CRS; i++) {
> + atomic64_set(&sbi->s_bal_cX_hits[i], 0);
> + atomic64_set(&sbi->s_bal_cX_groups_considered[i], 0);
> + atomic_set(&sbi->s_bal_cX_ex_scanned[i], 0);
> + atomic64_set(&sbi->s_bal_cX_failed[i], 0);
> + }
> +
> + atomic_set(&sbi->s_bal_ex_scanned, 0);
> + atomic_set(&sbi->s_bal_goals, 0);
> + atomic_set(&sbi->s_bal_stream_goals, 0);
> + atomic_set(&sbi->s_bal_len_goals, 0);
> + atomic_set(&sbi->s_bal_2orders, 0);
> + atomic_set(&sbi->s_bal_breaks, 0);
> + atomic_set(&sbi->s_mb_lost_chunks, 0);
> + atomic_set(&sbi->s_mb_buddies_generated, 0);
> + atomic64_set(&sbi->s_mb_generation_time, 0);
> + atomic_set(&sbi->s_mb_preallocated, 0);
> + atomic_set(&sbi->s_mb_discarded, 0);
> +}
> +
> /*
>  * Called on failure; free up any blocks from the inode PA for this
>  * context.  We don't need this for MB_GROUP_PA because we only change
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 923b375e017f..a5bd88a99f22 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -41,6 +41,7 @@ typedef enum {
> attr_pointer_atomic,
> attr_journal_task,
> attr_err_report_sec,
> + attr_mb_stats_clear,
> } attr_id_t;
>=20
> typedef enum {
> @@ -161,6 +162,25 @@ static ssize_t err_report_sec_store(struct =
ext4_sb_info *sbi,
> return count;
> }
>=20
> +static ssize_t mb_stats_clear_store(struct ext4_sb_info *sbi,
> +    const char *buf, size_t count)
> +{
> + int val;
> + int ret;
> +
> + if (!capable(CAP_SYS_ADMIN))
> + return -EPERM;
> +
> + ret =3D kstrtoint(skip_spaces(buf), 0, &val);
> + if (ret)
> + return ret;
> + if (val !=3D 1)
> + return -EINVAL;
> +
> + ext4_mb_stats_clear(sbi);
> + return count;
> +}
> +
> static ssize_t journal_task_show(struct ext4_sb_info *sbi, char *buf)
> {
> if (!sbi->s_journal)
> @@ -251,6 +271,7 @@ EXT4_ATTR_OFFSET(mb_best_avail_max_trim_order, =
0644, mb_order,
> EXT4_ATTR_OFFSET(err_report_sec, 0644, err_report_sec, ext4_sb_info, =
s_err_report_sec);
> EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
> EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
> +EXT4_ATTR(mb_stats_clear, 0200, mb_stats_clear);
> EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
> EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
> EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
> @@ -301,6 +322,7 @@ static struct attribute *ext4_attrs[] =3D {
> ATTR_LIST(inode_readahead_blks),
> ATTR_LIST(inode_goal),
> ATTR_LIST(mb_stats),
> + ATTR_LIST(mb_stats_clear),
> ATTR_LIST(mb_max_to_scan),
> ATTR_LIST(mb_min_to_scan),
> ATTR_LIST(mb_order2_req),
> @@ -561,6 +583,8 @@ static ssize_t ext4_attr_store(struct kobject =
*kobj,
> return trigger_test_error(sbi, buf, len);
> case attr_err_report_sec:
> return err_report_sec_store(sbi, buf, len);
> + case attr_mb_stats_clear:
> + return mb_stats_clear_store(sbi, buf, len);
> default:
> return ext4_generic_attr_store(a, sbi, buf, len);
> }
> --=20
> 2.51.0
>=20


Cheers, Andreas





