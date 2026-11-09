Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245057;
	b=bnK8QMecR/+uCHIA5KvAiIC6wceCVJwfZSlhQff/wU+NWkCaP0H+EgBZmW8EVoig85Pg
	 UcOjvVtOp/A5iRNfyVZdcb2CWjVN4MvM5Bp/Hevz6MC0YBLt2xhfOxfehqPV0jD8o6KV4
	 bdh2MJMaLqAzgfIWA5DyMlK7sv3FaaT/aqf4CYV+tqJ972yWpEdLUwp0QMBF3pLvRrfYm
	 w1NGvn6Shal8JqnuSScHyz3Sv35rwkAuGD/8p8Z7wVPK2PDYSEr68P1DlUN4fWOGGfJnk
	 xKEoo1ygce78+lYLL0u/qHolsBi1xsYOzPyeObz3ROhjz9/5I7OmKl3fXIxf6Bsb2SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245057;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=VrwMJ99WWWacF4cqxktw+u+v0MnM7ev02NI9rYCFdiY=;
	b=qEZdfQ/VaxC3moiWok+MDYMfd53adOLt2i9Pz7d3yRvMITDSFKlJHGndpHQn75MfT7xE
	 lFcWmbWYuZHIiovt0YHg4c00W+BfxpYNBcs5GQA/tyHtn6E/c1dt4+5kCuq7DRBKP1SR4
	 x1igrSkWm/uCyEzyqxGt5ioorzr/Z43E/lzifpKWVC23dhKn6ne7MCNx4tc+BTIPdbq9a
	 3KEG5NSXLOhzzW7r54zn6nfjqHo5mqpf7BYj+ZDKpEf6c7cSEEvr0Wo8QFukZM9tmb73D
	 n/91euKFLQWHt2zl5M0GVBVGbxe6k7AS99CZPArYcdINGs5PQfmFRYGieF2eu4oWtLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mA3sFTdi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B2B606A338
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mA3sFTdi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7547D1F008A1;
	Mon,  9 Nov 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794245056;
	bh=VrwMJ99WWWacF4cqxktw+u+v0MnM7ev02NI9rYCFdiY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mA3sFTdiPnL3Sna5VoI/BP8d4t+Qz0ioHdzxKE/OtXMTFwljOeC4chSmxrwhbT8Uw
	 pD7nkaGiFJUOYoIVXiihN19942qq4yO5aHjVJ6gsLLnUpXpGEsIZrHX5DKmPFi1KSY
	 XvYncPv5gOo4gMs7cTcFJk5kwmL/t9R8Q2nfqOYI853m0QU8uasCuiw1VgdM9FQHr7
	 0fd5N6Jf0UcwMj0L28ZdR9nbGceqpEROVeYbfeC/6E+q2PWAw6bAceWcrHSzxMxsm2
	 4KUHbSeqSigz8UYraKcZ9tlFwVC5P6x87OU6V0bxRYKYAybB1Ln1Aas25AjnvhiQLW
	 4WEZX5bSGopNw==
Message-ID: <sashiko-outbox-205294@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 07/14] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-7-91ac6c024018@kernel.org>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-7-91ac6c024018@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 17:24:16 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-work-inode=
-metadata_writeback-v3-0-91ac6c024018@kernel.org?part=3D7

