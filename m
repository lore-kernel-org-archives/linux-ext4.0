Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24118DB2A
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747752039; cv=none; b=SuW/m6Xmq1nsZQXMCA3PrwpMXqVAqc3L0zUm67AFIquZGaw+JfUQ4DF2MPUO503tIRvuMljYWR1OV0eq1kobke+IsqMdefS3HX+dx5g28MAuQIM2bWzLzfb5S+IjMyO6DFtbfgXZ9bV0NDLovgF6Kaji8g4WfJK+kqHtnhU2F1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747752039; c=relaxed/simple;
	bh=5aL7oVmO0ElrNheH5Utyl37/4pK/fmCDdkkI6So/6nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jz9yWaWeK3hDIQp0MZ3txYmXAFJJPo+NdE/PLZKmTpWcnieO7u407m3vwqgFTyvpVIwFcWReBGetY0MSQySghccGGU9RXfNAhccfRrMB6Dw5FtJhY1IvcJ4DNkf3Bmar77qHfvk6az5iUEjoe++6++e7mVVbfW/TNwGBo0SMfyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-111-173.bstnma.fios.verizon.net [173.48.111.173])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 54KEeQJZ013149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 10:40:26 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C3B342E00E5; Tue, 20 May 2025 10:40:24 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Luis Chamberlain <mcgrof@kernel.org>, kdevops@lists.linux.dev
Subject: Re: [PATCH] ext4: Fix calculation of credits for extent tree modification
Date: Tue, 20 May 2025 10:40:16 -0400
Message-ID: <174775151764.432196.8660962659258174516.b4-ty@mit.edu>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250429175535.23125-2-jack@suse.cz>
References: <20250429175535.23125-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 29 Apr 2025 19:55:36 +0200, Jan Kara wrote:
> Luis and David are reporting that after running generic/750 test for 90+
> hours on 2k ext4 filesystem, they are able to trigger a warning in
> jbd2_journal_dirty_metadata() complaining that there are not enough
> credits in the running transaction started in ext4_do_writepages().
> 
> Indeed the code in ext4_do_writepages() is racy and the extent tree can
> change between the time we compute credits necessary for extent tree
> computation and the time we actually modify the extent tree. Thus it may
> happen that the number of credits actually needed is higher. Modify
> ext4_ext_index_trans_blocks() to count with the worst case of maximum
> tree depth. This can reduce the possible number of writers that can
> operate in the system in parallel (because the credit estimates now won't
> fit in one transaction) but for reasonably sized journals this shouldn't
> really be an issue. So just go with a safe and simple fix.
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix calculation of credits for extent tree modification
      commit: 32a93f5bc9b9812fc710f43a4d8a6830f91e4988

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
