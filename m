Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011DB3B4EBC
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 05:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785217491; cv=pass; b=KM6z7SPOnGZV+f2pN1VOLGNFz6IQp20bazFWRN63h9jh30axPFb6Z4ymIsx2e6EcQJOUs+cpK/HZqVga8lWsVTW5RTYh6EkpMEHUFuCeHE3nRYyXDj6Le/D7DGoTnJxerFBR5D8A9aZbZPyV5pxHSPO90J7Qp4n3hZjr98T+Yy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785217491; c=relaxed/simple;
	bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CioXhClISyEelhB9BMOhMoDr/cHaEnVqI2MAqMlhGUsXaIRVZSrLFsKSC3X0KWwfdGF5XRgIxTJ3ygZM02h9n3lyuBLdSvnimSPEKKiqm3K56Ny1BgfUYmrURlVzfpHuR4CV4UoiSj5Bo6PUvs+mlOQIc5wvgP7L1lGfQPoj4sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fBjaNva3; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fBjaNva3"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-495635a85d2so28319725e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 22:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785217488; cv=none;
        d=google.com; s=arc-20260327;
        b=g4djJ6g7IQ4biryFocLE7pdognToRi+Orm2bj3+9DsccoH2KvIU02x57dnZHBNErSu
         y5u74doejvXIDPxLfekxcDvWOPA3rMq58YQUMTqHR21YIJnnhxV8pgCc/w2w3kk1QbJm
         yerfzBBGJx6FGORS0vaIheaPGIoQAGa5RifGlvx4zZObpJlyY2oIvIbXfZdDdF9VQEiI
         Z1AXZHkEm8DtXGCO7Sh+m1CPGe2i8pbdhOYYG010Om1TIWF7R9QLObTm7vRbn8xDHaJm
         b+M8dB1MOG2/dVkF1xjtMIzyWr/9fkth4mdNrYapGwJUFXnmFy/781c3CiEOsS0YsLsN
         qoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        fh=sXuxkfK+Pjd4btuPPJAKNtwDTWQyRxXO3gEmqQgZBoM=;
        b=ANUEp9k3aWCGYAgG3zrBHM/gHirR+Mtn4fEzTM9WFIvqKiRWfhaQ7HN3wnYSzXGPin
         FUY7xUBJ5jzV3cFSuej5bkynAgWYVyWOVAv/rf55n+8aCSeTAb19Q0kCMbcCjzHeAEmN
         ZC/0ihblrPoeQcVRaKvuE/EQvXDpVcC+O+DhxhoxaDK3MMrnFkr8vC4oj1NOIU+pROGV
         FNepHFeYqI7YH0rUlgVk6vn/1kvjAxGMe3+wd5Nc1bhWeq/CaoasAppjJmG0hrsbilQU
         4ZmqidYlVVQwORIjv5D3GUgaG2th1Ukott5kT1bockSm4qW2QT4RE4b24e0Znf2hHHzE
         miwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785217488; x=1785822288; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=fBjaNva39tUoIh3WdRtYTNHX6lXws0r73HuX15d2GPSulNVAVJug2chPtRkCxBctrT
         77fgXWVjRq4svwy/4Iy/mHq2Mf7BuTmIUSZgxS+pqU2tddt6Cz1jc+ba+k++HVdERP2u
         YTlyXEcjikO/XsTWJ+Ib7KoTgYlhV9JyoykvLCA+vLYLlDNa66LY8AA6t63oh39o+Lrm
         wDW/eKsE/q4VyshhT2rSJtcOjGvHaxZDnMcjzV0nygT/7ef6EezQbO67EtJgUo6U/DEU
         l2XoUeUA9dAonr3rbYVmbYUzoHKkN9KcrZ6/3wHbCjbDETMdv9MpHyAbC8TRmJQ3hoe9
         bWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785217488; x=1785822288;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YfjN6gu+ln7t5y5mDONTsNJDbtGDekxXLrfrMU8/Ds4=;
        b=ACDEmcOJy+SddcCkgIAmH1HCN68DVj48SpJoJRqFBjvWgqMEjz3gbjZj5KAvewmivl
         UUZ4beXBnrlp3d2Nd9rIkEjzYCjB8P+QmPAGD6lGyzo/+3xWAUjnutRqHErjRIMQuAZz
         HcGpKNaGIxeU1T1hDDAH+tVYKb8Z6SxRNZVVs+RJlSsNt4ST6S7ZT9lc0CAqEms+kpcs
         +wkC5ND6wKhTildIBZxA4LGsNXx64Sm4ScehL0ej6jendQxd0U/FEQSxN8Etf/GQhchq
         seJcGbssIvqChwUXeY8P4mOYYUQZj7iv5DIU9x0owVGmIV+7mouJRHenw/V5pET3G7p8
         CIEw==
