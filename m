From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: "block_dump, bd" in debugfs
Date: Thu, 27 Jun 2013 12:51:13 -0400
Message-ID: <51CC6D81.4040105@redhat.com>
References: <20130627030513.217820@gmx.com> <51CBB405.2080401@redhat.com> <87d2r83xf1.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Nick Dokos <ndokos@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3F0QvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Jun 2013 12:51:16 -0400
In-Reply-To: <87d2r83xf1.fsf@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 6/27/13 2:00 AM, Nick Dokos wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>> On 6/26/13 11:05 PM, jon ernst wrote:
>>  ...
>>> Also at the beginning of each line. The output pattern is "0000,
>>> 0020, 0040, 0060, 0100, 0120", where are numbers such as"0080,"?
>>
>> Identical lines are suppressed, similar to what hexdump does by
>> default.  You might have had a "*" in between?
>>
> 
> Offsets are octal, so there is no 0080: adding octal 020 to
> octal 0060 gets you to octal 0100.
> 

Oh right, that too.  :)  Thanks.

-Eric
