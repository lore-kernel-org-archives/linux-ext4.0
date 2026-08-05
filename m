Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E1938E8A7;
	Wed,  5 Aug 2026 10:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785927336; cv=none; b=dlHWhn5vJUwMyX+lSvX0syDCM6V4Ithk8tifa4R39cz52aZMEUs83HTlXBnoS2gz0jQD9EUP+5xGR47XWWCDF0BulFIE5YAGu1O5a98lypapyoQsmUCRx9OwfiKZ1JeRy/eeNPhbBCQebZkxX3YK9C+GzLlBoiPQN5uckOgUrlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785927336; c=relaxed/simple;
	bh=JUdBqFjm9fK/OlqJ2kX4GpW/Llh2cJlNW/cxLiJoMC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KQvtPZRdDN9rKgtUowH5IuA6KyL524Ll8HlVffOvZiPkK/7mFXLwy7rYJZ9d8X4HTJOWw8gHYcwq5Vkph0+uSw3z4yYQjfHRMb7QD99j3t590QJ77mAYiicNqf7T2epE+zcEkfQ1mm3n3VTZGFiZ8M4JDJ9KUywgzwxCKQzTi10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hFS3B5Jc1zYQx8y;
	Wed,  5 Aug 2026 18:54:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A3B5C4058C;
	Wed,  5 Aug 2026 18:55:23 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgDn1kWZFnNqZM3NBA--.7867S3;
	Wed, 05 Aug 2026 18:55:23 +0800 (CST)
Message-ID: <a7312401-3bed-4d5d-847e-a0c96be503d3@huaweicloud.com>
Date: Wed, 5 Aug 2026 18:55:20 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write
 fails
To: Jan Kara <jack@suse.cz>
Cc: Chao Shi <coshi036@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Matthew Wilcox <willy@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, linux-ext4@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev,
 linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <cover.1785621505.git.coshi036@gmail.com>
 <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
 <ff2f92ab-6c98-42f2-be0b-0c807bc9438e@huaweicloud.com>
 <t5vasainmrq7zlo2ptmjn5qfyiy26l4vvuqfkoldtx3naf5tir@4v6bktopybsk>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <t5vasainmrq7zlo2ptmjn5qfyiy26l4vvuqfkoldtx3naf5tir@4v6bktopybsk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgDn1kWZFnNqZM3NBA--.7867S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWDuw45AF1Uuw4fWFWrAFb_yoW5Ar1Upr
	Z5Ka1DKw4qqFyjyrnFkF1Fqa40yFyvvF47urWrG3WxZr90vr93WFy7Xw4Y9FW8Arnaga1j
	vr4Fgr93CF1UXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIF
	4iUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/



On 8/5/2026 5:00 PM, Jan Kara wrote:
> On Wed 05-08-26 12:52:11, Zhang Yi wrote:
>> On 8/2/2026 6:01 AM, Chao Shi wrote:
>>> A buffer whose write failed still holds exactly the data the filesystem
>>> asked to be written.  It is the disk that is out of date, not the buffer.
>>> Clearing BH_Uptodate says the opposite, and callers act on it:
>>>
>>>  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
>>>    filesystem that dirties the buffer again after a failed write - which is
>>>    the normal way to retry - trips it.  That is the warning this series
>>>    started from.
>>>
>>>  - a buffer that is not up to date gets re-read from disk, which replaces
>>>    the data the filesystem was trying to write with the stale on-disk copy,
>>>    silently.
>>>
>>>  - the window between the write completing and the buffer being marked not
>>>    up to date is visible to anyone holding the folio lock, so the state is
>>>    not even self consistent while it lasts.
>>>
>>> BH_Write_EIO already records the failure, and by now every place in the
>>> tree that needs to know about it tests that flag instead: the two core
>>> helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
>>> omfs, converted one filesystem at a time in the preceding patches.  The
>>> private completion handlers in jbd2 and ext4 fast commit were converted
>>> along with their waiters.  Nothing is left that reads BH_Uptodate to find
>>> out whether a write failed, so the clears can go.
>>>
>>> Found by FuzzNvme.
>>>
>>> Signed-off-by: Chao Shi <coshi036@gmail.com>
>>
>> It looks like after this series, we may need to revisit the necessity of
>> ext4_buffer_uptodate() in the ext4 filesystem. IIRC, it was originally
>> introduced as a compromise to address this issue. Now that we no longer
>> clear the buffer uptodate flag after a failed IO write, this flag will
>> still remain valid when getting/reading bh. Therefore, the necessity of
>> ext4_buffer_uptodate() is worth reconsidering.
> 
> Deninitely :) There are several hacks in ext4 (and other filesystems as
> well) that could be removed after this patch set. But let's settle on the
> generic changes first.
> 
> 								Honza

Yeah, that would be great!

Best Regards,
Yi.

> 
>>> ---
>>>  fs/buffer.c | 2 --
>>>  1 file changed, 2 deletions(-)
>>>
>>> diff --git a/fs/buffer.c b/fs/buffer.c
>>> index ac978d9090c2..0002f0736398 100644
>>> --- a/fs/buffer.c
>>> +++ b/fs/buffer.c
>>> @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
>>>  	} else {
>>>  		buffer_io_error(bh, ", lost sync page write");
>>>  		mark_buffer_write_io_error(bh);
>>> -		clear_buffer_uptodate(bh);
>>>  	}
>>>  	unlock_buffer(bh);
>>>  }
>>> @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
>>>  	} else {
>>>  		buffer_io_error(bh, ", lost async page write");
>>>  		mark_buffer_write_io_error(bh);
>>> -		clear_buffer_uptodate(bh);
>>>  	}
>>>  
>>>  	first = folio_buffers(folio);
>>

