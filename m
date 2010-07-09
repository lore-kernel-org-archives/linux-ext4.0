From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Ext3: batched discard support
Date: Fri, 09 Jul 2010 06:18:15 -0400
Message-ID: <4C36F767.3060103@redhat.com>
References: <1278508727-29135-1-git-send-email-lczerner@redhat.com> <AANLkTil_Y6rjgbAjQcOqTeFUt1WO46MNKFp5Qe4iSK3z@mail.gmail.com> <alpine.LFD.2.00.1007091050190.2867@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	linux-ext4@vger.kernel.org, jmoyer@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, Jan Kara <jack@suse.cz>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0GIKSa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Jul 2010 06:18:30 -0400
In-Reply-To: <alpine.LFD.2.00.1007091050190.2867@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/09/2010 04:53 AM, Lukas Czerner wrote:
> On Wed, 7 Jul 2010, Greg Freemyer wrote:
>
>> On Wed, Jul 7, 2010 at 9:18 AM, Lukas Czerner<lczerner@redhat.com>  wrote:
>>>
>>> Hello again,
>>>
>>> I have composed a set of patches to add batched discard support for Ext3 file
>>> system. Functionality is basically the same as in "batched discard support
>>> for Ext4" (see http://www.spinics.net/lists/linux-ext4/msg19827.html ).
>>>
>>> There are two patches:
>>
>> I'm inclined to review these, but before I do, I thought ext3 was
>> closed to patches like this.
>>
>> Or is it still accepting more new functionality than I thought?
>>
>> Greg
>>
>
> Hi, Greg
>
> thanks for your interest ! Unfortunately it seems like you are right,
> I was suspecting something like that. Anyway I am not the one who make
> those decisions...so anyone ?
>
> Thanks
>
> -Lukas

Not sure how much we want to move into ext3, but I think that Jan is the person 
to make that call.

Discard support got stuck into several other file systems and would be useful 
for ext3.

Jan, Ted, what do you both think about these patches?

Thanks!

Ric


