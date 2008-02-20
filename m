From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [E2FSPROGS, RFC] New mke2fs types parsing
Date: Wed, 20 Feb 2008 16:28:49 -0600
Message-ID: <47BCA9A1.5030901@redhat.com>
References: <E1JRpaN-0000Bs-4N@closure.thunk.org> <47BC76A9.307@redhat.com> <20080220222019.GG30305@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYBTW2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Feb 2008 17:28:53 -0500
In-Reply-To: <20080220222019.GG30305@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Feb 20, 2008 at 12:51:21PM -0600, Eric Sandeen wrote:
>> Theodore Ts'o wrote:
>>> The following patch is a work in progress, but I'm sending it out so
>>> folks can take a look at it and comment on the general approach.
>>>
>>> What this does is change how mke2fs -T works so it can take a comma
>>> separated list, so you can do things like this:
>>>
>>> 	  mke2fs -T ext4,small,news
>> Is there some hierarchy of what these options are and how they fit
>> together?  i.e. small & news might go together (in bizarro world...) but
>> "small,large" wouldn't make sense - nor would -T ext3,ext4.  Or, if
>> somebody stores mail & news on the same fs, nad they say -T mail,news
>> but the mail & news types have conflicting directives...
>>
>> how will you define what an acceptable composite of subtypes will be?
> 
> There are only three things which mke2fs will do, in my design:

I apologize if I was too quick to ask a dumb question rather than
atually read through the patch, but thank you for the text explanation :)

-Eric
