From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Tue, 27 Oct 2009 08:56:53 -0500
Message-ID: <4AE6FC25.3000801@redhat.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>	 <4AE67A1B.8060704@redhat.com> <a125a870910270117qa90debp8d5a9f90ffb8434@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Fredrik Andersson <nablaman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZJ0N4y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Oct 2009 09:56:54 -0400
In-Reply-To: <a125a870910270117qa90debp8d5a9f90ffb8434@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fredrik Andersson wrote:
>> Not trying to ignore you, but trying to sort out some corruption issues that
>> I'm afraid I have to rank higher than a hang for now...
> 
> I understand. Good to know someone is thinking about it anyway :-)
> 
>> From the traces, things are hung up on the i_data_sem; several pdflushes
>> want it for read in ext4_get_blocks_wrap, and drbdmakes presumably have it
>> downed for write in ext4_ext_truncate.  I'm not immediately seeing the
>> deadlock tonight, but then it's getting late...
>>
>> Is the application that's triggering this something you can share?
>>
> 
> Sorry, I can't provide source code for these applications.

Ok, I understand

> But drdbmake does what is described above: Preallocates a very big
> chunk on disk and then
> truncates it to its final length once it's done.

To try to emulate, how does it write into the preallocated space; large 
or small IOs?  Sequential streaming?  mmap writes?  It may not be 
relevant but would be nice to try to match it as closely as possible.

Thanks,
-Eric

> Please let me know if you need more details.
> 
> /Fredrik

