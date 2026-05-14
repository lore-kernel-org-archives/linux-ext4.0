Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B33F7A92
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771321; cv=pass; b=YSzqU1QR6luLgI7bmNGpvGuGrZ8zxP5WBhyLeFy30UhH6ENeY7z+w5e4rR7E2X7Ic/jOGTvNpWG2ikxT2LqAra76pqe5e2awPeVAyD8XxEjVRL27TMr7X63Ar36J6IP2fjgHfx+XfSVoAOR8Z3F450XATmcnStIpic9qgyhKetU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771321; c=relaxed/simple;
	bh=Oqw0NDluenc4M9KSxSuO4kI1l37w9GHWqNHYO2kNx68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FCwzZAp4PL0ibGt+H2rl9BJa2yb5Lp/giowjyXbGbcZEPsljr0b0Lw1UDwUs5qUsfRzpE5Ev4w3VDa/mFhefa0/ZTSsa5tttgek2T6I2L1hAn8nLvWzYoUc/397tMbfz7VAUiJWW2CIv00p4XkEjNmDswzYz7BVmofgboJslJ64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jFPFUZyG; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFPFUZyG"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43fe3e22e33so4907270f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 14 May 2026 08:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778771314; cv=none;
        d=google.com; s=arc-20240605;
        b=bAcS72BeOMJyM9HPSD8luVm/0uweQ9o4nOHSZifJvbVaEibtDKaZE673XwCE4fGrJW
         /R1v5MwQU6bMrkoH8eeicI4+iVw9z2ctKazFodwd5mrbrX8h+TyQN+1BYtsXPZFF38iv
         H5f2A/k/+YiYZRqQFYbpK5gR06KviZYX6SpRpIF7Ey00eymddxy1QS6X+rN4jj0F/SuH
         T0mcsRl6cv1XHOSvzZInni6vW2D/b9bXcBeX9gQnF1DlWdHEfhj7sP+nUY52eEkGLMMO
         FgFZ7vPMV70alEKw2t5Gw76WDQNUSOj7KLteFyhcOLYGkK9kBgC+i4HdQ8qWeadRPs23
         zdfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        fh=sxj0cB9Vjz4erRxqIGdCz/Ow0qaWpnsKUPjhLmtNjyY=;
        b=RUG9Jiyq49BLdFerMITrTpdBBZE9jKp0WvC9GRkDR183KVeNZKyilkSXZMHZlgJA0f
         pEyyIqZSzdLfJl3edHo0/K15Oak6y0DFA2UvEQkr55pgF2G7x9EZ7OWNfirPrkzRsPwu
         Ey0PpPq8/PRmYWX60ABR3/WGv5xKAhpZw+bSgUJsrh1QGwmf1wnCCUt+fRYWvjOVLZml
         bzswQSbrGUF86S/KhBY4c4nSuJOeoQdyDs4KsBl63JAeceYAw0PWC4vBavwxrg8LesRR
         9jm3/EPXZk/XDor0EQ+JaFhIStFh5AFkZmauf8CWb6YdONsL9FUDbZotI+JkkZh9gPuW
         wcJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778771314; x=1779376114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        b=jFPFUZyGbul8cFDW3q1P3p8RLFHIlj1m8F/jtBNQTuTemT8CbQcyZBT8xxrwEoNmdx
         dvoD/B1XdCHqWwexSKNL3GiAmxfVL27b9xO8VLbakoMzQCIlWUsOfnwuogxd2hefNitU
         EA/47XveoOX3bQebaE5Bn7Ib1z0EBA9QLxXTki+3y3j/Ix1432ha4YtONJr2yrwRUiEJ
         Ln2BI2WkrizjK6YQ5oQ7r21y+2JS2T8GcBqe1dKf/TMkqN3KHUqQuNnMrqOzpOgz+0Dg
         uvbu+oXzpm0FA7jHZYsRB7qlCYMB+jrUo9yjOLaEjPixn52lGmzHwMM99fy2pZE3AbJU
         BVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778771314; x=1779376114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+bdgZnAoM28ZGhdZNKKk0p4fIizw0yp98Oy054cZAiQ=;
        b=mVzHRS9YdnCVp0Di/MWMfdGNzpB5GfrULniBofbFZ5gC2Q7Re9fEl4i1i+bvCZ0OtO
         3DBxfoYvlRWv6p0QssuqsgKgMow1Y+XOrfH1J5CEzsLDu0S9xY3xHSj85Ls4jKp1N27q
         qjmoOB5J/IB1XmYgALqPJhCBvBbXruHRenARp9uGWAZPJwZgCDXRdWt5ND1PhVZ0Jv8Z
         MrEg21/MLJSpSstn/EG2ju3euCnZs6FSUKpmug3LYtbLA2VrIjfhO5tzgAgChGiyGas3
         gpfhvVnf04N3xotjRxqCJNLTotiQtEumBAt4YT7A+P5krGCE9XcZwlRcrKJfv9gFwIOy
         Qm+w==
