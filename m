Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168E3161A1
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 11:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773919077; cv=none; b=ffw4GpPKHhKDScgYeUsqx+0AwHQ0TJwDbPLfqG+vFAEt7GjmVwhaUxY+WVgy6LEdJBBHFbAe5oh9L6mXPDvQJdYwOKlw02/HaKrK0xsbJk/XBrBFDIZjtA1MrytwODJCUZAKSrqQuNxnibZqn048Dha4Ayo3M0XMRo/izRK9psE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773919077; c=relaxed/simple;
	bh=SRNx3iC3RmCV3sciXT2ZYqDvMqbNzYaybUSUqD++h+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FBJw3D8rxwlj23vrOEtKAogpjoAd0wpZAswLWVnlmU3a7qlgaOmsL/Q7ggeZ68sJvHoKL1/iK93eXOTmfcavAbU8NmVkYWNeXEJajjt2ZH7Ai1l8PbKHfG3UjAPr/XU1r6PBTTfBjvAZD4nTM+p7e1WHxIoPC6oEX/awDPCLBXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HOiUoOwH; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HOiUoOwH"
Message-ID: <f801417f-5010-4820-8eed-42f1e10f2076@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773919064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y2AvX1Xbko1BA1aQExGB95lS6ZdqtMuFl1N06LlGrNs=;
	b=HOiUoOwHrIyuR+fDtEjUJ7A7EekyTXKD65hLcyDTiweCyrb1FVF/cwpxz5kCkdTKl46cxP
	H/hQ70zeSKeCRWriGeM1S12DNjDoQ4tC03kg63SdSgogbFoPZ9c150D4MT+9IjR5n3QEIn
	pfObQknE2sX0rdIxHSTxH8+SKl358jk=
Date: Thu, 19 Mar 2026 19:17:04 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] ext4: fix use-after-free in update_super_work when
 racing with umount
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Ye Bin <yebin10@huawei.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
 linux-kernel@vger.kernel.org
References: <20260319073651.79209-1-jiayuan.chen@linux.dev>
 <h4afxbv3sivvopwqfnccd235wywla6bvwk6a5qp5yuwg5pnr2e@s7jlvfxjgxgq>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <h4afxbv3sivvopwqfnccd235wywla6bvwk6a5qp5yuwg5pnr2e@s7jlvfxjgxgq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 3/19/26 6:50 PM, Jan Kara wrote:
> The initialization of s_error_notify_mutex should happen early in
> ext4_fill_super() as ext4_notify_error_sysfs() can be called rather early
> before ext4_register_sysfs() is called.
>
> Also we should protect kobject_init_and_add() with s_error_notify_mutex to
> handle the case where ext4_notify_error_sysfs() is racing with
> ext4_register_sysfs().
>
> 								Honza
> -- Jan Kara <jack@suse.com> SUSE Labs, CR


Hi Honza,

Thanks for the review! The AI catches are reasonable — I'll move
mutex_init() earlier in ext4_fill_super() and protect kobject_init_and_add()
with the mutex.

Thanks,
Jiayuan

