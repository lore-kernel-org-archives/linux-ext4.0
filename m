From: Duc Dang <dhdang-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: 4.2 kernel trace when hot unplug a mounted USB/SATA/MMC devices
 with ext2/ext3/ext4 file system
Date: Mon, 24 Aug 2015 14:20:07 -0700
Message-ID: <CADaLNDnupucoQ=7uAEHOfRaEEDZYUORwjC_VcHnBCUfdAoPSdQ@mail.gmail.com>
References: <CADaLNDk7NNqe=839ro7KnwpfRAOLO3evX=JL12bMZR8vm2xYMg@mail.gmail.com>
 <20150813160128.GG10037@birch.djwong.org> <20150814080932.GA8710@quack.suse.cz>
 <CADaLNDmXi9ycM8RBLXn69YW-7Z3jw_=iESwn0AODv4VxPymVWw@mail.gmail.com> <20150815085810.GA21033@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	"Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	"Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
	Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	patches <patches-qTEPVZfXA3Y@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150815085810.GA21033-jcswGhMUV9g@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Aug 15, 2015 at 1:58 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Fri, Aug 14, 2015 at 05:52:44PM -0700, Duc Dang wrote:
>> The commit 08439fec26 "ext4: remove block_device_ejected" only causes
>> issue with ext4 and
>> trying reverting it helps our test passes with ext4.
>>
>> But how about the same issue with ext2/ext3?
>
> I tried to fix the underlying issue, but I either failed to fully
> fixed it or someone regressed it.
>
> Can you if rev 08439fec26 on it's own works to see if I missed
> a case or it was regressed later?

For more information. We tested kernel at commit 5f80f62ada "ext4:
remove useless condition in if statement."
(right before your commit) and still saw the issue.

df3305156f989339529b3d6744b898d498fb1f7b [media] v4l: xilinx: Add
Xilinx Video IP core
08439fec266c3cc5702953b4f54bdf5649357de0 ext4: remove block_device_ejected
5f80f62adae2a2920781a847805d34b36b323f7d ext4: remove useless
condition in if statement.
c9bca8b33118573da9b7ac2ea21947a8e4d287dd [media] v4l: of: Add
v4l2_of_parse_link() function

Further more, the issue does not happen with 3.19-rc7 but happens with 4.00-rc1

-- 
Regards,
Duc Dang.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
