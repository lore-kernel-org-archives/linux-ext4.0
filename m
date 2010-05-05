From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: Do not dec quota for reserved blocks on error paths v2
Date: Wed, 05 May 2010 11:05:02 +0400
Message-ID: <87wrvihlr5.fsf@openvz.org>
References: <87633dcxhp.fsf@openvz.org> <87bpd3ecya.fsf@openvz.org>
	<4BE08215.2050603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:49323 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0EEHFH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 03:05:07 -0400
Received: by bwz25 with SMTP id 25so2711800bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 05 May 2010 00:05:05 -0700 (PDT)
In-Reply-To: <4BE08215.2050603@redhat.com> (Eric Sandeen's message of "Tue, 04
	May 2010 15:22:45 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> Dmitry Monakhov wrote:
>> If we have failed some where inside ext4_get_blocks() internals we may
>> have allocated some new blocks, which was not yet claimed to quota.
>> We have to free such blocks, but without touching quota. Quota will
>> be updated later on exit from ext4_get_blocks().
>> There are two possible ways to understand what we have to skip quota update:
>> 1) Caller pass corresponding flag to ext4_free_blocks()
>> 2) check that free_blocks() was indirectly called by get_blocks() 
>>    (i.e EXT4_I(inode)->i_delalloc_reserved_flag is set)
>> Second is simpler, but may result in unpredictable consequences later.
>> So i've chosen the first one, because caller must know which blocks it
>> is freeing.
>> 
>> Eric, please take your attention to metadata blocks handling when
>> you will work on new versing of  "ext4: don't use quota reservation for
>> speculative metadata blocks" patch.
>> 
>> The bug happens on heavily loaded node, or with 227'th xfstestcase and
>
> hm which test?  227 is xfs-only...
Oh.. it has that number at the time i've posted it, and it wasn't
merged yet.
http://marc.info/?l=linux-ext4&m=127124399930095&w=2
You have already requested some cleanups, so i'll post new version,
under new number, soon.
>
> -Eric
>
>> result in incorrect i_blocks (less than expected). So truncation for
>> that file result in i_blocks overflow.
>> Seems this was the last bug which was easily triggered by 227'th testcase.
>> 
>> 
