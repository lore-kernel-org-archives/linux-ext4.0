From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 0/3] ext4: don't use quota reservation for speculative
 metadata blocks
Date: Thu, 08 Apr 2010 10:28:16 -0500
Message-ID: <4BBDF610.8030906@redhat.com>
References: <4BBCFD10.3030504@redhat.com> <87sk76tkx9.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab0DHP2W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Apr 2010 11:28:22 -0400
In-Reply-To: <87sk76tkx9.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>> Because we can badly over-reserve metadata when we
>> calculate worst-case, it complicates things for quota, since
>> we must reserve and then claim later, retry on EDQUOT, etc.
>> Quota is also a generally smaller pool than fs free blocks,
>> so this over-reservation hurts more, and more often.
>>
>> I'm of the opinion that it's not the worst thing to allow
>> metadata to push a user slightly over quota.  This simplifies
>> the code and avoids the false quota rejections that result
>> from worst-case speculation.
> Hm.. Totally agree with issue description. And seem there is no another
> solution except yours.
> ASAIU alloc_nofail is called from places where it is impossible to fail
> an allocation even if something goes wrong.
> I ask because currently i'm working on EIO handling in alloc/free calls.
> I've found that it is useless to fail claim/free procedures because
> caller is unable to handle it properly.
> It is impossible to fail following operation
> ->writepage
>  ->dquot_claim_space (what to do if EIO happens?)

Hm, if these start returning EIO then maybe my patch should be modified
to treat EDQUOT differently than EIO ... assuming callers can handle
the return at all.

In other words, make NOFAIL really just mean "don't fail for EDQUOT"

-Eric
