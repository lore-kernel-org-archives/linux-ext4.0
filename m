From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Fri, 7 Apr 2017 13:02:58 +0800
Message-ID: <20170407050258.GO22845@eguan.usersys.redhat.com>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
 <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
 <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>, Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 06, 2017 at 11:28:01AM -0500, Eric Sandeen wrote:
> On 4/6/17 11:26 AM, Theodore Ts'o wrote:
> > On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
> >>
> >> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
> >> after umount/mount cycle, then changed back to original result after
> >> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)
> > 
> > I haven't had time to look at this, but I'm not sure this test is a
> > reasonable one on the face of it.
> > 
> > A file system may choose to optimize a file's extent tree for whatever
> > reason it wants, whenever it wants, including on an unmount --- and
> > that would not be an invalid thing to do.  So to have an xfstests that
> > causes a test failure if a file system were to, say, do some cleanup
> > at mount or unmount time, or when the file is next opened, to merge
> > adjacent extents together (and hence change what is returned by
> > FIEMAP) might be strange, or even weird --- but is this any of user
> > space's business?  Or anything we want to enforce as wrong wrong wrong
> > by xfstests?

So I was asking for a review from ext4 side instead of queuing it for
next xfstests update :)

> 
> I had the same question.  If the exact behavior isn't defined anywhere,
> I don't know what we can be testing, TBH.

Agreed, I was about to ask for the expected behavior today if there was
no new review comments on this patch.

Thanks for the comments and review!

Eryu
