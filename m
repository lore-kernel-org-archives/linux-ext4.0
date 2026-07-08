Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F613E4C87
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 20:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783543251; cv=pass; b=OjGj4q0gblc6DHidcq9DaP2R7UXH29zhIkk4RsxU4bzbLVSR/VBVCPToQK5sbZs9DMGBmA1VX2QR4JzREKa0zJvcJ/5JeB76ADkt5s6qapBkqcD5tHlWgM8jOmEzNIBz60OROhki9m1ZQ/b3GBaUQQO4+J8JHLIbeqKMYrHIJ7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783543251; c=relaxed/simple;
	bh=eg8AbooWrchGP+5vFOVL+ntc126BYRP3715RVKn8f0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PV3bkmEnS21/ClwIil5UBe9FojySelTSWsMad2ngLTuZYPajQWNUfbY1OhbXlUKUXrryEU+HrXQD6RugOEt1VEEf+jwqHXlvfA5R6xYwmVW975IrP0y3zJnoAZzWW0pksXOFDFSXCPOOU9/r/Lcbc/0hbaa2jWoabGmqtacetVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lQ+cZroD; arc=pass smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lQ+cZroD"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493bab44440so1727655e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 13:40:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783543248; cv=none;
        d=google.com; s=arc-20260327;
        b=s/MT6DVEpJbPT4gkfnF58wp0iQRtgsiGyALyPJmhkYsDej905hF0zzBZmCgeJKfYaC
         6b+ZidmJaXsP1E31L1HcRP/y25gezEBX3iD45vBwZQkx3ROcoPVWWnIFNUsAkHnHTn03
         sgP3COrf8HMPpL9A1V3N4NwKI8YheIWxZSfeh5vjmMtsVs2d9VbeEZgtH36jUoJRmXSk
         fPO+9g0M5xRjKr3w+Acv+MG4mqdTrZ3KLMJ/KqLx2rXcjhM0xIcrKQsYCZywWyRu5DDj
         SsfjvPqhDQp/v8mNprTPpibxcBKXGNqLJ9+oIXs25qc86qoSchcAgSrKkhvGvGOSZjaq
         kx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        fh=l4kfER2Qp9ANr+ghwk0KWez/F03ESBp+QxZTgTQ/0/g=;
        b=e8x0jlFiLT/6KaXOmULY77KF2eRYt8G/JoRlnrbG4OC4zYZGdkyKNma3T1toi2e0Bc
         +CNZ5wi3wbMUs9O5mY8roVhQ76U00sxX15qpNxcw3IHr9Rno5qt0TJgmBi76nfeYNibG
         zHZFJUQulpntEcY+BvjNjsr/WCx9kkG2LFvBZtjc/EEIO93FwDRqVkb8wMZ5CRelQFDw
         WYHQXkVRuwdfqqnMWiRBdmcVpMWvp8Igz2xxyFF2sgysPYxgB2pJDFK8Agkq5l6cPu8x
         AnWj2MnlCTbKRjQrYh7UDEITwrsTHGuxOIrohh8N7uu9tav0DZusjniBN+qFryqj3OOY
         nw7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783543248; x=1784148048; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        b=lQ+cZroD0jZkScclfjtWa00kCjT+PAxETGJyEK7+MoJOgGcJfOBwrgUTGSH11L1ZOe
         JQmuiQ3lAyVZSLg8RH8T5Ry6no97tde53KzCbFfeiQU38p76utIP5b5/jerLTgEmMtio
         OPwiSKZeQwIOz9toPfuJ8CNEp+AyhddX0/DivgP++tTSKhrSYxKKsOajD02y//9R63I0
         twlBY3cXsJ1W8dHhCHwWqXvAt+Tx2hse5BzZBkPiPPW0MATnPGnCwTOD8jhhSHNSJxrC
         dERfkOhqyDcn3kCkxlXO7sKzhe4vZEP9p/DFZwjtTtnpxzvUPiMmdpx17RC/AOWxlcOd
         TDRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783543248; x=1784148048;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HV9dnVAAaywBkhcRiF+JFXkn347nONXaAEt0CLNpRQI=;
        b=eCsU/oe9Bxl1UQ+FDUJL44teoS+WvOO2/UYEBeRouCoXiK2Kh+aCxvcknGkQtAQtCV
         vhg0lUrF9hVQPZcuiL+FNqHefGE5/67e3pwNTeaojZXCShq65rXQ3KEncrtH8UhEyDzW
         COQusS4CzVPzpGQcWdQnO1m+57jzd73sGwuiKN7ZTIXLkTIqDyrmqyPybqNrLeyIGmx/
         a6WlKmEkxHP4NpYP1dk7KSmvheMMhussep9A8QVg4Q5OoeyRBxBr/Ll8fAq2OD4+ekQa
         rjkAlChEkoWPT/yI44GgrBQHE80jczRq8RgL9cTOxqBpIyidG3TH/6TtKRNfZNH2uNso
         lCUQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq9V8F3xKq8M7RJQ+ywzQsxUUAui9YGCpE2QoHsOKfTa7CKBEuPTWiL+mOEFf3rI5IUPvKjXBHdlNqf@vger.kernel.org
X-Gm-Message-State: AOJu0YxbYSRuJnQZkXvwD0sn5kmZtNQb1bmMFw/yM3OHUfrso8Vv3kcB
	ahm2+2XXagd7XNuee9D3XH+OserGCPpcsRb3Wgtj38zP/Ce/KnyEptV3Z46W6+M1CTOOr6C6ino
	GoopUKpUvqNmEmfSCEf5Zo81r8YjAY9BVWUq7
X-Gm-Gg: AfdE7cnoeXmEofMKeJWGWKD4qHKNZq0MfLDCNpj//z381FMdz7ThsNKoq7h8bT/loyA
	AZYmDBc6GviU9RgA1fjeP5uwMUxUTBkEs+npvnc0b0+YPrGZmmX6rRsh8lHcC180gBqqB6vdS6R
	BWmAyZA5gjodbS4VeOp2mmLT31obnOdmgVLS9n+e9X2bA1RZbzrVB+d/rh5VLRr/PrWtFkj7Avs
	uTLQ7QQcmeVbOvCxMuTNXZHlRUXCyRV0NbHliFk6vaeP3Cblhi8TSMWdNYW0YotYeUHCf8Ld+p6
	GWy5UdVs6c+JfGkDkIHptrzJy8ZHToGC/jjagHWWblyQ1LJVqS3l2iOuvoEeqAk=
X-Received: by 2002:a05:600c:34ce:b0:47d:52ef:c572 with SMTP id
 5b1f17b1804b1-493e1008fb8mr97418115e9.1.1783543248191; Wed, 08 Jul 2026
 13:40:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-5-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-5-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 13:40:36 -0700
X-Gm-Features: AUfX_mxh6mA1e0Oybe36TV4asjWw4ulMFew2ORY6N1hqoUi0VoqQJD26mBrzs8g
Message-ID: <CAJnrk1aBgAFu15wp3L-V34OU3i+AtMiDqjvhHtO=+ZMJ4yvfLQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] iomap: fix out-of-bounds bitmap_set() with
 zero-length range
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:14=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
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
>
> Add a !len guard to both functions before the computation, so that a
> zero-length range is a no-op.
>
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improv=
e performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
