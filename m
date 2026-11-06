Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793936582;
	b=dbcPiAJ7hm1+TEjfMK+89gZec6kpfNN4nAa3t+4zcauPJpZQwbYkuxbJcf+Xz4s1QHDq
	 Ud6FEwe3jZKS5c5P4QmU5UOteSxDSEdmxAeI6bsBQqwSypxIb6mFro4oJ3q97qq0pb3ir
	 ZVO8+BCT0OBPYMUrcu5cTsieIpxE4s61BubWdCPWJo/c+g1b7S7JpE39qUG1cfrv3C7lx
	 RaJFg4/uwmP+6kyVF2I3RvgH6+cZ3DAAocuJwVQvT8zuYWLOXUYjLK87ODZJkWOSm+n/e
	 5lCECua6SUbPUZ5ivDsj+TLO+CFFNwKZAJMrhY+4d4og9DAIxlHfhyTRz+EKSXWT4IA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gzgmR8wgSiBd7YvDFgX7LeDtcmzhG2S+NinOJPtbciw=;
	b=Fy/1EHHXDDVUCnKi9diyzFf/wsT2A5aDaFVWwNcPBKCkmPyPFBit0d9fdV0+mpeBQei/
	 XYD5W1Q2rMWWYL6vs3y9cBX8FgPOhhbH0bU9iY7g2nYQfXGAlryd1x0uTFDsVyUAm39jm
	 kKbIo0p6JwlpoWX7hZHyk565TnlJiuaNlUnojjIEVsopAi8/Xolpv8d2R5cjfthYvjXau
	 PzJ7qlIbpAm1KbVw3KvSc3AhdTE85C0fmZjGRmnc3XvGMBPhKV45IAA2NAXQu41mhr2DT
	 C0HgxAwPTKsOCf1Nzscz7gFXjaMC8aNhEfPj3D6I3ip+w2F8TcKSZk1sdUupzaYPLOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CPZFFpWJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C0606A32D
	for <linux-ext4@vger.kernel.org>; Fri,  6 Nov 2026 03:43:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D4C0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CPZFFpWJ
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a05b210703so74043b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 05 Nov 2026 19:43:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793936581; cv=none;
        d=google.com; s=arc-20260327;
        b=MIZmcyE8bkfI3Ic3Nnf6Q+7b5tz1GL762jKhJSCZNbf+n9AYFkGUC6Fe72BoeboXxw
         eQq5jIe+O2RtAWQi63uCEu2zGfd2YTx7MEkVN6EGCjyiJQfHHaw3aS/FK0Yd7j7NEFPU
         s0zapiUieNC78AAm7PNbOZhUlLX4Abfep+xo5dYUcbc1SYMZQCvq9rBaA6AkexbrCyO1
         e+YMQvpFzTHNIqdxYhqDOh7fIaR1li0R+JskUTJY5RY8Fa1016GyFLQfGy7GGSDpw8U/
         nBEUR+S5ccGLZE+RlG7BXPVh5gxgiutGyZlxB4yc0TlQmEK5k6qhlBTFqGIDSC6rSu+l
         al3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gzgmR8wgSiBd7YvDFgX7LeDtcmzhG2S+NinOJPtbciw=;
        fh=DiFlJpSzGwaXgmV1AT+jZK/nmqZHY/It8dUiJO9bnG4=;
        b=VaCE7YvBQB0qHFojNFvuG8gY39aPRZXfuwj05U2e6JK4LuyXvx9IvbAPQSMLtO+BPB
         qwMYx4fUaf6tKnD5aOaR1kA2gds89ApxopRHFJleqwidVugRgfPLW6Zb1ssc89/Gx5L1
         BzGflrarDGgUO8jlSKJFt5kkh5dJcN3Df9NKmhMyHOLJMgKqssK1F6HIbgwFcnEKYT+f
         kNHrKI0Wcd08vyrc1Z8hWyLnJIuM06acAq8fMiougIf4N55SZLfgR4NQlXBnSBNBZX00
         0Dta+uVJOcTRZryWrMckrklb2KvIf+DsuDYL3EMeTSignroLtUc7FX3/1jGd+1m586rC
         VXFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793936581; x=1794541381; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gzgmR8wgSiBd7YvDFgX7LeDtcmzhG2S+NinOJPtbciw=;
        b=CPZFFpWJ51qkxgb4AnkFJz3oZP+V2FTLYH6xZrmstaXd7SqDqwhwEB/QN6z3PyTKcV
         hdJDDhRGhKcL88JE9yOv2p/aors8P2JlN0QHLP9BnvtBLihRQitHijEAuCsw+jCNh1nJ
         oPPDxz5uFD0J57cwQ2WyryKKeTdU9kqXCuw5XQC9mpVCv7qIoPdKGdDZz4N02Wf0g8OU
         nUoBAffsM0MawQPKIdlEe8GdKf5rNPV/AuOt8f8AJmwKRO2ThTlQ/lOzPJpWcQAMnqLx
         a+XeuW0MDfBGmjdjzNQeD0VuP/DXt764L0R9JfPJWrUKz8KTBlR5ZaB7s6eABsbc8bdU
         +yug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793936581; x=1794541381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gzgmR8wgSiBd7YvDFgX7LeDtcmzhG2S+NinOJPtbciw=;
        b=Sf8Qm97xlNJjvGbqQWkM/z0Gc+88AghuXQtVhQnd01ruCPciCFtQOAcSCY9Q3MkhM6
         +mhnnb/qFtGRHLR564P1I2wfeTDdcesF8wndm5jlhKlpSVdgin6ErrmrGYKEuQAIbWeZ
         ocTGG06KCAoe3tl/sP2O4WREbNNSxGtuh708Gftr5njdfJeRtbreYTR2ejoWcT0pavkh
         8lzG59ipuLm98qEFTJa0HzNm0pzMzjzWNnM6k4O8KraSjV2N9DYgJn4xdcvE71c+0dAX
         9dSHMR8gelmC1aGw7i+mGMQv/odr1SrI2M5aHehVKd7Qq1AsL6kSmIfyXs6R3Y/I/qS/
         L/bw==
