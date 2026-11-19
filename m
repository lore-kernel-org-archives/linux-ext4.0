Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099668;
	b=Y8IvHtlI+TmUDYWzWOeSQLgm9XVihaFbSDIs28nK9Rx3ZGNL7YJyJSdnhfOsjkyevXCq
	 S10XxtUF1+QdT3UnfcWepymxVLDbFxIJDhzANox5xH40oOrGG827pJGkf9FGvMrezMTGK
	 FKfcxOj0jJoIfHwmGcZk3KXJS7Zr4lrdP2M4FmCLx9eF6edSUv4DpkEHULUQsXrI5cNQg
	 ZV1WXEs1hDM2UkwS3yuQ62DjHhXgsP7trlBiA3OL/SSSH0wMYnbiC5PI/jH6s04MorQRZ
	 teStSNh3/+JTz3B8i1EyvFE3AS+omrefnX6thx7tEU4W5K85dDpqBdwJ/me3Vm5cM0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099668;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=gmKS7olU8pvHBFZr1Ez2N8yveI7Ja30h8TS6V2BHOCE=;
	b=F5Mc7UlowdhNbsEeQKhrCwoyEuNgBtQi/qN1MJtxsuPHAJAWj3axdmcDA+vzNqWGVbb5
	 BBA5KiZfp0YjKVi2BaoRmBTC8+yOoUsL4pVpueCqzArWf4SffO5kE/pUR0YnBX44xqUNB
	 zr4FrG9BkL1rfaFvKvpD4leHLPtq0ykdcIfswuLQasq60CG3DBylzHF+q8DOWo7yEBq7k
	 4gzEVazdd/an34oXa1eXEWorfZCuDmqwtozUmk9R75w/lkhLMPEEw+E2kQieHiDC2wPrO
	 YwBLzCch7QcoLSK6owP9anYLxk8krLJz7VCJvscROg0C3ibtau3jk4bs6EMyZWMctdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=RtnhnpOe;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB69560A2615
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB69560A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=RtnhnpOe
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElfKY018172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099663; bh=gmKS7olU8pvHBFZr1Ez2N8yveI7Ja30h8TS6V2BHOCE=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=RtnhnpOeoNnn44NgHRV4oo3nQrhWv5X5saZXxSASiOnRxJHlvnfMWdEjX77JFVfgA
	 77hNsnxl9d/2d0tbUq6kWwEX6Z1WxCV2B9BsrCi1EaM60+ltNpbMNcx1+3+u1+yzQj
	 rsSqLBI9cTUPmkywVGPnD48HKiLcZq8ikFpkTAWmMxoDCUdYcUpO80CyhOg8Vhz8eh
	 vgke0zhGJoxcA0f8s2CXMZuRXGZok9oeU3mb2yAg1/ecURajF7za1LKS827xV7LJII
	 ywCEJWGxZ0Uj/ihGZnXi/CHMiSttiRXxEp0ULjrRhQNtlPjXmhZIjc8JXIQYx12prc
	 cZbBbz8IRAINw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 4E14A2E0190; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Matthias Goergens <matthias.goergens@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, jack@suse.cz, stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: drop extra ea_inode ref in cached-block reuse path
Date: Thu, 19 Nov 2026 09:47:13 -0500
Message-ID: <179509948677.1938961.12523889154252223783.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916071046.2182813-1-matthias.goergens@gmail.com>
References: <20260916071046.2182813-1-matthias.goergens@gmail.com>
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


On Wed, 16 Sep 2026 15:10:46 +0800, Matthias Goergens wrote:
> ext4_xattr_block_set() takes a reference on the ea_inode via
> ext4_xattr_inode_lookup_create() before it builds the new xattr block.
> The new-block path drops that reference once
> ext4_xattr_inode_inc_ref_all() has counted every entry in the block.
> When a separately built block is discarded in favour of an identical
> cached block, the cached block already counts its entries and the
> lookup reference is left unbalanced.
> 
> [...]

Applied, thanks!

[1/1] ext4: drop extra ea_inode ref in cached-block reuse path
      commit: e14029a6b72d5592bf8c031ccd29a57fd33ad1b8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
