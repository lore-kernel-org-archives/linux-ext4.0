Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301F12D97B7
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.125.188.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782394705; cv=pass; b=hU1wW0GGWNc/NDfdvXvRRAzur5UZtqCwUxreLXPygAg909hHmqkz+NysXWUBrwyEcTdCGDZnwVVz9Rji8QZvc54AA9eTXEC8ur60QFdvSieZT4Fpmn7dGwdVFtQRf9j5WiTup8AM4ZYsUF87OIi+gk4xzWN5FjBZ2pM6cjVbw9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782394705; c=relaxed/simple;
	bh=mRjuuX3KTtIqpTP4RHhNmhjwaWynA7BVMyuj9MtStro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RcPe5Zfztu3QnqdZFfH1dy1jx2zX4BviER3FT7Tvy2n08QqSHyEe2t05pm87Gm1E1+NdFMBx8fcqu1sX4LUztqvwoQYHe8ZowYebouddEyBvEBlHQQoER6UkQpWEPaIyZpzpC4WLjyBC/u7OE6JocAw2lzFNcEOCDjXOt2ZG4IA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=XRPuJKUx; arc=pass smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="XRPuJKUx"
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 42E563F6ED
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 13:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1782394700;
	bh=5p9tDKts5BDo1soyd4XDSTxZINlm3WyVmdhJwjz8S/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=XRPuJKUx+xN8ZEkF+/vkKwbbxbbNRY2uUSkp2G7ttBsmZYL11798aXlSGtlorsL3p
	 zPjvsZ1ojFWHCB7OLUT+BoFMS8KtHprv+BleUByApAdsUmYtFs3nMLGk4RFPYR8MOl
	 5g0l4tB9fKeq/aNgH5j7s78bU9c6DXkjM3rpC7hJQNVt2YiOCoGUxRTFY9Dy7oGeSk
	 K1BdgeD1R8AZJ9upiFdSlEjow47Mr3hFIz8ZJvVVWB0EPPNAV6XRTntW6YVJgzYubH
	 XR6r1HVP0f4zpUwrjHMYZS0RlpN0zFgmPkAwC67uCC3a827j/j96f/UPCTyBpnunx7
	 oDTRVIutepAiBJT6lc4rwVT00lGg73RAYudjrYpd2QiYUX3iSjdoId62FaafeVTEAz
	 ao1MmyCknzMaw1czqiOuh7PZd+15t1/x2bU92tvjgTOGBt3N5bb6rh09ohrePXN0Iy
	 zWxcVZLFnrJbc2Np+fGoFOu+lJW+EHGkUrc8XRvnumm0RVnocjFXbFn4NofzcIZfTS
	 5u3Yp98j1QHiRf7f6UbP3/mZ6nqZiMKziFd3XLgEirCQC79TDDCT65zlIm0+biSI1J
	 TD4iqz7sIzgCYK9+cpQZGVLDg7JK+TzbEjuMSzPFAhKG1AeDrOERdgUM9ZeBfL6Jw5
	 gHmQl1FPwIWIKQmpNpL4VTJc=
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aea4d1b3deso162617e87.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 06:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782394699; cv=none;
        d=google.com; s=arc-20260327;
        b=ivF2ePaYtoSI7oR6+RSoRdwe6ah86LwXwNm2Y5mr8Tk7O67vd1QMU6QLmKProu5zpi
         pvaccXV2M7EBG4VOfgOhuFsxno4WTcRCVBbeuOmez1KRMGEhFg6X/BGh78ILj8MxXX5n
         4D4VFX8PdLTvw6v9gIcW5v0JILgyXQesAvi4JOx/oUbD7Sk5ciiVpIe0uSNHse0yB5r5
         iHckwhuLexkAxPyDn2RYX/O4NpZaMkHZv/xvaGP3lm84yT6vE88ez/lmCKfVLd6/C3nt
         0D7Z2tTUxq2dUwWTuuUTzXSAZKHxV+A02xK0+Fe25ATCsjWJ1VG8wpQdDWo+oPNnyqy8
         nUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=5p9tDKts5BDo1soyd4XDSTxZINlm3WyVmdhJwjz8S/M=;
        fh=yoN2cwp3ZWnm8Fo95FtrUBBwl20D8oBpCyqewNUaq1s=;
        b=U2uys7L8xJMqyDpeUWQgaGrjwz1fGGpr4vfpXIPcEBZcnwE8SDpnEp3bbB3EEdy1qT
         jkpftc8/tScpuMhW7Hvy4zQgqOVQ5c9W9v7lvesqMdCkmUUN5UQE1Lsg3zRVxNiEIZjI
         e5TQzMyQtBSMJTsN3ias74dn0nUp/RvvrCHabI607AvoS4dm2jwAc0ipDCNTLs6zh2XF
         LklfG/uad5yRTi/qnV5Q4N312J+iutnQF9/BGAlCtJJv9gXe6o19NcXZKpFNMPrQMb8j
         Y7ltD2NCJVDaDTldo2Ew+iYBt4Y2iFPxQzoigpaCGn9kXH3OlqtUqm4dxA+9V07azQFI
         PtIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394699; x=1782999499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5p9tDKts5BDo1soyd4XDSTxZINlm3WyVmdhJwjz8S/M=;
        b=gfYDbb1x62uWOkTcE+u++gBRBMNC94JiGviOZAAYjoJIt9uX+oFc5uBmfyNM4G4r7d
         PxV8XDhkkg1Vwfaj9ftQj5BGov9YqtEwMu26b/m4FCx2B4ffhHQS4sksuatcDmNED6iz
         TMc9xvYfI5oVK8MsnLmuj9eF6MqA9umIzWdL4T8sFigB/LcN2o6iy47R1FXBJABtGTkb
         iD/S5qzWgRgaqI+brXa/+xqHvo3r37V/CTxCrznsoAAXoWHrmhm2ejDeesTKqFxQSKL6
         POEy8z0b71fUGqpcuVjwcUT78nWoFh669jnHkEIVoVKrSREmvlzTo1fVapC/RXQw5clh
         8euA==
