Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4904BC02C
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812178; cv=none; b=c7nUf/sq5OzIsc0XMgohVJjzSkp63Y9bxoK/cP9aUKVl+dSOhk5fGvCRJZ/SUVNs7lY4OOo9RlJMWmNZ1bKI+nPdgHsIzNNpq+FQuTaNePerybH5KFpwtRii+7Y4NhF+N6vHcsIbdEQybd5aEwSFLbtVowY9Hx7RxtWkDNJL8gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812178; c=relaxed/simple;
	bh=snpDzAn6tabgZHBo5JbSsNRnTOpNW8tXLRoU3Jg7uC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iVtiOt1CdvNwUPmHm+UBD6jzdB/sBmnBzi023/1qiiqE7BU6cUq8yNWwxDbbDDVVKj1qhjB4eBTPhZTch8JSauBy/bnxgto0N/4fajCrLKlMpvJwRmHKUZz+lQR5XP4jJ1scTcY3TTpm3zdkJlTc40Ve34M4FxxQMdNcoESC3zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=oLo+oWNe; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="oLo+oWNe"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND932m017946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812145; bh=0jo1So2aAnwPlJacq2jqgXTKD2SM6ms669yA2GCvizg=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=oLo+oWNe00T/QGFpjNlT74qrgWD1fHA1J3TcFocPHZ8E4DN2FjBhfqaao/1EKv+UC
	 pu028nfNRu/6Ym91htJ1UWE9BXt0wsZwj88LS9Ll1AN1xR9ZeJ5OAoIslgZh9wLT67
	 azfNWIG+LuNuqkycqOO1a0IvmK8MjLwMkfNfvk5IiIq27fHS8xh2Pd6F0sLBxA5uLM
	 AhV6cpsldJmTPBG8isAsmckbNr31+FAz2fKiJdctCGXUOkd9dBjLYdT17HOsZA9lFE
	 MVfjejpZBwg8+6wtUBtD0s1MOhiJKpbhaXhDa+pe09ujDrY6P3A46zWhqAj5oHeNgd
	 NPP1t9eXBADnA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id D34442E3F21; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Xiang Mei <xmei5@asu.edu>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH ext4 v4] ext4: fix out-of-bounds read in ext4_read_inline_dir()
Date: Thu, 23 Jul 2026 09:08:49 -0400
Message-ID: <178481171729.796182.15100587696186879447.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260615190519.946736-1-xmei5@asu.edu>
References: <20260615190519.946736-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 15 Jun 2026 12:05:19 -0700, Xiang Mei wrote:
> ext4_read_inline_dir() can read a dirent header past the end of its inline
> buffer, triggering a slab-out-of-bounds read during getdents64():
> 
>   BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
>   Read of size 2 at addr ffff88800f3dd23c by task exploit/148
>    ...
>    __ext4_check_dir_entry
>    ext4_read_inline_dir
>    iterate_dir
> 
> [...]

Applied, thanks!

[1/1] ext4: fix out-of-bounds read in ext4_read_inline_dir()
      commit: 9333cc809f0a89e001b814155a6cb8903a6274df

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