X-Forwarded-Encrypted: i=1; AKwUvBw8hB+RObBcWWVm3o9VQ+25l6qyJP3YfAsTljDJSUVyWvfr7uevGhU/nMqBscjEtkvuJ5EXe+20roWa@vger.kernel.org
X-Gm-Message-State: APuU4Z/MDI6XURxmNwZah63K3jDmG3j8zsPhE5MrK0vlr4eUIHnesNXu
	IhSSHRcQXUWCqikYF/lCbf1/IwVXQtxEeW8hGV5LPaBSeS1ahfgRXnQ/NMYBjfF7fclyHBLV0FT
	h3H4AVRPPa4C0SWCMyqzYnsZvpXB2H3c=
X-Gm-Gg: AYBFou3wR02K1wWXsQEZqfviGDPZh032tXaLfdobYTCQ43/u/FVxd5lfV+yMkW3lRTv
	Xw5Jb+pX2iBsAyb/fGlTbalYW922DuXqYpk1kYb48ZbJ2R4SL7kOw1i2jgfp2qpt85ghcBMflDr
	SPtavUyAGq+9w2duIjh4texWTIzXXAj+LPoPAoah+RcmZVXVWnxrXUbPZjYKFdjmqvJhwodjsom
	e1MX8eNveLy1c2iDcFgeySn2a+nbT6S3cgGyRlg+pXOeZMqA/EifyVtr1SB8/Bpad4QlA/J0RJZ
	9TPSnMHS+1vmehfXl9FLNhg70xD1yroSbhXSiyFR5uwQTNLG3/nb38tJLyW/tHAUYAYOiLejKmO
	QK076B7VktcZ7hfpSfljqx9VwlpuMiimQF0JF
