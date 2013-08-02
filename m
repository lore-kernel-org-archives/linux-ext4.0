From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Date: Fri, 2 Aug 2013 12:37:07 +1000
Message-ID: <20130802023707.GA7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
 <20130801002241.GH7118@dastard>
 <CAKYAXd_VvGQL6KW3+FmfPogxzkXq7yF-4WPM9iebXcTn7tiN9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com,
	elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, a.sangwan@samsung.com,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKYAXd_VvGQL6KW3+FmfPogxzkXq7yF-4WPM9iebXcTn7tiN9A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Aug 01, 2013 at 02:07:39PM +0900, Namjae Jeon wrote:
> 2013/8/1, Dave Chinner <david@fromorbit.com>:
> > On Wed, Jul 31, 2013 at 11:42:00PM +0900, Namjae Jeon wrote:
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Fallocate now supports new FALLOC_FL_COLLAPSE_RANGE flag.
> >> The semantics of this flag are following:
> >> 1) It collapses the range lying between offset and length by removing any
> >> data
> >>    blocks which are present in this range and than updates all the
> >> logical
> >>    offsets of extents beyond "offset + len" to nullify the hole created
> >> by
> >>    removing blocks. In short, it does not leave a hole.
> >> 1) It should be used exclusively. No other fallocate flag in combination.
> >> 2) Offset and length supplied to fallocate should be fs block size
> >> aligned.
> >
> Hi Dave.
> 
> > Given that the rest of fallocate() interfaces are byte based, this
> > is going to cause some confusion if it's not well documented. i.e.
> > this restriction needs to be documented in the header file that is
> > exposed to userspace, as well as in the fallocate(2) man page.
> Agree.
> 
> >
> >> 3) It wokrs beyond "EOF", so the extents which are pre-allocated beyond
> >> "EOF"
> >>    are also updated.
> >
> > I don't think that's valid for this operation. If the range is
> > beyond EOF, you are not modifying anything visible to userspace, and
> > that makes it the same as a hole punch operation. So, I'd get rid of
> > thisnasty implementation complexity altogether.
> The basic idea behind collapse range is that it does'nt leaves a hole.

I know what collapse range is and what it's supposed to do. read
again what I said - collapsing a range beyond EOF simply removes
extents that the user can't otherwise see. That makes it the same as
a hole punch operation. i.e. you don't need to use collapse range
for this, because you can simply punch the same number of extents of
the end of the preallocated range and get exactly the same result.

i.e. we already have functionality to manipulate extents beyond EOF
and so we don't need another.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
