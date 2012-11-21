From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] bdi: Track users that require stable page writes
Date: Wed, 21 Nov 2012 13:52:07 -0800
Message-ID: <20121121215207.GB32202@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020034.10225.51692.stgit@blackbox.djwong.org>
 <20121121105624.GA19050@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121121105624.GA19050@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ok, I'll update the description a bit.

On Wed, Nov 21, 2012 at 05:56:24AM -0500, Christoph Hellwig wrote:
> > +static inline void bdi_require_stable_pages(struct backing_dev_info *bdi)
> > +{
> > +	bdi->capabilities |= BDI_CAP_STABLE_WRITES;
> > +}
> > +
> > +static inline void bdi_unrequire_stable_pages(struct backing_dev_info *bdi)
> > +{
> > +	bdi->capabilities &= ~BDI_CAP_STABLE_WRITES;
> > +}
> 
> Any reason to provide these wrappers while other BDI_CAP_ values don't
> have it/
> 
> Also what protects bdi->capabilities against concurrent updates now that
> it gets modified at runtime?

Nothing seems to update ->capabilities at run time.

That said, if you're really worried about concurrent updates, I can always put
a spinlock around all the updates.

(Or revert to the atomic_t counter, but that seemed unpopular...)

I think I can drop the wrappers.

> > +static inline void queue_require_stable_pages(struct request_queue *q)
> > +{
> > +	bdi_require_stable_pages(&q->backing_dev_info);
> > +}
> > +
> > +static inline void queue_unrequire_stable_pages(struct request_queue *q)
> > +{
> > +	bdi_unrequire_stable_pages(&q->backing_dev_info);
> > +}
> > +
> > +static inline int queue_requires_stable_pages(struct request_queue *q)
> > +{
> > +	return bdi_cap_stable_pages_required(&q->backing_dev_info);
> > +}
> 
> Independent of the above I see no point in these wrappers that just
> provide a single dereference.
> 
> > +static ssize_t stable_pages_required_store(struct device *dev,
> > +					   struct device_attribute *attr,
> > +					   const char *buf, size_t count)
> 
> Can you add a rationale on why we'd want to allow users to change the
> value?  I can't really think of any.

I dislike the idea that if a program is dirtying pages that are being written
out, then I don't really know whether the disk will write the before or after
version.  If the power goes out before the inevitable second write, how do you
know which version you get?  Sure would be nice if I could force on stable
writes if I'm feeling paranoid.

--D
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
