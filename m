Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52CE371042
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623528; cv=none; b=ZxZJXGnt8jLn/ZIFN/sC1oF9yzJayV4XTugIZZ9iAGaketmJue9mPPI1ermKXHLv9LoHQRagnqsB5FesWnAIU7a+uyrqrv4xwHQUHRt5YX4g0+jXmDxBMBef6CwQAxPGE6kIk/+fM8WzFxfE8Nwg8ATF842fVKZIq6Fq0CfaONA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623528; c=relaxed/simple;
	bh=mzi/q7IpYpHbjFoz+vYChfAkMz/3XuABnRDtQsiphw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QsQ0aF6qvUGr4UWU38JSGjhPwALGXCX6olKA/HX2SOYb8rYRb3IWjyOmClqWVHWxzk3bD96zIrh+bfOihNy/sOmz4dT2uFld3QDiJYUmmUVJwyqBCX0wthEBp7H3U0hcvdGHE96Q9BbY6d5KOj6M7bhY475igPHIjTGfFMTZL7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=fn4B16YP; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="fn4B16YP"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5GvY028636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623518; bh=YH1ca8OekvLyctzdBJ9zNwDissYPtCgWP1lCYO3X2Wk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fn4B16YPNyDcMCo4YlRumyQLvj6e4sfOV5rBuwK8bKYYVFyikZJYtLRxw+0Dl3U7s
	 aCKt3LvhipeyyG0DBobjWFZt/ANCz8BmDWQvbLrZvq1DnMl/rXIZBxTYGyybCT+opC
	 OjrMVrgEMdZeWWrWgqU/Z/qN/OYcEo8z3uDtWGVlEEF3gc8tR80/HP3m7f9eEvn43O
	 Ez+AO6dItQcBSPinAsx1yDECwaWw8feMvlHiqAJBrd1HOzvQfS/WFMxeaLTa11Wjjr
	 mKO4VtNKjyTJ6hP08yEtlxbzRHvrbnJ5CA0RjHdNx2K0Ih7pUTs9Pk5T8O/tw1tyJA
	 GhBYzwsWn8yGw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 086DD2E00D9; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Donglin Peng <dolinux.peng@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        pengdonglin <pengdonglin@xiaomi.com>
Subject: Re: [PATCH] fs/ext4: Remove unnecessary zero-initialization via memset
Date: Wed, 28 Jan 2026 13:04:59 -0500
Message-ID: <176962347638.1138505.4707012923453555215.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251211123829.2777009-1-dolinux.peng@gmail.com>
References: <20251211123829.2777009-1-dolinux.peng@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 11 Dec 2025 20:38:29 +0800, Donglin Peng wrote:
> The d_path function does not require the caller to pre-zero the
> buffer.
> 
> 

Applied, thanks!

[1/1] fs/ext4: Remove unnecessary zero-initialization via memset
      commit: 26f260ce5828fc7897a70629884916301f5825d0

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
