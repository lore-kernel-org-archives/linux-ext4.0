From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v2 1/8] vfs: Add a new flag and related functions in
 buffer to count io types
Date: Fri, 11 Nov 2011 23:36:29 +0800
Message-ID: <20111111153629.GB6826@gmail.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
 <1320921294-30321-2-git-send-email-wenqing.lz@taobao.com>
 <1321008513.2710.33.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1321008513.2710.33.camel@menhir>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 11, 2011 at 10:48:33AM +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Thu, 2011-11-10 at 18:34 +0800, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > 'Issue' flag is added into buffer_head to indicate that a request is issued
> > to the disk. When an io doesn't hit page cache, 'Issue' flag will be set in
> > submit_bh(). Filesystem can understand request is sent to the disk according
> > to whether or not this flag is set. This flag will be cleared after filesystem
> > tests it. If filesystem doesn't want to count the io type, it can ignore this
> > flag.
> > 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
> > ---
> >  fs/buffer.c                 |    3 +++
> >  include/linux/buffer_head.h |    5 +++++
> >  2 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 70a1974..f681caa 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2920,6 +2920,9 @@ int submit_bh(int rw, struct buffer_head * bh)
> >  	BUG_ON(buffer_delay(bh));
> >  	BUG_ON(buffer_unwritten(bh));
> >  
> > +	/* set issue flag for indicating a request is issued to the disk */
> > +	set_buffer_issue(bh);
> > +
> >  	/*
> >  	 * Only clear out a write error when rewriting
> >  	 */
> > diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> > index 458f497..2bccdb4 100644
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -38,6 +38,10 @@ enum bh_state_bits {
> >  	BH_PrivateStart,/* not a state bit, but the first bit available
> >  			 * for private allocation by other entities
> >  			 */
> > +
> > +	BH_Issue,	/* Issue a request to the disk when this request
> > +			 * doesn't hit cache
> > +			 */
> >  };
> This looks like it will collide with any fs using more than one private
> flag, for example, ext4.

I will put this flag on the top of BH_PrivateStart.

Regards,
Zheng

> 
> 
> Steve.
> 
> 
> 
> >  
> >  #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
> > @@ -124,6 +128,7 @@ BUFFER_FNS(Delay, delay)
> >  BUFFER_FNS(Boundary, boundary)
> >  BUFFER_FNS(Write_EIO, write_io_error)
> >  BUFFER_FNS(Unwritten, unwritten)
> > +BUFFER_FNS(Issue, issue)
> >  
> >  #define bh_offset(bh)		((unsigned long)(bh)->b_data & ~PAGE_MASK)
> >  #define touch_buffer(bh)	mark_page_accessed(bh->b_page)
> 
> 
