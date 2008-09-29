From: vineetagarwal <checkout.vineet@gmail.com>
Subject: Re: Block allocation
Date: Mon, 29 Sep 2008 05:01:38 -0700 (PDT)
Message-ID: <19722589.post@talk.nabble.com>
References: <19703506.post@talk.nabble.com> <20080927215059.GA5025@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:35516 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYI2MBj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Sep 2008 08:01:39 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1KkHRa-0008Ez-5E
	for linux-ext4@vger.kernel.org; Mon, 29 Sep 2008 05:01:38 -0700
In-Reply-To: <20080927215059.GA5025@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


thank you for replying .
well iam working on a project where i need to allocate few blockgroups for
manipulation of data.
yeah i can write the code but i was actually thinking that could i somehow
manipulate the code at top level of allocation , so that not much changes


Theodore Ts'o wrote:
> 
> On Sat, Sep 27, 2008 at 08:07:06AM -0700, vineetagarwal wrote:
>> 
>> I want to allocate few blocks from a blockgroup in ext2 within a range of
>> offset specified by user. Is it possible of doing so if yes then can
>> someone
>> please explain.As i know balloc.c and ialloc.c are responsible for it and
>> they work on entire file system can i somehow manipulate it for ceratin
>> ranges.
>> 
>> For Ex
>> let say i provide a range 100 - 3000. Can i allocate few blocks within
>> this
>> range .
> 
> While the filesystem mounted (and accessed through the kernel) or
> unmounted (and accessed via libext2fs)?  Anything is possible. if you
> are willing to write some code....
> 
> Why do you need to do this, and is this for some class or problem set?
> 
>        	   	      	    	   	- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
View this message in context: http://www.nabble.com/Block-allocation-tp19703506p19722589.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

