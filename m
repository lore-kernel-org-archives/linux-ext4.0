Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B753B3DDDB6
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775834341; cv=none; b=okuNf6ATOmhkpeKD1CAeEVgBqhjVq3tdA36EUCNEQvrhX52N8DqeT3Hrk0HvYpyN8HJJcOya4TCngiIFvGZg9neI3yN9JBVNGdMNt3RMusmDgMMCEs89zKz/ofYJfQx2/n9Q5Bsejc2FJkGWDyHsNu5sw2kdtT1XDZUj50hUu24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775834341; c=relaxed/simple;
	bh=WEGxlVWHNQ7hEJOpYbIxC5MVcUjKdg856aQXE2v/9wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SE++ugO03uTUxv3zKE4Dm58mXrT+DBGpAsSHJVAz3F7XJkd/Q0A1YRVB50efTmBlQ8du8vRiztYHT9XdkPryxGSjtH9wQzpBe/tCCly0BoSO891+M2D3/xS47ukb3Bu5Y0a2w4KTex7x37bO8gOF0f5mOPKV40I/QrvK0WMtyGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=nGTnVQ+4; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="nGTnVQ+4"
Received: from trampoline.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63AFImxd015767
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 11:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775834329; bh=MOCndwwi8cBdObLsZAhsx3VJATlcQu8hFvQtHvO8iPo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=nGTnVQ+4hKeHOw7ce4yM8zPFL61ktxpgsaqRI38pJmAmpqRR8S2/4AiGJCoCYdyYO
	 ltuSdHeR+uMQSkW4+D6HOnvGX39bzoYf3CncFAGY/Ml2GLl0sgqk0aqgpUXn+YaEwv
	 w1aXL/5lTtpJjzp2Y2ClUFhewVpjUCjiDwg5bPzfxEW+FTcIUMUa9zDBbsDXRPmNRv
	 l54pER9tkFIdPr+hsdadSOmtfoImWK6d/HX199pkr/+2uKciEtIqA2WBd1l232CIGF
	 W4G5IJYy4hum+HCex0UggQm5VzGXhJ04/Bm/W2YvWalOnfFUz/XOAO9ZNkCGAbADsO
	 c4YLGirxeT/kQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E92032E00D9; Fri, 10 Apr 2026 11:18:47 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: adilger.kernel@dilger.ca, Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: remove tl argument from ext4_fc_replay_{add,del}_range
Date: Fri, 10 Apr 2026 11:18:32 -0400
Message-ID: <177583430852.2758959.16498510496906809489.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260121063805.19863-1-guoqing.jiang@linux.dev>
References: <20260121063805.19863-1-guoqing.jiang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 21 Jan 2026 14:38:05 +0800, Guoqing Jiang wrote:
> Since commit a7ba36bc94f2 ("ext4: fix fast commit alignment issues"),
> both ext4_fc_replay_add_range and ext4_fc_replay_del_range get
> ex based on 'val' instead of 'tl'.

Applied, thanks!

[1/1] ext4: remove tl argument from ext4_fc_replay_{add,del}_range
      commit: 2f17d1993b01960579761284e9a0da533a7a82fa

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
