Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B814499A4
	for <linux-ext4@vger.kernel.org>; Thu,  8 Oct 2026 08:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791449620; cv=none; b=o7Tv8p1ao45k6pJfVpdpNawz6TXrwdB0p7wsOnGGt2jDVSGsrHCP6hyE92sRhMJI8mpaQARockr7M7c2T/V+YPUPKC6KRp+8rQ1zMjdU+NTeUW4AB3ruGssIPlW7i5dlnAscGn6V81FhcNEYPakkFOr+j14K1gXN8dx+RIKsj30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791449620; c=relaxed/simple;
	bh=8DQSIKC6GxvLYGVLwkJQj+cpOYKLwFGmAsJkxIx9DcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VFFkh0PVmQJdaCMsdiO/uKUYeaxE1O3VZGM25mGkP4r57dq812uvJsQsIs8LOj8pdt/qQqp7ZnJIrtEKUUKq/Ey+0anHO9atchgOjfw0BK+MOsST8K6yg3ez8an5pqFn0VjzDuX3nd+Qp6IZRIKBcq04pT5nRxmmZfypLcBSE44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l1B/yr7e; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l1B/yr7e"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-892734ce7e6so674105b3a.1
        for <linux-ext4@vger.kernel.org>; Thu, 08 Oct 2026 01:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791449618; x=1792054418; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WoVuc57y0iB0VQsW+dVH6xl0rblskYdNvDdZ3Vwv6xY=;
        b=l1B/yr7eTIHEeGQvfc38pny08CQhmOz4qV46QgGae1JZI4tH8xaGeens+vu0o4AZvg
         mIsDlX4FvDKP+nQNYzJgR7Am0ybQnoV0QErM1nT8oKXFfrf7/yU8lzBUgys5v2Cz3P3c
         gk7eGdb2fUBKMK/PJzmpYhc86EdcFZN2fnhi4ApDLsHQf0d2yj4RAGamyZRbl2EfWHWp
         vlbRoxpf0rkTcuka2WoeGYLqZhub68AXg5K2JuCnv+YOeHsfhh1v9T/e9+q/lrz9IV5D
         C9VNd4E/MGMAtntPD1ju3nvj/NOMayHUefhrDeR4bVNQCGDFmOQfCmJw1Lhov1bm5iXU
         zMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791449618; x=1792054418;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WoVuc57y0iB0VQsW+dVH6xl0rblskYdNvDdZ3Vwv6xY=;
        b=ttbPZPpi2tCZcKaX0I+L/Ynfuj5pxnFDYoGyg7oqIdwnOnAoU6CrnKi0OFFcqgL+5Q
         XyoS9Q3++iMZzMrM9JKOxJjbDGtgKCIYTFZIPqkw6cY30x8NoTmEaK0289hWd1kttuzd
         ZIWrXslL01yC00ZUWYX91RsA4JpI/14o2mnMzv2cN2/JTrC0WEkbSp8clbJ9PfePD+ts
         TitNccdBqyp6W3wow6qwJiiFPQrcBzfXzgNqO/oNugV/hqSEPzFBnL0au1rJAn9x+Kjx
         QowYni4TLNsrDrBiBzXZg+wc+1nsizaBy0MQI8CGHBTc2hJbi8i12PKVLQpd4tBpHTC9
         eN4g==
X-Gm-Message-State: AFuF++nSwMO1rVuD78mMwxmdKT7MRxRbwNC5Ko0NDXDS3DxGcf0o3L1/
	gJTQomwEKzRa+VMRaO9m9t9KCiVoW75y6hkq06PifJdCiGR5mPgD4VtG
X-Gm-Gg: AYBFou1UQd6g14XsnUkXNNhRZ9BT90ancegL7BvxfUXheqUz0VELzOWl5tFTjwuJqV0
	dOcI9AblsEamcdHrGJqxKLPLgnUjBLR8VVI5aa+b94SWg2x5mcnVPsD4j8FUJammse2PL7fv1xv
	UiO+GKC6AtYJAFnoQ0ed0lvHrmsL4BnQ1svOzs1iEhj7Y+0RWmhc6T80JoJScCUfmY+KPIwrF80
	mFSkhdsFZAou/TzrUq5O/3YZ7QhJmZV36eOfz0YMaQtnboQgRrhwLl/Z0uNIdwEkGJB3gTHvaw3
	z0cTMYcYHYdCIDXVPG4JDFQwa9HZDka2yD5kIp6AnpgHU/L8hZVv/3ERKXhNCB/fbqF2K6ao2f3
	wyuSVjJuN3c71TGYmtDiW70h3Xfiz6C9cz6RIGsteTDCBPMRQDsHxSGOWkipFq0Nooc0uep3OS/
	TunPc9uINaPf8CWMpFqCkTNH3QdEygcpkYj7tAfbiqXqWYbrArnomBfy7N2NQMSrxyMwO6fOOvy
	tA1/Ie574YuT64/Mak=
X-Received: by 2002:a05:6a00:22c4:b0:878:34b8:231f with SMTP id d2e1a72fcca58-891b4700782mr4325448b3a.39.1791449617950;
        Thu, 08 Oct 2026 01:53:37 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-892bb59bd30sm1207676b3a.37.2026.10.08.01.53.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 01:53:37 -0700 (PDT)
Message-ID: <08dfc1dc-adc6-41ed-aaa5-7af7836f71c7@gmail.com>
Date: Thu, 8 Oct 2026 16:53:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
 <asNnFY8N3NJwucWe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <asNnFY8N3NJwucWe@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/2026 5:00 PM, Ojaswin Mujoo wrote:
