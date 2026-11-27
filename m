Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795810816;
	b=I4erw+LdI5rYddGK3N74Q+Dkp/5DFxppOeuxeloxJNitwWOuVnJcSLTwYxtdfaakjccY
	 Ny4RknYY74jKWnt91ueSgdkN7HW3yg8aTg1U+VCZiGjWr105kQlFGJHeos9JQxOGxDOfF
	 rWZ+Ctf1GRp26YH0OkgJ97Ee8Kfd9LwF/nrElEkB8EyVtkZe0bF+IfuBnIIDPqhfbpNbW
	 zH+gGLHEQIFU3Uos21YkkGOqlylJKK5ucW8DLK4YGmRkE6tvWCuD23IA3W7WG/zYkhiqE
	 rE15VH4gf3c1cGiWk09AVxvIXlXmh36mPoRPkrpWEOnJagJETci+HfmuiSeS8qLrXHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795810816;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eUOXj4BtCEjVrP9/xFWj/VHmZLFV+OWQWwKsGbGVb1o=;
	b=hGDnt5seqdTKSrWRbTr7/25GPIF8EhUiWIt/TBnifPXUE4Ov2D8eb5YL8Nsr7LxTgFTp
	 fS3646zE/PQVXnmihVkhhds9p1NJ8jbV3TOknkHWQQo4av1HmZyK09LJFKiZ0yPsLDxw+
	 rdSW+W89+/J9ns8gQ6OOWUU7O3cUFnBNMXAISXFiRWc8JxqW98CXwEJXR6IsHwo1TCPUF
	 X3lVGRJF+3JStHDusnQMXiNlK7wVl4JRxDCK/uQkR5i7+WU63VfBmiMLD6Sknt+mWZmpN
	 jwdSs7Ip9bXq6POO4Hr3SpW+F/9XWrjNhl+vxyiCXDJWCRBXAacQIIOJUYrKFoWh04w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cjqIQuk3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCF3606A326
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cjqIQuk3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341AF1F000C1;
	Fri, 27 Nov 2026 20:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810816;
	bh=eUOXj4BtCEjVrP9/xFWj/VHmZLFV+OWQWwKsGbGVb1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cjqIQuk3NIOwHjirTsRZNOpwLf/31OvwiYQ1BWcaWUmCFz0hYNajusC4GfD+TK7kc
	 cc/LGH6KwjqtJ/itxZVymqqOhwC43HN4lNTsfaXAGdR6MEd98am4khoWyfq/UhUTo4
	 rCM270PUhUWpXOSnFs4FNKWYXj5lkkAH1MkHihF9m7+x0OQzhTzBThYYwRGVcYQHUz
	 uUMCGuQFLalBaW+YR/b3aIVDh9wkg2F+AQQsck06RU1EhS+PlTNfKYtTs99yr2imz8
	 +bDCWy9i2f5fheL6DiddnvtmH5smfG3gAhdX+qMpP257vP4jQTvkNGPZWp7uhdXD8C
	 xPpGxPuuJBodQ==
Message-ID: <sashiko-outbox-238229@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 00/13] ext4: fix endio zeroout corruption by tracking
 to-be-converted unwritten IOs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 20:20:15 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 13-patch series:

- Patches 1, 3, 9, 10, and 12: no issues found.
- Patch 2 ("ext4: introduce CONVERT_PENDING extent status type"): 1
  potential issue (1 Medium)
- Patch 4 ("ext4: add es helper to convert unwrit to convert pen..."): 1
  potential issue (1 Medium)
- Patch 5 ("ext4: add support to track convert pending ranges in..."): 2
  potential issues (2 Medium)
- Patch 6 ("ext4: add tracking for unwritten to-be-converted ran..."): 1
  potential issue (1 High)
- Patch 7 ("ext4: add tracking for unwritten to-be-converted ran..."): 2
  potential issues (1 High, 1 Medium)
- Patch 8 ("ext4: add tracking for unwritten to-be-converted ran..."): 1
  potential issue (1 Medium)
- Patch 11 ("ext4: update extent status cache when zeroing extents"): 2
  potential issues (2 Medium)
- Patch 13 ("ext4: re-enable zeroout fallback"): 2 potential issues (2
  Medium)

Detailed reviews have been sent as separate replies to patches 2, 4-8,
11, and 13.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com
