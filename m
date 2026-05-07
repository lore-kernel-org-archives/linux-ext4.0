Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D94F342517
	for <linux-ext4@vger.kernel.org>; Thu,  7 May 2026 07:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778140087; cv=none; b=adbg4215+rA5o/mqHxs4UPK9ySfLcy5f5VpswV4RsfKxBpLG8fmR+7vCT+sOQHwQGuXVudLC/6npAjiWbbp0mCv9/yjduNT8YRBPqwQaHteAEtRwtLvL04ZUavVwzi6/hMMn++K6yGsoHq0c2XjSkGrcdU9WbeZpv112m8+cibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778140087; c=relaxed/simple;
	bh=mHeHSe7O2uumebGoC5Ajgv54f5PDJqOMdO1zqzdCKi4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cQ2yhw5kVrvtzD21+odWanqUPXZ+d91wMv/nV6mo2EXpTO6eEpdbbhMOHsYsd+kLcUK/r9Cu1vsxIjDoOx3lp5wfdPyH9uK66xBPUZULzSbRV8JZqCNqROgsF8FUG0K3fMWrtJXg8j5p3uxMPR6B81HrAjkndWXCCiCpASSMMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b=M+9mRrx/; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20251104.gappssmtp.com header.i=@dilger-ca.20251104.gappssmtp.com header.b="M+9mRrx/"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8367df48711so199227b3a.1
        for <linux-ext4@vger.kernel.org>; Thu, 07 May 2026 00:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20251104.gappssmtp.com; s=20251104; t=1778140085; x=1778744885; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPpEDr985RDhwP45FYZnGolgZFY3bC6Z2jdxJ62Gukc=;
        b=M+9mRrx/cqkXjhrttdEmkRuIJp5H3vgQfham8GiBK0yA4rcZcvSklZcAe7yixzVNyT
         2Jt4+kvawd4Lx6qOCfkr3NXQ3bXZzk1V56wsTMs8ecYBmTAvF3I+rIoCorQPBvQwyUlX
         JaoLefz4/SAJTmQQoeDh6hRQhcI1vfOCpgo2IaMDwfHOYBGmM/rJcZHpCnb+Bzj1Qxl8
         JOOHdRJXu+qNzaVLYKg6V9uZmtAUYm4SGTkBpGp8WK84ZwucIRBGfKYDMn90UfcYCeV9
         7V0IC+PNkIaT8ddmoLw+NuzqXb/ROhkG79usOp5Xn5KBv1/yfQASRDy2nPWMdblJkf1R
         Udeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778140085; x=1778744885;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bPpEDr985RDhwP45FYZnGolgZFY3bC6Z2jdxJ62Gukc=;
        b=gQLnGqaWQMo/uAY5fTsDBGJjJSod1otPhlxfRRhxfvwiEL7CE7Ka8FBhFekkw/KOnp
         mWtkkzdBOn2Vc2MAmoin3uFxCI7XyhYk02qG2aUrbxszuF1qpgxu7klbBvPH1OpnN7xu
         DuKzAI+EzmYuyHxiFKG0uYzt8jQmYSva30Z4RZad2I18luI4v2IPuBgHU1k6Cl7uMsiL
         9OdhG5P1A3tyuvkUeKODMrznwf9ETrX7BZwOGCHuZHGmpMbJqhyvIFL+t0xuhitkBhp4
         A4gsvr9jUrckNn1Q1tFbSoWLJa6n+9BdDjUSAaFPx4AwuNZQ94/te55THo2prwRc9Fn/
         yNeg==
X-Forwarded-Encrypted: i=1; AFNElJ9ESynv5mh2MMLiEhb0VYQavQOKLS9e834hrVyMgJmyJ6Ne6fXqnXXBeNGoG0j9kcnYRlsfczQnUTp2@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9JRxYTfGcbkce6yZKEvjlsb/SawWP6NwrceFRIJJwBLyo81RI
	tjZf51PjJJYhFFEKc6H0u75ciy91XflBPlmcmQDLozW0nFiCw9jM8N3e1mcNow9EOm4=
X-Gm-Gg: AeBDievqSMwmiB9UYn9n5WfgfDukut7lWLVhdvlYVvr7/Z8ch2GC41lmt3EUD3/5uY7
	CbQ90JBYXEY+wjrzA3Sw/3C32AK92gMns/BjOVWuLQapPudryZ1IT0mD64GayfBR2N+MOSY5Vd/
	o2tuZ4tYzvAf6n5duAqs4UEW+Kp3lq7z0bqArhRNzUAS4ZvZjlIT1ofF1JG8Fu68T2XBy7rQaU+
	1JZuqRBgcTFe+C1NVi26cvxWSHuPxMm9R1lnTa4xdqLaoHa7aOf1wRH8gXjMKvzsVOazSxw51ad
	jEI/YKeZ5ftHLpXJ2bvJSwT0da5OOHwV09OJUmgG/ZHGDgby8AkcIv0MsGDttFQM9GqmEjtjw6j
	1zyDZs9YKubCtPIt+G7jpchJ88lKLPAUHXB9yhn6cEYq2WusORVnz/Q1fP4B7Ve/Bn6E3sBTO6P
	JgwExj+Wv2btcyf+Hw6fCOqtJ34Z/YA6cBSaTl7v+KKL75e/9yL472viXathrpFO0CjsHvUI14U
	gR0VT4or8v7ozjAuQ11fGjdVcs=
