From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4_fallocate
Date: Tue, 26 Jun 2012 15:22:01 -0400
Message-ID: <4FEA0BD9.8060101@redhat.com>
References: <4FE8086F.4070506@zoho.com> <20120625085159.GA18931@gmail.com> <20120625191744.GB9688@thunk.org> <4FE9B57F.4030704@redhat.com> <20120626173050.GA6745@thunk.org> <4FE9FDA4.60509@redhat.com> <20120626185721.GA26669@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2FZTVP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jun 2012 15:21:15 -0400
In-Reply-To: <20120626185721.GA26669@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/26/2012 02:57 PM, Ted Ts'o wrote:
> On Tue, Jun 26, 2012 at 02:21:24PM -0400, Ric Wheeler wrote:
>> It would be interesting to see if simply not doing the preallocation
>> would be easier and safer. Better yet, figure out how to leverage
>> trim commands to safely allow us to preallocate and not expose other
>> users' data (and not have to mark the extents as allocated but not
>> written).
> TRIM is applicable to SSD's and enterprise storage arrays.  It's not
> applicable HDD's.

and device mapper can also support TRIM these days with the thinly provisioned 
lun targets (although this just moves the multiple IO issues down to device 
mapper :))

We would only use it when the device supports it of course. Also note that you 
can use WRITE_SAME on pretty much any drive (although again, it can be slow).

>
>> This is not a theory guy worry. I would not use any server/web
>> service that knowingly enabled this hack in a multi-user machine and
>> would not enable it for any enterprise customers.
> Sure, but for single-user or for dedicated cluster file system server,
> it makes sense; it's not not going to be useful for all customers,
> sure, but for some customers it will make sense.

The danger is that people use that google thing and see "ext4 performance 
improvement" and then turn it on without understanding what they bought. Believe 
me, I deal with that *a lot* in my day job :)

>
>> We should be very, very careful not to strip away the usefulness of
>> file system just to cater to some users.
> A mount option or a superblock flag does not "strip away the
> usefulness of the file system".  It makes it more useful for some use
> cases.
>
> Your alternate proposals (preinitializing the space with zeros, using
> trim, writing larger chunks) will work for some use cases, certainly.
> But it's not going to be sufficient for at least some use cases, or
> they will simply not work.

I think that for the use case discussed in this thread it would probably work 
quite well, but always worth testing of course.

>
> Fundamentally it sounds to me the biggest problem is that you don't
> trust your customers, and so you're afraid people will use the
> no-hide-stale feature if it becomes available, even if it's not needed
> or if it's needed but you're afraid that they don't understand the
> security tradeoffs.
>
> 					- Ted

No Ted, we don't trust exposing other customers data in order to cover up a poor 
design that other file systems don't suffer from.

Ric



