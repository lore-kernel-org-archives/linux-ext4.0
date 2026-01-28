Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD7371074
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623540; cv=none; b=s3G4n1jNGHZInO+h7pcqunmhk5S6PQKTshw+TX2jF04h+5PXdl5bx+nvv7dgtMeqnfJlwAGBKeiCdSU4aKKx1x2VAluMXNVEYQIVGl/zw3gQjNGANrSHxqXTtR3OA1+0mhFQwoKPVtrfE5twDpsz0Qx/oCwv81tqYbHZJW0uLOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623540; c=relaxed/simple;
	bh=YKtVJ2FlHa+ievf8/NuHncT390cDPWlSu/oGE8y00U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7fX9KDr0AGpYHWvV5wdOVsdRxRfU0MJOdH7PVwfiS8Wm/YeuBU64tSpTYKnn5I7uqRfLzphxY1/1QG1sIPDWhPcVH2ok1S54NbbuXe754TGFAlEoCifm7oiwmws5oZI2aRLC4SWLoUMlIO7NhiHD5p6gxOx9dZ9+9jPr4XFl8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=OLUG5ncp; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="OLUG5ncp"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5IFw028708
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623520; bh=5hrzRwaM60+86PUjG0i1Kz7XXLWMiZ2N+l1JrhxMpIo=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=OLUG5ncpen7Tp5e+E7OHRqteokomJI5r8cOSJkCTmojWYaUwXKN59+Hwx1wedLQgN
	 Ix21N9B8fPrY9CgqowEvRC/6p7h/3MgYlJgY4eZPjgFRRExmuPCknIb6kPX/aW8TE5
	 pbJDg4478w1lTAcyhP1lE+W6UmQuGR+OWspc7R95nbNlVda4sCMAcBPVX0GQbY4a9v
	 tDDmQXPOPvqi7etMLoyBcNiSiYdJle+GZcFX0WQ2psMFr+Tq3LGJXZqGvpejo4l2OJ
	 ork70ku5jgXOj+Wl61x9OR5vMYtZAKPfqQQ9tBDMB/yZQyFn3PNv+5OAV3MUyIGTTq
	 aOAE8eztqQ8yQ==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 1DD4D2E00E0; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ritesh Harjani <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        libaokun1@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] ext4 extent split/convert refactor and kunit tests
Date: Wed, 28 Jan 2026 13:05:06 -0500
Message-ID: <176962347641.1138505.2204022709740681511.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1769149131.git.ojaswin@linux.ibm.com>
References: <cover.1769149131.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 23 Jan 2026 11:55:31 +0530, Ojaswin Mujoo wrote:
> @Ted, I've rebased it over
> 
>    3574c322b1d0 -  ext4: use optimized mballoc scanning regardless of inode format
> 
> in your dev branch.
> 
> Changes in v4:
> - Rename EX_DATA_* -> EXT_DATA_* in kunit tests
>   to avoid build warnings on s390 arch due to redefining
>   symbols
> - In kunit tests, fix a couple places to use le32_to_cpu() when
>   accessing ex->ee_block
> 
> [...]

Applied, thanks!

[1/8] ext4: kunit tests for extent splitting and conversion
      commit: cb1e0c1d1fad5bfad90d80c74ebdb53796d8a2db
[2/8] ext4: kunit tests for higher level extent manipulation functions
      commit: 4dff18488fe22b743d6e2ee32ca4a533ea237454
[3/8] ext4: Add extent status cache support to kunit tests
      commit: 82f80e2e3b23ef7ecdef0a494f7f310a1b1702e4
[4/8] ext4: propagate flags to convert_initialized_extent()
      commit: 3fffa44b6ebf65be92a562a5063303979385a1c9
[5/8] ext4: propagate flags to ext4_convert_unwritten_extents_endio()
      commit: 6066990c99c48d8955eb4b467c11e14daa8d5ec4
[6/8] ext4: Refactor zeroout path and handle all cases
      commit: a985e07c264552d0aa7c019ca54d075414c56620
[7/8] ext4: Refactor split and convert extents
      commit: 716b9c23b86240d419a43c1f211c628ac04acb8f
[8/8] ext4: Allow zeroout when doing written to unwritten split
      commit: 4f5e8e6f012349a107531b02eed5b5ace6181449

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
