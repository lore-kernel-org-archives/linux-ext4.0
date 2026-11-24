Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795519325;
	b=LVsQ0P4jQJsE+PRP9UZ8aK0L3y+YpX9KI5B83wcI0FWW9qK5Sn7bgYP6sSmZ6oWD4pyr
	 qvt3EKyS3Bb4RQd26ux4Fex8Lz/PlfsYR54WH+usk/mZCHay69Q72GOI98/GF6kCZTUoS
	 jhQio1jrz6ngEtbKT94vly2WUTYr+iHk2/7ASvSycAT1HZtjTUQnVHtWufznsod+vbhgq
	 /k+VOms/qnrihONKFJ47AEz/dR/q5/3ojtlU+MvuHDeDVCTI1IL+AJNN6U5ogaK6B3CKS
	 UfnCqHD1qFhR8tqIADoxWNMImq7ohxLO0FMRHvpy+ufsT4PMj8eAmG8rUoo+2tJ4UiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795519325;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EqpD4WU1GBvWyrI0oG5FoUN/3UAfJNzQ1ZuvUZ4JDgc=;
	b=JqYroBUSj13W4O/Il+Pnk77JiUtbOz2Eepm/4B1i1MfzrYdRLLKXrdU4dHs0QdCYPmW7
	 9qt+pOhhwgLZuqLFA3aIMh5oXWJq5edlAi7nCkfK8Lec+9EcvNIHXe0+EsmZraK8pAMZ9
	 +CgQa0wEoQBBCU+WQVq3izJXRG1BRY8/n+4xKfd8MbInqEnv7Y5C7aSp2HDvf2Uoxiw8Z
	 nxfBeFARB2X/UqLMHPpOFvCMl9ndCiQ/lKZj1soMkq7Rl93rF0yfU/k0Hlh0qIqTYfrfm
	 9gf4JhssM/eZvlSoIadw9OBtl2/Rw5PljsHCPtRAi55cQ2/F1cLt0lDh1evYWXegIBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hSuIq9c2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3999F606A322
	for <linux-ext4@vger.kernel.org>; Tue, 24 Nov 2026 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hSuIq9c2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A871F000C6;
	Tue, 24 Nov 2026 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795519324;
	bh=EqpD4WU1GBvWyrI0oG5FoUN/3UAfJNzQ1ZuvUZ4JDgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hSuIq9c2XRnhU/dENIRjmeJ0Ks2wXWQeMZpG0vUlLmeo73dBeZKVqquYncHjybGc2
	 tjX/yZAluk0krOoMBU79DOQSImG+oRZsNcJu3tP3g4X4E6Y+9we0X3ntYfQlEA85rv
	 N4yYQVKLzVfI9guN8uJ6npL+XGHqmTpgUliPv2ZrgjoVDY5kZTYLY2yfss1oSKCmnG
	 t9NO2V/b1CjPx01G+TkHBVL8Ia3t7127HkfnN1HQnTOUe4WeO2T8Wx6KqJNjM28+2k
	 F83xG82tHoBfH7PBmg4dsWwzVrx2zCCNAfGVyih67BjsEdWP2lTrSQeMv3lGGsmsHI
	 DKtPc1sg9xEPw==
Message-ID: <sashiko-outbox-231042@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] ext2: Reject a superblock with an invalid
 s_first_ino
Reply-To: sashiko-reviews@lists.linux.dev
To: "Peng Hao" <flyingpenghao@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261124111708.24204-1-flyingpeng@tencent.com>
References: <20261124111708.24204-1-flyingpeng@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 11:22:04 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 2-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124111708.2420=
4-1-flyingpeng@tencent.com