X-Forwarded-Encrypted: i=1; AHgh+RpYZgpG2urqjY6DLCd+wt6jZP66S1BvqYX3+IxC19za9WI4jeRkp+cJNMLIUlLkPd59TXBOWVcgoomS@vger.kernel.org
X-Gm-Message-State: AOJu0YyDVJCPAiYJhhqw34d7mDuLoTbU+JYA/CK8qVYVKmQPQosZRog6
	HhGCIwvDNsc0xOxSvVAHA1Yh2Cj9H3xNrMDYBBBiOr+1H6oTvAm+RdcAS2/6G19Cs/yqSkUauPY
	BNOjXtMaXwrWu7H1dQZiaVWIyZGzyZyN/ZF6re5Fng8xnCdQqwXTX1caK5EzzRqVcAD+l2yR9ow
	oYn2qm/8CM1w1izqeD7aaZ90Xru6QjKyZd/hcIvWDXkZpZ0JwBkyu6bg==
X-Gm-Gg: AfdE7clpl2/RsYzTYNnF4PoUPS55GLNZGRzgKwG9TXb5/lT2dF/Z8bGHFNx7PmgwUjp
	UCsR/brq8z7r+NDITr3uGgX5kXg4Dqtf7O7g5SYlWJ4DoeMELpLCV9IeJX1HXW2OgPoMsis+++O
	kK56Y5a16pDSFyl2g89PlM6n2fO3EjPn6tudhoHNwxT3JwTUPxSBbN5afelWYtmh6PxOha
X-Received: by 2002:a05:6512:1328:b0:5ad:3035:b353 with SMTP id 2adb3069b0e04-5aea2066192mr690119e87.53.1782394699338;
        Thu, 25 Jun 2026 06:38:19 -0700 (PDT)
X-Received: by 2002:a05:6512:1328:b0:5ad:3035:b353 with SMTP id
 2adb3069b0e04-5aea2066192mr690104e87.53.1782394698815; Thu, 25 Jun 2026
 06:38:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623080312.2713478-1-gerald.yang@canonical.com> <asahstosrqlboeyjqyyzvwgne7qucw4y5mvoos346seqgrvwcd@wtuocifmom6c>
In-Reply-To: <asahstosrqlboeyjqyyzvwgne7qucw4y5mvoos346seqgrvwcd@wtuocifmom6c>
From: Gerald Yang <gerald.yang@canonical.com>
Date: Thu, 25 Jun 2026 21:38:05 +0800
X-Gm-Features: AVVi8CcHTPV_zQiNw1Dd7lUuLaLkWaDhN_EFcqN3QgOBzNhDpKACUtzXvRsbxos
Message-ID: <CAMsNC+tjwPzzvq=7bawwv1tZy-HJEw_yBdKFVGt1LwwP1Tx_Mg@mail.gmail.com>
Subject: Re: [PATCH] ext4: clear stale xarray tags on folios skipped during writeback
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, gerald.yang.tw@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review, I will send a v2 based on the suggestion.


