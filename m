Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1F92459E1
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 05:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774675887; cv=none; b=Xig3xrnO3W3DKtxJ6/Xzl5s+qk47D6QjVrnXy6ihlGtIfGGpN4RNgteW6P2A9HUFuNdVVTHozGvvLiMFgfe/zSVgswAsotJOQNZ2QTNFZStzg5brgHrz+2i4KDsk1rEC7NjSS4kn9KS7WSUxhv39ol0eWLDz6nCdfyHqOu5Ovwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774675887; c=relaxed/simple;
	bh=kS3d2CRM/V2zCQ1rYhFkDFVyfOq/xAv1HYttLPL8+NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cXFIWmWGbFxgHuCkg0h6BjTAtBh1LEaGSM+txQ2chnEE0m7nN8iNF65+IWzoUVQPtOVirrvzclN8Vn1Stc+N45StoLXl/wcdFx4t/4XlfpfuYDzFJ40hCnag79QNMiyxoiIdTCUGIRGjHHUi50+BcvKsjBKr1Qfh9ZG3AWyszi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Lt84eSkv; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Lt84eSkv"
Received: from trampoline.thunk.org (pool-173-48-121-153.bstnma.fios.verizon.net [173.48.121.153])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62S5VFlV013532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 28 Mar 2026 01:31:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774675878; bh=Uz/cqoX6DADKwB3OmZXIC+gCYepLUzkbnvAR1slNmDM=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=Lt84eSkvG4MNy7KXBRUMdB57ARue+JDnhYg15Dvdbwrrluz//iABeFMCAuvA6rvaA
	 EkP2O/q0l2N/R/LBHUmJyWTpZkCgUQc12UFPCaBBsA0f4zskPQSP21RXMZkYi/JWXn
	 VRVDiBqrSk6RlFAKz5d4fwgAxIUMtzpaJ/Fzw9VTKdleJ8U+KH8ukwehVFtJGk3FPn
	 V8FzdeRz9EEG0Izfb++6F5QOaU9T/zdsHBPPU96NzrBjr/mvKJXOhwadMih/0JEwEO
	 AlT8cV4QAScIbkbeFidJaYkbE7rdx+5PQNESI0EoWuwb4pbg/Cst9scTtbxPupa/42
	 P7GAnJJmcwgYg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F14502E00CE; Sat, 28 Mar 2026 01:31:14 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        yi1.lai@linux.intel.com, Mateusz Guzik <mjguzik@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix deadlock on inode reallocation
Date: Sat, 28 Mar 2026 01:31:05 -0400
Message-ID: <177467585138.1335526.8513595683008147724.b4-ty@b4>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320090428.24899-2-jack@suse.cz>
References: <20260320090428.24899-2-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 20 Mar 2026 10:04:29 +0100, Jan Kara wrote:
> Currently there is a race in ext4 when reallocating freed inode
> resulting in a deadlock:
> 
> Task1					Task2
> ext4_evict_inode()
>   handle = ext4_journal_start();
>   ...
>   if (IS_SYNC(inode))
>     handle->h_sync = 1;
>   ext4_free_inode()
> 					ext4_new_inode()
> 					  handle = ext4_journal_start()
> 					  finds the bit in inode bitmap
> 					    already clear
> 					  insert_inode_locked()
> 					    waits for inode to be
> 					      removed from the hash.
>   ext4_journal_stop(handle)
>     jbd2_journal_stop(handle)
>       jbd2_log_wait_commit(journal, tid);
>         - deadlocks waiting for transaction handle Task2 holds
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix deadlock on inode reallocation
      commit: 0c90eed1b95335eba4f546e6742a8e4503d79349

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
