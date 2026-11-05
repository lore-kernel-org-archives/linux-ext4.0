Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882959;
	b=xAgzhO9brCRl/oR++2uuishoIsvM2pqSnhlfbsmXqxXMLLUd1WAuHTQmDqKM46yvfFHJ
	 FcZcyI2dC9FZ2cmmxmdSXQOaIvzuEWtpXIxtePLDQrwD2BAO5EVQFa1Z2G9Id3f0/MvgI
	 YYHjSYE4CrnyZRQ/h29kqdnQTArqahXrK1l6oYv9PP1zvIaEp3+hu+noJv3rnDunuBgqY
	 dA64GfvfO4a9h9rKjj4vj5q++0IAX+1rh59q0wjyLpNqxTghz3m0S1xe3Gys9Tz6uAteL
	 cbZhSehDo77AWhYEcxLdIA2TpcDtiibxf+Af+VoFr5+x5Y2ldMmm8br5pzhn2IC+6+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882959;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7C0/ulRsqynLwQ4QMieDLTqkseejYHkHC5itXFcMhXI=;
	b=dcwd17405HNgQ6C2PXhUAC2HfpS31y0tGKsWFkiNfSJnhdC0wY5E4IRxaE8OcqtJLXm9
	 NLtVBU7Mcg/1903L9Ul9om4wz3OvwfABC/k5caJXPp4W/0SLsDZYSz0QS32dPJGb8U4WW
	 qmmYVRMyrrjTUGxDpQ16066yhSA9RxQonS5QWY3PlCdtbsePQXeC/pRm2gW5PhKFMbms5
	 HXGr3aeSrD/6GIyJ/3bjqn++KS2WzGwi9s8vcQvuqqUzTdneLYH1D2YhBCMg0w/jk7/jY
	 YN88CzYdO5Du+Sua+UbPcLFw4MqTgm1a2M46nw343aX5x+c4pfEDUgDKOmTMQTQIFaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8PUo2lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E82606A31B
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8PUo2lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17431F000C1;
	Thu,  5 Nov 2026 12:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882959;
	bh=7C0/ulRsqynLwQ4QMieDLTqkseejYHkHC5itXFcMhXI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S8PUo2lt2E44+gTdoaeelFPo2actKdHg/V/C6NExPyvXOoFKzBq/0F5MMPOvzCvhq
	 HVPMStN6fb6Mv0JvWm94eQau9uwIb4gYhosIfq5Vz76vWakchDt2dL3Da8JqHcxyli
	 eyxF3S1b+akm1TDbzDr01PM8gdvnCPoWv+w9vsV2meqkslXiWbjaYqxIuLZeBbjlet
	 Rv6tcqi5xvfaKXBEQQzrM7BHtbvZYaLURtlfFcpDdp55NwYAsxZFbfc2x0oXVCxswg
	 BRy+3072rc+SzrMZ4lp1Df4Vzi89nBhITfM3cSGjhud7ojc3g4Ch6LMzw/Z6tdllsK
	 z+x9VXbHknTEA==
Message-ID: <sashiko-outbox-199063@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 10/13] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-10-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-10-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:49:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> udf_sync_inode_metadata() looks the block that holds the inode up with
> sb_getblk() which allocates a buffer for it if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for and the buffer just gets thrown away
> again.
>=20
> That allocation is also something we can't afford once inode eviction
> calls ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D10

