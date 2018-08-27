From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 1/2] dax: dax_layout_busy_page() warn on !exceptional
Date: Mon, 27 Aug 2018 18:09:03 +0200
Message-ID: <20180827160903.GF4002@quack2.suse.cz>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180710191031.17919-2-ross.zwisler@linux.intel.com>
 <6ca60cf6-f1dc-27d5-fb79-7547aea39dfa@redhat.com>
 <20180810203349.GH627@thunk.org> <20180811021053.GB14368@thunk.org>
 <20180813101252.GC8927@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180813101252.GC8927-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Mon 13-08-18 12:12:52, Jan Kara wrote:
> On Fri 10-08-18 22:10:53, Theodore Y. Ts'o wrote:
> > On Fri, Aug 10, 2018 at 04:33:49PM -0400, Theodore Y. Ts'o wrote:
> > > I just kicked off a DAX test ("gce-xfstests -c dax -g auto") with
> > > CONFIG_KASAN disabled, and I expect it shouldn't show up anything
> > > concerning.  So assuming nothing surprising pops up, yes it should be
> > > merged at the next merge window.
> > 
> > ... and here are the results.  The first is 4.17, and the second is
> > the ext4 git tree:
> > 
> > ext4/dax: 488 tests, 4 failures, 97 skipped, 2647 seconds
> >   Failures: ext4/033 generic/344 generic/491 generic/503
> > 
> > ext4/dax: 488 tests, 3 failures, 97 skipped, 2637 seconds
> >   Failures: generic/081 generic/344 generic/388
> > 
> > The generic/388 failure is a known flake (shutdown stress test).
> > 
> > The generic/081 regression appears to be a device-mapper issue:
> > 
> > generic/081		[22:06:33][   15.079661] run fstests generic/081 at 2018-08-10 22:06:33
> > [   15.795745] device-mapper: ioctl: can't change device type (old=4 vs new=1) after initial table load.
> > [failed, exit status 1] [22:06:36]- output mismatch (see /results/ext4/results-dax/generic/081.out.bad)
> >     --- tests/generic/081.out	2018-08-09 18:00:42.000000000 -0400
> >     +++ /results/ext4/results-dax/generic/081.out.bad	2018-08-10 22:06:36.440005460 -0400
> >     @@ -1,2 +1,4 @@
> >      QA output created by 081
> >      Silence is golden
> >     +Failed to create snapshot
> >     +(see /results/ext4/results-dax/generic/081.full for details)
> >     ...
> >     (Run 'diff -u tests/generic/081.out /results/ext4/results-dax/generic/081.out.bad'  to see the entire diff)
> 
> I'll see if this reproduces for me. Doesn't seem to be related to the DAX
> patches you caary though.

This is caused by commit dbc626597c39b "dm: prevent DAX mounts if not
supported". I've started discussion with relevant developers how to fix
this.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
