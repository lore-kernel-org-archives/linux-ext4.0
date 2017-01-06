From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: introduce kv[mz]alloc helpers
Date: Fri, 6 Jan 2017 14:34:59 +0100
Message-ID: <20170106133459.GM5556@dhcp22.suse.cz>
References: <20170102133700.1734-1-mhocko@kernel.org>
 <747f7b9a-e95d-a872-7e30-ea235b91593a@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org,
	Joe Perches <joe@perches.com>,
	Anatoly Stepanov <astepanov@cloudlinux.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: Vlastimil Babka <vbabka@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <747f7b9a-e95d-a872-7e30-ea235b91593a@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Fri 06-01-17 14:29:33, Vlastimil Babka wrote:
> On 01/02/2017 02:37 PM, Michal Hocko wrote:
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -514,18 +514,9 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(vhost_dev_set_owner);
> >  
> > -static void *vhost_kvzalloc(unsigned long size)
> > -{
> > -	void *n = kzalloc(size, GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);
> 
> Hi, I just noticed that this had __GFP_REPEAT, so you'll probably want
> to move these hunks to patch 3 with the rest of vhost.

Well, spotted. I will do that. Thanks!

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
