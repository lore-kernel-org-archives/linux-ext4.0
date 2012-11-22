From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bdi: Track users that require stable page writes
Date: Thu, 22 Nov 2012 02:08:22 -0500
Message-ID: <20121122070822.GA8231@infradead.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020034.10225.51692.stgit@blackbox.djwong.org>
 <20121121105624.GA19050@infradead.org>
 <20121121215207.GB32202@blackbox.djwong.org>
 <20121122090643.7c9551dc@notabene.brown>
 <20121122023343.GC32202@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: NeilBrown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
	axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121122023343.GC32202@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 21, 2012 at 06:33:43PM -0800, Darrick J. Wong wrote:
> How's this look to everyone?  No more user-writable flag, and most of the
> helper functions are gone.

Now fix up the subject line as well and we might have a deal :)

> (Are these emails even getting through?)

At least this one is.
