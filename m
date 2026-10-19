Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985334F4CF6
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792413510; cv=none; b=jZ6bKA76pKk9BHJiqbSht4HwzYhW69mY3Isg47XqFABA1RZvOaDOIGUPXshtbflh2WTckzrnTtZwTEUu2pkW4OamqGvTCs1obADJbylSYS4AfFalze7z4ckaweiJe8LZ7WSagBIzQ0RuYjY4V5aTQO0fgtxq5Z+3hbVNQfrV/H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792413510; c=relaxed/simple;
	bh=WaGy4E03++97TCbMmAto9M75aT5iSsiYGQMrgToMqt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORR4k4KzGhgwP3hcKXYCZ3MrMvmV/wdmk7nu69MEc4HQNbcs0SGDmV252wm0aFs5TNDSU8pBBa2qayirl4Z88AsxrpEUcwUt2b8JztSS/z1IFYXCNx6LJeTyrdilyPe3TD9y4UEE2R5oy3hJAInCzpj6EkVEgstzyzIpYVNHZsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4j7Zp70DVlzKHPSb
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 20:38:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3BF7C40573
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 20:38:15 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBXkO82D9Zqy1klBA--.37298S3;
	Mon, 19 Oct 2026 20:38:15 +0800 (CST)
Message-ID: <efd8d9c6-8688-46e4-998a-6ef9b0129a88@huaweicloud.com>
Date: Mon, 19 Oct 2026 20:38:14 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ext4 data=journal deprecation: long-standing industrial use case
To: "Korber, Markus" <markus.korber@anton-paar.com>
Cc: Theodore Tso <tytso@mit.edu>, Gabriele Moabiti <gabmoa@gmail.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <CAAbJaeALOrZwWs++mz9Wv0pfvyDoHmfzPKyVHR0v6TwnzLkYGw@mail.gmail.com>
 <as0U-lfet5slrD8o@mit.edu>
 <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <AM0PR03MB5714FB8241C13A499E7D5155DE982@AM0PR03MB5714.eurprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXkO82D9Zqy1klBA--.37298S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWDKw1kXr1Dtw18GFW5Awb_yoW8AF4kpF
	Zaqr4DtFyvyr9xAwn293WxGa12qFn5uFW5Wrs8W3s0va45Kw129w1ayF409FyIyr1rGr1j
	vrZFqas5W34DZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgvb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIx
	AIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIev
	Ja73UjIFyTuYvjxUwmhFDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 10/19/2026 4:51 PM, Korber, Markus wrote:
> On Mon, Oct 12, 2026, Theodore Tso wrote:
>> Given that there is no guarantees of what writes will be persisted
>> with respect to program execution, it's unclear exactly what your
>> deployments are requiring or assuming.
> 
> I'd like to add another data point in support of Gabriele's use case.
> 
> We also use ext4 data=journal on embedded systems where unexpected
> power loss is possible. Our main concern is not losing the most recent
> few seconds of data. That is acceptable for our use case. What we want
> to avoid is corruption of file contents after an unexpected power loss.
> 
> We performed repeated hard power-cut tests using both data=ordered and
> data=journal. With data=ordered we observed, among other expected
> failure modes, files containing NULs and partially written files where
> the unwritten part contained NULs. These failure modes are particularly
> difficult for applications to recover from.
> 

If you're only doing regular append writes rather than post-EOF append
writes, then the upcoming buffered_iomap mount option should be able to
address this one (though in the short term it won't support all the
features of the buffered_head flow — hopefully it will be useful for
you), since the on-disk file size update is performed after the I/O
completes.

Regards,
Yi.

> With data=journal we still observed lost recent files, zero-length
> files and truncated current writes, but we did not observe those
> NUL-filled corruption patterns.
> 
> So at least for our use case, the useful property of data=journal is
> not primarily reducing the amount of recent data that can be lost.
> It is the different failure behavior when power is removed during file
> I/O.
> 
> Regards,
> Markus

