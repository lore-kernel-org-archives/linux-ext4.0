Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC23BE179
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 08:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536356; cv=none; b=tOwZMC8cMK7vzDTnhQrB2Eyg22GcHaIdvFA6uQt5l1FdiNoBnJQhpaiYkwyhJrYHL6cdV4ADh4bhB0NOyJ3M7GWlyIEd464q2YA93vt8pFCSu0E4+Vr68nrjgvhGEoO6PtMQlcJySko9KyM+8DOTjjYcw8GVnkR/FF9T8yHAgDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536356; c=relaxed/simple;
	bh=mowMhqZl9f3Psko2c6CBPzUMf5vlZmu/Y0eiCkIJ6GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uotMPV5nIdv9fTqvjkYMQ/fzhglm4MjLEjPN2F5ej8DQnmDLyZs9EEygN+5VzPWmGJvJqXJ5HTtb0b53jnlyryDz6nGW2Gh6u395VWPZIlB5AGkzAv1ZU5rVefxaJqmXMBIgt/JJtk+ouiKw+VGhTgo6N7rv7OjAN9V/eSQszMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=fi0xk1gs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="fi0xk1gs"
Received: from trampoline.thunk.org (pool-173-48-119-87.bstnma.fios.verizon.net [173.48.119.87])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6998uYW3014200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 9 Oct 2026 04:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1791536196; bh=LyUbgCC/yi72ozRqZOkfIA4QmpfRosNQetgJQYdx9HQ=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=fi0xk1gsDCKOoIa3K2I5s4mLBvuWuxkVtoN2zjFRdZGRIvO42OImF8g6p2z93pPYf
	 /TLm3EnpibrcMrDdO6SkLYRgBJJv5Tr6jRZgbghfYJGTeOpJPrL/FkFqX3yZZ9ttb0
	 ttlxwW0jW/MFcSD8Hh7fDsKtDMJlA1XrqqfD2LC+gnYRBMuIAgBLOJQd0P41BHCQim
	 /Ty2x1/DHXQlilNTjKWmsR9KM4aQXMMKDHRjJpBxN6NUWnN1u8gXKNmHp2g0rWXNHa
	 0l5fQQuGZmIMWhAfrSiII2HZ5TE9eZOPlad90BN5SyQ1fkR6WVdCK8RbSIEmaF9sZf
	 WDuqsjxWXMLPA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 61D062E0148; Fri, 09 Oct 2026 04:56:31 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sarthak Kukreti <sarthakkukreti@google.com>
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
Date: Fri,  9 Oct 2026 04:56:23 -0400
Message-ID: <179153611730.860602.7475827136438153442.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260827125158.4030598-1-senozhatsky@chromium.org>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 27 Aug 2026 21:50:20 +0900, Sergey Senozhatsky wrote:
> We observe the following ABBA deadlock (casefolding enabled):
> 
>  INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
>  task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
>  Call Trace:
>   <TASK>
>   __schedule+0xc2c/0xe60
>   schedule+0x40/0xe0
>   jbd2_journal_wait_updates+0x8f/0xf0
>   jbd2_journal_commit_transaction+0x321/0x1850
>   kjournald2+0xa9/0x230
>   kthread+0x226/0x2a0
>   ret_from_fork+0x101/0x1e0
>   ret_from_fork_asm+0x1a/0x30
> 
> [...]

Applied, thanks!

[1/1] fs/ext4: fix ABBA deadlock in ext4_rmdir()
      commit: 19e16597f9baf1b5719a3a6c710486446f6808fd

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
