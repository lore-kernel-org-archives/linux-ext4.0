Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA78B2CCB9
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675885; cv=none; b=UH1EaGwF7VVBXrZyTtwy63SIXThNEYB0tj6qmBBsacA/SMl6BxSpOWpDBnooFQDmDmQNa1FBMxzNZubBgCKR4wds53tHRewfPZTtmvS9pCqeE47mKKh/GHuZ1kjxtSyEFg8OK5P6cSPXAIw6y60MV1hJfg0kjrcPs8gf9nWNa5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675885; c=relaxed/simple;
	bh=OIw1ff5vPGz9ShKuc942VycBWi2Zc7ppzW3CiG1a4Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aqPQXf87RhSq8BhdKQW3yG7d/WSv/8eFzUmoFg5sMy5NjafGKbSI5FF98JaJwHiNKEBkZoKABzPdycFtJjf5jFYT2TENi6uBaKF16aQz/fI/srf6Pug8Vj8lCleWOS3oKwBfKpdATt13tyARrgYxuQZxD6K9jHV3bqTCiLqL2P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=OGrBLFv8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="OGrBLFv8"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VIT3013578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675879; bh=mF71/NDCFx4CQUjxiTWjVrfpz4aSbzhxoJUB7Pdzzr4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=OGrBLFv8diDiL9DIrHN53vMySBeiYZ5TE4R81yjxHJo6Ej0Bo7p2301nhWCHlG0ny
	 8B6oMxRmcLaCUcZ2FbHTXANQHBcqOwLWJVk55yvi7Rfl8s/WZKuM5W+8wkKqE1jfSi
	 gl/dlQYrCAwud8uCWhjonsZHRjc8JeQjz0nxikhB+O0VIZ9GIuED9A0Uh2K8p8H7JX
	 NBk+7KdJWDAWydPZvKNu+rwEQEC1qI0hnhvPuRD6lSwHEKUAjX5tId5xKADmR6iVNz
	 p6yWd3OyBLpyF3x7C5v21/kGAoQsZW0FIunDZWJPYVC66z73OKxtN8Lp+JGsYDz3VM
	 WEL7GvPQfBvYg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0E4052E00DE; Sat, 28 Mar 2026 01:31:15 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: handle wraparound when searching for blocks for indirect mapped blocks
Date: Sat, 28 Mar 2026 01:31:11 -0400
Message-ID: <177467585142.1335526.5177975430062183104.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326045834.1175822-1-tytso@mit.edu>
References: <20260326045834.1175822-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 26 Mar 2026 00:58:34 -0400, Theodore Ts'o wrote:
> Commit 4865c768b563 ("ext4: always allocate blocks only from groups
> inode can use") restricts what blocks will be allocated for indirect
> block based files to block numbers that fit within 32-bit block
> numbers.
> 
> However, when using a review bot running on the latest Gemini LLM to
> check this commit when backporting into an LTS based kernel, it raised
> this concern:
> 
> [...]

Applied, thanks!

[1/1] ext4: handle wraparound when searching for blocks for indirect mapped blocks
      commit: bb81702370fad22c06ca12b6e1648754dbc37e0f

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
