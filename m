From: Theodore Tso <tytso@mit.edu>
Subject: Re: Simple inode question (ext2/3)
Date: Wed, 25 Feb 2009 08:11:18 -0500
Message-ID: <20090225131118.GE7064@mit.edu>
References: <20090224210515.GA7064@mit.edu> <alpine.DEB.2.00.0902242148450.13652@pintail.doc.ic.ac.uk> <20090225040654.GT3199@webber.adilger.int> <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33145 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZBYNLY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Feb 2009 08:11:24 -0500
Content-Disposition: inline
In-Reply-To: <417E5333-32B8-42AA-A498-011DF1DDB074@doc.ic.ac.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 10:59:22AM +0000, Felipe Franciosi wrote:
>> Because there are lots of questions like this from university
>> students that would rather have the mailing list do their
>> homework for them.
>
> I'm sorry, but quite honestly, I don't think my questions looked like  
> "hey, can someone do this for me?".

Actually, it looks a huge amount like questions I've gotten in the
past, where, after I push the students a little, they admit that they
are taking undegraduate classes and that they were lazy and it really
was for a problem set for some undergraduate introduction to operating
systems class.  About half the time the Really Dumb Approach was
caused by a clueless professor and it was driven by the problem set
question; the other half of the time the Really Dumb Approach is
caused by the students being completely in the weeds.

So out of respect of the pedogagical process, these days *whenever* my
"this might be a bogus problem set" warning light goes on, I always
quiz people asking for progamming assistance.  If you really are a
Ph.D. student, and someday you are teaching undergraduates, hopefully
you would appreciate might care in trying to not help undergraduates
attempting to cheat on problem sets.  (Whether it is students trying
to cheat on a problem set, or developers who lie about their skills
and then try to get work done by asking on the mailing lists --- I
prefer not to help either, thank you very much.)


As far as your approach is concerned, you asked a whole bunch of
questions which were just *off*.  They made no rational sense, and
even if you are practicing, sometimes the wrong kind of practicing can
end up doing far more harm than good.  If you have code that
completely bypasses all of the normal abstraction layers, the danger
is that you might actually try to use it later, or get confused into
thinking that this was a valid thing to do.  It's like practicing to
compose counterpoint where there is a huge numbers of parallel fifths
between the bass and soprano lines.  What you did would be the
equivalent of asking a composer with help with the interior voices,
and the composer notices and raises questions about the parallel
fifths in the outer voices, and observes that helping you would be
doing you a disservice, because you are *practicing* *the* *wrong*
*thing*.

In this particular case, you mentioned that you want to be able to
access and change the inodes.  Well, there is an inode cache, and
bypassing the inode cache while the filesystem is mounted will only
give you possibly out of date information if you are reading, but will
be ***disastrous*** if you plan to (in your worlds) "change specific
inode data".  So this is not a question of doing things in a more
"fashionable" way.  It is a question of doing things the right way or
the data corrupting way.

Finally, please note that I, nor any other kernel developer that you
might try to cozen, am under no obligation to dispense free progamming
advice.  Your attitude seems to be that we all exist to help you out,
and that we are obliged to spend time answering your questions.  If
someone will eventually be contributing to the kernel, and submitting
useful ext4 patches, I'll give that person some beginning pointers.
But most of the time such contributors start by trying to implement
something useful, not just "practice".  If you are just practicing,
and your only interests is to develop your own skills, and get your
own Ph.D., why the heck should I help you?  Personally, I think the
world needs a lot more Ph.D.'s that don't have attitude, so if someone
is going to be an *sshole, the last thing that I would find an
appealing is using some of my precious free time (that would otherwise
be devoted towards making ext4 better) and waste it instead helping
them get that Ph.D., at which point they will probably be even more
offensive to others because they think the "Dr." title makes them
better than everybody else.

The bottom line is that this is a list about ext3/ext4 development.
If someone wants to ask a question, and it doesn't make sense why they
are asking a question, I'm going to ask them why.  In some cases this
is important, because otherwise I might give them a wrong or
misleading answer.  But it's also because if we let every single
person who has a random "I want to learn how to program the kernel"
swamp the list, we'd have no time to work on what the folks on the
community *really* is interested in doing, which is making ext3/ext4
better and more stable filesystems.

	  	      		    	   - Ted
