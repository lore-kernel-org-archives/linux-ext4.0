From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 20/20] gfs2: clean up some filemap_* calls
Date: Mon, 24 Apr 2017 13:52:36 -0400
Message-ID: <1493056356.2895.19.camel@redhat.com>
References: <20170424132259.8680-1-jlayton@redhat.com>
         <20170424132259.8680-21-jlayton@redhat.com>
         <2139341349.405174.1493043175630.JavaMail.zimbra@redhat.com>
         <1493053143.2895.15.camel@redhat.com>
         <2092108386.509535.1493055674293.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
        jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
        v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org,
        linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
        ross zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>,
        mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, jack-IBi9RG/b67k@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
        corbet-T1hC0tSOHrs@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
To: Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2092108386.509535.1493055674293.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2017-04-24 at 13:41 -0400, Bob Peterson wrote:
> Hi,
> 
> ----- Original Message -----
> > On Mon, 2017-04-24 at 10:12 -0400, Bob Peterson wrote:
> > > > +	filemap_write_and_wait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
> > > 
> > > This should probably have "error = ", no?
> > > 
> > 
> > This error is discarded in the current code after resetting the error in
> > the mapping. With the earlier patches in this set we don't need to reset
> > the error like this anymore.
> > 
> > Now, if this code should doing something else with those errors, then
> > that's a separate problem.
> 
> Okay, I see. My bad.
>  
> > > >  	gfs2_ail_empty_gl(gl);
> > > >  
> > > >  	spin_lock(&gl->gl_lockref.lock);
> > > > @@ -225,12 +223,10 @@ static void inode_go_sync(struct gfs2_glock *gl)
> > > >  	filemap_fdatawrite(metamapping);
> > > >  	if (ip) {
> > > >  		struct address_space *mapping = ip->i_inode.i_mapping;
> > > > -		filemap_fdatawrite(mapping);
> > > > -		error = filemap_fdatawait(mapping);
> > > > -		mapping_set_error(mapping, error);
> > > > +		filemap_write_and_wait(mapping);
> > > > +	} else {
> > > > +		filemap_fdatawait(metamapping);
> > > >  	}
> > > > -	error = filemap_fdatawait(metamapping);
> > > > -	mapping_set_error(metamapping, error);
> > > 
> > > This part doesn't look right at all. There's a big difference in gfs2
> > > between
> > > mapping and metamapping. We need to wait for metamapping regardless.
> > > 
> > 
> > ...and this should wait. Basically, filemap_write_and_wait does
> > filemap_fdatawrite and then filemap_fdatawait. This is mostly just
> > replacing the existing code with a more concise helper.
> 
> But this isn't a simple replacement with a helper. This is two different
> address spaces (mapping and metamapping) and you added an else in there.
> 
> So with this patch metamapping gets written, and if there's an ip,
> mapping gets written but it doesn't wait for metamapping. Unless
> I'm missing something.
> 
> You could replace both filemap_fdatawrites with the helper instead.
> Today's code is structured as:
> 
> (a) write metamapping
> if (ip)
>     (b) write mapping
>     (c) wait for mapping
> (d) wait for metamapping
> 
> If you use the helper for both, it becomes, (a & d)(b & c) which is probably
> acceptable. (I think we just tried to optimize what the elevator was doing).
> 
> But the way you've got it coded here still looks wrong. It looks like:
> (a)
> if (ip)
>    (b & c)
> ELSE -
>    (d)
> 
> So (d) (metamapping) isn't guaranteed to be synced at the end of the function.
> Of course, you know the modified helper functions better than I do.
> What am I missing?
> 
> 

<facepalm>
You're right of course. I'll fix that up in my tree.

Thanks!
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
