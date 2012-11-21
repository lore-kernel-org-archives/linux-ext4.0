From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] bdi: Track users that require stable page writes
Date: Wed, 21 Nov 2012 05:52:49 -0500
Message-ID: <20121121105249.GA15010@infradead.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020034.10225.51692.stgit@blackbox.djwong.org>
 <20121121075435.GA16370@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121121075435.GA16370@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 21, 2012 at 02:54:35AM -0500, Christoph Hellwig wrote:
> On Tue, Nov 20, 2012 at 06:00:34PM -0800, Darrick J. Wong wrote:
> > This creates a per-backing-device counter that tracks the number of users which
> > require pages to be held immutable during writeout.  Eventually it will be used
> > to waive wait_for_page_writeback() if nobody requires stable pages.
> 
> Why are we going down this stupid route again now?  Just let the block
> device say it needs stable writes and let the VM deal with it.

Seems like the series actually does that, and this paragraph was just
left over from earlier versions.  Sorry for complaining too quickly, but
you really should update the description.
