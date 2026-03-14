Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143CD4F881
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773490942; cv=none; b=NoGp54utPoiytYtiOGnC+TIsQGjwOBFv9ppkUATpoK/SYVCW+0x1cSNlqu8fOPeBhqrWfX6wJOE/zKfpC2T2Y5zX8OnWsDkX/kNh8cVWinvvPtB4HCRV5vbWTQLEjbJF5OMpIsDVz0fH1Cs/oyzETn4PPNxaKS3LKkTgmYiIqA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773490942; c=relaxed/simple;
	bh=3nszJU0fhMmeS2s7cQq92WNoGX3yvkhiasIRRu74KAo=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=cJWfVETmW5GwYvkhUGE/jLHZ5NJVSlZ619s+SBmsIMTgel1MUN2TJXEOYkXDym+6yox+qGMQbqxfXXiSyLHFurUNgi8RnVgAQhZbhzAUYigwMtVJ0SUGOn1lfmWkm3WNw5/5IliY5cNrmhyTlTO9LoxDe9NE6UTyEMX2jZoEJsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QM5pqE1h; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QM5pqE1h"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c70f91776fcso1288978a12.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773490940; x=1774095740; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bf3fNlAAf501mOZKCUyojYaKm5vtm31Tsb5GCuqg+L4=;
        b=QM5pqE1h37E9YaGNlwwNOgFbUGIyU86cAnfSUPr01ClAota4Lpwo6E4HdTJfWHe9FQ
         OVoIUNBqLCDmSy2ssRLsJWs5FOW9C+/ZeccYVp3LXXyDID9Aivh4c9yQA2DocBvBV7go
         ML1zyD9mlPsMshTuP2Y+OZaMveXbSVv+Hmwc5cpkypBro6nFTcf6FZ4UBSof4cte9bor
         FujDJ/KXVROh9y7gEj5gT79i3KuT6qipI2PgXaFcT0sg/EvNUn8jeAGCYNa7paqWQ2qn
         WzJVEUmkUlJK+w9fbddA5Rkx58HRS1o/ZxnNUebHPbwceuJMOJAbsZaGxT3yNFnga/L+
         JSPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773490940; x=1774095740;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bf3fNlAAf501mOZKCUyojYaKm5vtm31Tsb5GCuqg+L4=;
        b=ZZEjqiPQ7z41G4L1o8tpFWfE4ZduAk/mBSrug3Z87bX7OlrAJn6qEF9KkkBexvQiz+
         qYvn9lSI5pFlFuXVU9FsMkzVkcnYTyNkpYrmzP+G/226XTeZSXxPqR80EA609YooCroN
         w8rlsB3aKbXzBEbnKgEAshvYLzSd9KNzd1E29Wc8HYXfwfueNveNYdgu27JKnaJwvXBQ
         /8EDPaQIQV3YM7l5UFLlqcj/ChQmVRlNfra9TQROcant//pq8iss1keAc5By1KFOYPfB
         QIVlVEerZYktWF7c2pPYh/UejRbPkQ9QeC2jY9AG6+EcF85S7/7jI1H6yjVI2wgwrk+A
         4sLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqiqDWSx3ObfJ5bJiLIqEeqNa6PbVoqoryXy42hi9wLUmZFkJ3TmdN+iO1C+TcuN6y+axeXlMjbL61@vger.kernel.org
X-Gm-Message-State: AOJu0YzYbL5De1pJx9Uyg9Bf6hu/d+tcQutqS+lcU5wa4V+edsNB274/
	+GJyROu5bk/iirAEp6np6BMXyh5d9DoBu8+QBdk7csRhZ9+9wiLKHpjl
X-Gm-Gg: ATEYQzy1tJhmiOqR2Z4ZE+OFwesm5Gci2jZS6CaI//HrPmineODxhpSmp7P4vpMMd8J
	qJBvim5kQxEN02RE+lXUXSrkb7YVEWl9ex7ZYmvE9t7UjqasLe02wM50kLmXBCBbmGQ09itwuor
	YKsXUpIQ4QpwjxkmgbX8z4cnpMo7nntn87R+4LOsUzcB46QEmOh5EIdYIpkcSVfmLtTExuZoAvi
	Tc1WfLbe4MEp+i5imLPA6niCRCZjQPjgVi4loEkO0CtdVKQQLgOcYGxJU7TEXl8gabiqtW+G4in
	UxTRlbN6Q+DORhOo5rjcK/3I4je9MXr1Y8suTZxk1jL0w69DG4jlYl7IFKSNMcJBpzLwDi8CQxY
	vr5Nan+SLTM6TvmhYjgo6UL6YnuWagLIl113BPP8KKE9ASg+bT6EhLGXSqdFr2l7I6VqYGvvm+F
	FeKTzTZJSmLSa4Qt0UXaAQUQ==
X-Received: by 2002:a17:902:da83:b0:2ae:4d8f:6b65 with SMTP id d9443c01a7336-2aecaaf3728mr65799185ad.28.1773490940316;
        Sat, 14 Mar 2026 05:22:20 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56ccb1sm52263225ad.12.2026.03.14.05.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:22:19 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v3 2/5] ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
In-Reply-To: <20260314074903.1314851-3-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 17:51:45 +0530
Message-ID: <ikaytxd2.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com> <20260314074903.1314851-3-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's warning as follows when do ext4 kunit test:
> WARNING: kunit_try_catch/15923 still has locks held!
> 7.0.0-rc3-next-20260309-00028-g73f965a1bbb1-dirty #281 Tainted: G            E    N
> 1 lock held by kunit_try_catch/15923:
>  #0: ffff888139f860e0 (&type->s_umount_key#70/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x172/0xa90
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x180/0x1b0
>  debug_check_no_locks_held+0xc8/0xd0
>  do_exit+0x1502/0x2b20
>  kthread+0x3a9/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
>
> As sget() will return 'sb' which holds 's->s_umount' lock. However,
> "extents-test" miss unlock this lock.
> So unlock 's->s_umount' in the end of extents_kunit_init().
>

Agreed.

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index e3d23e3cda87..3d4663d99eb1 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -310,6 +310,8 @@ static int extents_kunit_init(struct kunit *test)
>  	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
>  	kunit_activate_static_stub(test, ext4_issue_zeroout,
>  				   ext4_issue_zeroout_stub);
> +	up_write(&sb->s_umount);
> +
>  	return 0;
>  }
>  
> -- 
> 2.34.1
