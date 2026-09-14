Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37393B7754
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 07:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370858; cv=none; b=PBluvf4uW4Zgk72jvARoTRHC1s0lRZYbVeCi+OZwKomUpyRRSNx3nlOirmes5Cp1VvZZpq4mUOMf6izD4Yw2TFBEUDK1Prwu9GygNQhSLKAzlLTolhoXhiqfCpWZHF47Z2KPnF1gugCaJHFvU9xzsJ7TEWuKrlW5z11/gW4whYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370858; c=relaxed/simple;
	bh=FDmdJsva6PhVAruik3JBwqxF0r/t249ybkFPnUQ8UnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=liOH8sL6rX2bLFszcn6aABE9qMAKFD7GVwCG1+4trf2i1L8iJkNYVBvprEfCmv1XEtYbZcBE/Cwd+lwUC6hXCwonGaoMiMxSenzCSRqHllYLYuECoFnv29aRXmDzyJeegaHtWF2Qri7ywctiL6dmGxunwh2ZgzztTLPHWPCPBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kpmTxZPG; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kpmTxZPG"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ee1f9bso18004875ad.3
        for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 00:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789370856; x=1789975656; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1JAD9tmGDUmLFmmjsY5lDiINw+bhtxWNRT0fitk2tyM=;
        b=kpmTxZPG0ggYaB0TPKaXFghDTeg2fT7auPYDjYSZO+VPRpX4neF5wISVZhxHRM425l
         gKrhXMQMWjhUe9eaHGhKTRSNou20BPek/jD7IU7APPO+nCbGqGsfLItLjLuCsXDD40w8
         ZrJA9JjCnuoRkKeTT3q1IQl713Pj2lh/PkkV/b0/8riVtjV2MqxrK9UmnCEBue0LZdGI
         3N49BxT6uPWO0s5rA+z7Orp8/4/6jv3bPDPDhnJhnE4et+WYK9Nx8+Dn7jthTR+SuXdm
         I/kLdrgRsVtwGHw2nDFsEqe4vUdXDXKFpxom8CvQAiHLFEJEoKi+Em8ioPPd38FA03Ew
         O7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789370856; x=1789975656;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1JAD9tmGDUmLFmmjsY5lDiINw+bhtxWNRT0fitk2tyM=;
        b=aOjM2AQCUOumPCim+bvVhr1Jhic6HywJpoez9v8qavQ7NMDarCQvREXwEwJDBg8Ze+
         urfqaGGWb+QMVcMV5seJygBYtXfrINRKgrerZMebF/Jz6RyrhQdGlr1xE7jqcNPmeuOe
         yt6YuQvzPPumVJn+ctvOyf939QxCjqCL+2Ytf2CNFiFoIWcm7QsDFgFMotOeBa4xqfGn
         /E0SJMez7/zgxIT2tsmg9LXEtQ+KEONjP7KMkEReNXOmH438PJ8ge3gEkOaxM1xn5NMQ
         XIbvIBb4ScS/VzZSYVU7DWK0i20IvAxQRj6/pD0CJbllspGZl9cvrCw5biAE3Oz9KORm
         dp/Q==
X-Gm-Message-State: AFuF++m48CznxVjbmeoYVqySYzAirbuvZIntgA3zxu7SFhpzqSZe/uWE
	XnFRkHLImrPmPNxv18bBraUuZNqygxL/CzQKeGUlQBJY0I4PmOJrtxggCs+EzFU9xjE=
X-Gm-Gg: AYBFou3DwRSEtdV1o5yMeJaGQ05mp14LcCie8DmTBE2076nGv2u9vWJHp8lR5KItfQw
	IAXFT7hH0L2xslMMzDr9izyOoZGTe7X8N/bs9OsUUYfo8Ab2joGyw5aufuMQmZDyIcoB5x38FkL
	K34466eHZj/qx65V4p+lWNQeWslu2nfdEMMuSFaXKD9r9DdZC/x7L2ZfbMruRGnyDzVHq1U8Gv8
	yFSgNz34EnBkjHo4ytFV8tQqrGtpsXWMglLfpP0k+SceKkfx2YnKhPjk7LXk2TdK2tXlgNXjM81
	Wx4/IOMa4uTGJzITm3w/aD9f9Y2HZuu4D9Eu/BO6jujxTAjJZggew7cTWSRGsx5TMy33/Pr0e/Z
	hA7z1gqlWt5C6qnFBYN1/3DIHGRUaNxpcevEt4TbhpK6Vf/2gvW1XaWHMp5gosfA6gX10xIQHrD
	I/Y1CxaAK+WAxDmz6qDNayvMy6EU89EilMXFj2Rvlk7VypvyVvksUKav2XLYAMaudhGoP6/vce5
	bb5hpnaaYgBUKeFDWxi5kYEpH1Tlg==
