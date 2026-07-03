Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C35E318EDC
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 04:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783054205; cv=pass; b=UqO1UUKCd8TzbVzpY6pV0TGeMeThHSJDH5KRv/cEdgGcN5r+a49FG7wrDOYRFL2JalHixn4GdYt37NvK0Tv2dHUneiOijQV9zzl7Kk/aZks7EB8ZZ0ScKYk7o2sfyER1POLh4ox8KtAfsuAgbDmJ6MPQriRQEdKYz01X8D4dcBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783054205; c=relaxed/simple;
	bh=WNaI7evD2W1G/CdnGJTvDBBueYGbm7A4pArwx/U7aqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OqkBPwCohYo247ySBOy+XdJEAdpbKzFHWhiH5D5OgOa4dyLqLsr4ZXHiU3mg6qrCoEnARfCrBOnIi5fSlUd1rwrRNC63WARKk6iRFCS77zK2j/qvwOaxoUfdUoPZIggOQqgs5mUq7FDCoa6c0YCzW6jX/jEWhuTvrrzNBc2yE3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j7juXO4z; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j7juXO4z"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-698aa75d15dso252494a12.2
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 21:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783054195; cv=none;
        d=google.com; s=arc-20260327;
        b=k8NyKme71TAvsgAg7FADJHjZi+nMMDg/qlzWDgBzgGk7/QAiDsUqkFTJKRSIwCsjGk
         xtxaLa3k7xvwRJ2M73uioAgCiePwQ1XG7JPdttgJV1+cspBTEyqFJ6GgxC97mj155ULx
         SZn588QIxU4Ct/B2GOxfGSdFiKypyYQ+8ZvYkVZbISZ3SPTT9uLzgpdPm5jfLh6rowiO
         zvbqf5OR0SQE/wxhb3D0amITEODe6fhGf/+2AT/iZwRvDlNGzxmAklf0wYacVmAAHlx6
         XuqNiL5xspyA+NTrED5ScJGnwkhj82v98uK47EeWOoPP425O0gAMkfFFk+MEmOB/6xo1
         SzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=abYqechUaVMX68IHoATU67J3c08QbMDJ1JRtoo3TnyU=;
        fh=T+YB5wIaXqlyL/HZEX7JT/0etG37HoQDhLo21K61mWw=;
        b=SESUdJJ1ckCx8yVLKA9hGtk/weWUdy3sY55B9/pRZRuKc3BTJzFBSM2Tv6sNgDyYZl
         8SwXFCD+HJd2MdxVQ3EeawNILELOt6FAmJ7ZT78tTwtjjm18LbR7MxoOFqoqHSPM85WC
         ZAo8L7AeQWJWW31Ol2tkAhf+K6e+GsH3JDISd+JTIL2FxHsir7WjSqUKvfECUfPd72ln
         /qCk0t7PZpbvbYNg1U4/D//FhwvcmzGumhgLEMV63ryif03WsG4VCYardtATfqIhituC
         dAfSDBQwgW/SBwVxcrsngcRIWkpDITnheKN/1fE5Ta3WPw0IBbJ2PXuZMg3oiin335Of
         uMZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783054195; x=1783658995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abYqechUaVMX68IHoATU67J3c08QbMDJ1JRtoo3TnyU=;
        b=j7juXO4zQpUk5pEHlFBGKWimbFyWqQYZMPxoaI9p1yXpjwlF43NeRfyDqFjaRw80oT
         m9X2L5n2gd6hni/X6vQRH+pS4zgZGbu2t1U8vRLW/YWKhR4UO/oGcbZAvmCRGefHZGU+
         ZlQ996GB00E94ALJmhUoBICX4oQ7ELJnqGF7oCfCqxQsNzVG8E3jR/HIBcVKkHrEgG3B
         +Av0ch4dtVJ+EVlhobsOPAWlXeofLz9CBZbyIGXqzNDBZkdVXZwtGjz29eIIY+h6oSnF
         +D8/C3a0LKz9Cpi3lJc+/4Q25RBY6LB8Zox2T3F0ODcNof2n2AGerdqwH5gVCeXy2srB
         8wEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783054195; x=1783658995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=abYqechUaVMX68IHoATU67J3c08QbMDJ1JRtoo3TnyU=;
        b=hjdC3SG08cePRDR12XbHyyt+qDIHcwpqbcnlzk4LeyRD/FDsQmYGAGhKgKIiAIgiac
         k10J6KcVDjK9N0FrjpZE1LBDIBndFsIO+SSisXDWozqUREVhsEqxI//jaDO0Mhnue6EN
         PXWdJaSgWO/H8U/YmcapAilBrfi6oj8UcWLRwQmUbEdZGzniOPn6WqgOpL7iSSRIDSGG
         phPhGdl/9YWwkNP82z7H+9XXhMW3MV4ps2uaNgztjYvkX802ayrEINwVcMfI+YjCCl7I
         1bguYal9g1ia0BtCti6O856VPJ9pKmy470ZGDTy6zaOPFmbqlpUlStnToWJYFT/U4ZWK
         Si7A==
