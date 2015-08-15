From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: 4.2 kernel trace when hot unplug a mounted USB/SATA/MMC
	devices with ext2/ext3/ext4 file system
Date: Sat, 15 Aug 2015 10:58:10 +0200
Message-ID: <20150815085810.GA21033@lst.de>
References: <CADaLNDk7NNqe=839ro7KnwpfRAOLO3evX=JL12bMZR8vm2xYMg@mail.gmail.com> <20150813160128.GG10037@birch.djwong.org> <20150814080932.GA8710@quack.suse.cz> <CADaLNDmXi9ycM8RBLXn69YW-7Z3jw_=iESwn0AODv4VxPymVWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	"Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	patches <patches-qTEPVZfXA3Y@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org
To: Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADaLNDmXi9ycM8RBLXn69YW-7Z3jw_=iESwn0AODv4VxPymVWw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 14, 2015 at 05:52:44PM -0700, Duc Dang wrote:
> The commit 08439fec26 "ext4: remove block_device_ejected" only causes
> issue with ext4 and
> trying reverting it helps our test passes with ext4.
> 
> But how about the same issue with ext2/ext3?

I tried to fix the underlying issue, but I either failed to fully
fixed it or someone regressed it.

Can you if rev 08439fec26 on it's own works to see if I missed
a case or it was regressed later?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
