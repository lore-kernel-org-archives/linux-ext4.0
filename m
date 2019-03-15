Return-Path: <SRS0=fczw=RS=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81676C43381
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 01:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE92217F5
	for <linux-ext4@archiver.kernel.org>; Fri, 15 Mar 2019 01:18:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dP56ccAX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfCOBSj (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 21:18:39 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41881 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfCOBSj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Mar 2019 21:18:39 -0400
Received: by mail-oi1-f194.google.com with SMTP id k8so6017408oik.8
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 18:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=veKyPsgON6W1jbguJE/twHD29+Wll4L4ftLYMkCOF0c=;
        b=dP56ccAXzRgEjiqT3NRBIrKXflLJKST1eVP172FrCjH/V9i+c7M6Ku0FfOtxDqmYqt
         iuFAJjXDwig+EbK/o6RTbPEzH9c2FReO6+E19c0QEcqvhU4+uLtH8U253mIRLbfxBuLn
         9coxuXWX/ZnV9xvkQZ86HCBKB2OP1t3kXV8Q1RFyaah/QbORJHv1f0g+6SJtaiAlr6H/
         6mpmtBuOYy8l9X6l8ZUhvHV1fR5b1gGC6t74/R0TLqmqajO5WtRHryRX6essnBHHtjg8
         iNXeuen1yNs6Xd8X5HtPyOIPBjCvT5ON0PwqjO+cajGpDJXkqmmh5abIc+RE46XcrTeW
         1yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=veKyPsgON6W1jbguJE/twHD29+Wll4L4ftLYMkCOF0c=;
        b=Y1e3TFGYCMjP+yViC5nz79Ft8s2nkbl1w2UZ1J1BGR7phRubSD5mX16Pw/OBgNkz7W
         KfEzKi2CHGkWJ6bgE3o7/6oLqWcQGIkApkT/hAPa3nORNsd39jJMNpzyeySLo9JojUgp
         22Be38jI8mjOjx2WSRIBztEgWX76rBv4a1rhpyfyxIbCVVauMn5mompq8Cctn8S9NLGE
         VDVS270zj3Sw5lGlkxo9/yTDvIjOyTHKvMtrVXnaMDpyA2ai3EGivL9KmFtk0wT+qsgB
         Y5bQQP44N1S1PpckktSNltLLWCrzioo6m+faiFbSQnnHm21/yacvpoNtn+yen5gOPsfh
         G8eQ==
X-Gm-Message-State: APjAAAVCWI44/krmYcHkf2rpVD7e0wp8w9H3iDZ1Ij9//wZ7GBH3rC20
        vh+dzbHs2alF8q9O58U4d5E1XW/J
X-Google-Smtp-Source: APXvYqwtKgi/903J/G4TM7RZNqXKpzylsvP3LcZH3rf+VctrNfuRfLKEvsvvYTVfhy3MWvQg3yh4cA==
X-Received: by 2002:aca:c745:: with SMTP id x66mr54799oif.44.1552612718349;
        Thu, 14 Mar 2019 18:18:38 -0700 (PDT)
Received: from ali-186590e05fa3.local ([205.204.117.15])
        by smtp.gmail.com with ESMTPSA id k15sm258909otj.26.2019.03.14.18.18.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 18:18:37 -0700 (PDT)
Subject: Re: [PATCH] ext4: fix NULL pointer dereference while journal is
 aborted
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        linux-ext4@vger.kernel.org, tytso@mit.edu, Jan Kara <jack@suse.cz>
References: <20190311063528.112996-1-jiufei.xue@linux.alibaba.com>
 <82869475-fc3b-441e-e87b-866e9aa1d93b@linux.alibaba.com>
 <600cf315-b3bc-75f4-5816-757eef4d6689@linux.alibaba.com>
From:   Jiufei Xue <xuejiufei@gmail.com>
Message-ID: <90b21c16-b7e2-31e7-ba1e-510cb3e45495@gmail.com>
Date:   Fri, 15 Mar 2019 09:18:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <600cf315-b3bc-75f4-5816-757eef4d6689@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Hi Jan,

Could you spend some time to review this patch and give some feedback?

Thanks a lot.

Jiufei

On 2019/3/12 下午7:00, Jiufei Xue wrote:
> Hi Ted,
>
> Would you please review this patch?
>
> Thanks,
> Jiufei
>
> On 2019/3/11 下午2:45, Joseph Qi wrote:
>>
>> On 19/3/11 14:35, Jiufei Xue wrote:
>>> We see the following NULL pointer dereference while running xfstests
>>> generic/475:
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>>> PGD 8000000c84bad067 P4D 8000000c84bad067 PUD c84e62067 PMD 0
>>> Oops: 0000 [#1] SMP PTI
>>> CPU: 7 PID: 9886 Comm: fsstress Kdump: loaded Not tainted 5.0.0-rc8 #10
>>> RIP: 0010:ext4_do_update_inode+0x4ec/0x760
>>> ...
>>> Call Trace:
>>> ? jbd2_journal_get_write_access+0x42/0x50
>>> ? __ext4_journal_get_write_access+0x2c/0x70
>>> ? ext4_truncate+0x186/0x3f0
>>> ext4_mark_iloc_dirty+0x61/0x80
>>> ext4_mark_inode_dirty+0x62/0x1b0
>>> ext4_truncate+0x186/0x3f0
>>> ? unmap_mapping_pages+0x56/0x100
>>> ext4_setattr+0x817/0x8b0
>>> notify_change+0x1df/0x430
>>> do_truncate+0x5e/0x90
>>> ? generic_permission+0x12b/0x1a0
>>>
>>> This is triggered because the NULL pointer handle->h_transaction was
>>> dereferenced in function ext4_update_inode_fsync_trans().
>>> I found that the h_transaction was set to NULL in jbd2__journal_restart
>>> but failed to attached to a new transaction while the journal is aborted.
>>>
>>> Fix this by checking the handle before updating the inode.
>>>
>>> Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
>> Looks good.
>> Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>>
>>> ---
>>>  fs/ext4/ext4_jbd2.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
>>> index a1ac7e9245ec..75a5309f2231 100644
>>> --- a/fs/ext4/ext4_jbd2.h
>>> +++ b/fs/ext4/ext4_jbd2.h
>>> @@ -384,7 +384,7 @@ static inline void ext4_update_inode_fsync_trans(handle_t *handle,
>>>  {
>>>  	struct ext4_inode_info *ei = EXT4_I(inode);
>>>  
>>> -	if (ext4_handle_valid(handle)) {
>>> +	if (ext4_handle_valid(handle) && !is_handle_aborted(handle)) {
>>>  		ei->i_sync_tid = handle->h_transaction->t_tid;
>>>  		if (datasync)
>>>  			ei->i_datasync_tid = handle->h_transaction->t_tid;
>>>
