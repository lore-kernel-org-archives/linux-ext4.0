From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: Tree for Aug 7 [ call-trace on suspend: ext4 | pm related ? ]
Date: Thu, 08 Aug 2013 01:02:50 +0200
Message-ID: <2146168.3J7W6RtiZr@vostro.rjw.lan>
References: <CA+icZUW990rWKdQmppjkGTJzFBtTnW-tb0dRu2AbTYB8KSDN4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Colin Cross <ccross@android.com>
To: sedat.dilek@gmail.com
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CA+icZUW990rWKdQmppjkGTJzFBtTnW-tb0dRu2AbTYB8KSDN4w@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday, August 07, 2013 04:25:14 PM Sedat Dilek wrote:
> On Wed, Aug 7, 2013 at 7:54 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > Changes since 20130806:
> >
> > The ext4 tree lost its build failure.
> >
> > The mvebu tree gained a build failure so I used the version from
> > next-20130806.
> >
> > The akpm tree gained conflicts against the ext4 tree.
> >
> > ----------------------------------------------------------------------------
> >
> 
> [ CC ext4 and pm folks ]
> 
> I saw this on my 1st suspend which was not successful (2nd and 3rd try
> I could suspend and resume):
> 
> [ 5467.724074] PM: Syncing filesystems ... done.
> [ 5467.973575] PM: Preparing system for mem sleep
> [ 5467.974121] Freezing user space processes ...
> [ 5487.970574] Freezing of tasks failed after 20.010 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [ 5487.970591] DOM Worker      D ffffffff81811820     0  2437      1 0x00000004
> [ 5487.970595]  ffff880056ca3ca8 0000000000000002 00000000002d627f
> 000009af00000002
> [ 5487.970598]  ffff880066ede640 ffff880056ca3fd8 ffff880056ca3fd8
> ffff880056ca3fd8
> [ 5487.970601]  ffff880119f98340 ffff880066ede640 ffff880056ca3ca8
> ffff88011fad5118
> [ 5487.970604] Call Trace:
> [ 5487.970612]  [<ffffffff81144360>] ? __lock_page+0x70/0x70
> [ 5487.970615]  [<ffffffff816e8179>] schedule+0x29/0x70
> [ 5487.970618]  [<ffffffff816e824f>] io_schedule+0x8f/0xd0
> [ 5487.970621]  [<ffffffff8114436e>] sleep_on_page+0xe/0x20
> [ 5487.970624]  [<ffffffff816e4be2>] __wait_on_bit+0x62/0x90
> [ 5487.970627]  [<ffffffff81144f9b>] ? find_get_pages_tag+0xcb/0x170
> [ 5487.970630]  [<ffffffff811444d0>] wait_on_page_bit+0x80/0x90
> [ 5487.970633]  [<ffffffff8108a0e0>] ? wake_atomic_t_function+0x40/0x40
> [ 5487.970636]  [<ffffffff811445ec>] filemap_fdatawait_range+0x10c/0x190
> [ 5487.970640]  [<ffffffff81145ce0>] filemap_write_and_wait_range+0x50/0x80
> [ 5487.970644]  [<ffffffff81246c3d>] ext4_sync_file+0x15d/0x340
> [ 5487.970648]  [<ffffffff811db8dd>] do_fsync+0x5d/0x90
> [ 5487.970651]  [<ffffffff811dbcc0>] SyS_fsync+0x10/0x20
> [ 5487.970655]  [<ffffffff816f25ef>] tracesys+0xe1/0xe6
> [ 5487.970658]
> [ 5487.970659] Restarting tasks ... done.
> 
> With yesterday's -next I did not have issues like this.

It looks like ext4 was doing fsync, so it scheduled a write a waited for it
to complete, but that never happened (most likely whoever was supposed to do
the write had been already frozen then).

Thanks,
Rafael