> On Thu, Sep 03, 2026 at 08:35:34PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> When the current writeback pass begins beyond the disksize-grow-pending
>> zeroed EOF block, the ioend worker would otherwise have to wait for the
>> pending EOF block to complete before it can advance i_disksize.
>> Otherwise the old EOF block could be exposed as stale data once
>> i_disksize advances past it.
>>
>> Therefore, introduce the ioend mechanism for the pending range, tag
>> ioends that cover the pending zeroed EOF block which straddles
>> i_disksize with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO in
>> ext4_iomap_writeback_submit(), and clear the bit and wake up all waiters
>> in ext4_iomap_end_bio() when such an ioend completes.
>>
>> Clearing EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO does not depend on whether
>> the disksize grow I/O succeeds. That is, even if the I/O fails, we still
>> allow subsequent writes in the range to update i_disksize. This is
>> consistent with the previous behavior, and we rely on data_err=abort to
>> prevent metadata updates when data write failures occur.
>>
>> In order to avoid the ioend that passes the pending range waiting for a
>> long time, proactively submit the pending range first in
>> ext4_iomap_writepages() so it completes in parallel with the rest of the
>> writeback.
>>
>> Note that the handling of discarding the zeroed EOF folio will be
>> processed later, otherwise the bit will be set forever.
>> EXT4_STATE_DISKSIZE_GROW_PENDING will be set after everthing is done.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>   fs/ext4/ext4.h    |  6 ++++++
>>   fs/ext4/inode.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ext4/page-io.c | 40 +++++++++++++++++++++++++++++++++++
>>   3 files changed, 98 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1c3d736fb700..089dbd39c5c2 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -3986,6 +3986,12 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
>>   			     __u64 len, __u64 *moved_len);
>>   
>>   /* page-io.c */
>> +/*
>> + * The I/O range covers the zeroed EOF block that straddles i_disksize
>> + * and will advance it upon completion.
>> + */
>> +#define EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO	1UL
>> +
>>   extern int __init ext4_init_pageio(void);
>>   extern void ext4_exit_pageio(void);
>>   extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 05dd4ee805fb..4239be5a769f 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4366,7 +4366,10 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>   				       int error)
>>   {
>>   	struct iomap_ioend *ioend = wpc->wb_ctx;
>> -	struct ext4_inode_info *ei = EXT4_I(ioend->io_inode);
>> +	struct inode *inode = ioend->io_inode;
>> +	struct ext4_inode_info *ei = EXT4_I(inode);
>> +	unsigned int blocksize = i_blocksize(inode);
>> +	loff_t pstart, plen;
>>   
>>   	/*
>>   	 * After I/O completion, a worker needs to be scheduled when:
>> @@ -4379,6 +4382,21 @@ static int ext4_iomap_writeback_submit(struct iomap_writepage_ctx *wpc,
>>   	    test_opt(ioend->io_inode->i_sb, DATA_ERR_ABORT))
>>   		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>>   
>> +	/*
>> +	 * Mark the I/O as DISKSIZE_GROW_IO by setting io_private to
>> +	 * EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO if it covers the pending range.
>> +	 * Such I/O will allow or trigger i_disksize advancement in the
>> +	 * ioend worker.
>> +	 */
>> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
>> +	if (plen &&
>> +	    round_down(ioend->io_offset, blocksize) <= pstart &&
>> +	    round_up(ioend->io_offset + ioend->io_size, blocksize) >=
>> +			pstart + plen) {
>> +		ioend->io_bio.bi_end_io = ext4_iomap_end_bio;
>> +		ioend->io_private = (void *)EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO;
>> +	}
>> +
>>   	/*
>>   	 * ext4_iomap_end_bio() always defers endio processing, disable
>>   	 * generic BIO in task to avoid double deferral since we will use
>> @@ -4398,6 +4416,33 @@ static const struct iomap_writeback_ops ext4_writeback_ops = {
>>   	.writeback_submit = ext4_iomap_writeback_submit,
>>   };
>>   
>> +/*
>> + * If the current writeback range begins after the pending zeroed EOF
>> + * block range which straddles i_disksize, issue a separate writeback to
>> + * flush it first, so as to avoid prolonged waiting.
>> + */
>> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
>> +					    struct writeback_control *wbc)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	loff_t pstart, plen, range_start;
>> +
>> +	if (wbc->range_cyclic)
>> +		range_start = (loff_t)mapping->writeback_index << PAGE_SHIFT;
>> +	else
>> +		range_start = wbc->range_start;
>> +
>> +	plen = ext4_iomap_get_disksize_pending_range(inode, &pstart);
>> +	if (!plen || range_start < pstart + plen)
>> +		return;
> Hi Zhang,
> 
> Maybe we can check here if pstart lies withing the same folio as the
> writeback range, then we don't need an explicit flush as we will anyways
> flush out the whole folio. We can check against the
> mapping_min_folio_nrbytes perhaps.
> 

Hi Ojaswin,

Thank you for the suggestion. IIUC, do you mean to change it somewhat
like the following:

       if (!plen ||
           round_down(range_start, mapping_min_folio_nrbytes(mapping)) <
                      pstart + plen)
               return;

The benefit is that it covers the case of blocksize < PAGE_SIZE, where
the pending range occupies only part of the folio and range_start lands
in the middle or later part of that same folio. It does not help when
the pending range happens to be in a large folio, though, because
mapping_min_folio_nrbytes() is only a lower bound on the folio size.
That said, the pending range is the old EOF of the file and it is
unaligned, so that folio can more likely to be a single page than a
large one.

Or do you want it to be very precise, able to know exactly the size of
the folio containing the pending range and its positional relationship
with the writeback range? If the latter, that would require an exact
folio lookup, which seems a bit expensive and perhaps over-optimization
to me.

Thanks,
Yi.

