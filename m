From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: why unlikely(rsv) in ext3_clear_inode()?
Date: Mon, 27 Oct 2008 20:09:01 -0400
Message-ID: <170fa0d20810271709v1c6738co68fe7db339b31557@mail.gmail.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com>
	 <1225151532.6685.31.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Steven Rostedt" <rostedt@goodmis.org>
To: "Mingming Cao" <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:62136 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYJ1AJD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2008 20:09:03 -0400
Received: by ey-out-2122.google.com with SMTP id 6so937501eyi.37
        for <linux-ext4@vger.kernel.org>; Mon, 27 Oct 2008 17:09:01 -0700 (PDT)
In-Reply-To: <1225151532.6685.31.camel@mingming-laptop>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 27, 2008 at 7:52 PM, Mingming Cao <cmm@us.ibm.com> wrote:
>
> 在 2008-10-27一的 18:29 -0400，Mike Snitzer写道：
>> Please see: e6022603b9aa7d61d20b392e69edcdbbc1789969
>>
>> Having a look at the LKML archives this was raised back in 2006:
>> http://lkml.org/lkml/2006/6/23/337
>>
>> I'm not interested in whether unlikely() actually helps here.
>>
>> I'm still missing _why_ rsv is mostly NULL at this callsite, as Andrew
>> asserted here:
>> http://lkml.org/lkml/2006/6/23/400
>>
>> And then Steve here: http://lkml.org/lkml/2006/6/24/76
>> Where he said:
>> "The problem is that in these cases the pointer is NULL several thousands
>> of times for every time it is not NULL (if ever).  The non-NULL case is
>> where an error occurred or something very special.  So I don't see how
>> the if here is a problem?"
>>
>> I'm missing which error or what "something very special" is the
>> unlikely() reason for having rsv be NULL.
>>
>> Looking at the code; ext3_clear_inode() is _the_ place where the
>> i_block_alloc_info is cleaned up.  In my testing the rsv is _never_
>> NULL if the file was open for writing.  Are we saying that reads are
>> much more common than writes?  May be a reasonable assumption but
>> saying as much is very different than what Steve seemed to be eluding
>> to...
>>
>
> i_block_alloc_info as the structure to keep track of block
> reservation/allocation,  is dynamically allocated when file does need
> blocks. So rsv remains NULL even if file is open for rewrite,  until
> file is about to do block allocation.

Yes, i_block_alloc_info is only allocated when a block must be allocated...

I over simplified this by making the distinction of the file open for
writing.  My intent was to point out that allocating blocks for writes
isn't that uncommon.

I was mainly just looking for clarification on i_block_alloc_info's
life-cycle... based on Steve's comment from 2006 I thought I might be
missing something.  It doesn't really look like I was.

regards,
Mike
