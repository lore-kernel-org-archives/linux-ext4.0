Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520996;
	b=NXr8Z6KtlIaWJe+y2OwCDvt1evcrr2wj+2Rbqrvb7kQf+IapDkQJ4nCV5HXvRbjL5iUe
	 CttSxgQ77qDnuW6rHUXB1D0esym+oTCfbZFAe1VH6bauKO3lSf8oMBYlGLrBfr6jqZTjz
	 yvoPPnCMinXCXjXxQXInjkZpUTMEFuyH0pCpCe+N82xcOkcpHvL/95Rc5eYi8XpLyxCFU
	 jrTPou3sczGgxrX5TX+TadPyYBGp0dlNv6XPSrh4iUSWdykZgHn1Z7BgCmi+sC56N61GQ
	 SFQzwGclQO/RG1hb8/Yu5kXiiTSg0IxnOliFfn64k1MTpqBoE2Y2+ktE1LRpul+16Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520996;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6KkoX69lXsjTsaMo3aTW9EbBWS4ZelVtsRspoJVlaYE=;
	b=GVdFWSCWUYViEak1W4u7YJvlVxLDrrhBL+/U7JIpd/qk+3GyPPlnQ2lERIdyanU7Efmn
	 OHzXbDbiwkiW51hdwr6oCe7TukJ0/bk7+3MLHe+IG+X5aLSMBk99+h4ppYl32J1IHtGpx
	 VSarJ0Kne4ThDLOpR03t6AyVoNe2Ic8YSU9Rbf1cOc0ZSx3t+SBZ2dlTO9bqXWV3kR6pY
	 qpAnqtB2c43BXPL6Uhf+L1mtkNW0RKsJuBBkrkaZR0xUP6JHaJrPEsDnqPMm7IH1HUqH2
	 Kz1qNMYSRhvgOwQ/bloobCCmx67HROfS/2xKYK1/s1edH9WkR7Aj/Nm/d5cnDgiOEeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAs6M2yw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4534A606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TAs6M2yw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9571F000C7;
	Thu, 12 Nov 2026 22:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520995;
	bh=6KkoX69lXsjTsaMo3aTW9EbBWS4ZelVtsRspoJVlaYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TAs6M2yw50Xsy1ASiD0neztegLXxnQiYIRnxUADwcIPjoLSl+kmUJp88r65pG5nDm
	 OWcoWmdHXMjpaZX0LA6VAMWLLd8VH9VrtH7VUqIC9ezfKYc/fjrZdLSTyXoq5JjdU3
	 vOJUov75p/qg/SFx1ZVjkJ+5bYRw+JOjYyu6teEYcBTUxGlV9cXc6vNQ9KSlb52cHC
	 NRVYI/mvJg7n4NlUsSUral/fuEGKmLpYpFsOKxiphUHcRS2dc2NXSNpk4CKhinHEoB
	 8LYNUjmvR5+RFdiDRLWmPTfWssiWK/XFStVBo6w3a0Xb2y3p3rMFne99Ur+IILxvNL
	 gMr+UBOhhyzkQ==
Message-ID: <sashiko-outbox-211885@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 13/14] xfs: don't enable DAX on zoned inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-14-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-14-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:03:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A store through a shared mapping can dereference a NULL pointer if the
> file is zoned and has S_DAX.
>=20
> The zoned code does not support DAX, but XFS doesn't check for this:
> with dax=3Dalways or FS_XFLAG_DAX, an inode gets S_DAX if its device does
> DAX, and an internal zoned section on pmem does. The write fault then
> takes the zoned path:
>=20
>     xfs_filemap_fault()
>       xfs_write_fault()
>         xfs_write_fault_zoned()
>           page_folio(vmf->page)     /* NULL in a DAX fault */
>=20
> ftruncate() crashes in a similar way, in xfs_reflink_end_cow().
>=20
> The fix used here is to never set S_DAX on a zoned inode, and to refuse
> to change the realtime flag of an S_DAX inode on a zoned file system.
>=20
> Zoned files now use the page cache with dax=3Dalways or FS_XFLAG_DAX. A
> file whose realtime flag is cleared stays without DAX until its inode
> is evicted.
>=20
> Fixes: be458049ffe3 ("xfs: enable the zoned RT device feature")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D13

