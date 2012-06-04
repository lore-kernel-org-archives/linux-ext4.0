From: Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: container disk quota
Date: Sun, 3 Jun 2012 21:57:16 -0500
Message-ID: <20120604025716.GA3480@sergelap>
References: <1338389946-13711-1-git-send-email-jeff.liu@oracle.com>
 <20120601155457.GA30909@quack.suse.cz>
 <20120601160421.GA17402@amd1>
 <4FC9ABBB.3050303@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu,
	containers@lists.linux-foundation.org, david@fromorbit.com,
	hch@infradead.org, bpm@sgi.com, christopher.jones@oracle.com,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, tm@tao.ma,
	linux-ext4@vger.kernel.org, chris.mason@oracle.com,
	tinguely@sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FC9ABBB.3050303@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Quoting Jeff Liu (jeff.liu@oracle.com):
> Hi Serge,
> 
> On 06/02/2012 12:04 AM, Serge Hallyn wrote:
> 
> > Quoting Jan Kara (jack@suse.cz):
> >>   Hello,
> >>
> >> On Wed 30-05-12 22:58:54, jeff.liu@oracle.com wrote:
> >>> According to glauber's comments regarding container disk quota, it should be binded to mount
> >>> namespace rather than cgroup.
> >>>
> >>> Per my try out, it works just fine by combining with userland quota utilitly in this way.
> >>> However, they are something has to be done at user tools too IMHO.
> >>>
> >>> Currently, the patchset is in very initial phase, I'd like to post it early to seek more
> >>> feedbacks from you guys.
> >>>
> >>> Hopefully I can clarify my ideas clearly.
> >>   So what I miss in this introductory email is some highlevel description
> >> like what is the desired functionality you try to implement and what is it
> >> good for. Looking at the examples below, it seems you want to be able to
> >> set quota limits for namespace-uid (and also namespace-gid???) pairs, am I
> >> right?
> >>
> >>   If yes, then I would like to understand one thing: When writing to a
> >> file, used space is accounted to the owner of the file. Now how do we
> >> determine owning namespace? Do you implicitely assume that only processes
> >> from one namespace will be able to access the file?
> >>
> >> 								Honza
> > 
> > Not having looked closely at the original patchset, let me ask - is this
> > feature going to be a freebie with Eric's usernamespace patches?
> 
> It we can reach a consensus to bind quota on mount namespace for
> container or other things maybe.
> I think it definitely should depends on user namespace.
> 
> > 
> > There, a container can be started in its own user namespace.  It's uid
> > 1000 will be mapped to something like 1101000 on the host.  So the actual
> > uid against who the quota is counted is 1101000.  In another container,
> > uid 1000 will be mapped to 1201000, and again quota will be counted against
> > 1201000.
> 
> Is it also an implications that we can examine do container quota or not
> based on the uid/gid number?

I'm sorry I don't understand the question.

As an attempt at an answer:  the quota code wouldn't change at all.  We would
simply exploit the fact that uid 1000 in container1 has a real uid of 101100,
which is different from the real uid 102100 assigned to uid 1000 in container2
and from real uid 1000 (uid 1000 on the host).

> > Note that this won't work with bind mounts, as a file can only be owned
> > by one uid, be it 1000, 1101000, or 1201000.  So for the quota to work
> > each container would need its own files.  (Of course the underlying
> > metadata can be shared through whatever ways - btrfs, lvm snapshotting,
> > etc)
> 
> Do you means that we can not bind mount outside files to container for
> as general adquot.user/adquot.group purpose?

Right, not without some sort of stackable filesystem which masks the uid.

Actually there may be a way around it (simply provide a mount option,
requiring privilege in the original user namespace, saying mask uid x to
look like uid y for this bind mount), but it's too early to say how
cleanly that could be done.

> If so, per glauber's comments, bind quota to mount namespace should be a
> generic feature, and container just one of users could make use of it.
> 
> Again, if bind quota to mount namespace is on right direction, and it
> only does make sense to container for now, maybe we don't need such
> files. IMHO, container is a lightweight virtualization solution, maybe
> its fine to make it as simple as possible.  If the server admin need to
> configure hundreds of user/group dquot per container, perhaps he should
> consider KVM/XEN.

Server admin doesn't need to do that.

-serge
