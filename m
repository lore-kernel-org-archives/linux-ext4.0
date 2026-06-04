Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1242BEC34
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2026 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584373; cv=none; b=DAXiwi5t9j5pgsP8IVldOR9nxIIvNbFMhrpwM4SluXZiaT/RMiRnSetzDmdjWSDQ1BfPGJLhEB0Tm4YxTE1Te/mLWIzk9hzezV/beVImSwn1QGtQ3dXGNX1gnS848PNFZGL6Dzw1CGxFC7tmsJ563HxVfzdeHS6q1/1O+5EvONM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584373; c=relaxed/simple;
	bh=3cJVdoDFclYr5f8RF8tPhTQdKInMMFnu9ezfG6aU4L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGEfDWOn7VJ1ApUkWA+0J32WQ+roYC2xvFyPCSPd+jzki6JoIy6xk674bwbL6kbhz87zqjA4mAJUGkFn/khurvnRMNFC1q2EcAeonNN2FlgI10g5Cv+9y2rapT9aejgBTeXb3semxAWyZMxTIDOPQuMHIpRo30qKbwiDlJVa2h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=P7ENRvhy; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="P7ENRvhy"
Received: from trampoline.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654EjvGs012397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780584359; bh=amwdSVW9BKx7EIZ8tN+Lm3PeIeIHWviy8ryXdNOGsPc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=P7ENRvhyNVitN9H/7bisDJ+XYJ2NPeGyglRGt4um+QK2bVaccE4uNuyOdJgtL6JvY
	 hhPqXQQcjxEttrsCIxcD48Sh7BAWo0iZ6pBUtPBPvCEU7rKBrwhadP6Cai1UJO8cgi
	 ITkPk0LqjDRFpKx3pHhzMTSe1LxZtptINTEsP1m/PZtm2aysi6E2kesExCIz4wwi9L
	 cgjFyBNnx+qYZp0DMcBFJvuX04UdzB1pX2QNId0Yg/1rkw+6bbYpFsM+GykvGjLj52
	 sQ/NBftGFNpCAiTnssCl9Q7m9UniCItGS1KGuE8P9NCUxFzLP5lunPY+0nw9mV1oYz
	 2/nrWFSDAPtqw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 72CB32E00D4; Thu, 04 Jun 2026 10:45:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.com>, Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Junrui Luo <moonafterrain@outlook.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuhao Jiang <danisjiang@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
Date: Thu,  4 Jun 2026 10:45:52 -0400
Message-ID: <178058434002.388727.8849033608952624453.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
References: <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 13 May 2026 17:28:40 +0800, Junrui Luo wrote:
> jbd2_journal_initialize_fast_commit() validates journal capacity by
> checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
> Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
> j_last the subtraction wraps to a large value, bypassing the bounds
> check.
> 
> The resulting underflow corrupts j_last, j_fc_first, and j_free,
> leading to journal abort.
> 
> [...]

Applied, thanks!

[1/1] jbd2: fix integer underflow in jbd2_journal_initialize_fast_commit()
      commit: 289a2ca0c9b7eae74f93fc213b0b971669b8683d

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
