From: Neil Brown <neilb@suse.de>
Subject: Re: [patch v2 1/5] mm: add nofail variants of
 kmalloc kcalloc and kzalloc
Date: Fri, 3 Sep 2010 07:15:06 +1000
Message-ID: <20100903071506.6e6b4d63@notabene>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
	<4C7F5951.6040809@gmail.com> <20100902145141.GA3273@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20100902145141.GA3273@quack.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Thu, 2 Sep 2010 16:51:41 +0200
Jan Kara <jack@suse.cz> wrote:

> On Thu 02-09-10 09:59:13, Jiri Slaby wrote:
> > On 09/02/2010 03:02 AM, David Rientjes wrote:
> > > --- a/include/linux/slab.h +++ b/include/linux/slab.h @@ -334,6 +334,57
> > > @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
> > > return kmalloc_node(size, flags | __GFP_ZERO, node); }
> > >  
> > > +/** + * kmalloc_nofail - infinitely loop until kmalloc() succeeds.  +
> > > * @size: how many bytes of memory are required.  + * @flags: the type
> > > of memory to allocate (see kmalloc).  + * + * NOTE: no new callers of
> > > this function should be implemented!  + * All memory allocations should
> > > be failable whenever possible.  + */ +static inline void
> > > *kmalloc_nofail(size_t size, gfp_t flags) +{ +	void *ret; + +	for
> > > (;;) { +		ret = kmalloc(size, flags); +		if (ret) +
> > > return ret; +		WARN_ON_ONCE(get_order(size) >
> > > PAGE_ALLOC_COSTLY_ORDER);
> > 
> > This doesn't work as you expect. kmalloc will warn every time it fails.
> > __GFP_NOFAIL used to disable the warning. Actually what's wrong with
> > __GFP_NOFAIL? I cannot find a reason in the changelogs why the patches
> > are needed.
>   David should probably add the reasoning to the changelogs so that he
> doesn't have to explain again and again ;). But if I understood it
> correctly, the concern is that the looping checks slightly impact fast path
> of the callers which do not need it. Generally, also looping for a long
> time inside allocator isn't a nice thing but some callers aren't able to do
> better for now to the patch is imperfect in this sence...
>

I'm actually a bit confused about this too.
I thought David said he was removing a branch on the *slow* path - which make
sense as you wouldn't even test NOFAIL until you had a failure.
Why are branches on the slow-path an issue??
This is an important question to me because I still hope to see the
swap-over-nfs patches merged eventually and they add a branch on the slow
path (if I remember correctly).

NeilBrown
