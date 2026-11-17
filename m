Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909082;
	b=iP4oiCugNrdUpRk44aW89Rg+vddq3z/temgy3rRtVAyqIDPXwJKEYISL2cmojcqAEnQ5
	 m4rdeDBS23KBS7BFgveiEfZke9NztwE+XJWR8EC1FMJvuDPYEpMlnYHGpixkhO4phyzv8
	 2DPqQoKZ6/JTTINrWID8VjBIqA6niRfyjNPTfeFiVptrpwvPGYw2RXP6ABL6y0YX6Ar5J
	 9MFTGGoSwJ3SuM0wepU2voo9cGYqMHNIFfbMsPtp0F2tlIJrl2A/QS4EvaWli7bnP/PON
	 gryHsDSW2ITg/Opos9XQ6pdsfeuLLG7a1+pgwdpUEZZ/3EiOja7wUSbnW/YeR8j5FPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909082;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3jxa/kAJ15lKxFwPMTclDKch6tj8Yv9VYBIGJ7Uyr94=;
	b=ZrmiUogN5qVfQbJW201bAtucMdJUL0WE9Dv4u/4fEi+oCnfKe9PHpO+5IMgfmpKNZzBa
	 /ZmMNLHIjqTZp/SxfGIWXZpm82YMtIa0D6h+0ofgJPfY03KO9JQkTY0fGrCSPLhVr8hua
	 Sw4ul/6drda6zh531iQ+YgrtT+v6d+jg9MqOjcOu8HtlQuA7BCol3l3fbDfHHIAEzYjml
	 8cjDwimS0v0EixY4Kg/AsQ057C1GRsifQLABea5NELNAe/Mm+57CzprNJb160X1SVBfWH
	 nEd/SvhN3QKUqGk4jPsToI2mT5zL8Nc6bPIoEUulzc0WLHcbOoon43mabXbdVrzDW5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEaQdnWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223CC606A31C;
	Tue, 17 Nov 2026 09:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YEaQdnWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4889B1F000C4;
	Tue, 17 Nov 2026 09:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794909081;
	bh=3jxa/kAJ15lKxFwPMTclDKch6tj8Yv9VYBIGJ7Uyr94=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YEaQdnWp9hLwkYUqGOFX0ayap+gXO4krb2XydLS1lZQnWRN9mW1DgoAG4nPAJpDOy
	 pfUCmXWNeUL8Br7oRTKmpxSsIdEnpvdaX+xY3A82MHrz+bHj2tY26UM/x+F5IJwujk
	 tCIOyBrC+xbzGTypkKQbaiHAucjtsWPN9r16XNy+2psAaNcF5MSnlOPBQ6/GplVHao
	 8sD4sDgR2oqlCBHL/saxmEDR9ydixLloNRC/oo/BSGWswAyzaRYrGPXVVw4F/f6CBt
	 7UU8ZGjkiAadqywtCMlLpDyA7pp+gEoTO83zWGwc7yjQb7XSeKOCPEcvXIPjCKulnV
	 FMySy8Hm2ydEA==
Message-ID: <sashiko-outbox-218534@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] gfs2: don't BUG when remounting read-only after a
 withdraw during mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Jan Kara" <jack@suse.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, "Mark
 Fasheh" <mark@fasheh.com>, "Joel Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
 <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 09:51:20 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] gfs2: race in gfs2_queue_withdraw() lets flush_work() return
  before queue
--

commit 3d2897f8b51331dc6f7b51a37f13ef421ac6739b
Author: Christian Brauner <brauner@kernel.org>

gfs2: don't BUG when remounting read-only after a withdraw during mount

This commit introduces gfs2_queue_withdraw() guarded by SDF_WITHDRAW_QUEUED
and flushes sd_withdraw_work in gfs2_reconfigure() before remounting a
withdrawn filesystem read-only.

> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 6ec47376aecf2..3bd5702535dfe 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -1590,6 +1590,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
> =20
>  	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
>  		if (fc->sb_flags & SB_RDONLY) {
> +			/* gfs2_withdraw() doesn't queue the work during mount. */
> +			if (gfs2_withdrawn(sdp)) {
> +				gfs2_queue_withdraw(sdp);
> +				flush_work(&sdp->sd_withdraw_work);
> +			}
>  			gfs2_make_fs_ro(sdp);
>  		} else {
>  			error =3D gfs2_make_fs_rw(sdp);
> diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> index 529c3ec37a18a..5558af374994a 100644
> --- a/fs/gfs2/util.c
> +++ b/fs/gfs2/util.c
> @@ -238,6 +238,13 @@ void gfs2_withdraw_func(struct work_struct *work)
>  	fs_err(sdp, "file system withdrawn\n");
>  }
> =20
> +/* The withdraw work must only run once. */
> +void gfs2_queue_withdraw(struct gfs2_sbd *sdp)
> +{
> +	if (!test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags))
> +		schedule_work(&sdp->sd_withdraw_work);
> +}
> +
>  void gfs2_withdraw(struct gfs2_sbd *sdp)
>  {
>  	if (sdp->sd_args.ar_errors =3D=3D GFS2_ERRORS_WITHDRAW ||
> @@ -253,7 +260,7 @@ void gfs2_withdraw(struct gfs2_sbd *sdp)
>  		if (!(sdp->sd_vfs->s_flags & SB_BORN))
>  			return;
>  		fs_err(sdp, "about to withdraw this file system\n");
> -		schedule_work(&sdp->sd_withdraw_work);
> +		gfs2_queue_withdraw(sdp);
>  		return;
>  	}

[Severity: Medium]
Can flush_work(&sdp->sd_withdraw_work) in gfs2_reconfigure() return before
a concurrent gfs2_withdraw() has queued sd_withdraw_work?

CPU0                                  CPU1
gfs2_withdraw()
  test_and_set_bit(SDF_WITHDRAWN, ...)
  gfs2_queue_withdraw()
    test_and_set_bit(SDF_WITHDRAW_QUEUED, ...)
                                      gfs2_reconfigure()
                                        if (gfs2_withdrawn(sdp))
                                          gfs2_queue_withdraw()
                                            test_and_set_bit(SDF_WITHDRAW_Q=
UEUED, ...)
                                              --> already set, skips schedu=
le_work()
                                          flush_work(&sdp->sd_withdraw_work)
                                            --> not pending yet, returns fa=
lse
                                        gfs2_make_fs_ro()
                                          ...
                                          gfs2_quota_cleanup()
                                            --> hits BUG_ON()
    schedule_work(&sdp->sd_withdraw_work)

Because test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags) runs before
schedule_work() marks sd_withdraw_work pending, CPU1's gfs2_queue_withdraw()
can observe SDF_WITHDRAW_QUEUED already set and return without queuing the
work.  flush_work() then sees an idle work item and returns immediately,
allowing gfs2_make_fs_ro() -> gfs2_quota_cleanup() to proceed with
SDF_JOURNAL_LIVE still set and hit its BUG_ON().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-work-fs-sb=
_rdonly-fixes-v1-0-95a25ce917ad@kernel.org?part=3D1
