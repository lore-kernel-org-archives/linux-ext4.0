From: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 20:16:27 -0400
Message-ID: <20070927001627.GA18346@thunk.org>
References: <20070925153735.GA26693@infradead.org> <20070926105946.GB429@thunk.org> <20070926120533.GA15894@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070926120533.GA15894-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 26, 2007 at 01:05:33PM +0100, Christoph Hellwig wrote:
>  - make mount/fsck use libvolume_id unconditionally for detecting the
>    filesystem type.  There's absolute no reason to use anything in
>    libblkid for this, and caching the result doesn't help us at all
>    as we're going to touch the disk anyway as part of the mount/fsck.
>  - make libblkid use libvolume_id internally for filesystem detection

No, that's not true, since on a non-udev system (and there are those,
including a number of kernel hackers, who don't use udev for a number
of reasons --- like not trusting the sysfs/udev breakages, and who
want a static /dev) you need an efficient way to do lookup by UUID or
by LABEL without needing to search every single device.  If you have a
some large storage box with 30,000 LUN's, you don't want to search
them all at boot time, whether you are using udev, especially if you
are only mounting a small subset of the images on demand.  So there
will be circumstances where you really will want to use the cache, and
*not* want to use /dev/disk/by-* as the lookup mechanism.

      	      	  		    	       - Ted
