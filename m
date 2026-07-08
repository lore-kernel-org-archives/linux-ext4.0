Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727654C9563
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535802; cv=none; b=s1MZlrwy0t3eemcdwqLJ8/ZnoUs+GQL+WoyKvxSsIsG2kmplksBcFkq/62rKryOOC6fTCHH/5ICV/W21acPAeoRfchL8DlI/r6Ru6GtSiP4UtpmOWiKPu8rEwRREZlGZFdV8Zj1SaBzD6/Nb3lC15Vr7xXX0bMjHi5q/mt+F/Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535802; c=relaxed/simple;
	bh=NZHFr2MOLmhMjkgR2/YPepqybQyNYGqfxQtnpDBOW0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NTjkaugB47H5m3HrCWjTYVV0sAQUkwbtk9Bn3kY5lkDYEc0DGUIbdy/Cnu2yTmiuuRE1JkvjiCdlMY7l7KIzc1hylCvOH80GW6xXGD4M/lTdBPLzUa0/jwjT1oMIogzyeCNCmixo8xh8YHcL76kVZZWRzlkM4BqmQkfYK7RkCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=oFr7D6pn; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="oFr7D6pn"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e7632b193so61605485a.2
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783535799; x=1784140599; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HQUQLqO2Mk8JcZRKdWc9LApUtZaqCBfghfuCA1j/MN0=;
        b=oFr7D6pnMqzMhUsytJSHmF1PRPWgunnSidmEcic8E8ebvfG9XPw5NlWIiYuBUBNlBX
         DXDjzNNpGrNBTBCeYVXUWc+TFHMw9wtMgxI1fEsAlWERWLcNygyZYskVTypa+6v8OnKt
         oHZ2m+mL98lUZT7Abq7HkM8nufplLPXUUxHEhEJeHBJT0iqqdCIU/+URPyxGRkOrD4bw
         dq3fknmjpMpSzwIcSZCpczCfF7y/8/qdL0q7rCS+o+4aB28QhpEJbPf/FuminoJLl1Zk
         s0hY4beQ9TWXti+j/Yxyh2fKxnmIKrCKfV/Cpjd25aKYNIZC7+8wWBcprr8WfUMh26Ll
         rHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783535799; x=1784140599;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HQUQLqO2Mk8JcZRKdWc9LApUtZaqCBfghfuCA1j/MN0=;
        b=rgQFFlyxnMyHKPFXx+5wW+jF6ftlHlf6z5r5cWbja26xYoSL4VQ6dKVqYdIr0JkMTk
         mUQfHDq3XCyAKAW8RPS4+21TbVve9ourgIv6Jp/pQ1sM6SvFqnBSj6xxxtGub9dhI8bj
         K8yU561/CQhnojJZTWqM1syFLnI7a66QW0eozsDobMRikeYpup8U1vhc5rIKv8RSrWmn
         RH0sNUcVKShlak3/Z2v2knMWIyDJEL1k2cJqMKZBKDtEJaf1nxQTTxUjUANtAB0SPxua
         1ofiHIEDNFNNbH//0x5VoV9EZCKV2bSECQ8XyV6iNnoHbAa2NP9sawLmAQcwBHNm66mp
         uXWw==
X-Gm-Message-State: AOJu0YyMaJVLk/MejR/0z9/f9HomltUTqkz21WBLhWaO9B1Ey3D7IQq3
	Xjv1lXLRAyPIeCdWje/sxHx9nvd/WIZ/Horjznr7XNXonaVmQmBePxxxPqwsSvRAk9M=
X-Gm-Gg: AfdE7ckhEXoV0SAsR8sxrw7cFYjNpJSEmbRR1KUBg5xTfbHP8b2Un6VCvSybR2PvIVd
	KNiQazo6c+BOho3ndFhDNb759tniNQydZ8H4FMxSGTD6ToXUMRbEFR3uc1/gLZ3/akmXQ+8V+Ew
	RfDFQLrCdaHsigb50P/8JV8P9bEzqVTv1+KlVDAHAHKWMcj7pRjMISe52Z5wB0Fwo5GhuqqZxOe
	mmf2Sd8DzKjR+PGZHRAVHm5D0VIxQItHS9a1owUej22Yt9klDBbR++gIU5yxLVvCe5vpAyiHmdn
	REWGGexJGaUB9fZc7wqJM17/qUDNewvpk0MpwYkOxTh9wENXPqRDVa5zzpLE0K8zcENSRxyPlQs
	FfHLAEPgrUiCNUhand3cfAXscGbPFjAJn2RIJYtRqQPfGLUKdc/n7mzfgs9LAzGfi6gl2y8o/kE
	tq37xxbu3g5cI=
X-Received: by 2002:a05:620a:4049:b0:90d:c28d:9666 with SMTP id af79cd13be357-92ecf5f5107mr379796585a.30.1783535799119;
        Wed, 08 Jul 2026 11:36:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90b800fasm1446082185a.6.2026.07.08.11.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:36:38 -0700 (PDT)
Date: Wed, 8 Jul 2026 14:36:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michael Hicklen <michael.s.hicklen@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu, vbabka@suse.cz
Subject: Re: kernel NULL pointer dereference in drain_obj_stock during ext4
 e4defrag
Message-ID: <ak6Yr-BHnRIr_LoE@cmpxchg.org>
References: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>

Hello Michael,

On Tue, Jul 07, 2026 at 06:51:14PM -0500, Michael Hicklen wrote:
> Kernel: 7.1.2-arch3-1
> Arch: x86_64
> Hardware: MSI MS-7C95 / PRO B550M-VC WIFI
> CPU: AMD (kvm_amd loaded)
> 
> Workload:
> 
> 4 concurrent e4defrag processes operating on 4 separate ext4
> filesystems on 4 separate HDDs.
> 
> The crash happens during memory reclaim while ext4_move_extents() is running.
> 
> First oops:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000676
> #PF: supervisor read access in kernel mode
> 
> RIP: drain_obj_stock+0x175/0x310

Thanks for the report. The trace and register state suggests that we
have the stock pointing to a dead objcg. Through this mess of
container_of(), you basically have to read the lines in reverse:

  drain_obj_stock()
    mod_objcg_mlstate(old = stock->cached_objcg, stock->cached_pgdat, ...)
      rcu_read_lock()
      memcg = obj_cgroup_memcg(old)          // objcg->memcg: stale value
      lruvec = mem_cgroup_lruvec(memcg, pgdat)  // memcg->nodeinfo[nid]: stale value
      mod_memcg_lruvec_state(lruvec, ...)
        pn = container_of(lruvec, ...)
        memcg = pn->memcg                     // freed pn, first 8 bytes now contain 6
        pn = memcg->nodeinfo[pgdat->node_id]  // <<< faults: 6 + 0x670 = 0x676

Michael, do you have the full dmesg available from this machine? The
oops you included already include taint flags for previous crashes and
warnings.

There is an interleaved Code: block (twice) that disassembles to what
looks like an obj_cgroup_get() encountering a percpu_count_ptr of 0,
which further suggests use-after-free of the objcg.
