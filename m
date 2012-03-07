From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Wed, 7 Mar 2012 09:51:27 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203070927010.5117@dhcp-27-109.brq.redhat.com>
References: <20120305125029.GA5121@gmail.com> <alpine.LFD.2.00.1203060912170.5085@dhcp-27-109.brq.redhat.com> <20120306135656.GB24695@gmail.com> <alpine.LFD.2.00.1203061504230.5085@dhcp-27-109.brq.redhat.com> <4F564F19.50804@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab2CGIve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 03:51:34 -0500
In-Reply-To: <4F564F19.50804@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Mar 2012, Sunil Mushran wrote:

> On 03/06/2012 06:29 AM, Lukas Czerner wrote:
> > However the file system do not have the information which part of the
> > device it resides on is faster. It might be the beginning of the file
> > system, but it might not be the case at all.
> 
> 
> Think HSM and flash storage as the hot region. Remember these are
> hints and not guaranteed to work in all cases.

Exactly, first we have to define what we actually need to achieve with
it. Not just randomly making up stupid pseudo-optimizations. Moreover
there is _no way_ file system has the information about the HSM nor the
flash regions, fast regions or whatever, it does not even know where is
the beginning of the disk. Stop constructing building from the roof!!
There just is not any interface for the file system to use to get such
information!

I also believe that regarding HSM user is in no damn position to decide
whether his file will be on flash or not. It just does not work that
way, every user's, or application's files has to be accessed faster than
others from their point of view.

> 
> 
> > Moreover the flag which is stating that the file does not have to be
> > allocated sequentially is not particularly helpful, I can not imagine
> > people using it. Why would someone want to lower their performance ?
> > Well, they might think that it will increase performance of the other
> > files, but that is highly disputable and there are better solutions like
> > using faster storage for the files that actually needs it.
> > 
> > Additionally *_HOT* flag does not say anything about the allocation
> > policy. It might be accessed often ,but no in sequential manner, or it
> > can be written to a lot, it can be appended a lot, or it the content
> > might be changed without changing its size etc... *Hot* might mean so
> > many thing that this is just not useful for the file system. It would
> > certainly be better to come up with something less esoteric which would
> > actually address concrete user issues and help file system to deal with
> > them better, like, I do not know, do not fsync/force allocation on
> > rename maybe...(or whatever we are doing right now).
> 
> _HOT/_COLD is descriptive for allocation policy though fadvise() is
> the wrong call as it pertains to access patterns.

Of course _HOT/_COLD is totally stupid flags from both user and file
system POV. It could mean whatever you can imagine behind HOT/COLD. In
this case it is so damn esoteric I can not imagine even file systems
agree on the meaning of it. But when it comes to user it will be even
worse - total disaster - no one would be able to say what benefit should
it actually bring.

Just come up with concrete optimizations and give them concrete names.
If this is going to be of any use to file systems and users, both should
know exactly what workload would be applied to the file, or what user
actually intents to do with it, so that file system can take concrete
action. What you proposing is a flag which should spawns ponies all
around, it does not work

And if you can not come up with any flag like that, well then it certainly
tells you something about this feature as a whole.

-Lukas

> 
> Sunil
> 

-- 
