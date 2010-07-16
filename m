From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Fri, 16 Jul 2010 13:02:35 +0200
Message-ID: <201007161302.35775.arnd@arndb.de>
References: <20100716062251.GA9318@zoia.osj.us> <30646.1279230807@redhat.com> <8527.1279275842@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Mark Harris <mhlk-gcwzot8L0og@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8527.1279275842-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Friday 16 July 2010, David Howells wrote:
> Mark Harris <mhlk-gcwzot8L0og@public.gmane.org> wrote:
> So how about using up the dead space for what Steve French wanted:
> 
>         | One hole that this reminded me about is how to return the superblock
>         | time granularity (for NFSv4 this is attribute 51 "time_delta" which
>         | is called on a superblock not on a file).  We run into time rounding
>         | issues with Samba too.
> 
> By doing something like:
> 
>         struct xstat_time {
>                 signed long long        tv_sec;
>                 unsigned int            tv_nsec;
>                 unsigned short          tv_granularity;
>                 unsigned short          tv_gran_units;
>         };

I like that!

> Where tv_granularity is the minimum granularity for tv_sec and tv_nsec given
> as a quantity of tv_gran_units.  tv_gran_units could then be a constant, such
> as:
> 
>         XSTAT_NANOSECONDS_GRANULARITY
>         XSTAT_MICROSECONDS_GRANULARITY
>         XSTAT_MILLISECONDS_GRANULARITY
>         XSTAT_SECONDS_GRANULARITY
>         XSTAT_MINUTES_GRANULARITY
>         XSTAT_HOURS_GRANULARITY
>         XSTAT_DAYS_GRANULARITY
> 
> So, for example, FAT times are a 2s granularity, so FAT would set
> tv_granularity to 2 and tv_gran_units to XSTAT_SECONDS_GRANULARITY.

You could also define the tv_gran_units to be power-of-ten nanoseconds,
making it a decimal floating point number like 

enum {
	XSTAT_NANOSECONDS_GRANULARITY = 0,
	XSTAT_MICROSECONDS_GRANULARITY = 3,
	XSTAT_MILLISECONDS_GRANULARITY = 6,
	XSTAT_SECONDS_GRANULARITY = 9,
};

That would make it easier to define an xstat_time_before() function, though
it means that you could no longer do XSTAT_MINUTES_GRANULARITY and
higher directly other than { .tv_gran_units = 10, .tv_granularity = 6, }.

> We could even support picosecond granularity if we made tv_nsec a 5-byte
> field (tv_psec):
> 
>         struct xstat_time {
>                 signed long long        tv_sec;
>                 unsigned long long      tv_gran_units : 8;
>                 unsigned long long      tv_granularity : 16;
>                 unsigned long long      tv_psec : 48;
>         };
> 
> but that's probably excessive.  Does any filesystem we currently support need
> that?

I wouldn't even go that far if we needed sub-ns (I don't think we do), because
that breaks old compilers that cannot do bit fields.

	Arnd
