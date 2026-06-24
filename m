Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6042FA0DF
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 03:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782273480; cv=pass; b=Gobj7nAr4vqAYvsxrXn6jImn/bY9QwUu4LChn0uAU1O0EwLgRy7mZ8NHCdnIBHxMCNWoul+BM9ws5GuAuOnGxnoYc05jx7Gfb5zMol/4v46BxvX3SUwq8pm3gezG6cUhXq+k4VXP0EMi3ZHQxG4Cr2eHXTj8bvhZq+qpxFT2Nc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782273480; c=relaxed/simple;
	bh=F54ALYVQ2cppre7dcHpGG/ElL/+cEWQeKWO60zhuRxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nlBL3MdXeExdfe4yCyCcdYkuU5+VRqYGE3XSZCv1dcdPsD5XTwhUVyapq07vTe+XsiBzBqLUCWLz/zSjNnDfdHhVOWHqrF8zGW7jwuoh3rhFtaGZ4l9rSUB9CwAtpnN2oMRK11E5YfFOKrJUW0aLu8hy+8ya9iYPExLop7z6jFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=daCkp5+A; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="daCkp5+A"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c074ac8adaaso59054966b.3
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2026 20:57:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782273477; cv=none;
        d=google.com; s=arc-20240605;
        b=av4f/8F91SGkd4PGEieYCyUuFMrV6y+ASBpjDVeT+N214jEWSLzmiSeO9TN/41cQOE
         216NKNB6+dNKiXAlN/IHn2lFMPZQL7cqK5zMgfc8hOLTHdp6EE3NjP5GLx/jVv04uaIY
         wP8hz2M8mqqBnS6FsYtJQmHvKDSSbAppeo7psTkXhca0ESyTu6D9HOriVZpXdfOwCEeV
         E64UNEMRN62+f9FbCfB0S0W8EfVfEnHkYW62VumRDLKAi15g6sc9IM7D+4dr/9P63xls
         T0zQFhCZkbflenNdZI9UL6EVc7OoOLQSodkD2r7QrNGIA/ej2+zHdjKzos43aX9HpYiz
         +nmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kwDqA9GUyMoJt/cleQxTaFzT4OHdlG1ZfH1YPr9GtbE=;
        fh=jz4XxTnbVQkTP0AntjCVAXZu1jRmrNAGXDF9jraoRTA=;
        b=RrQgbMvEadwWih+/OZfc+89VjRBI+KmSzSPIfNM3ayZ1zDJUai7x145+8qbxnNfQhe
         N8x6LXNgTE99WdGwHI/9FFNQ96iZLl7w70OsytwKiKVCrsekA7J9GmIayo4pDTyLAeoh
         Wc/gvuU1b+C2E2z95QOFHKkDEtxslA5BS9LLDYx+My8KtvbrXVHdbDOmJZe55GIi36td
         z1UJkQhlnzWUtrW3Jg33yDANdUr/KWv/AwKRH2KMfzfVt55C8i9lghGpXJ9LodUDissY
         84DRYTUPKe9OQZsvfly3ZKUc9mTydeXhCjYkkPCWmVWskF9xKwP9sSxaOIPR/IsDPTOW
         MRfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782273477; x=1782878277; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwDqA9GUyMoJt/cleQxTaFzT4OHdlG1ZfH1YPr9GtbE=;
        b=daCkp5+AnAKGHlwVqOXg+1QFre/ofcIcAG7iz4Ns0cCUKoe8uDhvTn4dvS0h7C/jNz
         h9ECo99tv/dZzGpTFCMW4kL7VyJSXszTbdRX145g9X4EallUc4ZZRZTVH+y6Y2QuWr6K
         nmtpkEA8Y+5efO8H9wbzKnuZDRSQ5ZcOXn7hkZRHjKGR5vlEP0Plh5+2kbP5zkd+wnAD
         8CKhaKnBJhISUJJujvfNuBtnsFcdJ+QVL/o9Lq9Adl+eEct3vKIvvrCq8vcpkouOP/T3
         wuy31X5NDFQaXe2GTX4t+H9ei6jYRP9q3bK9kWpfXErZAsSgLfot7eHYnYEkPZsDtcz9
         1Fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782273477; x=1782878277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kwDqA9GUyMoJt/cleQxTaFzT4OHdlG1ZfH1YPr9GtbE=;
        b=VvL62ogvTz7fxtFJeicVKUMh43rxt0+l8tMt4UNNi5Xw8YRtVEjVuGaJLiziIxxGd+
         WW0C3JRvZPwim5WU1frFBEgJPX6MW/bP/9F4Hwv15m/KKT81pisv1I/ymzvdtVpwmlmh
         xer6j2MwnKgwmghpUlsO/NDSmjARouWIxW/+EMQvLZvRb4aEu/KoT7MP5XNQHSNgJrIO
         dGDAhdmGt4bWPlbSFYcvriH8JWggoTrOex3VsZO81MIdg4UmTW5wUMiKNRMJxRuks3fr
         UMg87lXbNbOtdpglbxYaPWozU21lfsHUfsY0GKZAI8l3R+tSUFTLqch4L7eE0ixJIw0W
         CTOw==
