From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: 4.2 kernel trace when hot unplug a mounted USB/SATA/MMC
	devices with ext2/ext3/ext4 file system
Date: Tue, 25 Aug 2015 10:53:14 +0200
Message-ID: <20150825085314.GA31630@lst.de>
References: <CADaLNDk7NNqe=839ro7KnwpfRAOLO3evX=JL12bMZR8vm2xYMg@mail.gmail.com> <20150813160128.GG10037@birch.djwong.org> <20150814080932.GA8710@quack.suse.cz> <CADaLNDmXi9ycM8RBLXn69YW-7Z3jw_=iESwn0AODv4VxPymVWw@mail.gmail.com> <20150815085810.GA21033@lst.de> <CADaLNDnupucoQ=7uAEHOfRaEEDZYUORwjC_VcHnBCUfdAoPSdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	"Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	patches <patches-qTEPVZfXA3Y@public.gmane.org>
To: Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CADaLNDnupucoQ=7uAEHOfRaEEDZYUORwjC_VcHnBCUfdAoPSdQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 24, 2015 at 02:20:07PM -0700, Duc Dang wrote:
> For more information. We tested kernel at commit 5f80f62ada "ext4:
> remove useless condition in if statement."
> (right before your commit) and still saw the issue.
> 
> df3305156f989339529b3d6744b898d498fb1f7b [media] v4l: xilinx: Add
> Xilinx Video IP core
> 08439fec266c3cc5702953b4f54bdf5649357de0 ext4: remove block_device_ejected
> 5f80f62adae2a2920781a847805d34b36b323f7d ext4: remove useless
> condition in if statement.
> c9bca8b33118573da9b7ac2ea21947a8e4d287dd [media] v4l: of: Add
> v4l2_of_parse_link() function
> 
> Further more, the issue does not happen with 3.19-rc7 but happens with 4.00-rc1

Thanks for the report.  Does it happen with commit aad653
"block: discard bdi_unregister() in favour of bdi_destroy()", either
cherry picked or the whole tree at that version?

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