On Thu, Jun 25, 2026 at 7:33=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 23-06-26 16:02:38, Gerald Yang wrote:
> > In data=3Djournal mode, the writeback thread can hit the
> > WARN_ON_ONCE(sb_rdonly(sb)) in ext4_journal_check_start() while the
> > superblock is being remounted read-only during reboot:
> >
> > Workqueue: writeback wb_workfn (flush-253:0)
> > RIP: 0010:ext4_journal_check_start+0x8b/0xd0
> > Call Trace:
> >   __ext4_journal_start_sb+0x3c/0x1e0
> >   mpage_prepare_extent_to_map+0x4af/0x580
> >   ext4_do_writepages+0x3c0/0x1080
> >   ext4_writepages+0xc8/0x1a0
> >   do_writepages+0xc4/0x180
> >   __writeback_single_inode+0x45/0x2f0
> >   writeback_sb_inodes+0x26b/0x5d0
> >   __writeback_inodes_wb+0x54/0x100
> >   wb_writeback+0x1ac/0x320
> >   wb_workfn+0x394/0x470
> >
> > And followed by the warning:
> > EXT4-fs warning (device vda1): ext4_evict_inode:195: inode #6263:
> > comm (sd-umount): data will be lost
> >
> > This issue is not reproduced every time, but frequently.
> > The reproduction step is to create a VM with 8 CPUs, 16G memory and
> > setup data=3Djournal:
> > sudo tune2fs -o journal_data /dev/vda1
> > Run fio:
> > rm -f fiotest
> > fio --name=3Dfiotest --rw=3Drandwrite --bs=3D4k --runtime=3D6 --ioengin=
e=3Dlibaio
> > --iodepth=3D256 --numjobs=3D8 --filename=3Dfiotest --filesize=3D30G
> > --group_reporting
> > Reboot the VM, and check the console output from:
> > virsh console testvm
> >
> > But there is no dirty inode, folio_clear_dirty_for_io clears PG_dirty
> > but leaves tags PAGECACHE_TAG_DIRTY and PAGECACHE_TAG_TOWRITE set which
> > are only cleared by __folio_start_writeback.
> > In data=3Djournal mode, jbd2 checkpoints the journalled data to its fin=
al
> > location and clears its own dirty flag without touching folio PG_dirty
> > or xarray dirty flags.
> > The commit f4a2b42e7891 ("ext4: fix stale xarray tags after writeback")
> > fixes when PG_dirty is still set but there is no dirty page.
> > Another case is PG_dirty is cleared, but PAGECACHE_TAG_DIRTY and
> > PAGECACHE_TAG_TOWRITE is still set. In this case, writeback thread
> > checks clean folio and skips it in mpage_prepare_extent_to_map:
> > if (!folio_test_dirty(folio) ||
> >     ...
> >         folio_unlcok(folio);
> >       continue
> >
> > And never reaches ext4_bio_write_folio where the commit f4a2b42e7891
> > clears the stale xarray tags. Print debug logs after the filesystem
> > is remounted read-only:
> > writepages RDONLY nrpages=3D2048 dirtytag=3D1 wbtag=3D0 towrite=3D1 syn=
c=3D0
> > And all folios are actually clean:
> > folio idx=3D3 dirty=3D0 wb=3D0 checked=3D0 dirtybuf=3D0 jbddirty=3D0 ma=
pped=3D1
> > ...
> >
> > We need to clear the xarray stale tags for such clean folios by
> > cycling them through writeback in the skip path, the same way
> > f4a2b42e7891 does in ext4_bio_write_folio.
> >
> > Fixes: dff4ac75eeee ("ext4: move keep_towrite handling to ext4_bio_writ=
e_page()")
> > Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
>
> Good spotting. One comment to the patch:
>
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index ce99807c5f5b..40da611b0831 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -2698,6 +2698,28 @@ static int mpage_prepare_extent_to_map(struct mp=
age_da_data *mpd)
> >                           (folio_test_writeback(folio) &&
> >                            (mpd->wbc->sync_mode =3D=3D WB_SYNC_NONE)) |=
|
> >                           unlikely(folio->mapping !=3D mapping)) {
> > +                             /*
> > +                              * A clean folio (PG_dirty =3D 0) can sti=
ll carry
> > +                              * stale xarray tags: PAGECACHE_TAG_DIRTY=
 /
> > +                              * PAGECACHE_TAG_TOWRITE.
> > +                              * In data=3Djournal mode, the data may h=
ave been
> > +                              * checkpointed to its final location by =
jbd2
> > +                              * but these tags are only cleared by
> > +                              * __folio_start_writeback() later.
> > +                              * These tags keep the inode on the write=
back
> > +                              * list and make the writeback thread cal=
ls
> > +                              * ext4_journal_start on a read-only sb d=
uring
> > +                              * remounting fs to read-only, and return
> > +                              * -EROFS from ext4_journal_check_start.
> > +                              * Cycle the clean folio through writebac=
k to
> > +                              * drop the stale xarray tags.
> > +                              */
> > +                             if (folio->mapping =3D=3D mapping &&
> > +                                 !folio_test_dirty(folio) &&
> > +                                 !folio_test_writeback(folio)) {
> > +                                     __folio_start_writeback(folio, fa=
lse);
> > +                                     folio_end_writeback(folio);
> > +                             }
>
> Instead of this check, just split the top level condition to make things
> more obvious:
>                                 if ((folio_test_writeback(folio) &&
>                                      mpd->wbc->sync_mode =3D=3D WB_SYNC_N=
ONE) ||
>                                     unlikely(folio->mapping !=3D mapping)=
) {
>                                         folio_unlock(folio);
>                                         continue;
>                                 }
>                                 /*
>                                  * If the folio is clean, skip writing it=
 back.
>                                  * Cycle the folio through the writeback =
state
>                                  * though, to clear stale xarray tags.
>                                  */
>                                 if (!folio_test_dirty(folio)) {
>                                         if (!folio_test_writeback(folio))=
 {
>                                                 __folio_start_writeback(f=
olio,
>                                                                         f=
alse);
>                                                 folio_end_writeback(folio=
);
>                                         }
>                                         folio_unlock(folio);
>                                         continue;
>                                 }
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
