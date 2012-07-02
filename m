From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_fallocate
Date: Mon, 02 Jul 2012 13:48:15 -0400
Message-ID: <4FF1DEDF.90105@redhat.com>
References: <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <20120702031611.GB2406@gmail.com> <4FF1CD5D.8010904@redhat.com> <20120702174421.GM6679@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab2GBRrg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2012 13:47:36 -0400
In-Reply-To: <20120702174421.GM6679@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/02/2012 01:44 PM, Jan Kara wrote:
> On Mon 02-07-12 11:33:33, Eric Sandeen wrote:
>> On 07/01/2012 10:16 PM, Zheng Liu wrote:
>>> Hi Eric,
>>>
>>> Could you please run this test with 'journal_async_commit' flag.  In my
>>> previous test, this feature can dramatically improve the performance of
>>> uninitialized extent conversion.
>>>
>>> I have sent an email to do a similar test [1].  In that email, I do a
>>> similar test and the journal_async_commit flag quite can improve the
>>> performance.
>> I can try to find time for that, but so far I haven't actually seen any
>> severe impact of conversion on a non-debug kernel.  And didn't Jan think
>> that journal_async_commit was fatally flawed?
>    Yes, that option is broken and basically unfixable for data=ordered mode
> (see http://comments.gmane.org/gmane.comp.file-systems.ext4/30727). For
> data=writeback it works fine AFAICT.
>
> 								Honza

I think that we need to start with the basics - let's find a specific work load 
that we can use to validate the performance. In Eric's testing, nothing really 
jumped out.

What type of disk, the specific worst case IO size, etc would be great (and even 
better, if someone has a real world, non-synthetic app that shows this).

Definitely more interesting I think to try and do the MB size extent conversion, 
that should be generally a good technique to minimize the overhead.

thanks!

Ric