X-Forwarded-Encrypted: i=1; AFNElJ8FEjmSif2F1UVsaxrXXaEMxcylj946hcYfcMvqS8pVCx6jeUFsljSTwFW8Xym0JQroWxyp08BK3G5b@vger.kernel.org
X-Gm-Message-State: AOJu0YyrmUm0m0tKwAwmZ7nqhc1O2YcZ3kuTDYWeEO40L84p/4FSgHiM
	0TMIxZYh3zOe6XAJzZlBQmDrbc9HaXQ4hiIh9/vC27lzGT2aCqUak60sXoPzLl9O1ikEj0epCs+
	PCBpnXy6yT7vlUce2fJcrMarG28qw4iDXyelrRhkIiA==
X-Gm-Gg: AfdE7ck6EGMFGUAi1o0IEDSsgpUb0MdGiUi3M4MTguXU58zHxEX7ZPr21G+oDv0sbYD
	UmNZMCpMb70YOBu8/hpPkr19ssHwl56thUZz4Jk5BnuSvhiD00DqIATcosUjpb8OOw2lnDFL7P6
	dMuDusalcuA9yZ6yCQCsMrY0iumsrWYGz984exCfVXcTtbOMGBgghIEs0aThGUCPyYCW7H3AGPt
	6gd99PSDE/qccAQ3K95wUfG1rs32aqFo9sVmGqsY6cjbNdk8dk6cv/mzdYGZUKYPAxLNNhqJTFY
	aJZUfhIbMIocDRxO0q0lxCncmJAiKA==
X-Received: by 2002:a17:906:9f89:b0:c0c:ab91:d1b with SMTP id
 a640c23a62f3a-c119e4478ffmr61878766b.31.1782273476845; Tue, 23 Jun 2026
 20:57:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623161131.2189-1-aditya.ansh182@gmail.com> <d94027e3-53e7-4317-bc8d-c72bbd49186f@huaweicloud.com>
In-Reply-To: <d94027e3-53e7-4317-bc8d-c72bbd49186f@huaweicloud.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Wed, 24 Jun 2026 09:27:45 +0530
X-Gm-Features: AVVi8CfBTD0rClpn3XECHIEmFqzS9xYdw6D9mAI_7aWZG1oi18iXZiDrjD2-eI8
Message-ID: <CAK5ssPN3gM0R62Rio60qdSmZjEkP-KbFcW_N5RwckXjauFdEiA@mail.gmail.com>
Subject: Re: [PATCH] ext4, jbd2: abort journal on file data write error under data_err=abort
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, jack@suse.cz, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Anthony Rebello <arebello@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yi,

Thank you very much for your feedback and for pointing out commit
ce51afb8cc5e!

I was investigating the open Bugzilla ticket #207729, which was still
marked as ASSIGNED and unresolved without any links to the fix. I'm very
glad to hear that the abort logic has already been cleanly integrated
into the end-I/O workqueue path by commit ce51afb8cc5e.

I have added a comment to Bugzilla ticket #207729 referencing
commit ce51afb8cc5e so that the ticket can be resolved/closed and
others don't duplicate this work in the future.

Thanks again for the review and guidance!

Best regards,
Aditya

