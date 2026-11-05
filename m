Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883272;
	b=JeCstEAhH+N3ASWc1zBEbcmGFFemaxXG5J00jJWVi9x/QnMXPP9OHkPz5lsCBHsDwzP2
	 sCiiplgevtZnFy5g5Y6OczeB3Wb54KTZlnxBlo+Kq/gG25i0zKvQX/P9VvdlScuH7VZNI
	 1NhiiwsU9adOt1E1m43wF/GQ0dWz3tAisbd3swKz3tlO6hTLOmXre7b6AX7wwGx9iiuB+
	 9Kw/hlrbpQOdWGz+nPRRysE1hvWyFpSYqiS4wfYtRUejC8UWixBEuNlfyTm5cb584FThc
	 +gr3UoTFCtP+HFlJAjFaxxz4I4K7T8tR+ultaLJZ8y6Q+T07eG+uNpEKQWg2A5rGB7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883272;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ijZFTxIXDeAdow6WpLpXkyRviD54bxBSx9eVsdrEbmw=;
	b=vFDgmXGQeImjrBiMWRl1oBKgveNgGb1lYdYL9MHmU4F9gX+iYVK6WL0SV0wyzUC1wX4n
	 ilCWsVwTv9qG3NWchz0Tbk3zafHap7eFSzWhFklAWrlq02QcqAJUcIQ3zXo4Lhroow2vz
	 Xod3zTYCgGUivANJcFU57NR/VIuSJp4vc+ewTWxRu7N4cVQfLmimxZ3BokWHbkw2Bk7fv
	 /YsnaUULu8ds2RCLhxAO72Tg051qyKOCPDVEOvxlxrNC57Hc3kzc9LHPRBt3PFVg9d5wq
	 czhraa0fQiT7ej0txxC3Mm8PpKXz+xo0o5AHwrGJGEhHU2qdpvdtu0WqmokVUt7IXLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cI1Y8IdQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FE7606A331
	for <linux-ext4@vger.kernel.org>; Thu,  5 Nov 2026 12:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cI1Y8IdQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486EF1F00919;
	Thu,  5 Nov 2026 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883271;
	bh=ijZFTxIXDeAdow6WpLpXkyRviD54bxBSx9eVsdrEbmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cI1Y8IdQI0VcImRCpo2YYaAM6riH0zh5mu25tzok2pdvUS20q+vnInbfcWXLDNwJl
	 Zg7CKsMfe/++UE7sb4us3/JtOm5HaUnqNfAnxp7w0muRjL6T5XpfYnRoMC9dyyEeMH
	 /bxsK+7efFIdSrVHKREffrFVbG0vLR9iFKCHZ5/Qf/l5HWd78TtyyLTm2x1hh4jTQS
	 HUDX+Kg8fdDqFl53ZsnaMo//YPkf3G1t8einceG9fLrpaUIguLJQbdMxUswDTcaBiT
	 lMALnCuzYdBW5t5FTij2hhICzGRz4yeVhq3+yhPLcoGrsco7MtncWEjonJjF50zy8X
	 fnox2DZszxNog==
Message-ID: <sashiko-outbox-199078@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 11/13] udf: sync inode metadata in
 udf_evict_inode()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-11-48628c60c336@kernel.org>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-11-48628c60c336@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:54:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> udf_write_inode() copies the inode into the block that holds it, marks
> the block dirty and sets I_METADATA_WRITEBACK so that a later fsync()
> writes the block out and waits for it. But the bit goes away with the
> inode. If the inode is evicted and read back in, fsync() finds a clean
> inode and returns while the block might still be dirty or under
> writeback.
>=20
> Right now that can't happen because inode_lru_isolate() never lets go
> of an inode with I_METADATA_WRITEBACK set. That is about to change.
>=20
> So call udf_sync_inode_metadata() from udf_evict_inode() for an inode
> that isn't deleted and still has the bit set. It syncs the metadata
> buffers as well so it replaces the mmb_sync() there, and since the
> previous patch it doesn't allocate anything.
>=20
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-work-inode=
-metadata_writeback-v2-0-48628c60c336@kernel.org?part=3D11

