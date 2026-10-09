Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1412F1FDE
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 02:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791514551; cv=none; b=hCiFTq+700G3SMr3FSJpjSVbpqPBABWZCEJ4KGh5pPNqBZxnKIcIbaK8Gqb/IXGHBGbAtYcDXdXKsw5Jq9zUMXrqlpwjW7gzaO4+oDsJo0Y2YEI9CNwnMUl3h82VKr2LOSTh+qD3QLnOdqeLmPF3VK36nyMqgI9kATn0N/7Utv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791514551; c=relaxed/simple;
	bh=s/7cQJj6dkZmxCwXUVkGruBW6UVsJCpPoQ8BpXkWk4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jKTwwVmcNEWpEn5DfvsMP3uHiLzaukOi5vv3j2Irheb5f8a5+i6dQ3mPQ68cVQfLAZqTAYC1EpvGXqTiiSd9jJVbn6yuP3HglEYR7XHyJi51MyuOnTkjp0nkeGPvNLOHlXQlgu9mqJet1N82DDE/Bk2Eyfl4lRbJurywPCvJC5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qk21cMtU; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qk21cMtU"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2dd76b1361dso38346535ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 08 Oct 2026 19:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791514549; x=1792119349; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Ct3a3ES+gpFhXoGvhN0/KPCQwhxUgb4QuLzs3cj7zE=;
        b=qk21cMtUy/3kxvuJwCvIk3EnlGJdQW7q5+IgFS2uG2IrhAiZ28ULf1N+lMiL55BMX/
         cZFlnNGZWJZsnvCoX96ZAN6j+3wfeUmmD0vRd3eQetTdJayhBlRswBSUGfRq9jzVT8K2
         2qHbW3kA3R/CNVyrkx1/93Hx7LHhjOUFZ5Uw7W0//WaujudHJEdxvv9+Jl2JNQK32/d+
         z54O+yz8J+R9O6hkGIIPTUiZwHKJ88yEMjzb83sljqvwnFkoe0F/7bc0hTwmPLYEOuo3
         Z116zM+0sPNaRutXuisK1C6B5gkkvf9SvmyAdwVMGhGpFwnhhHDoCVu1U1ZeZqti6NnA
         gNBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791514549; x=1792119349;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Ct3a3ES+gpFhXoGvhN0/KPCQwhxUgb4QuLzs3cj7zE=;
        b=0sQG9rtxkclvr5oyU1eAxHbfPwYdgdcQUwg735zKlBK0UnwE24JEzE+OBCwQepYpOn
         Rfoj3OmBx8gpnEbl/uK7DJqASCFHppPtxBfzWXNatb6RXm+HPcN4pgDZFddvICXHHipf
         GNboISwyJ4jQICbwcj4f+UYDD5JKlsQ8ALVV1+PEiJcD9AprtLcMgGGy1gKdXVDwYt9O
         fWiUk4Lfv4h5jeVEAKPBeAYe/r0eXRnaWicOapbO28M/MftAba97P5Y7T7H4trP+nxnO
         3UV4iInFSGtQEyyGOa/CRgkk267gLq+xoG7UgGeGABJfBUFqYd8tPUg3mZjw7y3ESSkM
         9HUg==
X-Forwarded-Encrypted: i=1; AKwUvBz5uiqIIuB9DLU+qLtoxETZAT7Q4BXjy5d24lzIvp8S9N3esa+rkICYnX3VrksSvTJzxK0hJPGAzDMb@vger.kernel.org
X-Gm-Message-State: AFq9FYJi/6R6Up5OeYv1fVufvCHE23yRnh/HUNYxZWXGZFsXxw+xJ6am
	RuK+LhWJKhqeaujKh6fNI4RmBzKBifo53wXCHSHpbugv9WE86Ls+d0vX
X-Gm-Gg: AYBFou36RZ0XhD8sj3fAXNkckDj/xVUNB1ytJ86QHKjVllwZAL6Tn+VHYT2r2EmyVtf
	TFD2bKB2mnO5v8XJDq4Z96N6YZUYVzwqyKCFmwJsujI7bfc+zqZ9qjBjV6zLzmPuegLmnApJjzd
	Ujv7Dbr0cdFQ5Z5oGwKtOKjWKj+nC/k+nlYMk+OGlUBimWC+xLWCOIa6GeywOv/76mXO6lyZ8Rz
	Aqx7M/6YrPbz7qtaXo4W0eUfkzrSz/FEA3duyVh0sH5j7v5Ba6AqRli44rHoOXsFdnLuFXxgG6S
	aKQ0aPouxQhIZuhg041soYRXgj4dBG6wRvx2r2eMswNevLcGwu+YB5s+ZfZW9rcPlfeqji9pxgi
	1/6Vi4qBwQSKYNH3T1Bi2NyA/ym7ooIOpJwRvpVBinZesvpVp5az6JE/ba0Zygo6X7Kn2lW7YRw
	wP3HhQAp0+O1BQ9jwuiA/ZiT8GP2H5DPf41hKoNGK9PLk3zcrrP/bszEn1lUGc+M7f9c5xF5qoX
	QftxaQmNvE/2JV/ybX0
X-Received: by 2002:a17:903:41c1:b0:2e8:2f95:7658 with SMTP id d9443c01a7336-2e8427f0416mr5152055ad.7.1791514549085;
        Thu, 08 Oct 2026 19:55:49 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8421b1987sm2341315ad.38.2026.10.08.19.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 19:55:48 -0700 (PDT)
Message-ID: <5bac3071-5823-4714-8c39-662b91c927a3@gmail.com>
Date: Fri, 9 Oct 2026 10:55:18 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [tytso-ext4:dev 21/41] fs/ext4/inode.c:4002:24: sparse: sparse:
 symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be static?
To: kernel test robot <lkp@intel.com>, Theodore Ts'o <tytso@mit.edu>,
 Zhang Yi <yi.zhang@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-ext4@vger.kernel.org,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <202610082225.lcsAyIiF-lkp@intel.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <202610082225.lcsAyIiF-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/2026 4:18 AM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> head:   35aefefd7aba0801bab635b11943f932626be3b2
> commit: e933fd1b6cd5322563d5caf283dabd9cd09bcef8 [21/41] ext4: implement buffered read path using iomap
> config: arm-randconfig-r2308-20261008 (https://download.01.org/0day-ci/archive/20261008/202610082225.lcsAyIiF-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 16.1.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610082225.lcsAyIiF-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610082225.lcsAyIiF-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>>> fs/ext4/inode.c:4002:24: sparse: sparse: symbol 'ext4_iomap_buffered_read_ops' was not declared. Should it be static?
> 
> vim +/ext4_iomap_buffered_read_ops +4002 fs/ext4/inode.c
> 
>    3998	
>    3999	static DEFINE_IOMAP_ITER_NEXT(ext4_iomap_buffered_read_next,
>    4000				      ext4_iomap_buffered_read_begin);
>    4001	
>> 4002	const struct iomap_ops ext4_iomap_buffered_read_ops = {
>    4003		.iomap_next = ext4_iomap_buffered_read_next,
>    4004	};
>    4005	
> 

Thanks for the report. ext4_iomap_buffered_read_ops should indeed be
marked static, and I've already fixed this in my local v7[1]. v7 also
includes fixes for some corner case issues reported by Sashiko on v6 as
well as some small optimizations, and I expect to send it out today or
tomorrow once testing is done.

Hi Ted, would it be okay to replace the current version with my v7 on
ext4 dev branch after I send it out?

[1] https://github.com/zhangyi089/linux/commits/ext4_buffered_iomap_v7/

Thanks,
Yi.

> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