On Wed, Jun 24, 2026 at 8:12=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 6/24/2026 12:11 AM, Aditya Srivastava wrote:
> > From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> >
> > The "data_err=3Dabort" mount option in ext4 is designed to abort the
> > journal and force the filesystem into read-only mode if a file data
> > writeback failure is detected (to prevent silent data loss and stale
> > data exposure).
> >
> > However, in standard data=3Dordered mode, file data writeback is execut=
ed
> > and waited for during transaction commit in
> > journal_finish_inode_data_buffers(). When
> > filemap_fdatawait_range_keep_errors() detects and returns a data writeb=
ack
> > error (e.g. -EIO), JBD2 merely prints a warning message and then
> > discards the error. This results in the transaction committing
> > successfully, exposing stale/corrupted data and defeating the purpose
> > of the data_err=3Dabort option.
>
> Hi, Aditya!
>
> Thanks for the patch. However, after commit ce51afb8cc5e ("ext4: abort
> journal on data writeback failure if in data_err=3Dabort mode"), has
> already moved the abort logic into the end IO workqueue. In that case,
> it seems the journal abort would be triggered properly upon a data
> writeback failure. The issue described in this Bugzilla looks like an
> outdated one. Have you encountered any actual issues for now?
>
> Thanks,
> Yi.
>
> >
> > Fix this by:
> > 1. Defining a new JBD2 configuration flag, JBD2_ABORT_ON_DATA_ERR.
> > 2. In JBD2, if JBD2_ABORT_ON_DATA_ERR is set, abort the transaction com=
mit
> >    and the journal thread via jbd2_journal_abort() if writeback fails.
> > 3. In ext4, configure JBD2_ABORT_ON_DATA_ERR on the journal based on th=
e
> >    ext4 "data_err=3Dabort" mount option in ext4_init_journal_params().
> >
> > Reported-by: Anthony Rebello <arebello@redhat.com>
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D207729
> > Suggested-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> > ---
> >  fs/ext4/super.c      | 4 ++++
> >  fs/jbd2/commit.c     | 2 ++
> >  include/linux/jbd2.h | 1 +
> >  3 files changed, 7 insertions(+)
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 7283108d7609..de34490a5b68 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -5875,6 +5875,10 @@ static void ext4_init_journal_params(struct supe=
r_block *sb, journal_t *journal)
> >               journal->j_flags |=3D JBD2_BARRIER;
> >       else
> >               journal->j_flags &=3D ~JBD2_BARRIER;
> > +     if (test_opt(sb, DATA_ERR_ABORT))
> > +             journal->j_flags |=3D JBD2_ABORT_ON_DATA_ERR;
> > +     else
> > +             journal->j_flags &=3D ~JBD2_ABORT_ON_DATA_ERR;
> >       /*
> >        * Always enable journal cycle record option, letting the journal
> >        * records log transactions continuously between each mount.
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index d8577725a2fb..49acc9d0809e 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -768,6 +768,8 @@ void jbd2_journal_commit_transaction(journal_t *jou=
rnal)
> >               printk(KERN_WARNING
> >                       "JBD2: Detected IO errors %d while flushing file =
data on %s\n",
> >                       err, journal->j_devname);
> > +             if (journal->j_flags & JBD2_ABORT_ON_DATA_ERR)
> > +                     jbd2_journal_abort(journal, err);
> >               err =3D 0;
> >       }
> >
> > diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
> > index 7e785aa6d35d..e39679656de6 100644
> > --- a/include/linux/jbd2.h
> > +++ b/include/linux/jbd2.h
> > @@ -1410,6 +1410,7 @@ JBD2_FEATURE_INCOMPAT_FUNCS(fast_commit,        F=
AST_COMMIT)
> >  #define JBD2_FLUSHED 0x008   /* The journal superblock has been flushe=
d */
> >  #define JBD2_LOADED  0x010   /* The journal superblock has been loaded=
 */
> >  #define JBD2_BARRIER 0x020   /* Use IDE barriers */
> > +#define JBD2_ABORT_ON_DATA_ERR       0x040   /* Abort the journal on f=
ile data write errors */
> >  #define JBD2_CYCLE_RECORD            0x080   /* Journal cycled record =
log on
> >                                                * clean and empty filesy=
stem
> >                                                * logging area */
>
