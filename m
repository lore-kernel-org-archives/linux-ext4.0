From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sun, 10 Aug 2014 09:38:32 +1000
Message-ID: <20140809233832.GM20518@dastard>
References: <CAPTn0cAKi64Fh1pAVTDLvSS5-1Kjv7KN2HpGxtm4J8-ym-4nOQ@mail.gmail.com>
 <20140808223335.GQ25145@thunk.org>
 <CAPTn0cCwczoaH7va4x3yJZBgtRr8b7_eG9V0YO16YzQcnshdTA@mail.gmail.com>
 <20140809172427.GF15431@thunk.org>
 <20140809221710.GH15431@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23352 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbaHIXih (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Aug 2014 19:38:37 -0400
Content-Disposition: inline
In-Reply-To: <20140809221710.GH15431@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 09, 2014 at 06:17:10PM -0400, Theodore Ts'o wrote:
> An additional philosophical question.  If your argument is that you
> want project quotas to be as fully general and to work like group
> quotas --- then this brings up a fundamental question --- why can't
> you just use group quotas?
> 
> What is the use case where you need to have two different quotas that
> work exactly like group quotas?  And following in the general design
> rule of "Zero, one, or infinity: there is no two", for whatever use
> case where you might argue that you need _two_ quotas with identical
> semantics as group quotas, who is to say that there won't be someone
> that comes up with some other use case where you need _three_ quotas
> with identical semantics as group quotas.  Or _four_ group quotas
> being tracked simultaneously.  Etc, etc., etc.
> 
> The advantage of doing the directory hierarcy based quota system is
> not just that it's compatible with XFS; it is that it is *different*
> from group quotas.  Not more restrictive, but *different*.  There will
> certainly be scenarios where someone wants to enforce a restriction on
> the size or number of inodes in a directory hierarcy, and where when
> you move a file out of a directory hierarcy into another one, you
> *want* the usage quota to be transfered from the source to the
> destination hierarcy.
> 
> It may not be what *you* want, but let me ask you this --- why is it
> that you can't use the group quota system, and need to invent an
> entirely new project quota?  The only excuse I've heard is for people
> who are doing container virtualization.

Step into the enterprise or the HPC world where you are managing
thousands of users spread across departmental/research groups and
undertaking a few tens of distinct projects at the same time.

Users have space limits, departments are billed for their user's
space usage, and project space usage needs to be accounted (and
maybe limited) to ensure the shared storage doesn't run out of space
inapprpriately.

I've seen this sort of thing quite a bit over the past 10 years.
Most of the time on storage systems measured in the high tens to
hundreds of TB of storage, which puts it way out of the scope of
knowledge of most Linux distro and application developers. That's
most likely why you don't get any other answer to your questions -
most people can't see how project quotas get used because they've
never worked in a large, multi-project environment before.

> Personally, I think this latter approach is way too complicated, and
> I'd much rather implement a single directory hierarcy based quota
> system which is compatible with XFS and has XFS's semantics.  But at
> least this second approach is *fully* general, if you are going to
> argue for a more general solution.

AFAICT, the 90% solution is "compatible with XFS" solution. It's
also the simplest and lowest cost, given that you should be able
to do it with a few hundred lines of kernel code. Userspace doesn't
need immediate work, because you can use the XFS tools initially
and hence all the xfstests validation. Don't be different just
because of NIH syndrome....

If we need a more *complex* solution because people need more than
just what the simple solution gives them, then that is a topic for
-fsdevel and probably LSFMM because there's all sorts of semantic
and interface discussions that are needed and a lot more code that
needs to be written. i.e. the simple solution can be deployed within
a couple of kernel releases, a generic solution is more likely a
coupleof *years* of work to deploy...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
