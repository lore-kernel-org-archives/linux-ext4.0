Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B736F1E492D
	for <linux-ext4@vger.kernel.org>; Sun, 31 May 2026 01:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780192160; cv=pass; b=ggXWP+5uN6qe4RuKbCKVac8n51AP07Uo7xR1s4j+9PyeNhrGHPhey6Hgy+PfpO4wIqKMocjdlxbB/Nkm1tKNVKwkUupGGSwjVYRxgkgq8IFrtx0uhgitU91gouxYfAhPKoHLEp4J+/UIqTDRWlvKGeZCYDsY7wxtRX2ePDa0xgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780192160; c=relaxed/simple;
	bh=A8HLHhbwIBFhaPWuTSTtXyzEDduN3a5G/gWDMiiuKFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBt/T4O22mT+sQ1plVvlt2jBpmgT6JjkBE+byF0UAdkXNV5PX4LD6dLpuZdhb3/RW1a3nYBpOjdLH8QwlYecB1+jzedcxTRhsiVVX4x/vj2NkzOKmkP+9zX6xcmn9ElKlhLGF5/LUVWh492L63obJRT8Bf2tOZqr5qysSn2A4Kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MJMhscza; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJMhscza"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6604df9ba4eso1522589d50.0
        for <linux-ext4@vger.kernel.org>; Sat, 30 May 2026 18:49:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780192158; cv=none;
        d=google.com; s=arc-20240605;
        b=QQ7fuCM33vcN7Iv6pj54WqJ3hzAULYFbwa4W2u8GXu9npNWMN+HXKryY1bKmkXp8Yq
         c25T2pLBSWETqUBFxbpr2o+R14SykkMy8wJir9Pt76JOZ2XuOTzGjrs+TNJ28auS8+fC
         t/4RolaSpe2dooAI5nu84jXxunrc6FzvKawDCjvLhmteccPDLYg7KhqAlhFFL8M46eXz
         QnilSlGx5qkj+VO5DBhwhDacali/O4XhQ1rNEk/b2ei5ZocWG7HfFRVKv5Tya9WUJkXk
         8bhCIROKruWbk/K/+yo72Sh+mNI5i23hwp5vyMnvO66hkTy2GDgcBD78PswKCAr3llQe
         wmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sf0WF4YnZQfmy1VY7oAHx1peijwCr//lUKmblGm638k=;
        fh=ItR53ua/NxAh+K0BJQ0Y4PGiJKh0xe9YMBmyJboPlz8=;
        b=TdMQYlK/A8K2b+cHHc2B5bqL+HBcpJ8+EUt9WS7CZ++ee8mlZ0idrBfuoDDLB/iDxU
         py+0gzHqnkoqr8HsdXxbKcWoaZErRKl/GTOnP6BeDsOoGweiskV6LJZLFzTpJD8Zld81
         WzXqt4exl7JOnV3ZHNcZ571HZU6S4YpWbUQKRZs/ke1daa2XsOUvyt2UVS1U8AV8COQo
         JSyiE/WsBFZu8uQNnehIV0XJBXDjGRvTFvXQKxW/gnOyoSGB9pGzCnTK1WOjOVtPjs73
         z50tIvwRV1iV0Gi71gPEWeQHlFb4APngOPBEE/3OE0taisYW9K44TdV0rdqfutq2vQyq
         SKdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780192158; x=1780796958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sf0WF4YnZQfmy1VY7oAHx1peijwCr//lUKmblGm638k=;
        b=MJMhscza9e4+66GT5FE9ZKHRYY0gnlHHaZbiEo72PGTqPvmXiBUfy7CWxSeDoh456K
         IUQrm6AuKj1S+vKcd2ByqtdQgOG6qo+cWp1mQTs7FMK/qQAHZXZAdDLpnulrXQIEjkmo
         hmYvLP1bYxGW8vutaYmpNTqvnOZK8u+nhIiC8dRohjqw7Ytdtu7VLCgw0Nuc4WgO+ifM
         TSYudpbnYpaS8aDVQ5x/3waTjJMd+PdP5gjLZxNNJ9/Tw8coukCr3PMfGbzaJwdOySBg
         bGZau0zezwTFBN4ngXVGzOZUViDyrZ0kHy+XMyUg3tooh04SofFF53ZkgycIIzeJAHNt
         KWVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780192158; x=1780796958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sf0WF4YnZQfmy1VY7oAHx1peijwCr//lUKmblGm638k=;
        b=pUghrzCi0rKfBvEAj9brt1ZEUgCRAJKIprW9G5cnFrb3NyZ2ESd9goLUuT0GYspfPY
         qCTAVFzEHGE+KTE/b/Q+YJBXz1UO7yGf9INbiWqYRZJtjkfiv9coaoyrqmslLKkfffUh
         M3lbnWTviPY/vwJwd/jw2hy0aZFaWIRoW0OI2OGvrxXsY7SkwOhDwEMQfZTZ6bMXbEVE
         nmF5A83tQGqphilis3PG55nzAqMMiSKcMD8hNFMU27T3FEy+ANEpFIKRYhdS67jP9czm
         uJjkUgLSKPBMCPMn1Wq1/nnYjfGkUBtl4ZArubZKAP0TSLZiuyGNcvtl33KKgNpDhDKM
         clXQ==
