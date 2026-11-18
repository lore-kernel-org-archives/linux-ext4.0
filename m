Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.71.93.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998968;
	b=zKeGN/cWl5FZ91TKgJps9rF5YLu9BDMtqTfFa1THyQ2BJncnZC9qNIIJn6EJRaT+DzMR
	 PmNFfN0w9p8AjTz0qCBY+LVqTMtENo40FXocE3GJ56lwKe/Vclcw9g2ezFqyYfqji++VD
	 5uYyhzk2D42/yWKrgulEOTthBSYgP70Et/SuqvBRFqK5mRd8nyZd5B7vEkxYCJZnBs0uE
	 +HzIhUY/yGgfTvuErE8Tm7AV80lr7M1ZcWTmZWfM7/vXmMAnv4aoFk80GSZgAsXDDoVx9
	 b8XulWkrcM74YRo3bLzqtOVKK8j+oxrQyheHVZsi3Hiu1mV8Rb/PNTFS3+1cRPabb+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998968;
	h=DMARC-Filter:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-CM-SenderInfo;
	bh=yjddwcwOXL4YWgrbreUffyhglJyEjmO2zwDmfBYX+v8=;
	b=ETcBv43sOZAIWcA5X8MpUixJGCwn3jYT1ABFk/QvJQbJeBWYH0gCHuAO6UTNDJooZAsm
	 3Se1WoXkotDAuN5JpNxjfzydG5WB9Np8tl84SEZus6aKAuOJMDk6iyNXlDjPp9Dj6uEZi
	 l+KLYE+fmw0FnayTKn47ZFxF7FTZvR03uFwGOHrd33eCi/S34M8+51QtwXPRVH2Q+vQxO
	 QsFrcf0+x0JL901dxyAUE2XOdAeQ24Wkszke3sdUeROXfynao9YVWNRChLygboMVNS6Xo
	 iwFzzIT+WUuRUztlAtiq4CCClOoL71n27XCVsffT6O7dGdsDCP3GfwcN8sYMtEjpoVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=huaweicloud.com;
	spf=pass smtp.mailfrom=huaweicloud.com;
	arc=none smtp.remote-ip=124.71.93.99
