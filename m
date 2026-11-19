Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099705;
	b=P1Y4AgOGY2IJtVlLTtZePzQ1B+ei5acJY2RvI1Q2zLWejSBagg69pGXv3HoiHUoGFlJh
	 w1LCw8qi++Vuwq2NAlymRWi1oECB5piY+HgNr1qV+aYpaigUM0Ve6+oE7fDKuXi0XqNPa
	 HF74Ozm0zm6h5NRutSFYb5HpXCKGZFysh/NLdoIiv5pz7JdxOCaIE7zSdb24DFHZUYXIh
	 sSoPxLjw03/RYX5KZXCheOEpNrCON2d6MivgTuTTK2Go5wuh3/PsKzzIpXsSOPcEQcfyW
	 2aAdFbLnBfiN1FCM0qkWXoORWC+K6WG1zU27DvhErbOUChIn49Tp7Gt4FfhW1F3jXBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099705;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=PdgqcayYya5rXePX9Z6kM606UQkgP0DFGzTOr7i42Tc=;
	b=G+GaE5DlS1tE163j6dgvHQbkD83yuQgkPmPIyBVDjiGfx73oYEnmNWg3N0F8jM5V4kHe
	 CYkJsUBipJS1slaGSY4qqAQKiTRtJwbyLCIt4m0OE9fT4NCyow/3zjMWEj5YFqhOAqbFL
	 Fy8AjkEskLNKi6X4bU5H1vwp+18urBc5oANAqng/EEttmjCSR0ujRZPM9e9tdi8a8Sc6V
	 MQNRUmhNPBsMdSYnz9tc2ZykhoGXU2TMn1oaSm9IozJDKHq3nAeRwC6Qqu5opHrRYnVK8
	 zrE3qDClemICcm320xaVtP9er1C2l803HxSeqFKfOifx6/oWA1K3BimyegsLoum6TIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HOn60FSA;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D76606FF5F
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:48:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40D76606FF5F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=HOn60FSA
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElgwe018260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099666; bh=PdgqcayYya5rXePX9Z6kM606UQkgP0DFGzTOr7i42Tc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=HOn60FSAh+3q5BwreMfhcFezOa40wblRA4itk2j4eszb6cQsS0+dgpQzNecwI+kvJ
	 m9nzRNXwd5hrvbJjDaDZbB+ewL8bUcJ2fAzdId8uz80QyKk+lCGJFoRtdKR43Rsikd
	 x8BSdmpCp7Vqy0KsiFR+u6iFn8yuYcKrGwRNKobxiLDjWcU0rHxPz5XC12pqwiZ5n9
	 IVBs2mCCgA09GK59OekeMyxFj9yx0iQkJyVEa8TTayESdvhLa5FfQ660cI10LCi2wl
	 LDK+rqCqfQ1J/+tIkmQQ+M6cH0aD+6rhhgc/SdhWak4jBiIO5MC8FBc3HBm7rBnLVd
	 1IW0/Sb5NAdWA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 703F12E019A; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>,
        Taotao Chen <chentaotao@didiglobal.com>,
        Christian Brauner <brauner@kernel.org>,
        Tal Zussman <tz2294@columbia.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: complete dropbehind writeback in task context
Date: Thu, 19 Nov 2026 09:47:23 -0500
Message-ID: <179509948703.1938961.3735999249476113497.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
References: <20261012-ext4-dontcache-complete-in-task-v1-1-6ac801557041@columbia.edu>
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


On Mon, 12 Oct 2026 14:04:37 -0400, Tal Zussman wrote:
> ext4_end_bio() ends writeback directly from bio completion, which
> usually runs in interrupt context, unless the io_end has unwritten
> extents to convert and is completed from ext4's workqueue.
> folio_end_dropbehind() only invalidates the folios of an RWF_DONTCACHE
> write when it runs in task context, and silently skips them otherwise.
> So on ext4, dontcache writes that overwrite blocks that are already
> written, or that allocate blocks without unwritten extents, leave their
> folios in the page cache. Dropping them was best effort so far, as there
> was no way to get task context from bio completion.
> 
> [...]

Applied, thanks!

[1/1] ext4: complete dropbehind writeback in task context
      commit: 5e835ae2e426b09699e05b6d49ef7fd157ee9dad

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
