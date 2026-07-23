Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6F44C77BB
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2026 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812180; cv=none; b=c29kBAsZfzImqT1KfQSA9t/ZLUmCu0r0tgL2aQ7pHnxapqxBVgjWKFQSxHOkoXSqUukx/oiGOZnPolI3vFKaXSYST2Jtp/07Hkv9rc23AAz+vdOibnMeb4B+kx8+OFUjQ7tAMJmTcf4hPY3ZwxK8zZM35WKKfGfWlHS184bFVtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812180; c=relaxed/simple;
	bh=KVFcNkS7dD9oB98/R+4BDHzFQtxV9A6hLTgMquZJDlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHbOJdXudltz3PAyi3od4NdRmKdjPc53Bg8qFoD3qZaGwLD7hGgOAI09zEQz9G0jq+0OsBU2cWJBE0QV7Sr9kfMr8sUU1yvgd6LrqGOTCCHYTiSiH2o26dbYPBPgOyamRM/E/ElsEEztwWOYiBBLkMZZFkWwFBFNxlni0DkKwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=fail smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=INvxhTCZ; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="INvxhTCZ"
Received: from trampoline.thunk.org (pool-108-26-156-127.bstnma.fios.verizon.net [108.26.156.127])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66ND946C017954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 09:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784812146; bh=QDmCrS8xsLj+0BbmDDGGrNDa5h8hcCLDiFKcrIAWncU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=INvxhTCZI9MdLKTa1Hb4OgMNyokEjhb5ZfidJgeKgc9fFuyyjtJShCxWsapfTSZVm
	 guXELerplWESKoKX+Zsg5NtkBpCU9EfZiO40XZTpEXOQ1+1WSqgP802HgaQg2iDsbc
	 WPb3l+1pR5x7l9x4OoNI9Jh4FGGzbesKmRj/+KHgXmCasr+6We5YK7UrTs7GoVMwj2
	 kmjynYlIO3wrcCmnd5Vt2fJ6Bd9tdDuMibp8Z0j3jbzieIKvkQYDYfbe1HnOHvs5h6
	 bo1ayhj8M/UR8Rttn2a2GWI7CofeXMDJAHHc89OEsqSn6c6sGftXmo3G00ldg2sTgl
	 TU5VkiNdpuqvA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id D6E3D2E3F22; Thu, 23 Jul 2026 09:08:59 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, Yao Kai <yaokai34@huawei.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, chengzhihao1@huawei.com,
        liuyongqiang13@huawei.com,
        syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] ext4: validate readdir offset before accessing dirent
Date: Thu, 23 Jul 2026 09:08:50 -0400
Message-ID: <178481171743.796182.460536597002637440.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706041313.708346-1-yaokai34@huawei.com>
References: <20260706041313.708346-1-yaokai34@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Mon, 06 Jul 2026 12:13:13 +0800, Yao Kai wrote:
> A corrupted directory can trigger the following KASAN report when
> ext4_readdir() resumes from an invalid position:
> 
>   BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
>   Read of size 2 at addr ffff88810a646000 by task repro_linear/509
> 
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x53/0x70
>    print_report+0xd0/0x630
>    kasan_report+0xce/0x100
>    __ext4_check_dir_entry+0x5ef/0x820
>    ext4_readdir+0xcde/0x2b70
>    iterate_dir+0x1a1/0x520
>    __x64_sys_getdents64+0x12b/0x220
>    do_syscall_64+0xf9/0x540
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
> 
> [...]

Applied, thanks!

[1/1] ext4: validate readdir offset before accessing dirent
      commit: bc4b7b0414c33b2c8898eb04386df0d21a13dad8

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>
