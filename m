Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360AC21C173
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2026 04:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889809; cv=none; b=BpY+rUbHPPY0v8C/qLW+mgktUiaDyppqnzeWXGEHQPomDmnJ+N9Nj0jmQhbg6RHtxd4G5gEXRx5rHx/URgBA06xc5jzmcFonvKN6Y6m8amKilahOFILSjhX2nNjFGTXSDzO8K2WSpcPvkwLK0ojxE5thV8ZfVJ2atTpRuj8bNVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889809; c=relaxed/simple;
	bh=+c9TrG6qF/RXwVUQ4mNgi8tG1UO/SMVAweFNSnaCzXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIqoo8CXUd+iLuJ67rsEt3aITfEkLH6g8lLbtkPYtauAFUlnwL55j18CKCxVCp4urK1rbGrhFyWURKIyhYuTBjon/lvL+8IJwqGfgW6tgSMTQ1iJ22N+SdfN6QkHSBpIoLN3uv610iOEBPrvNHLhH/yKJOp6lmWszLTbyxjcPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=eMd6DlV/; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eMd6DlV/"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caed617615so3810605ad.3
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 21:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1787889807; x=1788494607; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7jq/31s+3lvVSdHJF5/gGzjaWQfMFo0wDOdnUMkxXYI=;
        b=eMd6DlV/t59r/v7Tp0v96bynXZZ41Jn8bDsIhxtpDvZ6PPzM+poka9KaPHvhzWsNDC
         Ogc8MOSHZbY1kwNYhj5UUvXOPRY+mqYahHZT0HupHycprdZW5l5vthso4AgylAssrHAs
         btgcO0abEJbqf2eUAprQnkfac+Y4TErTUOpGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787889807; x=1788494607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7jq/31s+3lvVSdHJF5/gGzjaWQfMFo0wDOdnUMkxXYI=;
        b=TZ5JF+U0TilSgWUn7+hWt+rOmxb7U8ofLoo02pQ3wZZcRmkWGpofiV3cjm6d+JcUsq
         tcXmqE1comYsrNGWbmw8V9uOTFWiKmk+IkfAMKJNHXjmesnapXYw/YuONFYMEUhFTOME
         r6DsZRx1GyhIAUE4xGAb734zzvoUWreIps/Tiu26BMOjbXohhkU4SUvpBFVcxclmnmdx
         /J8uohtuvnEFeYMANDsrWHIpt0ygYYFbjKetyTZDjFpp+yB8kU6u8kNRkw9/w89YO9lQ
         T1i8E2N5c7zNTQRLHkt8E53QF4mkrihpkLFY8cKbj714L1BKjulItwAuP2WJH0aB97ik
         NCdw==
X-Forwarded-Encrypted: i=1; AHgh+RrjUPK6We473ovV7hIg2FHxE0EI1Brz6iBRtQFYbSnmX+N/acn71PeFhC128wtOuhBA6JWear233viI@vger.kernel.org
X-Gm-Message-State: AFuF++kUf4R467IiD2J/l1bQ8hVsI6qR9q+zbsjQonjC6dh/e69VyJ7/
	xftC+XP5TUVEmX5FBXOoBlOq3a147Q1txsf3J5/9YHB+eZWHmclCziMzn71JJ1WYS3bigvEpst5
	an4s=
X-Gm-Gg: AR+sD10UI1JL7nBL17QKtQzgkHMM5U1MUHevkO8+4nwl/aumHdURu83wP1YPhUL5JmW
	VjupzSUq8GtUYJtqejVR28copOvd3EOeSWAmZnc0L8ZBmujLqxH388mWYb1qOCubXzT/zZD4sh0
	a4cwaWQwNxgkMhVgXTq4eVeUo41Rcg0QHUSFxqLzGVBa3uknuBWDTEJ1vNp33zS/i3SeGnyKtHT
	7kMcbXCb+242ExmJQ0/8dB6vZCqwQ6pcMqQDAUMwgHyGwVHHpJeNcv5h1FWHLPx034slD2jIR0c
	83lxlEvmcrclqkMVNW7+WVD6brYhalRS3KDO5EXsHPkUE5Geh0QZYKaYrpWgtUL324PpGKUDCT6
	9gwmY8iBHeyTO6PHZQNDpITxrXjL5r0cQHAyAwSBj4IhuV0hFH6SoOGkvO2uB83RoqLEOHb1CVT
	B4OEDG/ZMoiv9Ny2WjOxHxNOprv3tYBzrYUrGKkII6a/U/E4V54DcMW64EXWyduSMsmk0sKUgo6
	yrhf4z7WIHLhncbtZhv9NSvzAA=
