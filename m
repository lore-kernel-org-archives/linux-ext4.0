Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099695;
	b=X5RYFUHQtCFsYKgKOhqQAN43QJb+D/3aNQm152vCn6dDedyXMXLjbjHBaKzuV/wwdWIm
	 uXVKUM/gOyde+FaP7kl9EiiIi2QbFgYMlhKDckbvXeZnMNqnXyn+1iKRyQZCQJejGW3Ua
	 AyNn30t/oqHlolsG4KIgBgxCqCyNrmfTvM/oAYF2N3IQX0ahJXUY2sjUEheS7ZwcjeuaG
	 arqSaUcRZOKwo5emkwDeSewOqwZniGWynhnDpQ7OvTi93h6sOmoDM1d5Wdjqj+1a7CUAD
	 vP/rueiprvGTQKYccLi5Phq0kOVB9SF3b7z/EZWotq4NcCVKbubcDm/y6f07rP1SZ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099695;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=oGiLuaAXbVTmodE93Bi2QufGuOl4dv0CyFDodMAbA9w=;
	b=rL5tVM3EpiVqcPB90qNIIku9s8cVnAlUZF/5qCWSpxmr0WYUPtTLa44Y1Vgl1jKEdkWf
	 wgJfmV/2p9u2cX3YHBzG/MMVBkcm6bxL6wdgCXvoT/4wGG0K4kNivPHvGwCOTjognRCHc
	 prX/qfWumFM3P1V/nUnxhnpfybLrPf8mOxbYix5AdVR1w46JsyYYa+YYHxZm3Gp94XLt0
	 3MomZAkIjWOqQEdUTFMf0GFwqjkY45LFE0NeaLOiOs7UodFegXwcj2MG/DFzrLNOAA07F
	 t+DO4gfn9/0cU7EcA5TjKfWQz1rTaFThb4zpeu0sT2rs4DjVWZphO/AUpyUFhqEjFZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=UjFPYLNT;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8522606C318
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8522606C318
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=UjFPYLNT
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfVs018190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=oGiLuaAXbVTmodE93Bi2QufGuOl4dv0CyFDodMAbA9w=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=UjFPYLNTqyQjF+lhbBhX3bboSMCUiNOGuQ99Un1t3u0v1Wd8ScP07gWsYO+mEqsyG
	 XchaesdM44aIl//wuk4dYML1KXg/RjjOesbbxsfFj49sbosYtnca879n16ukuy+gEk
	 Fnd+RsKoZ9e4wYZNjPIiu8GjzQWPk/pr3utlRPZxYNu6el+xLEQMx9cqDRrnBXw723
	 tUCEStikTQu8xHI3i8bK7N6cL+VU2VkIBgaY+PvErbJ5RZQjgu5VUWQzcDqFmd9fhP
	 Yxl3+FiXRKewEr7+cusxN//yPk59MzytUfuPhpFctFZONAG/hp0Is/OLDh8FDHbYPY
	 uzWn4eqWr/anQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 5BB692E0194; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: return -EINVAL on hole in ext4_convert_unwritten_extents_atomic()
Date: Thu, 19 Nov 2026 09:47:17 -0500
Message-ID: <179509948715.1938961.18167763696793669225.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
References: <20261023-ext4-atomic-endio-fix-b4-v1-1-f91feb0b9613@linux.ibm.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 23 Oct 2026 15:53:45 +0530, Ojaswin Mujoo wrote:
> We should ideally never encounter a hole during the endio conversion as
> that indicates something is wrong with our extent handling. Still if we do
> find a hole at atomic write endio, ext4_map_blocks() returns 0 which would
> be returned back to callers by ext4_convert_unwritten_extents_atomic().
> This can be wrongly interpreted as a success. Fix this by bailing out with
> -EINVAL instead.
> 
> [...]

Applied, thanks!

[1/1] ext4: return -EINVAL on hole in ext4_convert_unwritten_extents_atomic()
      commit: 23e76be92cd7cdb25d53d522a01285e595c30cbe

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
