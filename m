From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 13/27] lib: add errseq_t type and infrastructure for
 handling it
Date: Wed, 10 May 2017 10:56:16 -0400
Message-ID: <1494428176.2688.25.camel@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
         <20170509154930.29524-14-jlayton@redhat.com>
         <20170510141821.GB1590@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
        ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org,
        jack-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org,
        neilb-l3A5Bk7waGM@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
        josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, hubcap-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org, rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        bo.li.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510141821.GB1590-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2017-05-10 at 07:18 -0700, Matthew Wilcox wrote:
> On Tue, May 09, 2017 at 11:49:16AM -0400, Jeff Layton wrote:
> > +++ b/lib/errseq.c
> > @@ -0,0 +1,199 @@
> > +#include <linux/err.h>
> > +#include <linux/bug.h>
> > +#include <linux/atomic.h>
> > +#include <linux/errseq.h>
> > +
> > +/*
> > + * An errseq_t is a way of recording errors in one place, and allowing any
> > + * number of "subscribers" to tell whether it has changed since an arbitrary
> > + * time of their choosing.
> 
> You use the word "time" in several places in the documentation, but I think
> it's clearer to say "sampling point" or "sample", since you're not using jiffies
> or nanoseconds.  For example, I'd phrase this paragraph this way:
> 
>  * An errseq_t is a way of recording errors in one place, and allowing any
>  * number of "subscribers" to tell whether it has changed since they last
>  * sampled it.
> 
> > + * The general idea is for consumers to sample an errseq_t value at a
> > + * particular point in time. Later, that value can be used to tell whether any
> > + * new errors have occurred since that time.
> 
>  * The general idea is for consumers to sample an errseq_t value.  That
>  * value can be used to tell whether any new errors have occurred since
>  * the last time it was sampled.
> 
> > +/* The "ones" bit for the counter */
> 
> Maybe "The lowest bit of the counter"?
> 
> > +/**
> > + * errseq_check - has an error occurred since a particular point in time?
> 
> "has an error occurred since the last time it was sampled"
> 
> > +/**
> > + * errseq_check_and_advance - check an errseq_t and advance it to the current value
> > + * @eseq: pointer to value being checked reported
> 
> "value being checked reported"?
> 

Thanks. I'm cleaning up the comments like you suggest.

> > +int errseq_check_and_advance(errseq_t *eseq, errseq_t *since)
> > +{
> > +	int err = 0;
> > +	errseq_t old, new;
> > +
> > +	/*
> > +	 * Most callers will want to use the inline wrapper to check this,
> > +	 * so that the common case of no error is handled without needing
> > +	 * to lock.
> > +	 */
> > +	old = READ_ONCE(*eseq);
> > +	if (old != *since) {
> > +		/*
> > +		 * Set the flag and try to swap it into place if it has
> > +		 * changed.
> > +		 *
> > +		 * We don't care about the outcome of the swap here. If the
> > +		 * swap doesn't occur, then it has either been updated by a
> > +		 * writer who is bumping the seq count anyway, or another
> > +		 * reader who is just setting the "seen" flag. Either outcome
> > +		 * is OK, and we can advance "since" and return an error based
> > +		 * on what we have.
> > +		 */
> > +		new = old | ERRSEQ_SEEN;
> > +		if (new != old)
> > +			cmpxchg(eseq, old, new);
> > +		*since = new;
> > +		err = -(new & MAX_ERRNO);
> > +	}
> 
> I probably need to read through the patchset some more to understand this.
> Naively, surely "since" should be updated to the current value of 'eseq'
> if we failed the cmpxchg()?

I don't think so. If we want to do that, then we'll need to redrive the
cmpxchg to set the SEEN flag if it's now clear. Storing the value in
"since" is effectively sampling it, so you do have to mark it seen.

The good news is that I think that "new" is just as valid a value to
store here as *eseq would be. It ends up representing an errseq_t value
that never actually got stored in eseq, but that's OK with the way this
works.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
