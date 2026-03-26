Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6678383C7C
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 11:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774526288; cv=none; b=WL4uqnaMOSIuOPvQPUgjIL1P8iXGWajRJ4nMpPFovhVnuJQFnSBKSWy+Jzvtz1Igcn/hdnMnYCvOY2HToAZ0dSTkGytTcQdQMi+hu6Liv+kouenfIAmT14ozKA80YngpldtFiPRUJWOSFsNhQdpI5I6V6b66wl9S0Q6qlRuOX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774526288; c=relaxed/simple;
	bh=JkgwHLmz4YoaI0qPw76529HxLFzosOj7QBQf4IR2FfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcAIEqAxYGlQrNx+wwOBGRzKVv95PvDPEh44mkgDaXIYhN7oFosZDtLb4NDhclVWx/cOaEfIC7esAQYXy1F+7FfTbKclEsXQYo8de8jnpNGCFLZ1+kUY7zbzQddaQcEhCrIDuTfr8vBFbKrYrEMRMtYq2kCTyJP4TanM04aSUhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PUHmTBm8; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PUHmTBm8"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62QBvv15020391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Mar 2026 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774526278; bh=pSWYz49nrJnQVqogjdPNPiQhjFMArTdj3LVa8bcZDBA=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=PUHmTBm8iT3WjN6+z9qpArrZQyhwFXK5K2+AfD0+0JCNT7TGhuCRLVIssa2AtQAQ1
	 c/+C3OpQb/Wh/hINAGWp+hsXP4j31/dvpzr0q+fKioFeiQkPbWX+xJUYGPDgMq8q86
	 NTzd1AhRDXC8KfD5nmrR5BzVNUxDCoG1u0thT+ACHpxJ0MQ6XAPvvbMd32E+Ox4rZ9
	 2j9QXrgdd5oFSLtGfywvDy9RKxeMe3S57yEN2QnYBzNmaq6F7JFT/sAMo6TM09alNG
	 W8Df8vkzBYcaBHSfSWT+YOhuBwlLb/dh6lgAIIQso03+mGsku/ZD82SJgUfM+x4s9c
	 VWnsKVPHRzLkw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id E7ACD2E00CF; Thu, 26 Mar 2026 07:57:56 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Gerald Yang <gerald.yang@canonical.com>
Subject: Re: [PATCH] ext4: Fix stale xarray tags after writeback
Date: Thu, 26 Mar 2026 07:57:44 -0400
Message-ID: <177452625019.1205486.7499693288701434301.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260205092223.21287-2-jack@suse.cz>
References: <20260205092223.21287-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 05 Feb 2026 10:22:24 +0100, Jan Kara wrote:
> There are cases where ext4_bio_write_page() gets called for a page which
> has no buffers to submit. This happens e.g. when the part of the file is
> actually a hole, when we cannot allocate blocks due to being called from
> jbd2, or in data=journal mode when checkpointing writes the buffers
> earlier. In these cases we just return from ext4_bio_write_page()
> however if the page didn't need redirtying, we will leave stale DIRTY
> and/or TOWRITE tags in xarray because those get cleared only in
> __folio_start_writeback(). As a result we can leave these tags set in
> mappings even after a final sync on filesystem that's getting remounted
> read-only or that's being frozen. Various assertions can then get upset
> when writeback is started on such filesystems (Gerald reported assertion
> in ext4_journal_check_start() firing).
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix stale xarray tags after writeback
      commit: bc6874ab41809f210c3e966576374d0778e144ff

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