Received: from dggmsgout11.his.huawei.com (dggmsgout11.his.huawei.com [124.71.93.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C245606A33D;
	Wed, 18 Nov 2026 10:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C245606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggmsgout11.his.huawei.com (SkyGuard) with ESMTP id 4jTyxn1Nw6z1c1lw;
	Wed, 18 Nov 2026 18:48:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E841040574;
	Wed, 18 Nov 2026 18:49:21 +0800 (CST)
Received: from [10.174.179.19] (unknown [10.174.179.19])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgAnZPOTgv1q3vJQEw--.21239S3;
	Wed, 18 Nov 2026 18:49:21 +0800 (CST)
Message-ID: <1102a630-de07-4494-aea2-207e5b84e2a0@huaweicloud.com>
Date: Wed, 18 Nov 2026 18:48:50 +0800
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] ext4: silent data loss when a split at I/O
 completion gets ENOSPC
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
 Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Baokun Li <libaokun@linux.alibaba.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 guolingxing <guolingxing@tju.edu.cn>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <d400205a-0d3d-4ec3-a916-6c0a085841b4@linux.dev>
 <d8ac3185-44c8-41e7-9cbf-3d1baa27f272@huaweicloud.com>
 <av1Z_RLuH4vd0Wyi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <av1Z_RLuH4vd0Wyi@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAnZPOTgv1q3vJQEw--.21239S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF15ZryxJrW5Cry5Aw1xuFg_yoWrZr15pF
	WF9a4Syr4qkr1v9r1xZa1UXFyFqayftrW3Krn5WrZaka98uFn7KrWfKa1YkFyDCrs7Gw4j
	vrWF9ry3W3Z0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AK
	xVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UAwI
	DUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 11/18/2026 3:55 PM, Ojaswin Mujoo wrote:
> On Tue, Nov 17, 2026 at 07:37:10PM +0800, Zhang Yi wrote:
>> On 11/16/2026 10:27 AM, Jose Fernandez (Anthropic) wrote:
>>> Ojaswin's cover letter [1] explains how, since commit ea96cb5c4ae3
>>> ("ext4: don't split extent before submitting I/O"), the split of an
>>> unwritten extent at I/O completion can get ENOSPC. [1] stops the zeroout
>>> from hitting other writes in flight, and [2] reports the failed
>>> conversion to fsync(). Neither gives the split its block, so data is
>>> still lost.
>>>
>>> LLM agents working with me found that it happens with default options
>>> on a filesystem that is not full, and ran the tests. write() and fsync()
>>> return success, and after the pages are evicted part of the file reads
>>> back as zeros.
>>>
>>> Under a load built to run the allocator dry (QEMU without KVM), 42 of
>>> 72 files lost data at ea96cb5c4ae3, none of 72 at its parent and none
>>> of 48 on v6.18.63. On mainline at 23c62304dde2 32 of 72 did. With [1]
>>> rebased on it 42 of 72 still did, now as failed conversions in dmesg.
>>> With [1] and [2] fsync() failed with ENOSPC on 47 of 72, and the other
>>> 25 read back intact.
>>>
>>
>> Hi Jose!
>>
>> I'm sorry for causing this regression. The cause of this problem is that
>> the transaction freeing the file's space has not yet been committed and
>> thus cannot be returned to the mb allocator, so the extent cannot be
>> split at endio time to allocate space for metadata. This is easily
>> reproduced in scenarios with frequent file creation and deletion, even
>> though there is still plenty of free space on disk.
>>
>> I think the solution should be based on Ojaswin's counting approach in
>> [1] or the PENDING_CONVERSION solution we discussed, and then, after
>> extent splitting fails, try to flush the journal and retry. My idea is
>> roughly as follows:
>>
>> 1. For the iomap buffered I/O path and the DIO path, this is relatively
>>    simple. We just need to add journal flush and retry logic in
>>    ext4_iomap_finish_ioend() and ext4_dio_write_end_io().
>>
>> 2. For the traditional bh buffered I/O path, we cannot flush the journal
>>    in ext4_convert_unwritten_io_end_vec(), because this may lead to an
>>    ABBA deadlock with data=ordered mode. The journal process needs to
>>    wait for ordered folio writeback, but this folio may contain some
>>    ranges that need to be converted, and if we flush the journal after
>>    the conversion fails, it will form a mutual dependency with journal
>>    flushing. Therefore, we have to fall back to splitting before issuing
>>    I/O, and when splitting fails, flush the journal and retry via
>>    jbd2_journal_force_commit_nested() in ext4_do_writepages().
>>
>> 3. Split the workqueues used at the end of iomap and bh writeback to
>>    avoid deadlocks. Because the filesystem may simultaneously have
>>    different inodes going through the bh path and the iomap path, if the
>>    iomap completion worker is flushing the journal, it may need to wait
>>    for the folio of another inode going through the bh path to finish
>>    conversion, and that conversion worker still needs to be handled on
>>    the same wq, thus causing a deadlock.
>>
>> The current bh buffered I/O handling flow cannot be unified with the
>> other two, which is indeed not ideal. However, once data=ordered mode is
>> sunset in the future, we should be able to unify them. What do you all
>> think of this solution? Any better ideas?
>>
>> Thanks,
>> Yi.
> 
> Hey Zhang, thanks for the poc, it looks largely okay. I agree that this
> seems to be the right way forward although its unfortunate to have to
> revert back the unwrit to unwrit split. Hopefully we can move completely
> switch to iomap soon enough. 
> 
> On the extent status cache for zeroout approach, i'm currently fixing a
> few bs < ps bugs I'm seeing in it and would clean it up and post it as
> v2. My idea is to keep the first patch disabling zeroout and rest of
> them implementing the es changes and renabling it. 

Hi Ojaswin,

Yeah, this makes sense to me. Looking forward to your v2. I'll re-adapt
this POC based on your patch afterwards. :)

> We can just backport
> the first patch. Along with your poc fixes here also backported to 7.0
> i believe we should be good to go.
> 

Sorry, I don't quite understand. As far as I know, 7.0 is already EOL, so
why does this still need to be backported to this version?

Thanks,
Yi.


