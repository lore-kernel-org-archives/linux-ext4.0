Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793204284;
	b=IiTNua/6WB8OxMVen0e3Kn6s9P5pV88k/afKdMi+EaJa0SAv8QAU3EBHl7ZQQiD7GStA
	 c1XhjsaXNmVnwBqUPDACL1PfZuJYAK0bZdiVf3CHSnux8D1DN5o9yOhVWqtKk9tpJhwOK
	 upbKuYw6amTlUiWjQajIi62U3fFJuEAA399msMKvIogR7HvhxGFU2wYbML4yG7XmOQz+t
	 ynXrMANEhs2q+Mh5BgTYAz47ifaSvnVjEjO3VqkBXn7H3IXsATT6AEq8lkBmo6n5E/tYy
	 qH74E+hBt5lPT6xd+OlfQ+klD6P4S21hzfxJBjGHnzHh+FJJ9nGxL+8WQPpE9fR7FjQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793204284;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
	b=v0LgrOU33NFyWkbjCHVkMO10NZGFvGKafJ/OyHWl9qaYedaBGPkEcMe/GUk3anhSceXb
	 ukf9D07W855mp/Gv/pFR6Ms8n2T/qtMRfUE/P0RKo/ftWHgW04BfTtRdPjSkiRBJumPGq
	 UD3AnUAoMBHkfKNQlWdONLAXwWGsQDynxeFYQwfbH5g4IElw4q7SMkwN3DXoC+AfAU8Pz
	 QsrwEzeiO8kQ1mLz4j8Xin+WJ9dOWjPCMbZ7zE9f2QOq1S/36vdF2kXVngeJEbgwugMfZ
	 UiqfwweUwt6W6xVyp/Zcur5Gwpx7rIVR6D1d6i1OIdfhny4B5g0ddoNkHOtzE2iAQ8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE008606A31E
	for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 16:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE008606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aE0UVEPl
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-89ff475a152so575112b3a.3
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2026 09:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793204283; cv=none;
        d=google.com; s=arc-20260327;
        b=LEgd4fjhw5FNsyaE093UhCKOeyLV1HsoplnG7m66bHrQMuf+TkWGN2QCgMachv/5JX
         buOmJhblC7h4IMjsxkKNMctNIcUP7JsMEdUPJj1eKAkn8Kb4k7DXqw6cUnRv7m9Js7BG
         46gVoQ24VLd0kbLdj35d9ZoIixk2MzxOTq5eTlUOW3kxxZgQ6PLw8Us4Ekt1ddTcnlVM
         k05Hq7RfKWzeCft32GbsFwgut+DubgysfZWrH30WvZAm9GlY711vMEwFtHprj9feypPS
         30NQt24MB6U+ZiXLbbpQB3DbOBMnCsgwjksYKWAq29Z0D2rImtNTIghx4Ro4ubX2cgO+
         HJuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        fh=hviFk8mxVozNpi3dRTXYqiApCdCV/dRA+6ZX9ICy1oI=;
        b=nDpqdIDadtd72ln/nxN5O35vZd69H0ElHOxgJk1FebBTdhzcPE9KyMdMA0oDzBYGaq
         4NIdFBbVBCGbx2fvjvroYKv1CxcKzhNlmFSiceV589TvVImI6xQ4uXRK6XHixW1Dy9lC
         wQ9gqIy+LmmXt1miF75qQN43kJOGdgNvDyf08zPv/lXuOczuxgUVaT9jVGM7qvJwj9o6
         32SICEvjRLZaTodRjW5ZZom33WMA5eOUzzroWcSnycCjWBZnFqR9qJfEGgEAA8xMdPyP
         zoKVoXsZ7e9XRaDnlYt7I8IdD5CF6cr0LXOEQ2PvCntBup4JxAC1zS6glkeg/qmk0hDp
         ObFg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793204283; x=1793809083; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=aE0UVEPlAf/V7Y31izbriey87faIFsoS80MZfhPz+nDPK2fFTvb3pIODF+rYWahhAL
         IE/GRtPxJFWJY401Rp92EZ6jNjNQiz4DcR1KQKNa6Wrp8DP5JXEhIV3bawUSZ6OBMF3Z
         Fag/CZu8p4S0vDV+pKLBKXG5EdyK4ORV7TOV/oJxfGOY2FaA54ToDtf6HylO7ckImk9L
         EZJGWpNqqI1H/cea5knc2AQwEuMaFuJBcGtCUYmE2I6v4kVZDruIbLWQjeqrsqwYkeKv
         brBqy/vSgeArKD9ZAiQYA43dPDFIFx74Cu6p0i9jVLMzAd7CHb1//RgOJp9+fhNk+tAC
         6PvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793204283; x=1793809083;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LR+4Nh8FYTRY8kZRrhgD+RKAvmlbTqJy80aNBobHu6k=;
        b=HACt7HdxTP/SnBWaZvtrdAS57q9krWJb9hLZKB0CI4lsvAkfwFqZoAhAxhWA+Hvev8
         XZPdMwD6YyI678G1LSelZLCEcCARDh8z/x/JMn+LB7Fwt03Kq6cg0A4fqPTBqCw0kFr0
         JoOaNX1/ceNDtMnOZVVk7ZCR1ChxjMNzxIhBhryIRI9snpZOoVxixhRdZBnXLBKc+JIz
         EeuhSHCqLqpTEwyBFXtu1gb6dBB41IcCWrey/ja1nEOuS5ABL6R5L81PEwtp6Fz+ju1z
         /fY4ble3asEi3FT1LvudTxTv/LtJ6CKRLccqY8Nq53NYRJ56gPeU7trGDyC8xc8rgIBX
         FhWQ==