X-Forwarded-Encrypted: i=1; AFNElJ+nTjDY0fOrewVKosUY+jIDZA10MWy7vxVH3qGsrj0xtpMP/qH4wcsMt9Gqq+/aCTMJl81nvlJs4OF7@vger.kernel.org
X-Gm-Message-State: AOJu0YzneTCnGCNpq/4syBBy9z4mns1JvrjbpTcE1o4s+YNM/8Y56w++
	9SUuPhDa6HCzVky/MXGOBDz/cUHLkrvNXMrwg6vHLvAOjZmwy4heGjrX/0pVDPa4dYBbnoK25VZ
	ClLyRC/qxgpdDqu5SQqj6ORg93O5NrXk=
X-Gm-Gg: Acq92OE2M+fdwIbLkVHlb/DK/H/Qhl1sc+TLZPIt8IbsJq0J2o0orv1qe7SNIF32I55
	ilm6lioevQjWym+yv/4TU0m4nJprhIDJufDGnOyvQAVgdyrnfTb9a7P3DI7Pk0qpkKK88jUZ36f
	T1Br8F2rhc3Pzh7rkT+m4xeYryhwIdm2gHTgoTczEL2/cVtbdsJ7Nr2lU5ZtGbxHWKQW5WIpvWo
	pdtQ1kFBvO/L+KqW4H/zau+afNrOuJyjMC5l88Wo/uJIozmFDmQ12MSMx5ftLpX7Vk6gmyCiZ4g
	ZpQ2fA==
X-Received: by 2002:a05:6000:24c3:b0:448:8db5:410b with SMTP id
 ffacd0b85a97d-45c599ebcc5mr13067532f8f.20.1778771314283; Thu, 14 May 2026
 08:08:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com> <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260514062955.1183976-5-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 14 May 2026 08:08:21 -0700
X-Gm-Features: AVHnY4JGAYta6lc0ZFFwSJBwWzibm6rBu2Rx6wdCCAM4bkR5PfJiohRCslD9kBQ
Message-ID: <CAJnrk1bHM9aGXbk+LJYJZrfbtLvbwsqwrJgY2KkT5AyVfBjdrg@mail.gmail.com>
Subject: Re: [PATCH 4/4] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2026 at 11:35=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com=
> wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> ifs_set_range_dirty() and ifs_set_range_uptodate() compute last_blk
> as (off + len - 1) >> i_blkbits.  When off is 0 and len is 0, the
> unsigned subtraction underflows to SIZE_MAX, producing a huge
> last_blk and nr_blks value that causes bitmap_set() to write far
> beyond the ifs->state allocation.
>
> Regarding ifs_set_range_uptodate(), it is temporarily safe because len
> cannot be passed in as 0. However, for ifs_set_range_dirty() this is
> reachable from __iomap_write_end(): when copy_folio_from_iter_atomic()
> returns 0 (e.g. user buffer fault) and the folio is already uptodate,
> the guard at the top of __iomap_write_end() does not trigger because
> !folio_test_uptodate() is false, and iomap_set_range_dirty() is called
> with copied =3D=3D 0.

Is the Fixes: 4ce02c679722  ("iomap: Add per-block dirty state
tracking to improve performance") tag needed for this?

>
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 27ab33edbdee..6fe5f7e998fd 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -67,11 +67,14 @@ static bool ifs_set_range_uptodate(struct folio *foli=
o,
>                 struct iomap_folio_state *ifs, size_t off, size_t len)
>  {
>         struct inode *inode =3D folio->mapping->host;
> -       unsigned int first_blk =3D off >> inode->i_blkbits;
> -       unsigned int last_blk =3D (off + len - 1) >> inode->i_blkbits;
> -       unsigned int nr_blks =3D last_blk - first_blk + 1;
> +       unsigned int first_blk, last_blk;
>
> -       bitmap_set(ifs->state, first_blk, nr_blks);
> +       if (!len)
> +               return true;

I think both callers of ifs_set_range_uptodate() use the return value
to decide whether to mark the folio uptodate or not - does this still
need to return ifs_is_fully_uptodate(folio, ifs) instead of always
true?

Thanks,
Joanne

> +
> +       first_blk =3D off >> inode->i_blkbits;
> +       last_blk =3D (off + len - 1) >> inode->i_blkbits;
> +       bitmap_set(ifs->state, first_blk, last_blk - first_blk + 1);
>         return ifs_is_fully_uptodate(folio, ifs);
>  }
