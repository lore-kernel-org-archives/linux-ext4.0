Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dmxiDsyC"
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ECB10F3
	for <linux-ext4@vger.kernel.org>; Thu,  7 Dec 2023 08:06:17 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-130-174.bstnma.fios.verizon.net [173.48.130.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 3B7G5wrw030812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 7 Dec 2023 11:05:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1701965160; bh=zFtaW5LH8EX4QLGGXG1PoIgJhq1PLNfJuYpXNiR/Ko8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type;
	b=dmxiDsyCSlvGASmtgND511HwO6I91M4rQbevfKYZK4MT9uR6AUYWWaFy0uny442+q
	 rbCZ3nBxuTCF5kQ0I4bdnBIToyslu+lz/9nCbV+T8Ser5G7xrqhkaGLiwByQo67o5w
	 VSElsYLeVNCBWWFN1s39HE7o9J+x7q9R3p2kmzm5/9tbMVARbJTQF76m8+A25ORp+z
	 u5eKu2aeSox+tBc3NDSEvjsF2L8qUdm1imWKjCnHwkmUGyFQG/ZLpNHQUHkpBxjuwc
	 R+qJREbSZXnrVsTbzyI+DX9C7Hul3J/5zSCxo/pbfsuHrODq+kQc2tBA8zsWamzb4C
	 LKFilviR1rvTg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 5CC8F15C057D; Thu,  7 Dec 2023 11:05:58 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Li Dongyang <dongyangli@ddn.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger@dilger.ca, lczerner@redhat.com
Subject: Re: [PATCH] tune2fs: fall back to old get/set fs label on error
Date: Thu,  7 Dec 2023 11:05:55 -0500
Message-Id: <170196512708.16594.3926731283312351722.b4-ty@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20230520104329.2402182-1-dongyangli@ddn.com>
References: <20230520104329.2402182-1-dongyangli@ddn.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 20 May 2023 20:43:29 +1000, Li Dongyang wrote:
> If we fail to get/open the mount point for get/set
> fs label ioctl, just fall back to old method and
> silence the error messages.
> 
> 

Applied, thanks!

[1/1] tune2fs: fall back to old get/set fs label on error
      commit: 569074c65d7b3a2022e53f0d6abd405dbe5320a3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
