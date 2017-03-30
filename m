From: Boaz Harrosh <openosd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Date: Fri, 31 Mar 2017 00:11:11 +0300
Message-ID: <42bec37f-670c-3ea1-f2aa-7cecd619ad7e@gmail.com>
References: <20170320214327.GA5098@fieldses.org>
 <20170321134500.GA1318@infradead.org> <20170321163011.GA16666@fieldses.org>
 <1490117004.2542.1.camel@redhat.com> <20170321183006.GD17872@fieldses.org>
 <1490122013.2593.1.camel@redhat.com> <20170329111507.GA18467@quack2.suse.cz>
 <1490810071.2678.6.camel@redhat.com> <20170330064724.GA21542@quack2.suse.cz>
 <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org>
 <1490898932.2667.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490898932.2667.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 03/30/2017 09:35 PM, Jeff Layton wrote:
<>
> Yeah, I imagine we'd need a on-disk change for this unless there's
> something already present that we could use in place of a crash counter.
> 

Perhaps we can use s_mtime and/or s_wtime in some way, I'm not sure
what is a parallel for that in xfs.
	s_mtime - time-of-last mount 
	s_wtime - time-of-last mount, umount, freez, unfreez, remount, ...
Of course you'll need a per FS vector to access that.

But this will need some math foo to get the bits compacted correctly
just a thought.

Thanks
Boaz

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
