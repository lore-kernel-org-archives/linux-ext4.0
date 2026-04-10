Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8783DDDD1
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834344; cv=none; b=DBSuekT3mzo5ivz7RkPsO0zILVB4k6q9yzxaQPdjyk3n9sDyR1dqLMA9u3mWrOr6e127GGsfAUCrST4XNhaeCLSPu2Aq+y3rJwzNLWFpxBtS68ATlTx2RITkN5G2YRAsea/ibVfyBy0Xw0wXUZXxpiaF4YG8fIeZrmXBh2Pme7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834344; c=relaxed/simple;
	bh=ERODTwilelxJIMsfoBwEi3hONhCrefQhwbYmdObt90I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bznHRGNy2LSPD+ZiV0hKAc4r18l1fHaD9HskFlk6Ba/JQ7JB/ABoV348euTKTrZbyKwmMQEGOzLVHEHEvSzPQ2qS6zbenMZ1ii13D47EuM/ZfXPOMvmzmFcxJQXnqpOjC9z+T9jMnR9dgrvbIBIG/c/u81hyvlMM4SHkqDserLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=SEKAY/zL; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="SEKAY/zL"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFInQt015812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834331; bh=TmxqsR7bXEX6eSNWtOSW69K/bZwwTg7+AAg4oQDjk1U=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=SEKAY/zL1mpEVAk2rCW4vfzs5tZYOzyDVzjgVjS1QrOTF9nH+HePGxrDLTK1Fyi5E
	 7s+KmGhA4/0MWqrdAol44lmCEF/L7X05kmwYuZA+m/2SNLHHeRVp+V/PSc7L61DzLF
	 5UambJvAqMPOoTJf/Jr/xvK8/hRWzOM734FCpCXFinhO/egdXcMO4k+hC8EzBrPCNv
	 ySkSv75Apn6hhynyobXx9B5xZbu/1zGyBBxQQdi7tV4M2WySMD3TRw+EujCp9iIoig
	 yQie7A831GM6CZH52R/FUMhK+XxkFjb9kVwi6WcY76gLJpmqjQwdIokK1CQ9Qu5YHK
	 7bvzEN/SAnEVw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 003ED2E00DD; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Li Chen <me@linux.beauty>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused i_fc_wait
Date: Fri, 10 Apr 2026 11:18:36 -0400
Message-ID: <177583430851.2758959.10551476999007204633.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260120121941.144192-1-me@linux.beauty>
References: <20260120121941.144192-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 20 Jan 2026 20:19:41 +0800, Li Chen wrote:
> i_fc_wait is only initialized in ext4_fc_init_inode() and never used for
> waiting or wakeups. Drop it.

Applied, thanks!

[1/1] ext4: remove unused i_fc_wait
      commit: eb10607628acd1408a02e49b545e6421bb7a6ea2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
