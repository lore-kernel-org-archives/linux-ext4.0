From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Tue, 30 Oct 2012 01:10:08 +0100
Message-ID: <20121030001008.GA372@quack.suse.cz>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013524.GA19591@blackbox.djwong.org>
 <20121029181358.GG18767@quack.suse.cz>
 <20121029183051.GJ18767@quack.suse.cz>
 <20121030104837.2e4b06fc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121030104837.2e4b06fc@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 30-10-12 10:48:37, NeilBrown wrote:
> On Mon, 29 Oct 2012 19:30:51 +0100 Jan Kara <jack@suse.cz> wrote:
> 
> > On Mon 29-10-12 19:13:58, Jan Kara wrote:
> > > On Fri 26-10-12 18:35:24, Darrick J. Wong wrote:
> > > > This creates BDI_CAP_STABLE_WRITES, which indicates that a device requires
> > > > stable page writes.  It also plumbs in a sysfs attribute so that admins can
> > > > check the device status.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > >   I guess Jens Axboe <axboe@kernel.dk> would be the best target for this
> > > patch (so that he can merge it). The patch looks OK to me. You can add:
> > >   Reviewed-by: Jan Kara <jack@suse.cz>
> >   One more thing popped up in my mind: What about NFS, Ceph or md RAID5?
> > These could (at least theoretically) care about stable writes as well. I'm
> > not sure if they really started to use them but it would be good to at
> > least let them know.
> > 
> 
> What exactly are the semantics of BDI_CAP_STABLE_WRITES ?
> 
> If I set it for md/RAID5, do I get a cast-iron guarantee that no byte in any
> page submitted for write will ever change until after I call bio_endio()?
  Yes.

> If so, is this true for all filesystems? - I would expect a bigger patch would
> be needed for that.
  Actually the code is in kernel for quite some time already. The problem
is it is always enabled causing unnecessary performance issues for some
workloads. So these patches try to be more selective in when the code gets
enabled.

Regarding "all filesystems" question: If we update filemap_page_mkwrite()
to call wait_on_page_writeback() then it should be for all filesystems.

								Honza