X-Forwarded-Encrypted: i=1; AHgh+Rpa3J8FeVwcmvlW4KZsKmaUml+CuXr2vxJpMDY3DEVDoThII0CsQ5NbOyfpBt0xoWqPZnLRuBIsS0R1@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4SqjAj/AsjNZWZki0XUZ/hu+9hLpvHvaA4xM4qJXMJEcCx9uX
	nMQECpG763dv/KFkrCLxGl37l33nuph14CmRcAzPxZ/oFHE0D2U/gNkyfv0tk7n48dR2mvfQgu2
	NuEk2wS8qrL+PHXYNIgyci4INzm7UCqs=
X-Gm-Gg: AfdE7cmp25tEZbqWfulB48BaxEqvLyn+rZd9pXwQZgAOjORbhsBDl7pXmLFbRBRjQU6
	BEh9wq/ypUbSFY3/ciEm/m6iwkz7svSgjny8OHrTjPQYyTbk8vg1tfX/ZTby/I+4pmfkrIwnpp1
	R6lFJhf8oarREFP2PX5c8lX1vdIqOKgaFZ3ZcbFRhmowOelqCHRiWBwDxml4oSvZyYz1xMtxXJQ
	3T+T5E0HAeGvOTqcOLFCAVSg7ClC1LFFjNabqRlnxjhFuwSFpBAL1nE0Zvas3Fu0xH65/FrDo4X
	4EhByL5bZV/9mBVn49GbGJ7ImY/eOYE=
X-Received: by 2002:a17:907:8e15:b0:c12:39b4:413e with SMTP id
 a640c23a62f3a-c12a9d72229mr414235966b.21.1783054194228; Thu, 02 Jul 2026
 21:49:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260703042443.1655-1-aditya.ansh182@gmail.com>
In-Reply-To: <20260703042443.1655-1-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Fri, 3 Jul 2026 10:19:42 +0530
X-Gm-Features: AVVi8CdQ1KZMsBrMLSF8_EkTpENETnVSnkm3giXCsXB_qmCdUUAHyyvcaXeDwEI
Message-ID: <CAK5ssPORQt=5FyKw51n9=Onf8CfXZzRPdsfg_9ipFGgcXtpzXQ@mail.gmail.com>
Subject: Re: [PATCH v3] ext4: use fsdata to track inline data write state and
 fix race
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please ignore this as the subsequent cleanup of
CONVERT_INLINE_DATA will have to be dependent on this
patch and should have been sent as a two patch series in the
first place.

Thanks,
Aditya

