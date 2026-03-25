Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32507327BEC
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 21:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774472855; cv=pass; b=MYbIpbXoa5Vw1W6cjPQwnudPbOWd/w4/5D/+RjgnWXh/Y5sTAaHeo4wAhCEibcU5gXRL8AvWkTPRMkqxwZf1UrGgBk+Xo33WfsUkS6nxLXKsPhRoBtbP2SrI1+ZtGu/eJHP9D5Z9+ErYcZKiL0YNswBA/kgAOxBc6HfSjQxUVv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774472855; c=relaxed/simple;
	bh=JGjs+v5dawp1OwMd2nAirdT8cW4F0CuocDS42X+FnRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tH9A5H10WsXIu76d+CaEj80B0V1B8oIqHGjXtKk0jwPkFE2QfMe8iqDIujRdjlRc3QI3MIXmtUFSNiwQcl4VBt1Cj7CxcbTvljINiCWIO7tf/gYn01RNmiy5oPcajLzxYJLHInrv5ft7l1e1SdVlUE/nWZCowxmSiKDK23T78RY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OImVs1zk; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OImVs1zk"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66970715adbso551135a12.3
        for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 14:07:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774472852; cv=none;
        d=google.com; s=arc-20240605;
        b=JykDlY9aTrAHg2Kbkdbo3i/s5EnhWdx9eAzTddbbnIkGMZFUFt2IjIIhCYg2qAbMta
         QZSTj4AaTkNXi71F58H/UVc8MYwi3eEMABvpizR1XQy/55xcJ2N47eq11iYMP4EP6u2m
         YMYzhAiwNuola92DjokCUGCLNoX9rzCnGb0JY5KNVlH0aQWX35is7rAcUPW5SNW1khiT
         S8BQ4VhcsVafVq7TpF4zqjujhPjOQ+nLZrV3Q17RjBec0e70kfw0orwAeMHIvBQAhvIR
         UZ4msOjMiXalZZEi2Kl32oGqAZbPaKz3nMCVzh+xpXtyzIcbbaw7tERYHZxrB1REtjV8
         BzYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MYHNxKB+bgvczQp1QPu1TdjgicMQ/b36W0rRs4Y4aSg=;
        fh=PO4n2WBPaalELz73/30y88UgVUim4kmeRddFh02b9dE=;
        b=C2tG76fXMIUX034JeEVq1T+3OooHipgLE4YkZK5H+JBXuplIQlD1rm2Yz63VC+TcCC
         wGQqvyyPJOd2W7XR9bfx1qrHb568QeVTYCwPg/c7B/tzePdUK741HuHhbuQkclOKUH1y
         5MpL2wXRnMm8oHY7wGfvbkgTakOKrhGcN5dJBkv6PRgnPGxYLg7e5SJRoJWlhC7a6WWb
         x5WPT4NjinCgKSbucBn4obr9LK+0fZfatP9wBGHdxvOxg3MifTHezAdeJWiVNEG26rvF
         of9zWvK72hI/96+m7O4GLkLjBkiPaxsTCSZYNIcx5mATMBZP9Oo5SY8k7vEO5U5+TSaw
         tmOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774472852; x=1775077652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYHNxKB+bgvczQp1QPu1TdjgicMQ/b36W0rRs4Y4aSg=;
        b=OImVs1zkUJrlAkN52OwyfOW0lQFYMTwJf4Aq0gO3e+S/8/zHDfVDOG7htEcM0wVjxS
         7QBcjyYil/fcM56MZvIPoU8ESgiGBASTGxGb0GYVcHRaJ/Yb7GWo63hKC6fSYxx83Nky
         IMAZg9n4IICog16zDUZqs6PM9+B6T4ID8SUXWLDs50vlRwQaayYepSt5SzlQ6ruxnhIh
         MhgnFk4BzJwrYUo7QqlgkVfz/iVGEic1WZ/sVbH8IbyOmaqkZdNoNran00OHGlnmt20L
         2cNTbKeBQrxptXlhbB+Umo6alPQsb1k7KhAUg89JpUOelK3yO89TSz17qzDSrWcLS4Xn
         jjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774472852; x=1775077652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MYHNxKB+bgvczQp1QPu1TdjgicMQ/b36W0rRs4Y4aSg=;
        b=Up/jqSow50OhZfbcxqo+Ilzbt2YlPQJjS4YOO0AJvSpdSa7+ObKaZNdOdp9WXNVBVR
         8EBpLljJdkKXTX0cjCCIlyTjc+26Pkk5NLbzkPGV64Ehdg7NA6d/HHaYDFFYcyVfaYPE
         GGHq2XrkfqeRIdFWM0X3M5p8uIHaWFlszixv5SVq843u3mvIafiNBB7xO0yR+PrM0lNt
         fKGb6hGWVD4L2H0P4bMA/sRuIdGAfXVncZTCVg9cBpiOuYNowVZtpsFx1mghii6ESmA0
         /w1wT1m+hoQfznmfd+q40GM1M9lL2oIfinwim2enEYcDABJZA7GKyzDXOb8HL2XALAM+
         AGMg==