X-Received: by 2002:a05:6a00:1248:b0:82c:d9d0:f482 with SMTP id d2e1a72fcca58-83a5e34c689mr7026138b3a.46.1778140085376;
        Thu, 07 May 2026 00:48:05 -0700 (PDT)
Received: from smtpclient.apple (S01068c763f81ca4b.cg.shawcable.net. [70.77.200.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8396563f03bsm7997941b3a.9.2026.05.07.00.48.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 May 2026 00:48:04 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH] jbd2: check for aborted handle in
 jbd2_journal_dirty_metadata()
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20260507050605.50081-1-kartikey406@gmail.com>
Date: Thu, 7 May 2026 01:47:53 -0600
Cc: tytso@mit.edu,
 jack@suse.com,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D55B487-61B6-4153-884B-94649A963E68@dilger.ca>
References: <20260507050605.50081-1-kartikey406@gmail.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
X-Mailer: Apple Mail (2.3864.100.1.1.5)

On May 6, 2026, at 23:06, Deepanshu Kartikey <kartikey406@gmail.com> =
wrote:
>=20
> jbd2_journal_dirty_metadata() unconditionally dereferences
> handle->h_transaction at function entry to obtain the journal pointer:
>=20
> transaction_t *transaction =3D handle->h_transaction;
> journal_t *journal =3D transaction->t_journal;
>=20
> However, h_transaction may legitimately be NULL for an aborted handle.
> The is_handle_aborted() helper in include/linux/jbd2.h explicitly
> treats !h_transaction as one of the aborted states:
>=20
> if (handle->h_aborted || !handle->h_transaction)
> return 1;
>=20
> Every other entry point in fs/jbd2/transaction.c
> (jbd2_journal_get_{write,undo,create}_access, jbd2_journal_extend,
> jbd2_journal_restart, jbd2_journal_stop, etc.) guards against this
> with an is_handle_aborted() check before any dereference of
> h_transaction. jbd2_journal_dirty_metadata() was missing this guard.
>=20
> This is reachable from ocfs2's xattr code. ocfs2_xa_set() =
intentionally
> falls through to ocfs2_xa_journal_dirty() even after
> ocfs2_xa_prepare_entry() fails, on the assumption that the buffer
> needs to be journaled to record any partial modifications (see the
> comment above the out_dirty label in fs/ocfs2/xattr.c). If the failure
> was caused by the journal being aborted -- e.g. an underlying I/O
> error during a sub-operation such as __ocfs2_remove_xattr_range() --
> the handle's h_transaction has been cleared by the abort path, and
> the unconditional deref in jbd2_journal_dirty_metadata() becomes a
> NULL deref.
>=20
> Reproduced by syzbot with a crafted ocfs2 image where I/O against the
> loop device backing the mount is sabotaged via LOOP_SET_STATUS64
> between two setxattr() calls, causing the second setxattr (which
> truncates an external xattr value) to abort the journal mid-flight:
>=20
>  Oops: general protection fault, probably for non-canonical
>        address 0xdffffc0000000000
>  KASAN: null-ptr-deref in range =
[0x0000000000000000-0x0000000000000007]
>  RIP: jbd2_journal_dirty_metadata+0x4a/0xd30 =
fs/jbd2/transaction.c:1520
>  Call Trace:
>   ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
>   ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
>   ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
>   ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
>   __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
>   ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
>   __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
>   ...
>=20
> Fix by adding the standard is_handle_aborted() guard at the top of
> jbd2_journal_dirty_metadata() and returning -EROFS, matching the
> pattern used by every other entry point in this file.
> ocfs2_journal_dirty() already handles a non-zero return from
> jbd2_journal_dirty_metadata() correctly.
>=20
> Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D98f651460e558a21baae
> Tested-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

LGTM.

Reviewed-by: Andreas Dilger <adilger@dilger.ca =
<mailto:adilger@dilger.ca>>

> ---
> fs/jbd2/transaction.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bbd10..aa0be9e9c876 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1516,14 +1516,19 @@ void jbd2_buffer_abort_trigger(struct =
journal_head *jh,
>  */
> int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head =
*bh)
> {
> - transaction_t *transaction =3D handle->h_transaction;
> - journal_t *journal =3D transaction->t_journal;
> + transaction_t *transaction;
> + journal_t *journal;
> struct journal_head *jh;
> int ret =3D 0;
>=20
> + if (is_handle_aborted(handle))
> + return -EROFS;
> if (!buffer_jbd(bh))
> return -EUCLEAN;
>=20
> + transaction =3D handle->h_transaction;
> + journal =3D transaction->t_journal;
> +
> /*
> * We don't grab jh reference here since the buffer must be part
> * of the running transaction.
> --=20
> 2.43.0
>=20
>=20


Cheers, Andreas





