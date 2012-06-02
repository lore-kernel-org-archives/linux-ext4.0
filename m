From: Kirill Korotaev <dev@parallels.com>
Subject: Re: container disk quota
Date: Sat, 2 Jun 2012 10:06:59 +0400
Message-ID: <01FED15D-15A3-4542-B95B-1166F0A309E6@parallels.com>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com>
 <20120601155457.GA30909@quack.suse.cz>	<20120601160421.GA17402@amd1>
 <4FC9ABBB.3050303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"tinguely@sgi.com" <tinguely@sgi.com>,
	"containers@lists.linux-foundation.org"
	<containers@lists.linux-foundation.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"hch@infradead.org" <hch@infradead.org>,
	"bpm@sgi.com" <bpm@sgi.com>,
	"christopher.jones@oracle.com" <christopher.jones@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, "tm@tao.ma" <tm@tao.ma>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"chris.mason@oracle.com" <chris.mason@oracle.com>
To: "jeff.liu@oracle.com" <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:41413 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965010Ab2FBGHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jun 2012 02:07:11 -0400
In-Reply-To: <4FC9ABBB.3050303@oracle.com>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jun 2, 2012, at 09:59 , Jeff Liu wrote:

> Hi Serge,
> 
> On 06/02/2012 12:04 AM, Serge Hallyn wrote:
> 
>> Quoting Jan Kara (jack@suse.cz):
>>>  Hello,
>>> 
>>> On Wed 30-05-12 22:58:54, jeff.liu@oracle.com wrote:
>>>> According to glauber's comments regarding container disk quota, it should be binded to mount
>>>> namespace rather than cgroup.
>>>> 
>>>> Per my try out, it works just fine by combining with userland quota utilitly in this way.
>>>> However, they are something has to be done at user tools too IMHO.
>>>> 
>>>> Currently, the patchset is in very initial phase, I'd like to post it early to seek more
>>>> feedbacks from you guys.
>>>> 
>>>> Hopefully I can clarify my ideas clearly.
>>>  So what I miss in this introductory email is some highlevel description
>>> like what is the desired functionality you try to implement and what is it
>>> good for. Looking at the examples below, it seems you want to be able to
>>> set quota limits for namespace-uid (and also namespace-gid???) pairs, am I
>>> right?
>>> 
>>>  If yes, then I would like to understand one thing: When writing to a
>>> file, used space is accounted to the owner of the file. Now how do we
>>> determine owning namespace? Do you implicitely assume that only processes
>>> from one namespace will be able to access the file?
>>> 
>>> 								Honza
>> 
>> Not having looked closely at the original patchset, let me ask - is this
>> feature going to be a freebie with Eric's usernamespace patches?
> 
> It we can reach a consensus to bind quota on mount namespace for
> container or other things maybe.

1. OpenVZ doesn't use mount namespaces and still has quotas per container.

2. BTW, have you seen Dmitry Monakhov patches for same containers quotas via additional inode attribute? it allows to make it journaled.
How quotas are stored in your case?

3. I tend to think nowdays such quotas maybe of less need. Quota code doesn't scale well. And it's easier to put container in image file (as OpenVZ recently introduced).

Thanks,
Kirill

