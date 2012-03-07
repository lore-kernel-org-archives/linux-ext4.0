From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Wed, 7 Mar 2012 12:11:36 -0500
Message-ID: <20120307171135.GB11457@thunk.org>
References: <20120305125029.GA5121@gmail.com>
 <alpine.LFD.2.00.1203060912170.5085@dhcp-27-109.brq.redhat.com>
 <20120306135656.GB24695@gmail.com>
 <alpine.LFD.2.00.1203061504230.5085@dhcp-27-109.brq.redhat.com>
 <4F564F19.50804@oracle.com>
 <alpine.LFD.2.00.1203070927010.5117@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54361 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab2CGRLk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Mar 2012 12:11:40 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203070927010.5117@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 07, 2012 at 09:51:27AM +0100, Lukas Czerner wrote:
> Exactly, first we have to define what we actually need to achieve with
> it. Not just randomly making up stupid pseudo-optimizations. Moreover
> there is _no way_ file system has the information about the HSM nor the
> flash regions, fast regions or whatever, it does not even know where is
> the beginning of the disk. Stop constructing building from the roof!!
> There just is not any interface for the file system to use to get such
> information!

I'm not really worried about this problem.  This is something which
can easily be set by the system administrator via mkfs or tune2fs.
And just as we now have /sys/block/sda/queue/rotational so that upper
layers can make optimizations based on whether or not a disk is an
SSD, as we can prove that manual configuration of storage attributes
can make a measurable difference, it can be a spur to the standards
bodies to eventually (years and years and years later) come up with a
standardized way for the file system to get such interfaces
automatically.

In the meantime, we have flash vendors (or at least one flash vendor
who works with embedded/handset customers) interested in potentially
providing private interfaces to make additional storage attributes
available, or for file systems to provide information to the storage
devices so they can better optimize their behaivor.

So I'm not too worried about the fact that we don't have a way to
specify all of these things yet.  If we can find a way to make things
faster, eventually the rest of the infrastructure can get plumbed in.
(Even standards bodies that move in geologic time scales.  :-)

> I also believe that regarding HSM user is in no damn position to decide
> whether his file will be on flash or not. It just does not work that
> way, every user's, or application's files has to be accessed faster than
> others from their point of view.

Access control is going to be an interesting problem, and what the
requirements are for a file system running on an HPC system, or an
Android device, or a generic time-sharing system are quite different.
Given that many of us have grown up in an environment where there are
mutually suspicious (and untrustworthy) time sharing users, or equally
untrustworthy application writers who tend to optimize their
application without considering anything else, it's easy for us to
assume that if we can't solve the authorization problem completely,
that it's hopeless.

But the same argument can be made for real time scheduling priorities
(which is even easier for untrustworthy application authors to abuse),
but that's turned out to be extremely important in allowing Linux to
break through in various new fields --- including Naval Warships and
laser-wielding industrial robots.  :-)

							- Ted
