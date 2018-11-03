Return-Path: <SRS0=UtPy=NO=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out0-149.mail.aliyun.com ([140.205.0.149]:36535 "EHLO
        out0-149.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeKCOZ6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Nov 2018 10:25:58 -0400
Date: Sat, 03 Nov 2018 13:15:43 +0800
From: "=?UTF-8?B?546L5bCP5YWJKOi0ueabvCk=?=" <feiman.wxg@alibaba-inc.com>
To: "'Jan Kara'" <jack@suse.cz>,
        "'Fisher'" <fisherthepooh@protonmail.com>
Cc: <linux-ext4@vger.kernel.org>
Message-ID: <3c8a2760-7e8c-448f-b1e4-861641679a81.feiman.wxg@alibaba-inc.com>
Subject: =?UTF-8?B?562U5aSNOiBXaHkgbm90IGFsd2F5cyBkbyBjb3B5LW91dCBpbiBqYmQyX2pvdXJuYWxfd3Jp?=
  =?UTF-8?B?dGVfbWV0YWR0YV9idWZmZXI=?=
MIME-Version: 1.0
Content-Language: zh-cn
In-Reply-To: <20181025114156.GB7711@quack2.suse.cz>
References: <usGdshd4UQ6wFx4jVDkzY1xddFnUnT7NXj6IWA-uVczdSc5_TmczQvtmULxNVQ3reUPTmyQd2YeLhPa_L2uPbaNdfBPVlLz7rQQ9oC7aSkw=@protonmail.com> <20181025114156.GB7711@quack2.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi jan,

>
>Hi,
>
>On Mon 22-10-18 10:34:48, Fisher wrote:
>> Recently I was testing my storage's performance and found that there
>> were periodic performance drops when I ran sequential write benchmark.
>> After profiling the duration in each step, I found that the dropping
>> performance was due to wait_on_bit_io(&bh->b_state, BH_Shadow,
>> TASK_UNINTERRUPTIBLE) in do_get_write_access(). And this is what made
>> me confused, if my understanding was right, I thought
>> buffer_shadow(bh) stands for buffer not being copied-out that's why we
>should wait.
>
>No buffer_shadow() just means that some version of the buffer is being
written
>to the journal.
>
>> But why don't we do copy-out in jbd2_journal_write_metadta_buffer()?
>> and if we do do the copy-out, does that mean we don't have to
>> set_buffer_shadow because it refers to buffer not copied-out?
>
>The code in do_get_write_access() checks whether the buffer already has
>frozen data (by checking jh->b_frozen_data) and if not, if it is just being
written
>to the journal (buffer_shadow() check in there). If it is, we have to wait
because
>we cannot modify the version of the buffer that goes to the journal.
>
>> I made a test, when a buffer_head goes into
>> jbd2_journal_write_metadta_buffer(), as long as it belongs to
>> metadata, then force it to do copy-out and do not set_buffer_shadow,
>> then there will be no periodic performance drops. Is this test
reasonable?
>
>Well, it does trade of CPU overhead (you know copy buffer for each
>transaction) for the latency (no need to wait for buffer writeout when
>redirtying buffer). Usually I wouldn't consider this worth it but obviously
it
>depends on the workload...
I also run into this issue.
In do_get_write_access(), there are such comments:
/*
	 * There is one case we have to be very careful about.  If the
	 * committing transaction is currently writing this buffer out to
disk
	 * and has NOT made a copy-out, then we cannot modify the buffer
	 * contents at all right now.  The essence of copy-out is that it is
	 * the extra copy, not the primary copy, which gets journaled.  If
the
	 * primary copy is already going to disk then we cannot do copy-out
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      I wonder why we can not do copy-out here? We can not visit this buffer
while it's
      going to disk? 

	 * here.
	 */
	if (buffer_shadow(bh)) {
		JBUFFER_TRACE(jh, "on shadow: sleep");
		jbd_unlock_bh_state(bh);
		wait_on_bit_io(&bh->b_state, BH_Shadow,
TASK_UNINTERRUPTIBLE);
		goto repeat;
	}

Regards,
Xiaoguang Wang


>
>								Honza
>--
>Jan Kara <jack@suse.com>
>SUSE Labs, CR
