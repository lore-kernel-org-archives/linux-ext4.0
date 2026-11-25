Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606261;
	b=gD+Mfle5fU76n6cvbcJD+G9AMJIVyh1etSFfAEG3MIpij3kgz73S98gp7e7NcUuuClxd
	 wQ7vaXycCtEFAauuiPoqgxVM8lXslh5DLJO9GqIkIsrH2gUUe9Tu+JO0CY3c0A3eYjgz1
	 W+p2lr74GxyQwoTPMpbC/cf9N/axwgTaliyiT1lzVjPH+aiyB6kHHwG1Xgw8NQdjXFQZR
	 ix4uYwg7NviiKC7HBcBxL+OTv6xSBIiDdsScsG5QDFEv3SCIok66R7gbrElidGwa5EU1d
	 SRbLBJhUIUHQ1M1uq24rd+Npsj9tUB1x917Y2FrDjVj22cZJx/Yaqeoa7/3e5izFHtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606261;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6rtNDgpYUpQ70pCIEpPwsOjKXioaXSyEDy8mHSWjujE=;
	b=IKFjrQuVJE5ihlCN4fFYi0Xs05K9eZ4xA533miSbYQcQ2Jn82nhp9BnaYsZ+ydZfbY9t
	 XnTRu89rZhb6etfqfqOZTid4yHAX3wUd4c8/Em0vVn2k/IqUJS4o/RbAmXNFcy3Sv/uI8
	 7KB3c3l8q3oAh9RPTcScn3ZoO6x0144XXGqNI1c4sp8UCV2rd8CzMzjrbLJL/y0Bb2VDh
	 6TaJ1lfiq1a4HHE8rWVzghrD831ZkhswtAcqcS7erqG9efj4S5CGSQNuWLLwGFCd7cXka
	 EBerp8PdIX1UMG+wfSjBIyq1xGUZC5YyksCsNojncTRQcnKAOi+nNjGN3d5v/7dWLNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfRkfLTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D8606A321
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 11:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OfRkfLTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529301F000C4;
	Wed, 25 Nov 2026 11:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795606260;
	bh=6rtNDgpYUpQ70pCIEpPwsOjKXioaXSyEDy8mHSWjujE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OfRkfLTzAh2/3wCrgG1uGKNRC75aFEEMwQR1xB7yNxoigrNFCuH8TchVKodtjD1is
	 yrvEAFC+QuMseyCfREfb/3/62KoXEgP8ptey7+j6pIVHRnAU7n/Yuw3koNrack8ifT
	 l36/YfjbP8BEjQUnmyPKG87GPGoi1IRROd8NLtYN8OvMtMZNW49vuAsqxEXsZNwpLY
	 RDF+w8r8AzJO4TMI2uqV2Qr5RtwVE6D95La0Sk207Hkdm+AnigvXTb8sv70gkwdYdf
	 dgQbdrolDqWjlfXM6Xfh+CsA/8ZJwLAOQFN7Lu+s+zQUi4FLYC7BtQeOPNcbOafYoB
	 fyU/2d/F1mAHA==
Message-ID: <sashiko-outbox-233251@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 0/2] ext4: protect quota acquisition against
 filesystem freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Bin" <yebin@huaweicloud.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261125111055.3672233-1-yebin@huaweicloud.com>
References: <20261125111055.3672233-1-yebin@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 11:30:59 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 2-patch series:

- Patch 1: no issues found.
- Patch 2 ("ext4: protect ext4_acquire_dquot against freezing"): 2
  potential issues (2 High)

A detailed review has been sent as a separate reply to patch 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125111055.3672=
233-1-yebin@huaweicloud.com
