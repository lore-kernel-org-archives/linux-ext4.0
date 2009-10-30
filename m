From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 14354] Re: ext4 increased intolerance to unclean shutdown?
Date: Fri, 30 Oct 2009 08:54:27 -0500
Message-ID: <4AEAF013.60300@redhat.com>
References: <f7848160910152128h96237b7ga103915082d6412b@mail.gmail.com> <20091016091558.GA10184@mit.edu> <20091027101534.GA27584@skywalker.linux.vnet.ibm.com> <f7848160910291425q30377641qfe23e74fbc643d89@mail.gmail.com> <4AEA0B71.5050805@redhat.com> <20091030081602.GM18464@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Parag Warudkar <parag.lkml@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.k
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253AbZJ3Nyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Oct 2009 09:54:32 -0400
In-Reply-To: <20091030081602.GM18464@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Thu, Oct 29, 2009 at 04:38:57PM -0500, Eric Sandeen wrote:
>> I've been running my testcase, and I just hit the usual corruption with  
>> this patch in place after 8 iterations, I'm afraid.
> 
> Eric, since you have a relatively controllable reproduction case, have
> you tried reproducing Alexey's bisection results?  Specifically he
> seemed to find that commit fe188c0e shows no problem, and commit
> 91ac6f43 is the first commit with problems?

I can try it but I have very little faith in that result to be honest.

> Having to do multiple iterations will make doing a bisection a major
> pain, but maybe we'll get something out of that.

Well I've been doing bisects but I'm getting skeptical of the results; 
either my testcase isn't reliable enough or all the merges are confusing 
git-bisect (?)  Anyway it keeps ending up on nonsensical commits.

> Other things that might be worth doing given that you have a test case
> would be to try reverting commit 91ac6f43, and see if that helps, and
> to try this patch: http://bugzilla.kernel.org/attachment.cgi?id=23468
> 
> Or have you tried some of these experiments already?
> 
> Regards,
> 
> 						- Ted

After talking to Aneesh last night, I think other good spot-checks will 
be to revert 487caeef9fc08c0565e082c40a8aaf58dad92bbb, and to test Jan's 
sync patches.

-Eric