X-Forwarded-Encrypted: i=1; AKwUvBw9MjglFljxOFX1Nv7ESYiwmrOfeGtiz8DmO0Ng2W1i7Z0nHDHVPbqWysJs+iVxjyxui7hpvmyr0Toc@vger.kernel.org
X-Gm-Message-State: AFq9FYL5Y6dtwa/Cf7Y5v9w4oyui/mI+tZ7hPyUuuTLD4Qouf5ChXHF4
	gVPYpt05FADFnNbGXHJLeKEZfnIJq0XXsX9DuhAFEzIk7mBW+7DU9qxxfX7vnGqpUqeH6QeOmpe
	JoNrCW3zFfXjVD4Dh/SI6rJksILxC8DQ=
X-Gm-Gg: AYBFou15VOYqLzjkW8hIkEMW8IlivkvDcL2+011mberNRA65RWr1L4vBGEiV7rp9LWA
	hMYD1qCadvslChPV3MivZSP0KwhFyWYVOekzR/GyrrHimZr2pSEpS6i97oyWeHkvDQQbtBXJyhe
	nFdo1Myg/C22OWi9ySDZ3+Rp9udoisvm9voo32ag+MJc5OlO2kEkA4aKRLflRVnfrOe/7Tiw10A
	30bTAUyWxXYxzX2HbBkGdwcFqY9fBpHAQDQt87f63PUBhgFKjEs8vGrvdQPuo/QnvjYrUKOnju5
	ObgO4ptsKAmc33w2EPfOsXZhIK9QOnBtjXhh7LiT8tf1nONLNxvQZupMPcE+IqQeHgHO0LJwOks
	yetPkVh2vE5/tOqBljroeX01zhzD80omV4o+yDA==
X-Received: by 2002:a05:6a00:391f:b0:89e:9560:fc7a with SMTP id
 d2e1a72fcca58-8a6e6efa7a7mr2168656b3a.29.1793204283163; Wed, 28 Oct 2026
 09:18:03 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027215326.2693300-1-joannelkoong@gmail.com> <20261027215326.2693300-2-joannelkoong@gmail.com>
In-Reply-To: <20261027215326.2693300-2-joannelkoong@gmail.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 29 Oct 2026 01:17:43 +0900
X-Gm-Features: AclHuK91pZpqmliH2N1ROYQZJFORz_xx3uP0uM_hYUkPFZ1oO9AzV0q2NKIx0ms
Message-ID: <CAKFNMo=Kqs0T=a578WN+=PZ2gse2APWZ_jnJ64XyrerFK41sXw@mail.gmail.com>
Subject: Re: [PATCH 1/5] nilfs2: convert iomap ops to ->iomap_next()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, "Darrick J . Wong" <djwong@kernel.org>, changfengnan@bytedance.com, 
	kbusch@kernel.org, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	Viacheslav Dubeyko <slava@dubeyko.com>, linux-nilfs@vger.kernel.org, fuse-devel@lists.linux.dev, 
	Zhang Yi <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 6:58=E2=80=AFAM Joanne Koong wrote:
>
> Convert nilfs2 iomap_ops to the new ->iomap_next() callback. The callback
> is generated with the DEFINE_IOMAP_ITER_NEXT() macro, which wraps the
> iomap_iter_next() helper to finish the previous mapping if needed and
> produce the next one. No functional changes are intended.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

Hi Joanne,

Thanks for picking up the newly merged NILFS2 iomap code and handling
the additional conversion to complete this series.

While this patch is an intermediate step, the changes look good to me,
including the finalizing conversion in patch 4/5.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Thanks,
Ryusuke Konishi

>  fs/nilfs2/iomap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/iomap.c b/fs/nilfs2/iomap.c
> index e130ed63abd9..359786c97f2b 100644
> --- a/fs/nilfs2/iomap.c
> +++ b/fs/nilfs2/iomap.c
> @@ -67,6 +67,8 @@ static int nilfs_iomap_begin(struct inode *inode, loff_=
t offset,
>         return 0;
>  }
>
> +static DEFINE_IOMAP_ITER_NEXT(nilfs_iomap_next, nilfs_iomap_begin);
> +
>  const struct iomap_ops nilfs_iomap_ops =3D {
> -       .iomap_begin =3D nilfs_iomap_begin,
> +       .iomap_next =3D nilfs_iomap_next,
>  };
> --
> 2.52.0
>
