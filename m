From: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Thu, 22 Jul 2010 12:35:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100715021712.5544.44845.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


On Thursday 2010-07-15 04:17, David Howells wrote:
> (6) BSD stat compatibility: Including more fields from the BSD stat such as
>     creation time (st_btime) and inode generation number (st_gen) [Jeremy
>     Allison, Bernd Schubert].
>where st_btime is the file creation time, st_gen is the inode generation
>(i_generation), st_data_version is the data version number (i_version),
>st_inode_flags is the flags from FS_IOC_GETFLAGS plus some extras,
>request_mask and st_result_mask are bitmasks of data desired/provided and
>st_extra_results[] is where as-yet undefined fields are appended.

Linux already has a creation time field, it's called otime (there is no "b" in
"creation"), and you will find scattered fragments of that all over the kernel
(foremost, fs/jfs/, now btrfs, and I also notice sysvipc having something with
that name).

>	struct xstat_time {
>		unsigned long long	tv_sec, tv_nsec;
>	};

If it helps getting rid of the ugly suseconds_t in userspace ;-)
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