X-Received: by 2002:a05:6a00:3a1d:b0:890:e6dd:52ca with SMTP id
 d2e1a72fcca58-8b37bb5e2demr1221064b3a.47.1793936581257; Thu, 05 Nov 2026
 19:43:01 -0800 (PST)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104033539.3031910-1-frankljpliu@gmail.com> <rszreimkiwsu3yrksfrjvalosmvhsybnfrabups7dv2jfmrkdc@qvzzx3sw67rp>
In-Reply-To: <rszreimkiwsu3yrksfrjvalosmvhsybnfrabups7dv2jfmrkdc@qvzzx3sw67rp>
From: frank jpliu <frankljpliu@gmail.com>
Date: Fri, 6 Nov 2026 11:42:49 +0800
X-Gm-Features: AclHuK9I5nbDfS0WLfo-rNHrPzRkiLGTMb7ir1H75XJTpxOH4q0VVTp6EwkC0hE
Message-ID: <CALqwsrA7ZqR47K+sKnfGHx6816QxPdBxoOJSRvQbRLD30XLgDQ@mail.gmail.com>
Subject: Re: [PATCH v2] ext4: fix soft lockup while shrinking the extent
 status cache
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	frankjpliu@tencent.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 2:30=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 04-11-26 11:35:39, Jianping Liu wrote:
> > From: Jianping Liu <frankjpliu@tencent.com>
> >
> > __es_shrink() walks sbi->s_es_list and reclaims extents from each
> > inode. On a non-preemptible kernel that walk never gives up the CPU.
> >
> > There is a soft lockup report on our company's machine. The machine
> > with millions of active inodes, 256 CPUs, and heavy memory pressure,
> > concurrent shrinkers run too long.
> >
> > i_es_lock is dropped after es_reclaim_extents(), and s_es_lock is not
> > taken again until the next inode. When nr_to_scan remains, call
> > cond_resched_tasks_rcu_qs() before continuing the scan.
> >
> > cond_resched() does not report the RCU quiescent state needed here.
> > It is compiled out when CONFIG_PREEMPTION=3Dy. Otherwise it schedules
> > through preempt_schedule(), and RCU records that switch as a
> > preemption. An RCU-tasks read-side section ends only at a voluntary
> > context switch, cond_resched_tasks_rcu_qs(), idle, or return to
> > userspace. The helper reports that voluntary quiescent state and still
> > lets a non-preemptible kernel reschedule.
> >
> > Changes from v1:
> > - Delete time out logic.
> > - Change "cond_resched" to "cond_resched_tasks_rcu_qs".
>
> These three lines belong below the ---. Otherwise feel free to add:

   Sorry, I had forgotten it.
   I have added  --- in the patch just now :
https://sashiko.dev/#/patchset/20261106033141.1509656-1-frankljpliu%40gmail=
.com

>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
>                                                                 Honza
>
> >
> > Link: https://patchwork.ozlabs.org/project/linux-ext4/patch/20261028061=
628.1209508-1-frankljpliu@gmail.com/
> > Signed-off-by: Jianping Liu <frankjpliu@tencent.com>
> > ---
> >  fs/ext4/extents_status.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index 018b6146b9d8..62346eaf4350 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -1721,6 +1721,16 @@ static int __es_shrink(struct ext4_sb_info *sbi,=
 int nr_to_scan,
> >
> >               if (nr_to_scan <=3D 0)
> >                       goto out;
> > +
> > +             /*
> > +              * Report a voluntary RCU-tasks quiescent state before co=
ntinuing.
> > +              * cond_resched() is not enough: it is compiled out under
> > +              * CONFIG_PREEMPTION, and otherwise switches via preempti=
on, which
> > +              * does not end an RCU-tasks read-side section.
> > +              * This also lets a non-preemptible kernel reschedule.
> > +              */
> > +             cond_resched_tasks_rcu_qs();
> > +
> >               spin_lock(&sbi->s_es_lock);
> >       }
> >       spin_unlock(&sbi->s_es_lock);
> > --
> > 2.43.7
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
