Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA194E5343
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473564; cv=none; b=YYmZfwdHZrOpeKvS4NqOQ09dFqQ+cdKoJ7VOwNq8kja80JAsct5hnDzYGnvBbE1+N/FRc2kqtiiE+sSIaetFGiZddoXPx4CQsLaAawdXUlEeqJ0eVuw6+ltwXyvr1MfZ+IVFyb3d7H60on3UI/hdP6CCkUyz6uxJJNOONKnf6+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473564; c=relaxed/simple;
	bh=rvifOe/OGTKBV4rqvu3+7UQ1jGwI/PocPzyPp7Vh4es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJbAv3lq2NSom67IJ8UViny0uZ3R+mPByMSzs6hRgmTFq3Qm7rs6W+uJ0SJeEVs2NIlJbYlnmun5iGTC4rCZgCd6jNUzr1lHuOnOqH9TPQx72lD0qWb7aCI+i9lB0ttBwypUgpSRls1BnmAGcj8Xm9tZTLAk563z4JH/r1ZI5rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=ovy0futa; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="ovy0futa"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 698FWUwt005786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 8 Oct 2026 11:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791473555; bh=clQmTn8ejY4yugnnp9b4DQP2RT8dKZR0akbLytrgrK8=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=ovy0futajP0MpeAXQ2EybFjJNrz2QFa3ttrlchh22QM4hPFw70zEmR3Ww2i06TtZ0
	 Wx4KLgvsUMxuud6K/o5fVR5G9G26/UdY9JV7Aiawu9APjhopehtl2ijU84VCZTyYd8
	 iP/JPP6Jezl6YA3E4nxl1sfrKLPKN25M9vHVr+wp58JEJcm60xmH71W+hbFSoapcdF
	 fsB1R9ARhyDlUnsOB5YERXTJxVeZ6Z5lxl0cQZPMRFh2wSQQiVWZceoFIYV46MaaXQ
	 q7v0NRB+040TLchfgS8rSBCREZhc+Z4rO7x1F2d0sld3aAW6YdZ7WwkmcOisMSiodm
	 4zEGwABIaGtMg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id B2B412E00B9; Thu, 08 Oct 2026 11:32:30 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: name the ext4 dev branch
Date: Thu,  8 Oct 2026 11:32:17 -0400
Message-ID: <179147352556.849445.9771596497832212800.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923101749.3505886-1-matthias.goergens@gmail.com>
References: <20260923101749.3505886-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Wed, 23 Sep 2026 18:17:49 +0800, Matthias Goergens wrote:
> The ext4 T: entry names the repository without a branch, so tools that
> default to the repository's HEAD select master, which still points at a
> merge from October 2020 (96485e446260).  Development happens on dev,
> which is also the branch linux-next merges.  Name it.
> 
> The Sashiko review bot, for one, falls back to HEAD this way and has
> been reviewing ext4 patches against that tree.  Its review of an EA
> inode refcount fix reported a Critical double decrement and an
> undefined function after applying the patch to that stale baseline;
> neither holds on dev.
> 
> [...]

Applied, thanks!

[1/1] MAINTAINERS: name the ext4 dev branch
      commit: 4b1d04693e5ef388d8c6110bc93ee0d0681f9711

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
