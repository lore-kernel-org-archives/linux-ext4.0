From: Dave Chinner <david@fromorbit.com>
Subject: Re: [GIT PULL] ext4 updates for 3.9
Date: Fri, 1 Mar 2013 00:18:13 +1100
Message-ID: <20130228131813.GO5551@dastard>
References: <20130227170157.GA222@x4>
 <98C6DE45-F050-4AAD-82E2-7352F5BB0A5D@gmail.com>
 <20130227172256.GA236@x4>
 <7BFB2135-A1F0-4B6D-9962-16E75E5560F8@gmail.com>
 <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130227192907.GB14253@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 27, 2013 at 02:29:07PM -0500, Theodore Ts'o wrote:
> On Wed, Feb 27, 2013 at 02:19:23PM -0500, Dave Jones wrote:
> > 
> > Looks like it's fixed here too.
> > 
> > How did this make it through -next without anyone hitting it ?
> 
> > Is anyone running xfstests or similar on linux-next regularly ?
> 
> I run xfstests on the ext4 tree, and I ran it on ext4 plus Linus's tip
> before I submitted a pull request.  The problem is that XFSTESTS is
> S-L-O-W if you use large partitions, so typically I use a 5GB
> partition sizes for my test runs.

This isn't the case for XFS. I typically see 1TB scratch devices
only being ~10-20% slower than 10GB scratch devices, and 10TB only
being a little slower than 1TB scratch devices. I have to use sparse
devices and --large-fs for 100TB filesystem testing, so I can't
directly compare the speeds to those that I run on physical devices.
However I can say that it isn't significantly slower than using
small scratch devices...

> So what we probably need to do is to have a separate set of tests
> using a loopback mount, and perhaps an artificially created file
> system which has a large percentage of the blocks in the middle of the
> file system busied out, to make efficient testing of these sorts of

That's exactly what the --large-fs patch set I posted months ago does
for ext4 - it uses fallocate() to fill all but 50GB of the large
filesystem without actually writing any data and runs the standard
tests in the remaining unused space.

However, last time I tested ext4 with this patchset (when I posted
the patches months ago), multi-TB preallocation on ext4 was still too
slow to make it practical for testing on devices larger than 2-3TB.
Perhaps it would make testing 1-2TB ext4 filesystems fast enough
that you could do it regularly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
