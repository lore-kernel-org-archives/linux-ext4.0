From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4/004: add dump/restore test
Date: Wed, 17 Dec 2014 06:36:27 +1100
Message-ID: <20141216193627.GA15665@dastard>
References: <1416910869-28538-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20141206214040.GA27484@thunk.org>
 <54850290.2070201@cn.fujitsu.com>
 <20141216025827.GO17575@thunk.org>
 <20141216035942.GE2152@dastard>
 <20141216155328.GP17575@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141216155328.GP17575@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 16, 2014 at 10:53:28AM -0500, Theodore Ts'o wrote:
> On Tue, Dec 16, 2014 at 02:59:43PM +1100, Dave Chinner wrote:
> > 
> > Yes, that is too long for an "auto" test. A couple of minutes is
> > about the limit we should be trying to stick to for auto tests; we
> > don't really add any extra coverage by making such tests run for a
> > long time.
> > 
> > As it is, most of the xfsdump/restore tests take around 30-60s to
> > run, so that's probably a good guide to follow for this.
> 
> I'm currently running with a patch that cuts it down to ~22 seconds
> (and about 60 megs worth of data in the dump and restore directory).
> I'll send a patch....
> 
> > > And I'll note that using the current fsstress arguments, you are only
> > > creating regular files and directories, and there are no symlinks,
> > > device nodes, or FIFO's being created to test whether those files are
> > > correctly being backed up and restored.
> > 
> > Probably a good idea, too. Thanks for looking at this, Ted.
> 
> I looked a bit more closely at this, and unfortunately it's not a
> quick fix.  The issue is that the test is currently using diff -r to
> verify that the restore directory == the dump directory, and diff
> doesn't handle special files.
> 
> Doing this right might require writing a special case directory
> comparison script in perl, or some such; if we do this, then we can
> also have the directory comparison tool also check to make sure the
> uid/gid/mode bits match, which diff also doesn't handle.

See common/dump, specifically _ls_compare_sub,
_ls_nodate_compare_sub, _diff_compare_sub and _diff_compare_eas.
THere are also routines for creating directory structures with
symlinks, hardlinks and xattrs for dump/restore testing. Yes, it's
all xfsdump/restore specific, but we already have a wheel ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
