Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3F4EEBA
	for <linux-ext4@vger.kernel.org>; Wed,  2 Jul 2025 02:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751421665; cv=none; b=vGYnYeuR7HF62KD2NDW7bGSNSZBNh5NfsAAq3ipSY6b8PXYJmKJ5fbHPnArhVNQ87nm1RluKadGEIeBh9GUMP58+qS5ZMnsDd0RlSzSHYOJ5Tnvz5H+2w7qCXJp1Ub0aBppubJUF7vsxPC0q369Px7lO0CUli0pPxvvhXIG1iLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751421665; c=relaxed/simple;
	bh=ovNdiRHNOo+y6XRkVqbQjkEVvxiK41P/0+0PXaFxkOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iN5eJH2B99b17rK65Yb7wUQ3HE9JzjpSIi5UU1iVgjBnnKEg6qkHLQaSUd7ejymu1tg/1mq5HSRx8Y1VKKAz4cAJpJQ12RBK7kXyz9+6HpSIFccEaEvZMXRKwN+/+iyy88X4whZHKBWLByeDoUApyTMln9mM9YE8BfdWvcFAW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-108-26-156-121.bstnma.fios.verizon.net [108.26.156.121])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 56220o08003347
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 1 Jul 2025 22:00:51 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 938DD2E00D5; Tue, 01 Jul 2025 22:00:50 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Samuel Smith <satlug@net153.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] e2scrub: honor fstrim setting in e2scrub.conf
Date: Tue,  1 Jul 2025 22:00:47 -0400
Message-ID: <175142164312.30601.4341172187954644546.b4-ty@mit.edu>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250628051415.3015410-1-satlug@net153.net>
References: <20250628051415.3015410-1-satlug@net153.net>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Sat, 28 Jun 2025 00:14:15 -0500, Samuel Smith wrote:
> The systemd service unconditionally passes -t to e2scrub, forcing
> fstrim to run after every scrub regardless of the fstrim setting
> in /etc/e2scrub.conf. Removing the hardcoded flag will allow users to
> control the behavior via the configuration file.
> 
> 

Applied, thanks!

[1/1] e2scrub: honor fstrim setting in e2scrub.conf
      commit: 1b11e079a6189a49d7a13c01c13d222c8537cc1e

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
