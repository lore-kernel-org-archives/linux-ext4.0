From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 blocks up
Date: Mon, 2 Jul 2012 19:31:04 +0200
Message-ID: <20120702173104.GK6679@quack.suse.cz>
References: <1341231316.2979.11.camel@sauron.fi.intel.com>
 <20120702144444.GA18074@thunk.org>
 <1341240862.2979.23.camel@sauron.fi.intel.com>
 <20120702151442.GB18074@thunk.org>
 <20120702164548.GD18074@thunk.org>
 <4FF1D22D.2070804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FF1D22D.2070804@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 02-07-12 11:54:05, Eric Sandeen wrote:
> On 07/02/2012 11:45 AM, Theodore Ts'o wrote:
> > On Mon, Jul 02, 2012 at 11:14:42AM -0400, Theodore Ts'o wrote:
> >> On Mon, Jul 02, 2012 at 05:54:22PM +0300, Artem Bityutskiy wrote:
> >>> On Mon, 2012-07-02 at 10:44 -0400, Theodore Ts'o wrote:
> >>>> Can you tell me *which* xfstest this was blocking on?
> >>>
> >>> Test 068 which runs fsstress.
> >>
> >> Hmmm, I had just started an xfstests -g auto run using standard ext4
> >> defaults with 3.5-rc2, and I'm not noting any problems.  And I've
> >> gotten past test 68 w/o any problems.
> > 
> > I just tried again with 3.5-rc5, and I was able to reproduce your
> > failure by using "check 68 68 68 68 68" (it failed after the 2nd time
> > it ran the fsstress test.  What's interesting is that there have been
> > no changes in fs/ext4 or fs/jbd2 since 3.5-rc2.  So this may have been
> > caused by a writeback related change; I'm starting a bisect now.
> 
> Isn't this just part of the whole class of filesystem freeze races Jan
> has been trying to work out?
  Yes, I can hang the kernel on this test with basically any filesystem
when running long enough. My freezing patches should fix that - currently
waiting for Al to merge them...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
