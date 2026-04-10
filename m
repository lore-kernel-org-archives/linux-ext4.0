Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6323DB652
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834340; cv=none; b=d6Z0a/co1AkkDLT4gDwbV6ud5/0TJUa4+OO5c/2tnovXaVwoeTO+T+CwjQeYQcxRUMkecCCoHDSswYUWLWZSxsPhPE6MrjAWJci1vjQ7i5MeK5AbSWO56zRUwGNzF/FICVe9CRk3DCm4X1Frb06g6K9vvo1xzmwvfjfdKXe8cDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834340; c=relaxed/simple;
	bh=dL7vwgfPNwBYMIV8T9K96L/NzR1Vk762TZ5RQelz2ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iw1DxCrsV65P7Sdnit5poOpm58uTj2BwWG1VSBonv/hkeKg3x6QXujr6uL0EDtyR3fTtze2pLqEew6/24NiO05JVve58TxKU8Z9WBmeBOT30Umj0RaOITQF3AfBRDNCAgp1JVpijm1Zi426/mX9dGhNafNgqojnsYXTd6POkpJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Ad4m0N0u; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Ad4m0N0u"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFIoil015834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834332; bh=T3UD7vN4xZLfVzrYjrUiXSTKkNdy02+chYzncXZxnMU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Ad4m0N0uIU3G6rrxSL2ze1Yk/g1HlXEFuXYBbA3x2Vr/bdlqeDwdpYbwmVYHrT+J5
	 93t6cAnWSxCmghS+779Pv9Qj7j7AtghGsWh+uW3wsQ1ICq9sPU7U+lPqFzS6L7eiwu
	 7jcl+u/SMYkG+UEeX8YD4x+o6fYzXBVV9ub5RrrdEpGry3NaKBff2tNzf7yAWhl0XJ
	 OaZpnFjoaqce5Zfd09tE+GX1AXgxdCNNC/FPAVG+BxEkBnUhc7Jdufcrj7KGy1aZje
	 3uByqyV//HHIy8gt4RMFYj/fd/jepbUxxw2KsSrh9mlTbDsAFPJ5HDiue+UCMLyiAM
	 kVQpm8TYEZc0A==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 061DE2E00DF; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        NeilBrown <neilb@ownmail.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
Date: Fri, 10 Apr 2026 11:18:38 -0400
Message-ID: <177583430872.2758959.13958536214376230716.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320000838.3797494-2-neilb@ownmail.net>
References: <20260320000838.3797494-2-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 20 Mar 2026 11:03:16 +1100, NeilBrown wrote:
> __ext4_add_entry() is not given a dentry - just inodes and name.
> This will help the next patch which simplifies __ex4_link().

Applied, thanks!

[1/3] ext4: split __ext4_add_entry() out of ext4_add_entry()
      commit: 2879374604b72bd43b346777fa05d3ac6dea9c45
[2/3] ext4: add ext4_fc_eligible()
      commit: 0f5f14f334c85efd80503489f8c7cba1dd64bd51
[3/3] ext4: move dcache manipulation out of __ext4_link()
      commit: 52b4fea162dd384792d0dec7f817e4ba5d8d4c9b

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
