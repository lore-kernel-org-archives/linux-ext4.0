Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AB647F2C4
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812174; cv=none; b=YtBYTA1xmnbO3vFJu1sp6HSjO19zI50DP7KRY11W5lJDwd6s51wlEKzet8v5KmNKJGKtxuf0MyANhDO55LEhCVFSYlGF3syysuiuqKU1v4ck+5aJ9agKUn5PWTIJpjMZ6ZqN5q5jU9VSKHLxFqQr6chn+yCZ/FAdIMLiCbNfy5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812174; c=relaxed/simple;
	bh=cmq0+2e5NFY5IkiCE7Fo0jHJf0ZbiaQ5PcaLSeJ/HOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NiJm2KcwPWh8lDvFJD9cHd8QKJAg/jkn/sL/R0ZUh1FCPh6aKn2snCu42kDtAVp4DKdAkLnIuFFI2XMyAWP2ZjRtWxwYAiYYEUEyX3nF+QQ4Zx/n3K0Vr8Y5YvBxrax+rGwc8YtIZ7TZStqI1OyPLlgOcZsFwtQZhiD/iw2P5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=VURXD6Ri; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="VURXD6Ri"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND8xQD017861
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812142; bh=FCT6DkltI7zY+JuJu/hlpv6Wj0H6X4qQSistSeC08+4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=VURXD6Ri55ktTzqysYivTUy/SbpWrs8ZYCVzswXZij9fPMfLehaCirWQvf8geBxGp
	 eWbkhrIAfkHV6eXXZ7/5ll7hoHIfdOkWkuSYrntrFEUpHqGQxMDo1mWsDIGlt5YyJ4
	 bR8EBSQA74du73AijLrVeR20JmlAamEvVc0xVK5wdRP8wBzqvqepAO99rOWX3KTve/
	 +8EfK4tYiv+huezbrue0p9Ssn0iXBuuWDiiBw8tRY4p742lsj3Bf4stANkfDwPrELv
	 ij+ohZtC9Z8nZnYkWDCi1CzQWO47AtEYUadKdUCU9YmjNoChAQibxFKYDLR9L9Bzwr
	 06vIauH5oxt0g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id B10732E3F17; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: jack@suse.cz, Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Subject: Re: [PATCH v6] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
Date: Thu, 23 Jul 2026 09:08:39 -0400
Message-ID: <178481171739.796182.6989186136463897889.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626054821.1729-1-aditya.ansh182@gmail.com>
References: <20260626054821.1729-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Fri, 26 Jun 2026 05:48:21 +0000, Aditya Srivastava wrote:
> Syzbot/stress-ng reported an ABBA deadlock in ext4 when exercising
> concurrent xattr workloads (using the ea_inode mount/format option).
> 
> The deadlock occurs between the running transaction and the eviction
> thread:
> - Task 1 (stress-ng): Holds a reference to a shared mbcache_entry (ce)
>   and calls ext4_xattr_inode_cache_find() -> ext4_iget() to retrieve
>   the corresponding EA inode. Since the EA inode is currently being
>   evicted, ext4_iget() blocks in __wait_on_freeing_inode() waiting for
>   eviction to complete.
> - Task 2 (eviction thread): Currently evicting the same EA inode in
>   ext4_evict_ea_inode(). It calls mb_cache_entry_wait_unused(oe) which
>   blocks waiting for Task 1 to release the reference to the mbcache_entry.
> 
> [...]

Applied, thanks!

[1/1] ext4: fix ABBA deadlock in ext4_xattr_inode_cache_find()
      commit: 03438084a7b8621fb5c762dd3d04cff5f2630fb2

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
