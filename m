From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9 v3] ext4: Punch hole and DAX fixes
Date: Wed, 11 Nov 2015 16:25:42 +0100
Message-ID: <20151111152542.GB27806@quack.suse.cz>
References: <1446653920-23127-1-git-send-email-jack@suse.com>
 <80B02B5F638F054B8B1358323FECDE0A5EA64CCF@G1W3650.americas.hpqcorp.net>
 <20151109162256.GH11149@quack.suse.cz>
 <20151109165149.GI11149@quack.suse.cz>
 <20151110000027.GM19199@dastard>
 <20151110100253.GF26699@quack.suse.cz>
 <20151110223139.GN19199@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Boylston, Brian" <brian.boylston@hpe.com>,
	Jan Kara <jack@suse.com>, Ted Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	dchinner@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbKKPZq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Nov 2015 10:25:46 -0500
Content-Disposition: inline
In-Reply-To: <20151110223139.GN19199@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 11-11-15 09:31:39, Dave Chinner wrote:
> On Tue, Nov 10, 2015 at 11:02:53AM +0100, Jan Kara wrote:
> > On Tue 10-11-15 11:00:27, Dave Chinner wrote:
> > > On Mon, Nov 09, 2015 at 05:51:49PM +0100, Jan Kara wrote:
> > > > The zeroing code in __dax_fault() needs to go away anyway so whether we
> > > > return buffer_new buffer is not really substantial but I'd like to get some
> > > > agreement and consistency among filesystems in with which flags zeroed
> > > > blocks are returned. Thoughts?
> > > 
> > > There is no consistency to begin with, especially w.r.t. unwritten
> > > extent behaviour as the upper layers don't all understand that
> > > buffer_unwritten is a valid flag for getblock to return. Hence we
> > > have hacks in XFS setting buffer_new() in strange cases to get the
> > > upper level code to zero stuff that really needs zeroing...
> > 
> > In ext4 we set buffer as new in two cases:
> > 
> > 1) When it was freshly allocated (regardless whether into unwritten or
> >    normal extent).
> 
> Which only works for freshly allocated unwritten extents, not for
> writes into preallocated extents.
> 
> > 2) When it was converted from unwritten to written state.
> 
> Which, for direct IO, is no good when we do the conversion after IO
> completion because we need to know at IO submission if we need to do
> sub-block zeroing (i.e. dio_zero_block() will skip the zeroing if
> buffer_new() is not set on unwritten blocks).

OK, sorry I parsed the code flow wrong, ext4 sets buffer_new for any
unwritten extent it returns (when create == 1 only but that doesn't really
make a difference). And then for any freshly allocated block. This seems
pretty consistent to me. There are two places in ext4 that set returned
buffer as new (those two cases mentioned above) and that seems to be
enough. Maybe XFS needs something different but at least from looking at
ext4 setting of buffer_new is not complex...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
