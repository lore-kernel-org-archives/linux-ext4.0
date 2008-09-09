From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
 carefully
Date: Tue, 9 Sep 2008 11:10:06 -0700
Message-ID: <20080909111006.cc8aae89.akpm@linux-foundation.org>
References: <20080907121557.GA3432@x200.localdomain>
	<20080907160414.GB26248@charite.de>
	<20080905210652.GE11569@x200.localdomain>
	<20080906075713.GM3086@webber.adilger.int>
	<20080907121557.GA3432@x200.localdomain>
	<20080907162447.GB32429@mit.edu>
	<20080907164130.GA3376@x200.localdomain>
	<20080908143951.GH8161@mit.edu>
	<20080909070630.GC5786@x200.localdomain>
	<20080909001203.7480549e.akpm@linux-foundation.org>
	<20080909130900.GS8161@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778AbYIISKi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 14:10:38 -0400
In-Reply-To: <20080909130900.GS8161@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Sep 2008 09:09:00 -0400 Theodore Tso <tytso@MIT.EDU> wrote:

> On Tue, Sep 09, 2008 at 12:12:03AM -0700, Andrew Morton wrote:
> > On Tue, 9 Sep 2008 11:06:30 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Mon, Sep 08, 2008 at 10:39:51AM -0400, Theodore Tso wrote:
> > > > Here's what I've checked into the ext4 patch queue for submission to
> > > > mainline at the next merge window.  I've added a bit more error
> > > > checking in case proc_mkdir() fails and returns NULL.
> > > 
> > > Hopefully, Andrew, will pick up original non-broken patch.
> > 
> > What does this mean??
> 
> Alexey's trying to bypass the ext4 maintainers.  :-)
> 
> Alexey, both of the problems which you pointed out I noticed last
> night and have already been fixed and commited to the ext4 patch
> queue.  Please see attached.  This patch *is* better than your
> original one since using strdup is better than open coding it in C.
> 
> Andrew, note that some of the patches in the upcoming ext4 patch set
> which I am preparing for -mm and linux-next submission depend on a the
> percpu cleanup patch which is in already in -mm.

"the percpu cleanup patch" is nowhere nearly specific enough to be
useful.  I don't know what patch this is.

>  I've left it in the
> ext4 series file since the patchset won't apply against mainline
> without it, but I've left comments in the series file that should make
> this clear.
> 
> I'm not sure how you are managing -mm these days, but it looks like
> you are using git more, and so if you are pulling in changes in via
> linux-next, git will do the right thing and drop the duplicated patch.
> There is a similar issue with the FIEMAP patches and some ext3
> patches, but the FIEMAP patches will get dropped since Eric has
> promised to get on Mark Fasheh's case to submit for merging or to
> submit them yourself, and the ext3 patches I will submit to you
> separately.
> 

If stuff turns up in linux-next then I'll just drop the -mm duplicate
under the assumption that the patch is being taken care of by someone
else.  I will usually attempt to verify that the subsystem tree merged
the correct patch.  Fairly often they didn't.  Fairly often this is
because they took the original patch off the mailing list and omitted
fixes which I (or others) had made to it.  This is why I keep those
fixes as separate patches until the last minute.

If other patches in -mm have dependencies upon that patch then things
can sometimes get sticky, but as long as I know about it I can usually
get things in the right order.


