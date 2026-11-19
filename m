Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099688;
	b=J3SujO7YIp/IlQxgqRE5rQsHANCwOPpu0y0vD0Qc+4NyoDrlrmqVcObUc0ctI+IWWRq0
	 OclB4Hb2ezaZDHWaS4cQRQk+jtCOAfxKCGPCEpFuatBldUyQlf5fBD6S0G9V8TtgUXqgA
	 tQeNUyl3jmSaURd1TqCZ7kjkq3R6d7DEHYQa5+vX1NI4SiRT2nA48c3bh3DgGc6HUCqn6
	 8gtuIWoEqg7Uzyz3HiTaggNJtj2osgjdMhoQjrSMHbnclDtxfUPXscz9R6hga0H3W6/FC
	 JuiAJXup7eNKuMa3pLAB8fkO97hUWZRJfD5kN1+o2olFCJG+Ml23HF9x264pidKlpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099688;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=KIrRKPvTcZl6urzMdIQpsdibkczggTBV8JarCNfPQI4=;
	b=hUoQwwwpVrgFqb8eqaVbnVhydM8wSUJ5iEDLU8eH7qFb7t7tSwxzxKK7iLii2S7PbGeG
	 YFVqZQkaepX11RM9gxbmyUVn6nma/w9etD9/60Dz/YqnBPP2VvQXOAFiRRkxU6HsXW0e7
	 OT5i93H+Bsz6esGB8Rqva9MF3Y1Q9QMrRUkXK4/nUwFOlLxOlul0QkJHRNlkqLRhqWBuH
	 tpIS2YWdFdQaaDFYXtuEtIsLmHWMLt7cL56HTyaMruXtzFECTKeuRtmqUUZXoNPnPwr/d
	 KQaGYrOg+zYeYy5iSS31+OXMRwlabVTP9xbWci3IP1eq8DT5h29hu5RAjlWZ2AR/jYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=dp4tLDoC;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606D60A6F70
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3606D60A6F70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=dp4tLDoC
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElanX017855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=KIrRKPvTcZl6urzMdIQpsdibkczggTBV8JarCNfPQI4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=dp4tLDoCRCeVV3kV6mG2Y6i9ChDkaJHaFI3jMIkxuYkpkzZE4S869LwFdWY09b0n2
	 oErHtyvYyeRAhVISfWiMYZCJOMwUnY9I+8jQcMwGx/NsIDY+KwgpQt2SAss33yEqkU
	 bEm3gZbajn76dE9fBaIhqOsRw77VZf+kSJSCMasJa/V9721/qQqM0i+RYKayI0u6Ht
	 IZrglr+AV6+LrhfTU5Eg987xcHjKoUX5OkOTjcZNLvprJa4Okens22DkocsYwyABjq
	 x9Nd/s6nN8kJw7ER9BNNe1d4GusSUH91z46jY5SfrhJRB9LX9NUQnHyu20HWSMDXTA
	 EF3rPT3yQAU1g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C88D62E014A; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Yichong Chen <chenyichong@uniontech.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com,
        aneesh.kumar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: cap migration extent length at EXT_INIT_MAX_LEN
Date: Thu, 19 Nov 2026 09:46:38 -0500
Message-ID: <179509948667.1938961.5251473098395248189.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910034000.3155420-1-chenyichong@uniontech.com>
References: <20260910034000.3155420-1-chenyichong@uniontech.com>
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


On Thu, 10 Sep 2026 11:40:00 +0800, Yichong Chen wrote:
> update_extent_range() keeps merging physically and logically contiguous
> blocks without limiting the accumulated range.  The maximum length of an
> initialized extent is EXT_INIT_MAX_LEN, because the MSB of the 16-bit
> ee_len field is used to mark unwritten extents.
> 
> finish_range() can therefore store a range longer than EXT_INIT_MAX_LEN
> in ee_len.  A range of 32769 blocks is stored as 0x8001, which
> ext4_ext_is_unwritten() treats as an unwritten extent and
> ext4_ext_get_actual_len() reports as 1 block, so the migrated file
> silently loses its data.
> 
> [...]

Applied, thanks!

[1/1] ext4: cap migration extent length at EXT_INIT_MAX_LEN
      commit: b0a3f2c102e8c718e03be45f831e279ba9f6b112

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
