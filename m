Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520493;
	b=N7zJv47JytT0C24e5JQcyw7CwCL73r5sqGpkBQS/a66W5l6wMfq3RihPXdXCNDf3xati
	 /XohISXnjPDCWufmbZHDS6o8SFdSiYHv3eGAixeJoClqkMsyr75kbLrtQL4QL4d6coDNo
	 wWLf2z8E43hArSkUwhVHXJDPpBxkWa42PTF2ySngsYejgv6Wv+sIMmo93mOIo0WWwOL64
	 LopkoqDQcYnGVlY38YuOkyCPZO9OPY53SPkhDY+Xkdky3RYWQyJu4pCmLE0bddLiRQOJV
	 rrL7gGw6iAUM/E8OLo7edxcZSkUS+aOmhmO2BJer3kBzO/27nN2PIri8qQ3faa5MFSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520493;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pEp0DQ20rzWD3SNQ4E4W2QIICmXY5nEe5ed11HFLObk=;
	b=GVBVBJ32OlhKqntK4RLYsQUSZnZ2iKFDBFLH+bcpQv6ePda82A4WtQrsuLwKt7O53PCl
	 F/1tOojCtZRHxqUHinMwIejWeI4JuEVwg8ywoid5vRN/fHL4Kk5MLAwM9zVtOSxOdA/bb
	 htDPovMyrDtdK5ClMbDDD5gJRaCHougVeK+odyvhEhxSVvvmfA7NqFSWQ/t50A47u5BG7
	 lYDlONtVX8nrFzny2m53YOCfqBeLtewe5MwObKilSv7/L7pEX29ZsL4YWodmwfTe4dFdv
	 XG/XHqEilp0gM/qZLbA7RIYhVMya5D7QCp1ODnKEx1gppaRdHrpZUyBMGcQEO14B6/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="P/Vwt5TN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DCA606A330
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P/Vwt5TN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82601F000C5;
	Thu, 12 Nov 2026 21:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520493;
	bh=pEp0DQ20rzWD3SNQ4E4W2QIICmXY5nEe5ed11HFLObk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P/Vwt5TNL7E8U21Sch1nEeSwyi1aJ5QLLXrEIw41VmwAPlAs6stnG+AMRS02DnXeP
	 icWFzY4+b3D0t2O0tAg8zqUfz6WwHMd+5cZ21EtndfZfp8opw4rt9GnDaNFKn2cpm4
	 3/Ch4RcqAY4gZ6D9RjvqUWTmlwfLtbzqmS4/DDTvcSssTZ75DCv/eQzGLas648y46L
	 YDpdoaxqGWx9R+qgLhkw4NEd91iOJR2mdbp9uxisHX9pOEOZheDtdTNpuQ8oV9lUuP
	 nv4Mt3Ujx1KwSqVaGM3RfhVOgwnM1STAjAaW9hYyX2oaFpBX/cYNqyI4OLTPm3VqyJ
	 PkrM2m74TaNXQ==
Message-ID: <sashiko-outbox-211878@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/14] xfs: flush the shifted range before changing
 the file
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-3-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-3-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 21:54:52 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> If writeback of the range to be shifted fails, collapse range on XFS can
> fail with its hole already punched, and insert range with the file
> already grown.
>=20
> Both calls change the file first: collapse range punches its hole, and
> insert range grows i_size. Only then does xfs_prepare_shift() flush the
> range from the offset to EOF, and that flush fails if the writeback
> fails.
>=20
> The fix used here is to flush and invalidate that range before the file
> is changed.
>=20
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D2