On Fri, Jul 3, 2026 at 9:55=E2=80=AFAM Aditya Srivastava
<aditya.ansh182@gmail.com> wrote:
>
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
>
> Instead of checking the live inode state (ext4_has_inline_data(inode)
> and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
> write_end handlers, use the fsdata parameter of the address space
> operations to explicitly pass down the state in which write_begin
> prepared the write.
>
> A concurrent thread (such as ext4_page_mkwrite()) can convert the
> inline data to an extent between write_begin and write_end. If this
> happens, the write_end handlers would previously miss the inline
> write_end path and fall through to extent-based write_end logic.
> However, since block buffers were never allocated in write_begin,
> this resulted in NULL pointer dereferences or data loss because
> folio_buffers(folio) was NULL.
>
> Define EXT4_WRITE_DATA_INLINE (4) as a bit flag (Bit 2), treating
> fsdata as bitwise flags rather than mutually exclusive enums to keep
> states of the write path independent. Communicate this state via
> fsdata:
> 1) ext4_write_begin() and ext4_da_write_begin() set the
>    EXT4_WRITE_DATA_INLINE bit in *fsdata via bitwise OR when an inline
>    write is successfully prepared.
> 2) On entry, ext4_write_begin() clears the EXT4_WRITE_DATA_INLINE bit
>    to safely handle VFS retries (where generic_perform_write() bypasses
>    the fsdata initialization on its retry jump).
> 3) The write_end handlers perform a bitwise AND to check if the
>    EXT4_WRITE_DATA_INLINE bit is set and invoke the inline write_end
>    helper accordingly.
>
> Furthermore, during a buffered write, ext4_write_inline_data_end()
> acquires the xattr lock after preparing the write. If a concurrent
> page fault (ext4_page_mkwrite()) converts the inline data to an extent
> after the write_end handlers check the state but before
> ext4_write_inline_data_end() acquires the xattr write lock, the
> subsequent check will trigger a kernel panic via
> BUG_ON(!ext4_has_inline_data(inode)).
>
> To keep git history working and bisectability clean, replace the
> BUG_ON check in ext4_write_inline_data_end() with a graceful error-
> handling retry path in this same commit. If the inline data is cleared
> after locking the xattr, we safely release all resources (releasing
> iloc.bh, unlocking/putting the folio, stopping the active journal
> transaction handle) and return 0 (VFS retry) to let the generic write
> path retry the operation safely.
>
> Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D0c89d865531d053abb2d
> Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data"=
)
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
> Changes in v3:
> - Changed EXT4_WRITE_DATA_INLINE to 4 (Bit 2) and treat fsdata as
>   bitwise flags, allowing decoupling of independent states in the
>   write path (e.g. standard fallback and inline writes), as suggested
>   by Jan Kara.
> - Clear the EXT4_WRITE_DATA_INLINE bit on entry to ext4_write_begin() to
>   safely unroll state for any VFS write retries.
> - Perform bitwise AND checks for EXT4_WRITE_DATA_INLINE and
>   FALL_BACK_TO_NONDELALLOC flags in the write_end and da_write_end
>   handlers.
>
> Changes in v2:
> - Folded the BUG_ON fix from the second patch into the first one to
>   ensure bisectability across git history, as suggested by Jan Kara.
> - Removed the pointless initialization `*fsdata =3D NULL` on entry to
>   `ext4_write_begin()`.
> - Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.
>
>  fs/ext4/ext4.h   |  1 +
>  fs/ext4/inline.c | 14 +++++++++++++-
>  fs/ext4/inode.c  | 24 +++++++++++++-----------
>  3 files changed, 27 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..9e6f6467bdeb 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, s=
truct inode *inode,
>  void ext4_set_inode_mapping_order(struct inode *inode);
>  #define FALL_BACK_TO_NONDELALLOC 1
>  #define CONVERT_INLINE_DATA     2
> +#define EXT4_WRITE_DATA_INLINE  4
>
>  typedef enum {
>         EXT4_IGET_NORMAL =3D      0,
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..cfd591dc1d9c 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode, =
loff_t pos, unsigned len,
>                         goto out;
>                 }
>                 ext4_write_lock_xattr(inode, &no_expand);
> -               BUG_ON(!ext4_has_inline_data(inode));
> +               /*
> +                * We could have raced with ext4_page_mkwrite() convertin=
g
> +                * the inode and clearing the inline data flag, so we jus=
t
> +                * release resources and retry the whole write.
> +                */
> +               if (unlikely(!ext4_has_inline_data(inode))) {
> +                       ext4_write_unlock_xattr(inode, &no_expand);
> +                       brelse(iloc.bh);
> +                       folio_unlock(folio);
> +                       folio_put(folio);
> +                       ext4_journal_stop(handle);
> +                       return 0;
> +               }
>
>                 /*
>                  * ei->i_inline_off may have changed since
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..4e1bf54e511d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1302,6 +1302,8 @@ static int ext4_write_begin(const struct kiocb *ioc=
b,
>         if (unlikely(ret))
>                 return ret;
>
> +       *fsdata =3D (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_IN=
LINE);
> +
>         trace_ext4_write_begin(inode, pos, len);
>         /*
>          * Reserve one block more for addition to orphan list in case
> @@ -1316,8 +1318,10 @@ static int ext4_write_begin(const struct kiocb *io=
cb,
>                                                     foliop);
>                 if (ret < 0)
>                         return ret;
> -               if (ret =3D=3D 1)
> +               if (ret =3D=3D 1) {
> +                       *fsdata =3D (void *)((unsigned long)*fsdata | EXT=
4_WRITE_DATA_INLINE);
>                         return 0;
> +               }
>         }
>
>         /*
> @@ -1450,8 +1454,7 @@ static int ext4_write_end(const struct kiocb *iocb,
>
>         trace_ext4_write_end(inode, pos, len, copied);
>
> -       if (ext4_has_inline_data(inode) &&
> -           ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +       if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
>                 return ext4_write_inline_data_end(inode, pos, len, copied=
,
>                                                   folio);
>
> @@ -1560,8 +1563,7 @@ static int ext4_journalled_write_end(const struct k=
iocb *iocb,
>
>         BUG_ON(!ext4_handle_valid(handle));
>
> -       if (ext4_has_inline_data(inode) &&
> -           ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +       if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
>                 return ext4_write_inline_data_end(inode, pos, len, copied=
,
>                                                   folio);
>
> @@ -3161,8 +3163,10 @@ static int ext4_da_write_begin(const struct kiocb =
*iocb,
>                                                      foliop, fsdata, true=
);
>                 if (ret < 0)
>                         return ret;
> -               if (ret =3D=3D 1)
> +               if (ret =3D=3D 1) {
> +                       *fsdata =3D (void *)((unsigned long)*fsdata | EXT=
4_WRITE_DATA_INLINE);
>                         return 0;
> +               }
>         }
>
>  retry:
> @@ -3291,17 +3295,15 @@ static int ext4_da_write_end(const struct kiocb *=
iocb,
>                              struct folio *folio, void *fsdata)
>  {
>         struct inode *inode =3D mapping->host;
> -       int write_mode =3D (int)(unsigned long)fsdata;
> +       unsigned long write_mode =3D (unsigned long)fsdata;
>
> -       if (write_mode =3D=3D FALL_BACK_TO_NONDELALLOC)
> +       if (write_mode & FALL_BACK_TO_NONDELALLOC)
>                 return ext4_write_end(iocb, mapping, pos,
>                                       len, copied, folio, fsdata);
>
>         trace_ext4_da_write_end(inode, pos, len, copied);
>
> -       if (write_mode !=3D CONVERT_INLINE_DATA &&
> -           ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
> -           ext4_has_inline_data(inode))
> +       if (write_mode & EXT4_WRITE_DATA_INLINE)
>                 return ext4_write_inline_data_end(inode, pos, len, copied=
,
>                                                   folio);
>
> --
> 2.47.3
>
