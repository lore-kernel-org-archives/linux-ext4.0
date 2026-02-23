Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77091322B9F;
	Mon, 23 Feb 2026 23:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771887792; cv=none; b=NIzmccQ3LdagJXD+TDGRj3ALAL2FNH+fjszpxi4Pazt8xg0ETZsqDykzFzCG9Wo350le2jtbVqbWeQm1eeBUebehNlxXJjJ1Bpho2dmn/lCpMaiPnX4NmFnr74xGqrog2SIndHwpg+5625RIjJgTE8brTEqxgDDh1Y2vRxoVTvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771887792; c=relaxed/simple;
	bh=9V6S+ToqYOKGoCF4liioLukqlDyrfN2J298ylaop/4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2AepYXh2+fbblDk938mRsSOk1RhfaUMo5gmsqV6hnKBCQZxTdDFbTMqE0TudH0buZ+X2CoeG4io/PTfnhYBFACl2WGJshUzuLMBQoICJMtC8YuLUbsqq11rVXO8/S28w+i6srCNknLIuTLDKC2A5cAI/oqRRA9IYCUkfH4oJAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NY+vuXuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NY+vuXuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4928BC116C6;
	Mon, 23 Feb 2026 23:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771887792;
	bh=9V6S+ToqYOKGoCF4liioLukqlDyrfN2J298ylaop/4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NY+vuXuMJRoZgnGPaWfzfLU8PrLI4n1R2lqI6QlYka9VcWjd7KY+ZnFKHDXaTpMK3
	 nh8TEez1rb8uqVe6I+8Oz4mkT8Jtj4PNR7V6RpCgQR2V1ZTWMwF0Kd3794wFG1KFlD
	 4/Km5j9sNBCKxBXYPul641W1lOhKsKN25b5mCE7cUrKqiqKnw7aZxe44qMiVxnJ13C
	 LEkOVI+4suEwWmsno/kDRcV3xS/82y0Im6C9oGX9Xp1ovendP1RLEWWfQIKWI/KZ86
	 hO6JK0BmHpezCnpNiKGYsgcM882rCUxCpa2KtwXQu3TS5yDpdlOLEVLmpmKQVAe+Bf
	 MJVBSW5xl7o5Q==
Date: Mon, 23 Feb 2026 15:03:11 -0800
Subject: [PATCHSET v7 2/6] libfuse: allow servers to specify root node id
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, bschubert@ddn.com
Cc: bernd@bsbernd.com, miklos@szeredi.hu, neal@gompa.dev,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, joannelkoong@gmail.com
Message-ID: <177188740565.3941636.4202428671967258488.stgit@frogsfrogsfrogs>
In-Reply-To: <20260223224617.GA2390314@frogsfrogsfrogs>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series grants fuse servers full control over the entire node id
address space by allowing them to specify the nodeid of the root
directory.  With this new feature, fuse4fs will not have to translate
node ids.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-root-nodeid
---
Commits in this patchset:
 * libfuse: allow root_nodeid mount option
---
 lib/mount.c |    1 +
 1 file changed, 1 insertion(+)

