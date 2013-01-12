From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: add debug switch to use old online interface
Date: Fri, 11 Jan 2013 18:33:13 -0600
Message-ID: <50F0AF49.6010902@redhat.com>
References: <50F05175.8060502@redhat.com> <20130112003027.GA9550@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3ALAdQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2013 19:33:16 -0500
In-Reply-To: <20130112003027.GA9550@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 1/11/13 6:30 PM, Theodore Ts'o wrote:
> On Fri, Jan 11, 2013 at 11:52:53AM -0600, Eric Sandeen wrote:
>> --- a/resize/resize2fs.h
>> +++ b/resize/resize2fs.h
>> @@ -76,6 +76,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
>>  #define RESIZE_DEBUG_BMOVE		0x0002
>>  #define RESIZE_DEBUG_INODEMAP		0x0004
>>  #define RESIZE_DEBUG_ITABLEMOVE		0x0008
>> +/* old online resize interface */
>> +#define RESIZE_DEBUG_OLD		0x0010
> 
> 0x0010 is already used for
> 
> #define RESIZE_DEBUG_RTRACK		0x0010
> 
> (which is very useful for performance tuning resize2fs).

Ugh, how did I miss that.  Sorry.

> I wonder if we would be better off using a environment variable for
> this?  Mainly because currently, the current resize flags don't
> actually change the behavior of resize2fs, but just add different
> levels of debugging messages. 

The mechanism doesn't matter to me, we just need to be able to test
it if the interface is in the kernel.  I had originally had an "-o"
option for "old interface" but that didn't seem great.

-Eric

> 
> 						- Ted
> 

