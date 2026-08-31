Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1E53815E3
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 23:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219270; cv=none; b=ttlRYeVlWDG/Gffkgmx0bbzEq5HbEv6NWDKbHg46Ob9HTFD6kYbk1qatKz7oEYG3ninLXTvNZy5fDsZa43E+nQaS6H0h1Fqsuj8UY+VgydM8tZJdD2VY36IorP/N0jWI3gz81pEM/lK3pfmUitNM1ZCi59sXnXfqNCgEFvJ5JuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219270; c=relaxed/simple;
	bh=ma4zCwL1MJKOlGUTSok9zDIiwoRxL065nQAXZ6pA1bA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ek1jxm2sHyXuvWfwcrEW/7+0EtnM1AOHF6gfSto4pBUqLWAf0G7XaOsR0hTfgLD3jvIYS4ucMIHnptFoqxgs3+uA7wFDAeD7ars2Dt1Tg+tzzWvFGQwHNOYDa3/PCw1HPVTXwy70LOeNpSVvmL9GGCnXl+Wc/98qhKFQIufKbZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R2mLKBaJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R2mLKBaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06161F01560
	for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 23:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788219269;
	bh=tAVWsBwACx+IpWMY6PFdTt/YVw93rBRGG3Ku2i4nYdQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R2mLKBaJIt1LzWR0V0TjNUPUtImXik5BxuQM5K7ehXNP1UMZMf7jQOR5oBFVUpHVg
	 ErfrhJa96d3agy06drbJ8deA1ZThRetlAS6lJsgf8N9xX/VgCel/c9nX2RPsIbk+Vl
	 mZQ4MLUXXNiD5buS5hI4Maw+XeiXbFz5FhA18C/coXBRl/n+bLpfKd06U+vNCQu8h1
	 nY7TFJZADOwRT9YklDkbOoEb/kaSD3kKZP5MeSySq8npkFBuKXxRFIMi1/moKTPHsy
	 qZiLY8SW2Ixim8bMwIMGsf80Y9ayQVg3pFcCp3LyrRCqDGlycLx4ftJnvzACzVWxu5
	 oOzf74WtBZbmA==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so6559289a12.1
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2026 16:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwy7/XDIy5QZpy1q8iRDY2JQfKrltt11WaCDGl5x5h6hDxZS0ZCV0KahQG+FI7RgXGHRbYEv6UUcab2@vger.kernel.org
X-Gm-Message-State: AFuF++lowZDqr1lZMT1FI7s/F+lCRlmQil7viBtcUrPRilSmxgjAyncC
	BufI/jvOgmm61OAyIMJjISaMXiNmg60+2IXHdy/6jyGM56dJ5dMVddKHKu37nRx1aEVzL3y3Qc6
	nKeVwiYRZtzwSGTpSHiZpURjGZCAEZ6Q=
X-Received: by 2002:a05:6402:3245:b0:6a5:f44e:a009 with SMTP id
 4fb4d7f45d1cf-6a663a4a9dfmr2170192a12.7.1788219267560; Mon, 31 Aug 2026
 16:34:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260830041901.2668-1-willy@infradead.org> <20260830041901.2668-6-willy@infradead.org>
In-Reply-To: <20260830041901.2668-6-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Sep 2026 08:34:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
X-Gm-Features: AcwNN1WHItk-3z0F1xUEgtAcqL_7gSvlVk8E7QxJwHtI0RZzvTtB9qGbIwZCYNg
Message-ID: <CAKYAXd8qgCe0Kt_Pmpd+228LP+hCtF2shmVqftazX1+xrSCkFQ@mail.gmail.com>
Subject: Re: [PATCH 5/9] ntfs: Remove FGP_NOFS from __ntfs_inode_resident_attr_pwrite()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 30, 2026 at 1:19=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> I do not believe that FGP_NOFS is needed here.  This function is called
> from one place (ntfs_inode_attr_pwrite) which calls either this function
> or __ntfs_inode_non_resident_attr_pwrite().  The latter function does not
> use FGP_NOFS in its calls to allocate pagecaache memory, so it should not
> be needed here either.  If it turns out to be needed by both functions,
> then we should use memalloc_nofs_save at a higher level to protect both
> of them.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
