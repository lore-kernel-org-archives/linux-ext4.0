Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=18.9.28.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099669;
	b=J7YD7/tQrDJnH8NAUDWz35ldFk08CpwLkheufkpgW45r/vEZ4fiSuO1r4Cfa6JzSjXGn
	 bYNfJOcKCvMvQARdsug2Vg35bVultwA0uEHvjxvBMpgqGUVzT+YvjZdzqCZj/c4d/g5d0
	 GbaRAk2LpcsVHDfg3Q7tnJP46f9zA613DYj9DBLI5AYWgwDe2wT1rh4Qg1hNAXimdPH+Z
	 6jNQ9/zR/SqRUEUcSLSDVwoEBG8edRZ+SBy65rLCfR/gsnPj94fZGukdWQ6iPt25ZOdLW
	 70i7CpzuVrR0sJJ4M0WDRoTeADJVuQK3kJc6sbTeVznDXmZ6u+v2/10KOI8N4FbarMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099669;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=zYN7za216DbJHEf8A5gznBIaCzXojC3mYFNtYGvF78g=;
	b=cPRksBU2BqtMRS7uujSMXZW5uY+NKcbHhw14ojRcfSqf/UoGYZrtQbW8hS48HPa7ia36
	 vyaltK6vynCL5IEtowBx4LM6cxD19bmh8jEMRTGnPH0tseRdD9y4wik6aPbokXzZrZ5vb
	 Wsm6Ht8CJe8C5KYkNjnYryBAnE15xojrV6YvgaMQLYKo+DNjNY0tytb7AyCd09jAyZ/qF
	 HBIJPhaOv8gX6VdKzj8TBsdnDNm1v+UKLLOY9nsaHpbeFZHzizXkMS5QeRFZWhmxxILM2
	 3j6LRNHl4KktXU3xTv3z09fItyt7TsE6Bg6+o/7fLkbxo/soST3sZ4GX/W7c3Grwu8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mit.edu;
	spf=pass smtp.mailfrom=mit.edu;
	dkim=pass header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=CjAFSr0Y;
	arc=none smtp.remote-ip=18.9.28.11
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1621606A335
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 14:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1621606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.a=rsa-sha256 header.s=outgoing header.b=CjAFSr0Y
Received: from trampoline.thunk.org (pool-173-48-114-214.bstnma.fios.verizon.net [173.48.114.214])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6AJElc0B018020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Nov 2026 09:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1795099661; bh=zYN7za216DbJHEf8A5gznBIaCzXojC3mYFNtYGvF78g=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=CjAFSr0YElx+cfrE9aQWUYyIYuVK6cwsrR35OSFjQ6Bn9ajYQLI91bVgY0bL2sUYh
	 a4vvVl0id6UameecdD3ICCmDFd+u7m9GZ2ymW59zKH9iCU+GE9g+JyevpQjTwBW3/V
	 DYQM/4Yubyxmf0Kr4zHU/mG7VPOTgwkfJX9rygmvUzDmffaEnygjNpOOAj3YRM+LvG
	 oopLdC9VJ7eyhZ5Y9xp+ZwByNUK444YOIRolY4wBZzUKyIRt5Bp8UNtpbs2askbRTc
	 Dzt4H+2PyOy59wLwWcy4AJQzF7StHWTXd110C+u653rit8UmccT5XKZ0YaMV+e1OXd
	 AQMIhaCRNIPtA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 0BF452E015D; Thu, 19 Nov 2026 09:47:33 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.com>, guolingxing <guolingxing@tju.edu.cn>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] jbd2: check return value of blkdev_issue_flush()
Date: Thu, 19 Nov 2026 09:46:54 -0500
Message-ID: <179509948704.1938961.14114880981168213072.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013014028.1152277-1-guolingxing@tju.edu.cn>
References: <20261013014028.1152277-1-guolingxing@tju.edu.cn>
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


On Tue, 13 Oct 2026 01:40:25 +0000, guolingxing wrote:
> Check the return value of blkdev_issue_flush() in three JBD2 paths
> where it was ignored, and abort the journal on failure. This prevents
> journal tail updates or successful transaction completion from
> proceeding without the required cache flush succeeding.
> 
> Changes since v1:
> - 1/3: collected Reviewed-by from Jan Kara.
> - 2/3: reuse the existing err variable instead of declaring a new
>   one that shadows it, per review from Jan Kara.
> - 3/3: use flush_err to avoid shadowing err, preserve any earlier
>   commit-record error, and reuse the existing abort handling,
>   as suggested by Jan Kara.
> 
> [...]

Applied, thanks!

[1/3] jbd2: check return value of blkdev_issue_flush() when checkpointing
      commit: 74dead67b289a4e8543b03ebacf42279f0e8cfad
[2/3] jbd2: check return value of blkdev_issue_flush() when committing
      commit: 0be51944deaa666d93fc4b67960b495ca09a4721
[3/3] jbd2: check return value of blkdev_issue_flush() for async commits
      commit: b96c1535348e378847b53c5149f5b5f260ce459a

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
