Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418FA371045
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2026 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623534; cv=none; b=dBp3Gqlz/YEuOQBR2Dw+GCh2hdZkgWQxoK6cgyLELBuRSoTaIHle0YbNOjZASP5cyn5l75mzq4lYZITeVYjWDIVtXc3eatHXMlwMPXPk5pPh79MXwT9ZfE1hEf32HyO5nANoQDYERVrPd9/LtZUL7wQp8/ojr45K0zjT2NZ8hKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623534; c=relaxed/simple;
	bh=BnsqtumoOXnhguV2S8GG3DRqexWc/y9WKxtbbPXdd90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPL7NnvghUxiYa2704J6BT3qzFeMWMMXIwsgnMEs7q8oTsQuU/peCK4Vt+k2K8AzjAHnS5EXzrKg+9ir5d21mHlXJHPW4/j38lJQJ7E38ksurB2uCEaT+hw1FUHqEbmTT9tdPcIm3C2bOSKBhyNoP9gX0eMwVLp7F/96r9OZdI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=bVpUzeuS; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="bVpUzeuS"
Received: from trampoline.thunk.org (pool-173-48-123-50.bstnma.fios.verizon.net [173.48.123.50])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60SI5GRN028638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Jan 2026 13:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1769623517; bh=X8Ziaixd8D/jtSjuYO12nbTwQVpavQsr819JkYSrZ8Y=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=bVpUzeuSg6cT4CBZ9B79AMWHf/UQWKdh1erDHiOUwkwUw8MwWlPiRCWZ7WzyIkl8m
	 jaDLx3HMBaM9em+ehTMukgtFaZaD73bfeN9oSk9xacUTGdR24J/QtJJaRNFgywkj2i
	 3fx5PqX1otP8jknyzbYqzpbhOC7R2RmGDDTYNa1rtDxHA4ZHO7BaTz6td4B0JehawY
	 26LYwhDfeLPFnsqvza0VeWxGAhcNRkanyvMNP7FQX1XnQzZwOzutgWJFUSX/uLQNso
	 8h59SIMSatCTWs+1JH29SYUc33hkwsjQp9pv+3vRTCFQODKdjKZXU/cnVORy64Bz2P
	 ha+0+DCzG1pSw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 066332E00D7; Wed, 28 Jan 2026 13:05:16 -0500 (EST)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Baokun Li <libaokun1@huawei.com>
Subject: Re: [PATCH v3] ext4: fix dirtyclusters double decrement on fs shutdown
Date: Wed, 28 Jan 2026 13:04:58 -0500
Message-ID: <176962347640.1138505.6941853832675498828.b4-ty@mit.edu>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260113171905.118284-1-bfoster@redhat.com>
References: <20260113171905.118284-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 13 Jan 2026 12:19:05 -0500, Brian Foster wrote:
> fstests test generic/388 occasionally reproduces a warning in
> ext4_put_super() associated with the dirty clusters count:
> 
>   WARNING: CPU: 7 PID: 76064 at fs/ext4/super.c:1324 ext4_put_super+0x48c/0x590 [ext4]
> 
> Tracing the failure shows that the warning fires due to an
> s_dirtyclusters_counter value of -1. IOW, this appears to be a
> spurious decrement as opposed to some sort of leak. Further tracing
> of the dirty cluster count deltas and an LLM scan of the resulting
> output identified the cause as a double decrement in the error path
> between ext4_mb_mark_diskspace_used() and the caller
> ext4_mb_new_blocks().
> 
> [...]

Applied, thanks!

[1/1] ext4: fix dirtyclusters double decrement on fs shutdown
      commit: 94a8cea54cd935c54fa2fba70354757c0fc245e3

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
