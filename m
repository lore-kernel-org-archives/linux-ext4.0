Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F153274670
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 02:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773975586; cv=none; b=keEy4nDUWepEz9RABw8kAvGLCv3k5zXA+RyAVuf3R/H2mFs+jqgX0SZ0s8F0XWQXXErLfej8BxYU737Zv+qM0HqZ8Rh6sCvmE1nbMfjrn/Pv5AUPzGFrgpp0ZZKrczS8aGsEwJ9uTKgVGvSfpCy+8ErKNdvFQhNmaUVkWoZbdT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773975586; c=relaxed/simple;
	bh=IGZT/b2Wb5kjS/Sd+XkL28nXnaB9P5G3WNDz4tdsboc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=p4hLcUbwmQlYv+FV1Y9wqhyK4p3DXjTrI7j+u4F7WafXFr/JHwkIeQcEUmKAR1kBElov488AvwL8u2+5a2k2Qshrf3WnAmSE5Hdtt00sjZWCA06c2U3J5jOv5FltQaPe73qFMoYXHo5o84+306Jc8jCJwgDOetmegGBbCuryip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V6jd6bWs; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6jd6bWs"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35b98def50bso982551a91.0
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 19:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773975585; x=1774580385; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UGX89m0PohXrr797EE31OQ2fn8215Se8Vp7bchpg7Ng=;
        b=V6jd6bWs5C0dPh8RZWl13SCDGqn34DMzeOeyLW95gj8BiUbMCiMpLBZPVQ7qKltfq6
         Si4Le3aVNR2UXcq5/z6I/lyFGtlsmVI2Z3bkmgkTqW2rh4eFb58mK5o/9jv4OoOkv+HO
         y0mlAtjT35K3BiYvx3u+r11PK0Tih+DjzoY2sT6/3OrJKsMjA9BSHHbduOoVYAVKwvAa
         eSXZi8IN6LKJv2H5K3kugwEhgKmgdttJYTduighpxtE6LAKyLf5j5z3tgEn3a69oaY1i
         GbiilxmVbc+lTLd6LOzgeXm1y69dY1v1cY3oj5x4DpgFOz3KSbqj6lYLIu29YrAyE5ch
         cXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773975585; x=1774580385;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGX89m0PohXrr797EE31OQ2fn8215Se8Vp7bchpg7Ng=;
        b=h2gMuSUe2AzHqccCsbPVQRxarYWTyz9SADRprgoRvyamwEqI+Dsq+6IcURRA6k82KZ
         sSD2FOPdxgEG7bFTM8kgtA9iZxyx0WrmBWRcfT8i7qY7J+K4FL0IJT8wHvAWlswCccG7
         Q8L90SSHXnn6ijz58vmi7KnG/yJX/1qJNFV1kX6VthVfrDvWbcVodm5SlGIK62ucwSYN
         dbaJjJKUH79OKWmbiPDn7c2eNfwfeAlRKb5LLWCEc6DJGSaMOMo5KCAORQ1/Y+kJNFtk
         24tEnyHrlopqEmnoCtHZkGryVgYSv8/zWQZ/xULukADUlD6Mfnaz/CK/s+IU8KbC4//C
         wWvA==
X-Forwarded-Encrypted: i=1; AJvYcCXKX2EnLRq+BN7PbxeKZGiY1ZMBabQuLZxOeKpPr7q7NyQ56ZcuruA060ipGmjEMQ7k+Tl+QVHaPf7L@vger.kernel.org
X-Gm-Message-State: AOJu0YyAWzCKLTDTj9xRvNo+hFPZWDGz8pvsujH+vWlrZ69SyX41bqz6
	+3efnT55Ulrs8vhxIVcwrwJJ7SWf2nv3TCjyYdcbvDrEA920Vb4rTujA
X-Gm-Gg: ATEYQzzBvKGnyOr/pVdxAwDncBFizPTiTC80ma6pyxARyrm6G+C8v5pvE2LbvJA+Lhl
	MD0MIGGXKpgX45N/V/VePKir0vANY24mY+YDI9dBjLflYXyC2HOrb+1mpvTVZFJvqlvaZlW6kNR
	whH0dwcBa1BFtiZCuKMzeuvpo4nV57MsZ+KxUuaMxJALKOQDkOKS5psWPRmHcw5hIkYDoT32eBF
	YjfbsS/dsni33QDx7p4ujMTanO5cwyXqYh/fJHoPvos/u13OFl8aa9IkrW//9EGx50q+CQ4vMds
	lIhyMKT+BoScrzIAs85CG9y1tscBfW/HBWIEepN6axxCO+sbduMUu5FzUpVrhXsWke197HjyNcb
	E37+3DzgZamUroUSbWZ1h11hBE+SXiFpLPy/gVkMJ7VMV0TB9dIGhhNU95YMrRCc5CtV29e7Okv
	pZdpHu0QbSQEfRS4x9wnuvEg==
X-Received: by 2002:a17:90b:3b81:b0:359:9073:c368 with SMTP id 98e67ed59e1d1-35bd2d1fe24mr1070777a91.28.1773975584954;
        Thu, 19 Mar 2026 19:59:44 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc610c535sm3976321a91.16.2026.03.19.19.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 19:59:44 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-ext4@vger.kernel.org, jack@suse.cz
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>, Jiayuan Chen <jiayuan.chen@linux.dev>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Ritesh Harjani <riteshh@linux.ibm.com>, Ye Bin <yebin10@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: fix use-after-free in update_super_work when racing with umount
In-Reply-To: <20260319120336.157873-1-jiayuan.chen@linux.dev>
Date: Fri, 20 Mar 2026 08:23:16 +0530
Message-ID: <jyv7xlcz.ritesh.list@gmail.com>
References: <20260319120336.157873-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Jiayuan Chen <jiayuan.chen@linux.dev> writes:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> Commit b98535d09179 ("ext4: fix bug_on in start_this_handle during umount
> filesystem") moved ext4_unregister_sysfs() before flushing s_sb_upd_work
> to prevent new error work from being queued via /proc/fs/ext4/xx/mb_groups
> reads during unmount. However, this introduced a use-after-free because
> update_super_work calls ext4_notify_error_sysfs() -> sysfs_notify() which
> accesses the kobject's kernfs_node after it has been freed by kobject_del()
> in ext4_unregister_sysfs():
>
>   update_super_work                ext4_put_super
>   -----------------                --------------
>                                    ext4_unregister_sysfs(sb)
>                                      kobject_del(&sbi->s_kobj)
>                                        __kobject_del()
>                                          sysfs_remove_dir()
>                                            kobj->sd = NULL
>                                          sysfs_put(sd)
>                                            kernfs_put()  // RCU free
>   ext4_notify_error_sysfs(sbi)
>     sysfs_notify(&sbi->s_kobj)
>       kn = kobj->sd              // stale pointer
>       kernfs_get(kn)             // UAF on freed kernfs_node
>                                    ext4_journal_destroy()
>                                      flush_work(&sbi->s_sb_upd_work)

Yes, the race between kobject_del() and sysfs_notify() -> kernfs_get()
is real.

and sysfs_remove_dir() explicitely says:
	 * In general, kobject owner is responsible for ensuring removal
	 * doesn't race with other operations and sysfs doesn't provide any
	 * protection

Hence this patch which adds a new mutex lock to prevent the above race,
looks good to me. So please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
