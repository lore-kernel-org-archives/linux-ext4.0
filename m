Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9EA28DB49
	for <linux-ext4@vger.kernel.org>; Thu,  4 Jun 2026 14:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584367; cv=none; b=qjY2U5KwmW/STfTISBgkEMkbdTCK6di8Dx1GwxwfmgmyATz7I920ErJfTLTAru1qo/XXTGiUEbY7ZhuiYzn5pzujGbMsRfYO/KSr0mot0qXIXlEc8JR3OAfUafXmKV9gTLR1GrXwWKO1uKbO4zGORP6QgJUZzKQRf2asOifuUCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584367; c=relaxed/simple;
	bh=sKDG1+0bP+0stoqmsGoqt3Bj3VvOLMlftH9EsZJGYto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uvCdThpYvOq9RFAxMfoHUW4Dc90BDHoHRRr6FTlEBtfZQGogZu380f4ACw1T2rvtYrBX5dHD30pFVKvEPMIeb/UYwFySO7KBtWLHQPjnJA2+v7bYjukACVXb5+jn/EUhk5Rvv8oDoay6VJeasc/25WwS5+w9vmXFXiBPtWV74qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dD0Wy/lD; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dD0Wy/lD"
Received: from trampoline.thunk.org (pool-173-48-113-247.bstnma.fios.verizon.net [173.48.113.247])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 654Ejv33012382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 4 Jun 2026 10:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1780584359; bh=KZQDeRpXYnIRd615Dbd3Px9hZLAqRNMpZTVHcldihJQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=dD0Wy/lDb5f5uZUa8ZdBnYb4pfiybARFoxb2zm/B7w1W77N+9LcI6ZuAvo/HjhN2D
	 QcJBtjEue5/JdfUGcKfesP3Zzaf/y0ZTdhzwuca6+JS1ipcO5zTsNnQb4XQktqzIJg
	 zq5Ru3sVBWbZ+fUKq4YQhuDUEzAFQ0MrN0LbcD/nZr2hHANtzU2WZlmw985JHhanSr
	 GoLSIxl5/Vi89ffyNRuPOxaAnMbmFSUvbv4KGBoazcFNZFsxU5uNz1lwNIyJKYiKbm
	 0rl6YKjzEQQlj2XOGeE4us/K8ZFHleFJjtOiQEeOCIvBxrD/5VkHQKkQZP9VhckaNu
	 c8s33jx6YaKEg==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 690172E00D0; Thu, 04 Jun 2026 10:45:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.com, Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Subject: Re: [PATCH] jbd2: check for aborted handle in jbd2_journal_dirty_metadata()
Date: Thu,  4 Jun 2026 10:45:49 -0400
Message-ID: <178058433999.388727.14788289165393698815.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260507050605.50081-1-kartikey406@gmail.com>
References: <20260507050605.50081-1-kartikey406@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 07 May 2026 10:36:05 +0530, Deepanshu Kartikey wrote:
> jbd2_journal_dirty_metadata() unconditionally dereferences
> handle->h_transaction at function entry to obtain the journal pointer:
> 
> 	transaction_t *transaction = handle->h_transaction;
> 	journal_t *journal = transaction->t_journal;
> 
> However, h_transaction may legitimately be NULL for an aborted handle.
> The is_handle_aborted() helper in include/linux/jbd2.h explicitly
> treats !h_transaction as one of the aborted states:
> 
> [...]

Applied, thanks!

[1/1] jbd2: check for aborted handle in jbd2_journal_dirty_metadata()
      commit: 8fc197cf366beaabaeb46575c8cf46fe5076b943

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
