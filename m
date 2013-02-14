From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Thu, 14 Feb 2013 17:10:02 +1100
Message-ID: <20130214061002.GM26694@dastard>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
 <20130213133131.GE14195@fieldses.org>
 <20130213151455.GB17431@thunk.org>
 <20130213151953.GJ14195@fieldses.org>
 <20130213153654.GC17431@thunk.org>
 <20130213162059.GL14195@fieldses.org>
 <CAFboF2wXvP+vttiff8iRE9rAgvV8UWGbFprgVp8p7kE43TU=PA@mail.gmail.com>
 <20130213222052.GD5938@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anand Avati <anand.avati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130213222052.GD5938-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 13, 2013 at 05:20:52PM -0500, Theodore Ts'o wrote:
> Telldir() and seekdir() are basically implementation horrors for any
> file system that is using anything other than a simple array of
> directory entries ala the V7 Unix file system or the BSD FFS.  For any
> file system which is using a more advanced data structure, like
> b-trees hash trees, etc, there **can't** possibly be a "offset" into a
> readdir stream. 

I'll just point you to this:

http://marc.info/?l=linux-ext4&m=136081996316453&w=2

so you can see that XFS implements what you say can't possibly be
done. ;)

FWIW, that post only talked about the data segment. I didn't mention
that XFS has 2 other segments in the directory file (both beyond
EOF) for the directory data indexes. One contains the name-hash btree
index used for name based lookups and the other contains a freespace
index for tracking free space in the data segment.

IOWs persistent, deterministic, low cost telldir/seekdir behaviour
was a problem solved in the 1990s. :)

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