X-Received: by 2002:a17:902:fc4c:b0:2d9:123c:8c49 with SMTP id d9443c01a7336-2dd6c6db8b7mr32241015ad.14.1789370855896;
        Mon, 14 Sep 2026 00:27:35 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd5650198csm21446345ad.84.2026.09.14.00.27.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 00:27:35 -0700 (PDT)
Message-ID: <999d5aab-d84b-45c2-96d4-ce809a111d48@gmail.com>
Date: Mon, 14 Sep 2026 15:27:28 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/31] ext4: submit and wait for pending disksize-grow
 I/O on writeback
To: sashiko-reviews@lists.linux.dev, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-23-yi.zhang@huaweicloud.com>
 <20260903134042.5E0251F00A3F@smtp.kernel.org>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <20260903134042.5E0251F00A3F@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/2026 9:40 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Single-threaded workqueue stall causing filesystem-wide deadlock on concurrent write and writeback due to WB_SYNC_NONE skipping locked folios.
> --

I don't think this case can happen. A folio which is temporarily locked
by a writer is not skipped: writeback_get_folio() takes the folio lock
with a blocking folio_lock(), and the only folio WB_SYNC_NONE drops is
one already under writeback, i.e. whose I/O has already been submitted
with EXT4_IOMAP_IOEND_DISKSIZE_GROW_IO set (the flag is applied at
submission time in ext4_iomap_writeback_submit()), so the state is
cleared in ext4_iomap_end_bio().  That clearing happens in the bio
completion path, in softirq context, not in the rsv_conversion worker,
so a blocked worker cannot prevent it.

The jbd2 link doesn't hold either: inodes on the iomap buffered I/O path
do not use data=ordered, so they are never added to the transaction's
ordered list and journal_finish_inode_data_buffers() never waits for
their PG_writeback.

Thanks,
Yi.

> 
> commit 8015bea7c1654bcaea86ce738fcb50400fa35290
> Author: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4: submit and wait for pending disksize-grow I/O on writeback
> 
> This commit introduces a mechanism to proactively submit and wait for pending
> disksize-grow zeroed EOF blocks during writeback. This prevents stale data
> exposure when advancing i_disksize.
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 383824e89d123..4c2b6cd15d1f9 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
> [ ... ]
>> +static void ext4_iomap_wb_submit_zeroed_eof(struct inode *inode,
>> +					    struct writeback_control *wbc)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	loff_t pstart, plen, range_start;
> [ ... ]
>> +	/* Keep the caller's sync mode to avoid stalling the background flusher. */
>> +	if (wbc->sync_mode == WB_SYNC_ALL)
>> +		filemap_fdatawrite_range(mapping, pstart, pstart + plen - 1);
>> +	else
>> +		filemap_flush_range(mapping, pstart, pstart + plen - 1);
> 
> [Severity: Critical]
> Could this WB_SYNC_NONE flush silently skip a locked folio, leaving the pending
> EOF block unsubmitted?
> 
> If a user-space thread is concurrently modifying a folio covering the pending
> zeroed EOF block (which has EXT4_STATE_DISKSIZE_GROW_PENDING set), the folio
> will be temporarily locked.
> 
> When background writeback (kupdate) flushes a subsequent range, it will call
> filemap_flush_range() here, which uses WB_SYNC_NONE and skips locked folios
> without submitting their I/O.
> 
>> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
>> index 9b0e12b5463cf..697e12a54a49a 100644
>> --- a/fs/ext4/page-io.c
>> +++ b/fs/ext4/page-io.c
> [ ... ]
>> @@ -594,6 +622,9 @@ static void ext4_iomap_finish_ioend(struct iomap_ioend *ioend)
>>   	    end <= READ_ONCE(EXT4_I(inode)->i_disksize))
>>   		goto out;
>>   
>> +	/* Wait for disksize-pending zeroed data to be written out. */
>> +	ext4_iomap_wb_disksize_pending_wait(inode, pos, size);
> 
> [Severity: Critical]
> Does this wait cause a permanent filesystem-wide deadlock if the pending EOF
> block was skipped during WB_SYNC_NONE?
> 
> If the locked EOF folio was skipped by ext4_iomap_wb_submit_zeroed_eof(), the
> I/O for the subsequent range will complete and queue its ioend on the
> single-threaded sbi->rsv_conversion_wq. The worker thread will unconditionally
> block here waiting for the unsubmitted EOF block's I/O to complete.
> 
> This stalls the entire workqueue. Later, the jbd2 commit thread runs and blocks
> in filemap_fdatawait() waiting for the PG_writeback bit of the subsequent range
> to clear, which only happens at the end of ext4_iomap_finish_ioend() via
> iomap_finish_ioends().
> 
> Finally, kupdate attempts to write another file with delayed allocation,
> blocking in ext4_journal_start() waiting for jbd2. Because kupdate is now
> deadlocked, it will never loop back to write out the skipped EOF folio,
> resulting in a permanent circular deadlock.
> 

