Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793073920;
	b=5BDNyZ8fUIDQUSndLLGVeOwFi/gR3XMnz5kjEuhyGoZbmg2CPRj30O0/KrVvuAY5e+Ko
	 IQH7Jrf6oRjUL1V4Qg89qD1fafXZ3fFeCNUYsVHpiW1KERh5ttftB1YnMrbRsn10b1ivU
	 xVZfbKHpB+CutIuH/iJCYJY12IKiKpSm4Rdo4ibOoKSe4Bd9jk+LWcuF3qG9KSrzhEhV4
	 p7TrLSLrLCE8mx5CMVH5wTBeml5o31WlCE4CFBnP8s0OTnaxx/7qaoux8JfDhIHX0k+Zs
	 icYjKHLLa6hGUsKs0WrMgukMrRmd7HPHxW0xobGOaFEaKiCLIyDoz04WsocjlXShiHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793073920;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FaCo+vIg5jEqP64jS1Yux6s7G3MUWFtRbhq1pqhe18M=;
	b=bjuEdd4SGyzCGiNebGocFlmrWje+ZZCPJW9aSKD1dbCDJbBx5S7pjJV9tArHyd51Riil
	 38jJ9lDHa6kiuuwBWm7MCM+82tylB9gb5qSTMRV6ZgeW78HEQU96HoigF5i5buoW1atk0
	 15pUeP1z8zNiZowDsQU+zsiH4tzS3w7dUQWyNGZDg2+U7p4j3PMutz2E5uqwOpF02wFP/
	 7jWL+NU6fwenrvBHnLf8LvDE+n8DXsxiAkKYXSYBfsr0n3p7jBkcrR+birAw97zR7KMXJ
	 b6Z8oBaKdev/54+W/vR8Ne76FKjODPqDmoCyMqctHZ/+3mTSygpzV/UjevJ5Cm3zMKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YM1Clz8N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E13606A31A
	for <linux-ext4@vger.kernel.org>; Tue, 27 Oct 2026 04:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YM1Clz8N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6371F01825;
	Tue, 27 Oct 2026 04:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793073919;
	bh=FaCo+vIg5jEqP64jS1Yux6s7G3MUWFtRbhq1pqhe18M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YM1Clz8NI5lDN6m1tWS3+88uFNyiP1w7PH2fB2k3aiHFsRbv3JMl6EofII3iFR3mB
	 uiMWDS5k1omLxlXzMgYKOcN4GFVLh5wFHet/rEgLp3nQZ8mtMa/4+iaf/+C8eFX043
	 uBsHhP+vrPmhQA1jLTUZy4B9yXh3QYXQOy/6nkhWyOa3ngJAbhTpga3Pybc12AiBT0
	 IJbuGvN52fSiikmiSUpoeF2pJvhdBz/KhyQGBBCXVrLEMUxIHl4E7oRoClbxLJmsi3
	 CUiJL4bc7UzfCaeVKfguhi6ebtNqt8G8JWC2q6kNyNzGnQCTUXxfxmVHEQLs5QpEBK
	 GCRaXN22fhdjw==
Message-ID: <sashiko-outbox-186069@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: preserve force-fsck requests across unmount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261027035857.72265-1-dennylin0707@gmail.com>
References: <20261027035857.72265-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 04:05:19 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> EXT4_TUNE_FL_FORCE_FSCK sets EXT4_ERROR_FS in the on-disk superblock
> but leaves s_mount_state unchanged. On a normal read-write unmount,
> ext4_put_super() restores s_state from s_mount_state, clearing the
> requested flag.
>=20
> As a result, a successful EXT4_IOC_SET_TUNE_SB_PARAM call can be lost
> before e2fsck runs: after unmount it treats the filesystem as clean
> and skips the requested check.
>=20
> Set EXT4_ERROR_FS in s_mount_state as well, matching the state handling
> in ext4_clear_journal_err(), so later superblock updates retain the
> request.
>=20
> Fixes: 04a91570ac67 ("ext4: implemet new ioctls to set and get superblock=
 parameters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027035857.7226=
5-1-dennylin0707@gmail.com?part=3D1