X-Forwarded-Encrypted: i=1; AHgh+RoL89YVB5kfmmo1ES7u0fCsmN+dxNz+QvHBFPtNIxn2eBfAd/9UOyQuSjxdehzI7AC0gGYSGeYWPB9A@vger.kernel.org
X-Gm-Message-State: AOJu0YyJcXXweMZl7IHcqDNkceQPnuMxC27TbvLbaS1TpOJvUAehfpLI
	Qxp3fzUi61mzNoDGUs4qmZa9M1GuC0IAta2tnHew8Fvc3RiCxWvO0nKC3EOM8RPKJFDFCT6NjbW
	x+ng/GHKV8S1TTxUTXoUHKqK42Uv9ZyVVdm8FB/bCQQ==
X-Gm-Gg: AR+sD10Fctb3aT71e2y5/QqaBrKX8AIEsV+a0JNtrd20JTFAxQHtZb433x9+eLOurAx
	15Cv3ERfb36LMMSEd5i22dy5NFnuxDE4/bgT+0p3sewj3w3jAZ+9D3Tk6PKW7C7RdhyH0s3FZUG
	fQ2CKPJsi70DWPjfb2W96fHOrV3jzoc2bJgip8s09qoBGD4SmywTvzBcL9ZRqRJ1JbkOynqf1Ot
	aB/XVknDDg8k1o/UfQMFSO8OqeovBPVS2yOcsQV/syWoAi6DzjWbCdXRZp+hvv0KYvF/cVpPmRc
	zCmh3W4CsI1yOFkUTNin/gAL8hFCrLODBSQYToZUQsipI+tHDssuBmE4pOY=
X-Received: by 2002:a05:600c:a012:b0:496:c18c:f9a2 with SMTP id
 5b1f17b1804b1-496c6586ad0mr8148725e9.34.1785217488357; Mon, 27 Jul 2026
 22:44:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260724133328.1837318-1-neelx@suse.com> <amgfuk12imPN2XJe@infradead.org>
In-Reply-To: <amgfuk12imPN2XJe@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 28 Jul 2026 07:44:37 +0200
X-Gm-Features: AUfX_mweqQ4DC10RBxGq9-w14Z5dbzAU5cW-2aUZfLxC0EG3IWa7sp-qvz-yJvY
Message-ID: <CAPjX3Fd1KPswrsNe=BeDpkDwi8CmL9HNKcPScMsgGN16MDyVEQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] fstests: introduce fscrypt support for btrfs
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, djwong@kernel.org, 
	David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 28 Jul 2026 at 05:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 24, 2026 at 03:33:16PM +0200, Daniel Vacek wrote:
> > This is a rebase and cleanup of older patches [0] from Sweet Tea and Josef
> > fixed to work with the recent kernel and btrfs-progs changes.
>
> I'm not sure if you post this just for reference or what the intent here
> is, especially with a cover letter like this that doesn't have much
> information.
>
> Before we doing anything for the btrfs-specific fscrypt changes in
> xfstests, those changes should be accepted upstream first.
>
> Maybe some thing like splitting tests might make sense without that,
> but then it should be posted separately.

Hi Christoph. Thanks for looking into this.

Yeah, I could have been more verbose, perhaps also using an RFC tag. I
wanted to get feedback and a review from a wider audience to see if
this is a viable direction. This is currently the base for my btrfs
fscrypt development testing.
Especially for upstream fscrypt changes, when sending those patches I
was asked about tests support. I understand to keep fstests OOT as
long as the kernel part is in development. But at the same time I'd
like to make fstests complement the kernel part and ensure they are
ready and available for everyone throughout the process. Kinda to
"bundle" them all the next iteration.

Would you suggest otherwise?

--nX
