From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] ext4: Do not allow retry alloc loop under open transaction
Date: Thu, 04 Feb 2010 15:06:31 +0300
Message-ID: <877hqtdx2w.fsf@openvz.org>
References: <874olytbpe.fsf@openvz.org> <87wrytqlji.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39010 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab0BDMGh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Feb 2010 07:06:37 -0500
Received: by bwz19 with SMTP id 19so198181bwz.28
        for <linux-ext4@vger.kernel.org>; Thu, 04 Feb 2010 04:06:35 -0800 (PST)
In-Reply-To: <87wrytqlji.fsf@linux.vnet.ibm.com> (Aneesh Kumar K. V.'s message
	of "Thu, 04 Feb 2010 17:07:21 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> writes:

> On Wed, 03 Feb 2010 21:27:31 +0300, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> 
>> Some times we call ->write_begin() with opened journal
>> but write_begin() may internally call ext4_should_retry_alloc()
>> in case of ENOSPC, which result in deadlock.
>> This patch introduce new AOP_FLAG which should be tested on retry
>> alloc path.
>> 
>
> Can you explain this further. We do a journal_stop before
> ext4_should_retry_alloc. So not sure about the deadlock.
move_extent_per_page
 ext4_journal_start  -> current->journal_info != NULL
 ->write_begin
    ext4_journal_start
    ext4_journal_stop
    ext4_should_retry_alloc : here current->journal_info != NULL

Sorry i've missed the fact that ext4_should_retry_alloc() check 
for current->journal_info and skip running transaction in that case.
Seems what this check was added long time ago, but i miss it.
So this patch is useless.
>
> -aneesh
