From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v4 13/27] lib: add errseq_t type and infrastructure for
 handling it
Date: Wed, 10 May 2017 07:29:19 -0400
Message-ID: <1494415759.2688.3.camel@redhat.com>
References: <20170509154930.29524-1-jlayton@redhat.com>
	 <20170509154930.29524-14-jlayton@redhat.com>
	 <87inl9n0wu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, akpm@linux-foundation.org, hch@infradead.org,
 ross.zwisler@linux.intel.com, mawilcox@microsoft.com, jack@suse.com,
 viro@zeniv.linux.org.uk, corbet@lwn.net, neilb@suse.de, clm@fb.com,
 tytso@mit.edu,  axboe@kernel.dk, josef@toxicpanda.com, hubcap@omnibond.com,
 rpeterso@redhat.com,  bo.li.liu@oracle.com
To: NeilBrown <neil@brown.name>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	jfs-discussion@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
	v9fs-developer@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	linux-block@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87inl9n0wu.fsf@notabene.neil.brown.name>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2017-05-10 at 08:03 +1000, NeilBrown wrote:
> On Tue, May 09 2017, Jeff Layton wrote:
> 
> > An errseq_t is a way of recording errors in one place, and allowing any
> > number of "subscribers" to tell whether an error has been set again
> > since a previous time.
> > 
> > It's implemented as an unsigned 32-bit value that is managed with atomic
> > operations. The low order bits are designated to hold an error code
> > (max size of MAX_ERRNO). The upper bits are used as a counter.
> > 
> > The API works with consumers sampling an errseq_t value at a particular
> > point in time. Later, that value can be used to tell whether new errors
> > have been set since that time.
> > 
> > Note that there is a 1 in 512k risk of collisions here if new errors
> > are being recorded frequently, since we have so few bits to use as a
> > counter. To mitigate this, one bit is used as a flag to tell whether the
> > value has been sampled since a new value was recorded. That allows
> > us to avoid bumping the counter if no one has sampled it since it
> > was last bumped.
> > 
> > Later patches will build on this infrastructure to change how writeback
> > errors are tracked in the kernel.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> I like that this is a separate lib/*.c - nicely structured too.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> 
> 

Thanks, yeah...it occurred to me that this scheme is not really specific
to writeback errors. While I can't think of another use-case for
errseq_t's right offhand, I think this makes for cleaner layering and
should make it easy to use in other ways should they arise.

-- 
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