X-Forwarded-Encrypted: i=1; AJvYcCWdroCvWEV1HQRzvlmpM8xBFHobOkpKYFv9YiE6cHV3+l5fZM3vm96sRu9u/nyGl57211sjtRnom7kC@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9678641OjjkZil0BSEalbctbE5u2E69WfAGv8t3lZRQzDKXq9
	FjkCejqO1ErlbNuLiHDxkosYbxNv802QuNMUxuPVoDXv1WNIkN/mZSDhIYOIGQ89U8pvyV5qe9t
	kQHlJPtiGsAfdUq8IiFHpcGJ3h0bzZfX13PSl
X-Gm-Gg: ATEYQzxbXTVlC8xs+mAytj5p+wFEFKz2bzcV2wbW31tNaWkxP0CnYRkwj+fewL1bGz1
	baRq//Vi9O9+KlDbkSk9WSLndlekyYRvbI0SLj0FXbbrfdOybxDogE9bmYhgePh+gzhr6n3lPiw
	iTsHanN2Ku0l1StUYnUhHwy18y5Vxn1oYpW1R3zePwKZYILOrUnto6U7Ng9itz2fPhEgHb5nvmH
	eQxPOOnwc9Z0+QUXFK/o14iDzjqd2zj9joittxFTeQW7btbHN7cVaZ0uF0QgVlym8AZixkhcIHC
	54DrpRZOyZOtBGGOFpEbNT9GjQrjdqIq8mPgmpo=
X-Received: by 2002:a05:6402:528d:b0:66a:16ed:46d3 with SMTP id
 4fb4d7f45d1cf-66a826ea687mr3278329a12.30.1774472852230; Wed, 25 Mar 2026
 14:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260320090428.24899-2-jack@suse.cz>
In-Reply-To: <20260320090428.24899-2-jack@suse.cz>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 25 Mar 2026 22:07:20 +0100
X-Gm-Features: AQROBzBanJ2emY_czit1kyH4Eyo3hZKOPBi6ESjKXPu7BVQXtoaBV59UZf-eTh8
Message-ID: <CAGudoHF8zgjcKiHx75EwPmz5eTp_7yk+dh+ju4Ju2xZJqFJYvw@mail.gmail.com>
Subject: Re: [PATCH] ext4: Fix deadlock on inode reallocation
To: Jan Kara <jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, yi1.lai@linux.intel.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

can this get any traction?

master as-is contains a change which uncovered the ext4 problem.
either the deadlock needs to be fixed in time for the release or the
other change needs to get temporarily reverted.

interested parties can find proposed revert here:
https://lore.kernel.org/linux-fsdevel/20260316103306.1258289-1-mjguzik@gmai=
l.com/

On Fri, Mar 20, 2026 at 10:04=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> Currently there is a race in ext4 when reallocating freed inode
> resulting in a deadlock:
>
> Task1                                   Task2
> ext4_evict_inode()
>   handle =3D ext4_journal_start();
>   ...
>   if (IS_SYNC(inode))
>     handle->h_sync =3D 1;
>   ext4_free_inode()
>                                         ext4_new_inode()
>                                           handle =3D ext4_journal_start()
>                                           finds the bit in inode bitmap
>                                             already clear
>                                           insert_inode_locked()
>                                             waits for inode to be
>                                               removed from the hash.
>   ext4_journal_stop(handle)
>     jbd2_journal_stop(handle)
>       jbd2_log_wait_commit(journal, tid);
>         - deadlocks waiting for transaction handle Task2 holds
>
> Fix the problem by removing inode from the hash already in
> ext4_clear_inode() by which time all IO for the inode is done so reuse
> is already fine but we are still before possibly blocking on transaction
> commit.
>
> Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> Link: https://lore.kernel.org/all/abNvb2PcrKj1FBeC@ly-workstation
> Fixes: 88ec797c4680 ("fs: make insert_inode_locked() wait for inode destr=
uction")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/super.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> Ted, this is a regression recently introduced by VFS changes in
> insert_inode_locked() but I think it's best fixed in ext4. If you agree, =
it
> would be nice to merge this so that it makes it to 7.0 release. Thanks!
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 43f680c750ae..b8122d24c083 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1527,6 +1527,27 @@ void ext4_clear_inode(struct inode *inode)
>         invalidate_inode_buffers(inode);
>         clear_inode(inode);
>         ext4_discard_preallocations(inode);
> +       /*
> +        * We must remove the inode from the hash before ext4_free_inode(=
)
> +        * clears the bit in inode bitmap as otherwise another process re=
using
> +        * the inode will block in insert_inode_hash() waiting for inode
> +        * eviction to complete while holding transaction handle open, bu=
t
> +        * ext4_evict_inode() still running for that inode could block wa=
iting
> +        * for transaction commit if the inode is marked as IS_SYNC =3D> =
deadlock.
> +        *
> +        * Removing the inode from the hash here is safe. There are two c=
ases
> +        * to consider:
> +        * 1) The inode still has references to it (i_nlink > 0). In that=
 case
> +        * we are keeping the inode and once we remove the inode from the=
 hash,
> +        * iget() can create the new inode structure for the same inode n=
umber
> +        * and we are fine with that as all IO on behalf of the inode is
> +        * finished.
> +        * 2) We are deleting the inode (i_nlink =3D=3D 0). In that case =
inode
> +        * number cannot be reused until ext4_free_inode() clears the bit=
 in
> +        * the inode bitmap, at which point all IO is done and reuse is f=
ine
> +        * again.
> +        */
> +       remove_inode_hash(inode);
>         ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
>         dquot_drop(inode);
>         if (EXT4_I(inode)->jinode) {
> --
> 2.51.0
>
