Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051141;
	b=tiWPRN/tNixQywQxxH/OeJ3R66J4TmZnOYlbQMoqR5xxE5TeVjVJuoY85UAeO0Lsppuo
	 aqea1xh+HMvLUSpcBxbswZge/m9d19HqlWXqZthBLXMl3qSeVhq4tdCulrobHX/316Gai
	 Pj5J2WWE8e0A0str1/vnh9N29hK+H3HYq7DGRvSdASf0jMj0qwLBlnqRVC3uQjgCnlUsp
	 hCnPecXRj44eCqJp2WJ2toWN+CwQWJfitkHiXHbu6aA/2nkol2Air3fwtL8b/h7Y3b+E7
	 zwBmtK8mJAN2a4sVjMd0B5v5NQLe2UmMI2Dh70WNDwf1ZSyRZbEppJiyFxdq44y13aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051141;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UwH8yfiM951SajpzWNYhn0hNl3yG1fmgU03jiAwGEyk=;
	b=43BwZDGojHqtH7PEzNU1b5HJDMXclBRI22DEKN24ThzdjXDVUdweij50aqXSaxXjHoiY
	 sKQhovxZsgobcJZxrQKfeA4hF8aXco/sRQmeHBgr41QWXmnjQLAR2F/g4rx2el1RJEWyq
	 NKcpQm7/nlj8dmC1aOBz4dHjXtxRgQrKSenAUs10oz10/LUAKwqUL0OeXtZSL0gxouLDo
	 Ie9fNKtS7u02UMcp2m9fAN5mkEzha7GUeSQLMfWAtKeZL+OENafJt2Wf/NpSYFpoK18c0
	 D2rhi43s/SGszh8Jpn4mUbFa5frCjLsl3iQ7OTBZwI7eqE3wt809uga9Jx+iCHp1T9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAlKTwif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4841606A31A;
	Mon, 26 Oct 2026 21:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MAlKTwif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D4F1F01280;
	Mon, 26 Oct 2026 21:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793051140;
	bh=UwH8yfiM951SajpzWNYhn0hNl3yG1fmgU03jiAwGEyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MAlKTwifKmmrkSQ8dBhDfH/RzsUBrjYu6aDNsQWa/jqLPxWie7qbRvzIMG8y0M06+
	 WgjPdeVXinGfaU3WKxeBojFs4p20370SxW3jKKv2CgjcwfBXADuiDLZJZZkdIy5cXZ
	 pnZaGYHOroV7mO6AWfQSiA+DXkXh7H2wkL3aZhA9rLkfyqChijbFWFmjbQs5m55DsD
	 u5pnp2N6vlhJbpf5Htvg6l4mloC6L0xk6nwyoUNd19CnNeooQ89TzaRauouw1VWFIt
	 SD81E2RkGRzE7JQY2f9wLRpgA+ZkRoYC9OzE8oSQF2n792CH9gyerorMgasnHjGvTq
	 0aANobeZNrHLA==
Date: Mon, 26 Oct 2026 14:45:36 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.com>, Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v2] ext2: Make sbi an proper alias for EXT2_SB(sb) in
 ext2_fill_super()
Message-ID: <20261026214536.GC1330439@ax162>
References: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
 <l5r3w2wshrbhcxx4jamjufxdodmkb75zvitxcrll3uipih5cfq@plrdwt7fy5xz>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l5r3w2wshrbhcxx4jamjufxdodmkb75zvitxcrll3uipih5cfq@plrdwt7fy5xz>

On Mon, Oct 26, 2026 at 01:32:34PM +0100, Jan Kara wrote:
> OK, if this helps you :). Added to my tree, I plan to push it to Linus for
> rc2.

Great, that would help a lot, thanks!

-- 
Cheers,
Nathan
