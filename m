Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714369;
	b=K3Y+uoL+DYzTkoYu6rpt4yCnauzVYV8g7+0lG5fjnWSfUPnsm11I19rKF2UtRN4tyZin
	 67lO73b3F+m4cDMFVMR+UpWz4/nFKOEeV4eHKH1Ks9Awa0EosUfZ6q2kz0dCoW0SldqFW
	 nigFDpMSOhvNhFZSqJR5qDc8MhMFiRCiGiwcRKPSU6OKAHSrD+RziNTm6khqBRfb7XynU
	 yFX1GF7Yod0sfOUcM07+4Inj4ZIQ4X/senc03WhAsghyT1Wnk8WJHdSCPtrP+Was6Efgx
	 Z7DqW7NHi2MOLY01jIQT9UeuF/ATTEgbAYcL0OHBauohNPHh9a2ALUhP+DQo0aVujqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714369;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-MBO-RS-META:X-MBO-RS-ID;
	bh=/8LuhXp97qtdFj406BlwMUOjhk0vBw5Jtvt8qfn+3xk=;
	b=OBw2mXFUaISZQhUsrNeBpYgyTA0pvsLuewBgK/QjPvWZQ4Wbjq5RZ1morFfedT3rNilN
	 b3NQWZjhHrWHZ/ANhmXLuWg4QbgP1IU7bMnW+1o+ubTadf2AkDGtxvIAlMzwgyW60Zg8I
	 UeGXW7bNELaqX0MuUTknlyR9oOQMDszFj03cQoPQyXD0vP2mTDXOyLJqN9122K69TopVM
	 qwUJ96dl1W1rjw2q4FEM5DphAdB1mUhptjdc6Lb6+ojl9FCZ1ls/QrmWxeRQGzghobkuL
	 zjvZKUM68VfkFmu1FaVhHaZ/ge6PSt03wEvfR2DCuYO5dm5l/gjmBQ3Ri8To1MMxRhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mailbox.org;
	spf=pass smtp.mailfrom=mailbox.org;
	dkim=pass header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=HkNKB+he;
	arc=none smtp.remote-ip=80.241.56.152
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50DE606D83C;
	Tue,  3 Nov 2026 13:59:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C50DE606D83C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=HkNKB+he
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jJqv04dS7zKnBS;
	Tue, 03 Nov 2026 14:59:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793714364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8LuhXp97qtdFj406BlwMUOjhk0vBw5Jtvt8qfn+3xk=;
	b=HkNKB+heHlv5LaJqH/hz7nrve9bKBwybj0+1qChGIgpa+e7iuKXtzlKpK4nHz22fI/i3Uf
	X0wVmp8KMeNnzTpbrzl1N984xj17Dv6HJQnxgWDppb+nPDRi+etPprIXLnLiFtGSZMhWeg
	dbe6Xj6C/qQJfCeJ+hJnxhCyFhue9qIwx/2Dxusu5/D8y+Uo2pRIMYCCeGNxFCXaGbH5n5
	K2riW2QxpOhnAmw3dI5GCrz41+ESnFOX6NAB3agesDT91tyYTSNSO4s6elFGTdQN1dyiz4
	riqlv9cyRgBa0Ao9iOHugO1DuiVSIxJWTZQBzKyvBxRYAbYU1cbQyVMwzpP7Rg==
Message-ID: <2b8dcc231ad8fb9049f1d05082e0c18e57a0f3b6.camel@mailbox.org>
Subject: Re: [PATCH v2] ext4, doc: remove unnecessary bracket
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>,  Baokun Li <libaokun@linux.alibaba.com>, Jan
 Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,  "Ritesh
 Harjani (IBM)"	 <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 Jonathan Corbet	 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap	 <rdunlap@infradead.org>
Cc: linux-ext4@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Tue, 03 Nov 2026 14:59:17 +0100
In-Reply-To: <20260916104251.296148-3-manuelebnerli@mailbox.org>
References: <20260916104251.296148-3-manuelebnerli@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MBO-RS-META: hpcmcbqhu3poy9dpa96q15gh7cnjntie
X-MBO-RS-ID: f02d63db6813a739ef4

Hi,

On Wed, 2026-09-16 at 12:42 +0200, Manuel Ebner wrote:
> Fix sentence structure to improve readability
>=20
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> CC: Randy Dunlap <rdunlap@infradead.org>

Can I do anything to get this applied?

Thanks
 Manuel

> ---
> @Jan Kara, is the reviewed-tag ok even though I changed the patch?
>=20
> [v2]
> =C2=A0Incorporate Randys suggestion.
>=20
> [v1]
> =C2=A0https://lore.kernel.org/all/20260902143254.702971-2-manuelebnerli@m=
ailbox.org/
> ---
> =C2=A0Documentation/filesystems/ext4/directory.rst | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/filesystems/ext4/directory.rst b/Documentation=
/filesystems/ext4/directory.rst
> index 9b003a4d4..6d8021309 100644
> --- a/Documentation/filesystems/ext4/directory.rst
> +++ b/Documentation/filesystems/ext4/directory.rst
> @@ -429,7 +429,7 @@ block (precisely the length of one dx_entry) are used=
 to store a
> =C2=A0``count`` entries in the dx_root/dx_node structures are adjusted as
> =C2=A0necessary to fit the dx_tail into the block. If there is no space f=
or
> =C2=A0the dx_tail, the user is notified to run e2fsck -D to rebuild the
> -directory index (which will ensure that there's space for the checksum.
> +directory index, which will ensure that there's space for the checksum.
> =C2=A0The dx_tail structure is 8 bytes long and looks like this:
> =C2=A0
> =C2=A0.. list-table::
