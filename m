From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs over thin provisioning talk
Date: Fri, 6 Dec 2013 10:45:27 -0200
Message-ID: <20131206124525.GB13931@orion.maiolino.org>
References: <20131202165611.GA23816@orion.maiolino.org>
 <20131204032351.GC15658@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3LFMpb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Dec 2013 07:45:31 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rB6CjVp0027897
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 6 Dec 2013 07:45:31 -0500
Received: from orion.maiolino.org (ovpn-113-67.phx2.redhat.com [10.3.113.67])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rB6CjROx018346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 6 Dec 2013 07:45:30 -0500
Content-Disposition: inline
In-Reply-To: <20131204032351.GC15658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted.

> > For those interested, the slides can be downloaded here:
> > http://people.redhat.com/~cmaiolin/talks/XFS-dmthin.pdf
> 
> Hi Carlos,
> 
> Thanks for sending these slides.  They are very interesting indeed.
> 
> Lukas mentioned that you had run some tests using ext4 and it didn't
> do well at all using dm-thin?  Given that we're not doing proper raid
> strip alignment in our allocation decisions, that's not too
> surprising, but it would be useful if there are other things that we
> should do in order to do a better job working with dm-thin drives.
> 

Ted, my apologies, when I ran the tests over ext4, I didn't save the results
since I wasn't going to compare ext4 and xfs, and I really didn't think about it
might be useful.

> One other question --- in your conclusion you say:
> 
>    Bypassing block zeroing while provisioning blocks adds a significant
>    boost to the dm-thin performance, but, it can induce a security
>    breach, at the risk of exposing stale data
> 
> This might be true if you are directly giving dm-thin volumes to
> mutually suspicious VM's with different trust boundaries.  But if you
> trust the file system, and the dm-thin devices are mediated by the a
> file system running in the same context as the dm-thin volumes, there
> wouldn't be any security issue, correct?
>
Yes, you're correct, if you trust who is using the block device and it's not
'public' like you said (a block device given to a VM, like a public VM host
, amazon for example), there is no security issue.

Although, dm-thin should have an algorithm to bypass the block device zeroing
step in case you're writing a whole block. But, at the time of my talk, it was
buggy :)

> Cheers,
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
