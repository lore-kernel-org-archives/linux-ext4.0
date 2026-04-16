Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E778379979;
	Thu, 16 Apr 2026 07:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776323294; cv=none; b=oICJXEW2pLLHbWstEZrzKBjmfzv1jGxityGPot0F0KtMdmhqVXg2cephiUH8/rDqv0kcCNC/NIFBUCWel0e84k48CCZDfvNeqaqpDU2oiUVvvYJKQD+MbaOTaVu3GRoSXsEYCM+eVJtTgw/QwyRhUPYB0JKZKyNpuRIM+jgIEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776323294; c=relaxed/simple;
	bh=xvxoZZLTapK+XHwWro+HCK/dDhDP8DvRNWH7T7CeGM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+jN+4xLg4LqfgQotiY/5k1h1ehZXLP8u2JSjtoJBx1lLIB9eI+xfV5cC080le2ZwDzIwUaHcpsxGPRF3Jdw63JesUwhk6dYTT3kW+ZXXrdXiD1HYDnIQcIcyS1Pr1PjSQkdO6p2KTX0RXbdePNVO3+byTkymjr75kfLXNP3nqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ETXKgzWs; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ETXKgzWs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=LFPNGPaENT/hBl+GocrWQH8+ip14PqtZctiPRBXxdLA=;
	b=ETXKgzWsGjk91qCDdd62axe4zVADUpTgnQ2eaCK5fo+zjTGCpDFTE/chXj7irv
	jhag5RqBbudJQb5QkTC8GdMgJgeCXfugpr9T5jasAwPiN3j+KTdnOfkBWh3Ifi46
	iXhzTCIKSa406Ik95GtggkheKgEv+NPgUv2KqeOgCushA=
Received: from [192.168.52.68] (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wDHcf+4iuBpJw0iFg--.26284S2;
	Thu, 16 Apr 2026 15:07:41 +0800 (CST)
Message-ID: <d4d92271-4f46-4a38-86c9-94b2b8efa504@163.com>
Date: Thu, 16 Apr 2026 15:07:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ext4: add mb_stats_clear for mballoc statistics
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>
References: <20260414100212.95209-1-liubaolin12138@163.com>
 <ad_mguIqaOT-pEmh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <ad_mguIqaOT-pEmh@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHcf+4iuBpJw0iFg--.26284S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4xZF45uFWfuF15Ww4fAFb_yoWDWrgE9r
	18tFs7C3ZFqF1kJa1fCr18WFZY9FZ29ryDJwn5JFs3W34YvanYkrZ5WrZ0yF17WFW09rZ3
	WF4rXasxAFnFqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjtrcPUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwh1kL2ngir2GUAAA38

> Dear ojaswin,
>    Alright, thank you for your review. I will revise the patch according to Andreas's comments and submit a second version. 
>    When submitting the second version, I will also update the relevant files under the Documentation directory according to your suggestions to add explanations.
> 
> Regards,
> Baolin



在 2026/4/16 3:26, Ojaswin Mujoo 写道:
> On Tue, Apr 14, 2026 at 06:02:11PM +0800, Baolin Liu wrote:
>> From: Baolin Liu <liubaolin@kylinos.cn>
>>
>> Add a write-only mb_stats_clear sysfs knob to reset ext4 mballoc
>> runtime statistics.This makes it easier to inspect allocator
>> activity for a specific workload instead of using counters
>> accumulated since mount.
>>
>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
> 
> The patch looks good to me Baolin. We just need to add documentation of
> this to the Documentation/ABI/testing/sysfs-fs-ext4 file so that the
> users know what it is and the fact that the only value we allow to write
> is 1.
> 
> Regards,
> ojaswin

