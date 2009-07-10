From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: Question on huge_file
Date: Fri, 10 Jul 2009 09:31:20 -0700
Message-ID: <6601abe90907100931v40cf7b97h243642a469689ac5@mail.gmail.com>
References: <6601abe90907100832q6ab886f2r7fc8e3be2a79e8e5@mail.gmail.com>
	 <4A5760A7.60607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:22523 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbZGJQb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jul 2009 12:31:26 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id n6AGVN7x000331
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 17:31:23 +0100
Received: from wf-out-1314.google.com (wfg24.prod.google.com [10.142.7.24])
	by wpaz21.hot.corp.google.com with ESMTP id n6AGVFto000737
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 09:31:21 -0700
Received: by wf-out-1314.google.com with SMTP id 24so277450wfg.20
        for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2009 09:31:20 -0700 (PDT)
In-Reply-To: <4A5760A7.60607@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric:

On Fri, Jul 10, 2009 at 8:39 AM, Eric Sandeen<sandeen@redhat.com> wrote=
:
> Curt Wohlgemuth wrote:
>> I apologize if this is a dumb question, but I'm having trouble
>> understanding the huge_file superblock flag.
>>
>> I see how, if this flag is set, that the inode can have a size > 2**=
32
>> bytes, using the i_size_lo/i_size_high fields.
>>
>> But since an ext4_extent only uses 32-bits for for its ee_block fiel=
d
>> to represent the logical block, how can an extent describe any block
>> range of a file past the 4GiB boundary?
>>
>> Am I missing something?
>
> i_size_lo/hi is in bytes, ee_block is in .... blocks.
>
> so 2^32 blocks is a lot more than 2^32 bytes, and i_size_hi/lo are
> needed to contain it. =A0I think. =A0:)

Oops.  Of course.  I knew it had to be something simple.

Thanks,
Curt
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
