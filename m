From: Mark Harris <mhlk-gcwzot8L0og@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
	extended file stats available [ver #6]
Date: Fri, 16 Jul 2010 22:51:30 -0700
Message-ID: <20100717055130.GA2053@zoia.osj.us>
References: <201007161302.35775.arnd@arndb.de> <20100716062251.GA9318@zoia.osj.us> <30646.1279230807@redhat.com> <8527.1279275842@redhat.com> <10677.1279283886@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <10677.1279283886-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

David Howells wrote:
> With a 2:2 split between exponent
> (tv_gran_units) and mantissa (tv_granularity), you can do:
> 
> 	UNIT		SECONDS/UNIT	EXPONENT	MANTISSA
> 	nanoseconds	0.000000001	-9		1
> 	microseconds	0.000001	-6		1
> 	millseconds	0.001		-3		1
> 	seconds		1		0		1
> 	minutes		60		1		6
> 	hours		3600		2		36
> 	days		86400		2		864
> 	weeks		604800		2		6048

At least for the in-tree filesystems, I do not see any that keep
timestamps with a granularity larger than 2s.  For that, a simple
32-bit tv_granularity in nanoseconds (not limited to 1e9) would
suffice, and there is no need for the complexity of dealing with
a separate exponent.

If there is a need to handle larger granularity, its msb could
potentially be used to indicate that the number is in seconds
instead of nanoseconds.  This is convenient because the timestamp
is already broken down into sec and nsec fields.  So this bit would
then indicate that the granularity applies to the tv_sec field, and
that tv_nsec is not in use.  But even this is overkill if no one
uses a granularity larger than 2s.

 - Mark
