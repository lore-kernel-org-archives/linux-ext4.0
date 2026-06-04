Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03502D8DC3
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584394; cv=none; b=rONDacFsjOqbrOBrxKrk7FUSZ/GFoYVE0LIA2gI22kWnfxQilyclAxB3R1sd8jpjoyK0WcEfwlfV8AzXukp+bbzsj1gZ31DvzI6p2yjoiXYlvdMq/MbsmdkkdsKTByhe8Hqa83sqkY/vAAJ51NHiNYWnY8WG0vvw8htj0E1USqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584394; c=relaxed/simple;
	bh=sfj0rwf45NZ0cO09N6LvU7b2imtiyNSQGtiQh01tHRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfareMf+uo6JLXPN8JZSXswQcbaqj81N62sz21w/WwSdJeOfmzNwOiv55pzPRD4HfIwK+XREu9OHNVXkb1CvYNGiIgIiiMKynKhFF8XEPIJzG2coQIkWOY3btGAggKsvniwH1tbS2EQxOM7yfWPDi/n+WhBRFjjHvJlovr41nZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=DNAQGMVf; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="DNAQGMVf"
Received: from trampoline.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654EjvtT012383
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780584362; bh=ksPKn9v/jXS5ag6bI0zGSn2YZLTnryCOsOXcRItYBRk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=DNAQGMVfssnRfFk8chzghK74wUxAEknLsz+x8JeqTmAxjajX21zToGvnB/wsDgQXM
	 dOoROMhFxLQh35Cc9GTLFv/6xQdtADGBkJuHTTKjHczOpadX9p9JM0PzFph6fpcyMx
	 gyBS+HF/dYYDvDsmcVYfQQMITAU7HYCMUrAqIOfpDK+szm+e327yxRR38DMc+Kxbeo
	 FbeZ65GPzr+l1e/KDZuPI5ocFI6tpCj39D+Xb+hHrTNmwnLz/ubJTHMllziZwdq3sy
	 4cunF0J35gQRiS1ia40TdGllUH57lb/t626sSqNmRIIE6hGzsqCsZKbE9KHYk+H1kp
	 dSh50RqjZgTOA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 668FE2E00CF; Thu, 04 Jun 2026 10:45:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, edward062254@gmail.com,
        visitorckw@gmail.com, david.laight.linux@gmail.com
Subject: Re: [PATCH v6 0/2] ext4: add hash Kunit tests and optimize str2hashbuf
Date: Thu,  4 Jun 2026 10:45:48 -0400
Message-ID: <178058434006.388727.7362735536327292318.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
References: <20260531080019.3794809-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sun, 31 May 2026 16:00:17 +0800, Guan-Chun Wu wrote:
> This series adds Kunit tests for fs/ext4/hash.c and refactors
> the str2hashbuf_{signed,unsigned}() helpers.
> 
> Patch 1 adds test coverage for ext4fs_dirhash(), including the main
> hash variants and relevant edge cases.
> 
> Patch 2 simplifies the str2hashbuf helper implementation by processing
> input in 4-byte chunks and removing function-pointer dispatch. This also
> reduces overhead and shows roughly 2x improvement on longer inputs in
> local testing.
> 
> [...]

Applied, thanks!

[1/2] ext4: add Kunit coverage for directory hash computation
      commit: 3147cac6c1929f26b4687993b8c7af5b7b34496d
[2/2] ext4: improve str2hashbuf by processing 4-byte chunks and removing function pointers
      commit: 3ca1d19c1971ac4f25478eafb741e726bf2d5954

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