X-Gm-Message-State: AOJu0YwinmpiU5ZmhD9aQs02v8jVmENeMR5K3zU+fIa89lDGvD4+IHJR
	KHwtGSE/ciI5HOL5XQW1EQLMOnzdyUqdbDnu+qZgUst/f9QzBsA8qg446ik6i23LB2a5wDwQwtC
	ROvVsXouvjIJZorLo1FswVk7ljJ9LBBI=
X-Gm-Gg: Acq92OGMW1yfKCOIH1y3+goTZRM1BgtIeB/Q8LyVdN5v0AAARe1jzXl9bSBZcXq78a0
	P7+lgTcLpl4c6hnk9q5jnlZZwD5frg/YWAT7Xk71LoxI1eqKS0RJGcgfQ9E9WyH4uI5q2ykz6TX
	qnkD3INQe2sgToXM9JUdGklqK4LVd3lhDEcv3kpC6elEm5kCEXx/5X4s64gld82nXb0fOQX7Gcu
	MoNTZ3nJQRw9S+quCJZLsiv5UuZ0s4DxA52XhjOuE0X3cWm4YnA1DXjSMubtKR1TdhzhWYIWxKx
	cNkwbKowCVADMxoJOXT9kbJCBFc8VaPdZJ1lWaxtVr0sl++HTxdwM6KpdESk40MWNEbJcHcnZXu
	n82r3GQ==
X-Received: by 2002:a05:690e:3cf:b0:65e:b380:b6c5 with SMTP id
 956f58d0204a3-6605efdd7e9mr3015643d50.21.1780192157707; Sat, 30 May 2026
 18:49:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260507050605.50081-1-kartikey406@gmail.com>
In-Reply-To: <20260507050605.50081-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 31 May 2026 07:19:06 +0530
X-Gm-Features: AVHnY4I2XVTjH2eMK-GKn1fRiU5_mPea2ueZJxeDcObJ0UUH2GoiY7NwzeXSeT4
Message-ID: <CADhLXY5Rfe6=9FtwbWcOECys=3BEsidZy=NjAd0D6+pLoi=Ukg@mail.gmail.com>
Subject: Re: [PATCH] jbd2: check for aborted handle in jbd2_journal_dirty_metadata()
To: tytso@mit.edu, jack@suse.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 7, 2026 at 10:36=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> jbd2_journal_dirty_metadata() unconditionally dereferences
> handle->h_transaction at function entry to obtain the journal pointer:
>
>         transaction_t *transaction =3D handle->h_transaction;
>         journal_t *journal =3D transaction->t_journal;
>
> However, h_transaction may legitimately be NULL for an aborted handle.
> The is_handle_aborted() helper in include/linux/jbd2.h explicitly
> treats !h_transaction as one of the aborted states:
>
>         if (handle->h_aborted || !handle->h_transaction)
>                 return 1;
>
> Every other entry point in fs/jbd2/transaction.c
> (jbd2_journal_get_{write,undo,create}_access, jbd2_journal_extend,
> jbd2_journal_restart, jbd2_journal_stop, etc.) guards against this
> with an is_handle_aborted() check before any dereference of
> h_transaction. jbd2_journal_dirty_metadata() was missing this guard.
>
> This is reachable from ocfs2's xattr code. ocfs2_xa_set() intentionally
> falls through to ocfs2_xa_journal_dirty() even after
> ocfs2_xa_prepare_entry() fails, on the assumption that the buffer
> needs to be journaled to record any partial modifications (see the
> comment above the out_dirty label in fs/ocfs2/xattr.c). If the failure
> was caused by the journal being aborted -- e.g. an underlying I/O
> error during a sub-operation such as __ocfs2_remove_xattr_range() --
> the handle's h_transaction has been cleared by the abort path, and
> the unconditional deref in jbd2_journal_dirty_metadata() becomes a
> NULL deref.
>
> Reproduced by syzbot with a crafted ocfs2 image where I/O against the
> loop device backing the mount is sabotaged via LOOP_SET_STATUS64
> between two setxattr() calls, causing the second setxattr (which
> truncates an external xattr value) to abort the journal mid-flight:
>
>   Oops: general protection fault, probably for non-canonical
>         address 0xdffffc0000000000
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
>   Call Trace:
>    ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
>    ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
>    ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
>    ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
>    __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
>    ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
>    __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
>    ...
>
> Fix by adding the standard is_handle_aborted() guard at the top of
> jbd2_journal_dirty_metadata() and returning -EROFS, matching the
> pattern used by every other entry point in this file.
> ocfs2_journal_dirty() already handles a non-zero return from
> jbd2_journal_dirty_metadata() correctly.
>
> Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D98f651460e558a21baae
> Tested-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  fs/jbd2/transaction.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..aa0be9e9c876 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1516,14 +1516,19 @@ void jbd2_buffer_abort_trigger(struct journal_hea=
d *jh,
>   */
>  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh=
)
>  {
> -       transaction_t *transaction =3D handle->h_transaction;
> -       journal_t *journal =3D transaction->t_journal;
> +       transaction_t *transaction;
> +       journal_t *journal;
>         struct journal_head *jh;
>         int ret =3D 0;
>
> +       if (is_handle_aborted(handle))
> +               return -EROFS;
>         if (!buffer_jbd(bh))
>                 return -EUCLEAN;
>
> +       transaction =3D handle->h_transaction;
> +       journal =3D transaction->t_journal;
> +
>         /*
>          * We don't grab jh reference here since the buffer must be part
>          * of the running transaction.
> --
> 2.43.0
>

Gentle Reminder. I want to know the status of this patch.

Let me know if anything is required from my side.

Thanks

Deepanshu
