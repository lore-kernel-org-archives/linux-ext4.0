Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099672;
	b=ckfbOb12aMbIbfMw9C0UtdHWGzlfiudM0DT1g2JGaU14TkkKvZcoRerhtY/A0JfQjnT6
	 VKGae0/tOvpFpt4WFLu4/qfhPq89lzwClKT164Pu1eVRM3eH9KAAmw0y9FBP5E8xuyPe0
	 pCmztLPaIvz7ftp/QiIcfW5o1ssggBNVmjI0+nV20yrPlkIVhHr/jwfBv2QNxQkwXa40j
	 KSLEXvLANZKMW9EdftydZnWvdjqiY46kSqkFMVYDhbk4dIReJTyT4SAM1TsENEIpYW3/l
	 L87W4JPlmVfuKsiZKFJo8OfudbHMi3Kidbx286+FesV1O9CCimPOsgSMNmhOd4Fo9+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099672;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=LErsLJ2xD/OM4nw6QsbLleaIymGiQiBZUamWToR6ZjQ=;
	b=fgoA5KiILNHyy9tOX9pGsck23FUEJXlB+D0G+cXb408DAQkXkq1g+OTCbWSyn3yvsQAb
	 0LLDwQI7vI95vL1ELnm7f0LheO6nkNE5ZViI1WvdS0PWSV/mYIMqYkcubsdEDE4F9OkZ1
	 Q431hQSlyn1qsfrOMzTx1emI32Kkm6yi0rBOv3qnH2JFHY5JBli3f4b6Dvc50shkW06rf
	 tXL3hSbNVIkERnyGZcJ9xtckfSEKQy+lN7433sBm1X5zFH8ICIdJZV5vMVOmlHPjAcHWe
	 v/Y7dXQIS1C0fEY7A0JVZiovdLc8Z+lEIhApEuXWp3qmR8cTsRPNJRh4hcAIYsHQEPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TeyXvchA;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D4D60A3832
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07D4D60A3832
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=TeyXvchA
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElaSg017856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099658; bh=LErsLJ2xD/OM4nw6QsbLleaIymGiQiBZUamWToR6ZjQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=TeyXvchAPYaaODOePpMH5AbnOTIOqGgf1ScYt3IPOXQlxf6JMuzHX4odAiAUWTdmT
	 22uCaE7Ed/0ow2tvFd0fvuC+PYSC8Lw+hhmNppyxYG6UrkXy6bIegzF+D3IF0HPVrY
	 EqHG8ycmuA4zglmmIkZJWji1f5wbSHTIWT8GnTL34CNEK6cLZeWhjcU6vgr4WAPBNH
	 xnvWjrH980oe/qT9ZiPXWbkzz/Aig/1Ganr+uUMIZFlc4hRUq6INWX6BSP7cJHGTId
	 iqQizT9OGUDqlg0Vpalge49pmU5e3RmHcdOI9C0umF4YkLMbYZEKc7DicieoVz/2bh
	 cF3Hq7twbGiQQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id C50BB2E0149; Thu, 19 Nov 2026 09:47:32 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgoettsche@seltendoof.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>
Subject: Re: [PATCH] jbd2: set JBD2_LOADED under j_state_lock
Date: Thu, 19 Nov 2026 09:46:37 -0500
Message-ID: <179509948688.1938961.5335688737682588805.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
References: <20260928202159.2463182-1-cgoettsche@seltendoof.de>
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


On Mon, 28 Sep 2026 22:21:59 +0200, Christian Göttsche wrote:
> j_flags is protected by j_state_lock, with only quick racy checks done
> without it.  jbd2_journal_load() however sets JBD2_LOADED with a plain
> read-modify-write after journal_reset() has already started kjournald2,
> which tests and may update j_flags under the lock.  KCSAN reports this
> while mounting the root file system:
> 
>   BUG: KCSAN: data-race in jbd2_journal_load / kjournald2
> 
> [...]

Applied, thanks!

[1/1] jbd2: set JBD2_LOADED under j_state_lock
      commit: 92a6d43e632d0005aca582aeb80d9419e6c37d19

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
