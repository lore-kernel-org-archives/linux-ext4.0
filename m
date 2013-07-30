From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Tue, 30 Jul 2013 13:08:07 +1000
Message-ID: <20130730030807.GI21982@dastard>
References: <51E8356C.9030603@redhat.com>
 <20130718185310.GA17548@thunk.org>
 <51E88ECD.3040806@redhat.com>
 <20130719025934.GE17938@thunk.org>
 <20130719033309.GQ11674@dastard>
 <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:49216 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab3G3DIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 23:08:14 -0400
Content-Disposition: inline
In-Reply-To: <20130722125745.GA2827@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 22, 2013 at 08:57:45PM +0800, Zheng Liu wrote:
> On Mon, Jul 22, 2013 at 08:02:55PM +1000, Dave Chinner wrote:
> > On Mon, Jul 22, 2013 at 10:17:42AM +0800, Zheng Liu wrote:
> > > I don't think fiemap is a good interface.  The application uses
> > > fiemap(2) to retrieve extent mapping. 
> > 
> > fiemap is used to query information about extent maps. What it
> > returns is entirely dependent on the input parameters that are
> > passed to it. Indeed, from Documentation/filesystems/fiemap.txt:
> > 
> > "If fm_extent_count is zero, then the fm_extents[] array is ignored
> > (no extents will be returned), and the fm_mapped_extents count will
> > hold the number of extents needed in fm_extents[] to hold the file's
> > current mapping."
> > 
> > Think about that for a minute. What does the filesystem do with such
> > an fiemap query when the extent map is not cached?  That's right,
> > *fiemap reads the extent map from disk into the cache* and then
> > returns the number of extents in the range.
> > 
> > All I have suggested is adding a flag to make this an *explicit
> > operation* rather than a side effect of a "count extents" query. I
> > fail to see any justification for a whole new interface when we
> > already have a perfectly functional one that already provides the
> > functionality that is required...
> 
> Yes, I understand your point of view.  We can use fiemap to do that.
> All I concern is about semantics.  When someone mention about fiemap,
> first I remember is that I can use it to retrieve the extent mappings.

But that's exactly what Ted wants to do - retreive extent maps from
disk. From Documentation/filesystems/fiemap.txt:

"The fiemap ioctl is an efficient method for userspace to get file
extent mappings. .....

Certain flags to modify the way in which mappings are looked up can
be set in fm_flags. .....  This scheme is intended to allow the
fiemap interface to grow in the future but without losing
compatibility with old software. ..... "

The functionality being discussed here is userspace being able to
retreive extents from disk into memory. The initial description of
FIEMAP covers this. We can change the way fiemap behaves by input
flags - that's clearly stated - and it is intended to be extended in
this manner for future functionality. That's what I suggested to
make it explicit, but it's not actually necessary to actually read
the extent map into memory with FIEMAP.

Keep in mind that this "new extent map functionality" is *exactly*
why we designed the FIEMAP interface to be extensible.

> But for fadvise, it looks like more naturally.

fadvise() is for giving data access behaviour hints. It is not for
controlling how filesystems access their internal metadata.

> When I look at it, I
> always think that I can use it to provide a hint to the kernel, and then
> the kernel will do the rest of things for me.   So that is why I prefer
> to use a fadvise flag rather than use fiemap.

But Ted's case is not a "hint" - it's a direct command to fetch the
extent map from disk. You can do that already with FIEMAP, so no new
code or interfaces are needed. fadvise() is not the proper interface
for manipulating filesystem metadata behaviour, and fiemap can
already do what you need. There is no need for any new interfaces
here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
