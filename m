Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312329BDA2
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 04:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584402; cv=none; b=mf8I7msadNJSIgD03Tiyisg3w6Wbzjz6GxbRy74LFFK9MQ3L7JoMbEj6+WJUvCyyF3sMbi+3JnYHef1Kqa++osjyGXPS+lSjm0gh6S0ull1lSQKtPWajPZByq26oAHOZ1MyYmmojvHp1siD7wcxIhPlpqcqnvPhG/4dPZN56Iy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584402; c=relaxed/simple;
	bh=PKGTfbtnSitnpg+5qlHnkFgxvSzwVx2/Bhd96NiXm4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EmtblDkytZ8HAUZYuBHLx4Svsi4itiOhRnqmdtZ8522HVYUsn9OuWjOtJJKy5zxLwcbtqRAIAuejDPlM7ETNqDrWvfwv84npU9XRDmWYwF3OLDD7ODUJjslapy78cBdvGE0vKF2AzACYG5CZD5d/GBfrYvPDMglwkkF1ypDvW+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=coSg+P0/; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="coSg+P0/"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62R46Tfw005939
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 00:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774584391; bh=vATOROsxK1GOhF2paSVJO/P8gRrrNn/LOOO8cI9JdFI=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=coSg+P0/DMtiFVxGjDhQiptwhnDI8YAt4UIsgk5uHZda3tsY+R7wmqv2K/SEiMfZE
	 un1WH7wexJ5H+wCB3rpjmUWZ4KrME8jDO3vdEOwvLC8AsTtLIczycoU0K/RoCHMrkB
	 CEiJMATuChu9elf7QGHHO3H0Iswd2uSS5cFlW3z/V4IVg+F+5z5xUqiU5pVzu4LRvW
	 E6pGxJFQtWIsbnhWkr30dJ3h12SrP+ugsj5wzywrjPbqeItzCwJzoLEBGp84S4KWvg
	 nbeNkRo6x0RFL+MCX8uFLJVrqtudCIJ3VeAuZXuAjHm1CbRyIzHDmFbHpIjc1ANnGd
	 B/qHA0zlQ6/cw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4FAA72E00D9; Fri, 27 Mar 2026 00:06:29 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, tejas bharambe <tejas.bharambe@outlook.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: validate p_idx bounds in ext4_ext_correct_indexes
Date: Fri, 27 Mar 2026 00:06:23 -0400
Message-ID: <177454194756.1228042.15152022188906422694.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
References: <JH0PR06MB66326016F9B6AD24097D232B897CA@JH0PR06MB6632.apcprd06.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 04 Mar 2026 07:32:08 +0000, tejas bharambe wrote:
> ext4_ext_correct_indexes() walks up the extent tree correcting
> index entries when the first extent in a leaf is modified. Before
> accessing path[k].p_idx->ei_block, there is no validation that
> p_idx falls within the valid range of index entries for that
> level.
> 
> If the on-disk extent header contains a corrupted or crafted
> eh_entries value, p_idx can point past the end of the allocated
> buffer, causing a slab-out-of-bounds read.
> 
> [...]

Applied, thanks!

[1/1] ext4: validate p_idx bounds in ext4_ext_correct_indexes
      commit: a32da9c8bcceb70a5ced2f74c7551d300c541455

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
