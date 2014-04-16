From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Wed, 16 Apr 2014 12:43:09 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404161242480.2586@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com> <20140416063618.GA12498@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	tytso-3s7WtUTddSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140416063618.GA12498-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 15 Apr 2014, Christoph Hellwig wrote:

> Date: Tue, 15 Apr 2014 23:36:18 -0700
> From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> To: Lukas Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>     linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
>     xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Mon, Feb 17, 2014 at 04:08:17PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> Lukas, can you please also send a man page update for
> FALLOC_FL_ZERO_RANGE now that is has been merged?

Right, I'll do that.

Thanks!
-Lukas

> 
> > 
> > It can be used to convert a range of file to zeros preferably without
> > issuing data IO. Blocks should be preallocated for the regions that span
> > holes in the file, and the entire range is preferable converted to
> > unwritten extents - even though file system may choose to zero out the
> > extent or do whatever which will result in reading zeros from the range
> > while the range remains allocated for the file.
> > 
> > This can be also used to preallocate blocks past EOF in the same way as
> > with fallocate. Flag FALLOC_FL_KEEP_SIZE which should cause the inode
> > size to remain the same.
> > 
> > You can test this feature yourself using xfstests, of fallocate(1) however
> > you'll need patches for util_linux, xfsprogs and xfstests which you
> > can find here:
> > 
> > http://people.redhat.com/lczerner/zero_range/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
