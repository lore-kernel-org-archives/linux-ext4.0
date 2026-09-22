Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63C6352014;
	Tue, 22 Sep 2026 01:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039500; cv=none; b=DdNVVx2PHKL8sgqnFl+td3ByuMK6ss8XnSPwDWn2att8Yzjl77V1irNyM2kM5SLF9snbo07OiZZtZz1hihIIQPH9SqmQOolz6SySR5lPPbsYiUJClTtsOA3dmMdAhkhkenQbABLPacBMaFXvIOmf8RiugstwwxSuPMbWAbGSxVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039500; c=relaxed/simple;
	bh=LjqntJm4sYSuRQmpROhO2wmSoFEVZCKevoQ1XiN/sc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=icxyA7Tb3WQeJjQKRhYttvEwwFRS1MsxHGO+oVaNYBbYNnB5stCWAnLKKbPPnnAMHBurofkMf3aGEi6UZSmJhPrC2YVnPi7lL9zEqwEZIQSiTQFQLSODcqz3O5J86qq269Mm7c3x+GYZi8P3DcvKrguu0zR0Fx+NRbBxoA3KtAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hphqz5V5XzYQvCb;
	Tue, 22 Sep 2026 09:11:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2545640A64;
	Tue, 22 Sep 2026 09:11:26 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgB3Ryqx1bFqtPrQBA--.27304S3;
	Tue, 22 Sep 2026 09:11:25 +0800 (CST)
Message-ID: <a563fc94-1143-46f5-a505-49a1a74a9e88@huaweicloud.com>
Date: Tue, 22 Sep 2026 09:11:13 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
To: Jan Kara <jack@suse.cz>
Cc: Zhang Yi <yizhang089@gmail.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 chengzhihao1@huawei.com, wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
 <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
 <9d931f5e-cb34-4721-9def-7aeeda48700c@gmail.com>
 <453d0054-4f53-452a-9737-cd37d30a7d44@huaweicloud.com>
 <35me4qswsu2dd3howvfdglh4ge4t5vihkizoutxt2jhiyul6xj@i6kqsnqpvbra>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <35me4qswsu2dd3howvfdglh4ge4t5vihkizoutxt2jhiyul6xj@i6kqsnqpvbra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3Ryqx1bFqtPrQBA--.27304S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur17Zw1rCFy3JFy3Zw4UCFg_yoW5CrW3pF
	ZYgrWqgFWxJr1jkrnrZ3WjqFyay345WF1UAFWfGF17C3ZxXrn3KryYg3WDu3yfGwnrZ348
	XFyUtF9ruF1jyFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAq
	x4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6x
	CaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8
	ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU04xRDUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/21/2026 5:05 PM, Jan Kara wrote:
> On Thu 17-09-26 20:03:57, Zhang Yi wrote:
>> Sorry, the previous diff format was incorrect, reposting it.
>>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 23c90f00b530..b5e5bdf5f9ef 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -279,51 +279,46 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>>  			*pstart = round_up(pos + offset,
>>  					   min_nrbytes) >> PAGE_SHIFT;
>>
>> -		if (offset + length == size) {
>> -			end = aligned_end;
>> +		end = aligned_end;
>> +		if (offset + length == size)
>>  			goto out;
>> -		}
>> -
>> -		split_at2 = folio_page(folio,
>> -				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>> -		folio2 = page_folio(split_at2);
>>
>>  		/*
>> -		 * folio2 may become stale due to a concurrent split or
>> -		 * freeing, so validate it before and after taking its lock.
>> -		 * If it fails, we can't get an accurate end position and fall
>> -		 * back to folio->index, which may leave sub-folios split off
>> -		 * at the offset edge in the page cache this round.
>> +		 * After the first split at the start edge, the folio at the
>> +		 * end edge may be freed and reused concurrently.
>> +		 * __filemap_get_folio() looks up the straddler at
>> +		 * aligned_end and returns it locked and ref'd with the
>> +		 * mapping validated.
>>  		 */
>> -		end = folio->index;
>> -		if (!folio_try_get(folio2))
>> +		folio2 = __filemap_get_folio(folio->mapping, aligned_end,
>> +					     FGP_LOCK | FGP_NOWAIT, 0);
>> +		if (IS_ERR(folio2)) {
>> +			/*
>> +			 * No sub-folio straddles the boundary when aligned_end
>> +			 * is empty so discarding up to it is safe.  Otherwise
>> +			 * the straddler is locked by someone else and we
>> +			 * cannot obtain a reliable end position, so we fall
>> +			 * back to folio->index.  This is safe but may leave
>> +			 * pages split off at the offset edge lingering in the
>> +			 * page cache this round.
>> +			 */
>> +			if (PTR_ERR(folio2) != -ENOENT)
>> +				end = folio->index;
>>  			goto out;
>> -
>> -		if (folio2->mapping != folio->mapping ||
>> -		    !folio_test_large(folio2))
>> -			goto out_put;
>> -
>> -		if (!folio_trylock(folio2))
>> -			goto out_put;
>> -
>> -		if (page_folio(split_at2) != folio2) {
>> -			folio_unlock(folio2);
>> -			goto out_put;
>> -		}
>> -		if (!folio_test_large(folio2)) {
>> -			end = aligned_end;
>> -			folio_unlock(folio2);
>> -			goto out_put;
>>  		}
>>
>> -		/* Split failed: back off to the head of the straddler */
>> +		/* Already at the minimum order, nothing to split */
>> +		if (folio_order(folio2) == min_order)
>> +			goto out_put;
>> +
>> +		split_at2 = folio_page(folio2, (aligned_end - folio2->index));
>> +
>> +		/* Split failed, keep the straddler intact */
>>  		if (folio_split_or_unmap(folio2, split_at2, min_order))
>>  			end = folio2->index;
>> -		else
>> -			end = aligned_end;
>>
>> -		folio_unlock(folio2);
>>  out_put:
>> +		folio_unlock(folio2);
>>  		folio_put(folio2);
>>  out:
>>  		if (pend)
> 
> FWIW this looks much more understandable to me. And since this is a
> preexisting issue I agree this should be a separate patch.
> 
> 								Honza

Thank you for confirming. I will send out the next iteration after
testing.

Thanks,
Yi.

