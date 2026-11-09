Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794244418;
	b=TpNfp0MkII0XOKjOyPKWwLz5w7dtEqxsTIJvDSyIP7pBw2fnjNi7YZn4niMt+VJFSeVx
	 eGBEIiCZbKRTmGG60w4/MOPCk6s6TYW1UcARPGTru+AZ15xQkiEGYBadZ1Lxks60VagXQ
	 yER9yIRqhZ/wjtKe0RbbF/kFgU2ttBQQQebVYA8ImGDe3wGQ3Iwyucz9MBndLLqRanTlP
	 zlS/Y8xd8ty8o3oriOy+TmJeexdpeAIdVZctz97gf4zzKwJzZd10nfv+ZWwlg6di5Cbvv
	 XDr0xJGyeYrleEl/gnsfSyVSDX0dRPBb5ryRA0iVH1Y1oqP2Yo74EcYO/I4q7i2Iaeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794244418;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4izFxKHtSfzMZLM5hdTETjC4RMKLjXZ43Rws/bDpAwU=;
	b=Js95BigY989XfYFViAD5EyhW/bZuxbwrsftwXX3i4KC9P0jiFvKFjltPB4+K6mwNVxMX
	 8ImH8sQBYQNPndPRDL18xnOPz+sKTnKs3LMRCT36Nfg049bSoTKTYZAD209Z5dE5dIxyg
	 SrW6QGczCaYL7yzglthcQ0c/K7a9MgrHIeRqLMXqyhxez2JHdYUs7THWV+5lmmwCkC7oS
	 pF2rYHs2So7S4mmDUdeXITU/98lu8wNotj7stc4S7ttXYz5f+SXjpxOImU1oH5G5OQIWq
	 j3f1AuFPypiKY8N7ZwQyKCiWGskOTxPEs4DqT6KREwVoT73L4RCIW5h3GMGMq13qvug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvyP7ts7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C202606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvyP7ts7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEE61F0089F;
	Mon,  9 Nov 2026 17:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794244418;
	bh=4izFxKHtSfzMZLM5hdTETjC4RMKLjXZ43Rws/bDpAwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FvyP7ts7Asb2HAu3CYWw6iLzW/Cq89c7si5ZY2hmvl94+ANE6FO7ugCWNUztPkUUT
	 5eI1fa+ZrVc0p4IRkxtmAzAWm6pzENy08uaIkL/lbkJw1HuDUYZoxPn2QgQA65y61Z
	 FrPIgpcuxcxUyWVVWRYJ6es75TrdsK+2YACzeimvQbHedlsao2iZM8iQD/oquxDdDV
	 ZbxJhw6zHln7P6U8py+YCWbsohr+OB/u1MtIkdQyClr9RcCcwztERi1qHeW9WsVtBJ
	 3ZJNI+4u2vTkAgk33PB0g1qdP3yB2b7IFo8UnJVfxo8m8uOt5foXE57ToV3rz69j/a
	 ULB+xHhBW/xiQ==
Message-ID: <sashiko-outbox-205282@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 05/14] minix: add minix_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-5-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-5-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:13:37 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the block that holds an inode out of
> minix_V1_raw_inode() and minix_V2_raw_inode() into a helper.
> minix_sync_inode_metadata() is going to use it to find the block
> without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D5

