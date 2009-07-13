From: Evan King <f11n1@unb.ca>
Subject: Re: Strange disk failure...could ext4 be the culprit?
Date: Mon, 13 Jul 2009 11:38:52 -0300
Message-ID: <4A5B46FC.6090808@unb.ca>
References: <loom.20090707T173457-377@post.gmane.org> <20090713053520.GA5088@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailserv.unb.ca ([131.202.1.21]:60329 "EHLO mailserv.unb.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbZGMQUW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 12:20:22 -0400
In-Reply-To: <20090713053520.GA5088@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Tue, Jul 07, 2009 at 06:16:23PM +0000, Evan King wrote:
>   
>> Hello all,
>>
>> I'm administering a small computing cluster...
>>
>> _____
>>
>> So my questions are these:
>>
>>  - How likely is it that some arcane bug in ext4 is responsible for the failure?
>>     
>
> Can you check whether your kernel have this patch
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ec0ae3acec47f628179ee95fe2c4da01b5e9fc4
>
> -aneesh
>   
Thank you for that bit of sleuthing...what you've unearthed sounds like 
a perfect match for what I experienced.  The system is dual core, and 
the kernel is the latest Ubuntu server (linux-image-2.6.28-13-server).  
I've not been able to find the exact release date of that image (and am 
surprised that release dates are not metadata in apt nor the package's 
web page) but I believe it is too close to the date of this patch to be 
downstream already--and I find no references to this bug in the changelog.

Since there are no launchpad entries referencing this either, I think my 
next step will be to create one pushing for inclusion of this patch in 
the next kernel update, and hopefully for that update to come soon.  My 
cluster has operated smoothly since restoration from backup, and it 
would be nice not to have to reformat (ext partitions were freshly 
created as ext4) or go "aftermarket modding" when a fix is already out.  
At any rate, I have my answer, and it's nice to have a plausible 
explanation--especially one that doesn't point deeper concerns about 
disk load.

Cheers,
 - Evan