X-Received: by 2002:a17:90b:2f0f:b0:380:540:d499 with SMTP id 98e67ed59e1d1-396d0ed0023mr8803932a91.6.1787889807324;
        Thu, 27 Aug 2026 21:03:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:ff0:ad84:24b0:9e52])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396db196903sm790271a91.0.2026.08.27.21.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 21:03:26 -0700 (PDT)
Date: Fri, 28 Aug 2026 13:03:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Jan Kara <jack@suse.cz>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sarthak Kukreti <sarthakkukreti@google.com>
Subject: Re: [PATCH] fs/ext4: fix ABBA deadlock in ext4_rmdir()
Message-ID: <apEIfeA6sftEfv3l@google.com>
References: <20260827125158.4030598-1-senozhatsky@chromium.org>
 <a5zm7znmyelavclrssrhtxcksozgkgjadefvdojpeabck7hstr@tn7yhv2dey63>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5zm7znmyelavclrssrhtxcksozgkgjadefvdojpeabck7hstr@tn7yhv2dey63>

On (26/08/27 15:41), Jan Kara wrote:
> On Thu 27-08-26 21:50:20, Sergey Senozhatsky wrote:
> > We observe the following ABBA deadlock (casefolding enabled):
> > 
> >  INFO: task jbd2/dm-13-8:447 blocked for more than 720 seconds.
> >  task:jbd2/dm-13-8    state:D stack:0     pid:447   tgid:447   ppid:2
> >  Call Trace:
> >   <TASK>
> >   __schedule+0xc2c/0xe60
> >   schedule+0x40/0xe0
> >   jbd2_journal_wait_updates+0x8f/0xf0
> >   jbd2_journal_commit_transaction+0x321/0x1850
> >   kjournald2+0xa9/0x230
> >   kthread+0x226/0x2a0
> >   ret_from_fork+0x101/0x1e0
> >   ret_from_fork_asm+0x1a/0x30
> > 
> >  INFO: task Thread-10:4161 blocked for more than 720 seconds.
> >  task:Thread-10       state:D stack:0     pid:4161  tgid:3848  ppid:540
> >  Call Trace:
> >   <TASK>
> >   __schedule+0xc2c/0xe60
> >   schedule+0x40/0xe0
> >   wait_transaction_locked+0x8c/0xd0
> >   start_this_handle+0x252/0x870
> >   jbd2__journal_start+0x120/0x280
> >   __ext4_journal_start_sb+0x11a/0x250
> >   ext4_evict_inode+0x208/0x760
> >   iput+0x222/0x5c0
> >   dput+0x293/0x690
> >   ____fput+0x145/0x2b0
> >   task_work_run+0x7a/0xb0
> >   exit_to_user_mode_loop+0xc0/0xd0
> >   do_syscall_64+0x14b/0xf10
> >   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > 
> >  NMI backtrace for cpu 0
> >  CPU: 0 UID: 1010216 PID: 4160 Comm: Thread-7
> >  RIP: 0010:d_walk+0x0/0x290
> > [..]
> >  Call Trace:
> >  <TASK>
> >   shrink_dcache_parent+0xb2/0x100
> >   d_invalidate+0x50/0x110
> >   ext4_rmdir+0x3a2/0x3d0
> >   vfs_rmdir+0x9d/0x1d0
> >   do_rmdir+0xf0/0x330
> >   __x64_sys_unlinkat+0x34/0x50
> >   do_syscall_64+0x61/0xf10
> > 
> > The problem is that ext4_rmdir() calls d_invalidate() before stopping
> > the jbd2 transaction handle.  Because d_invalidate() traverses child
> > dentries it can encounter dying or in-use dentries.  If a concurrent
> > thread executing __dentry_kill() on a child dentry invokes ext4_evict_inode(),
> > it requests a new transaction handle via ext4_journal_start(), which
> > waits for all running handles to close.  However, the thread executing
> > ext4_rmdir() still holds its active transaction handle while looping
> > in shrink_dcache_parent() waiting for the dying child dentry to complete
> > eviction.
> > 
> > Stop transaction handle in ext4_rmdir() before calling d_invalidate().
> > 
> > Fixes: b886ee3e778e ("ext4: Support case-insensitive file name lookups")
> > Co-developed-by: Sarthak Kukreti <sarthakkukreti@google.com>
> > Signed-off-by: Sarthak Kukreti <sarthakkukreti@google.com>
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> Good catch! Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks!
