From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Wed, 30 Jun 2010 10:20:53 +0200
Message-ID: <201006301020.53978.arnd@arndb.de>
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100629200315.23196.68742.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 29 June 2010 22:03:15 David Howells wrote:
>         ssize_t ret = xstat(int dfd,
>                             const char *filename,
>                             unsigned atflag,
>                             struct xstat *buffer,
>                             size_t buflen);
> 
>         ssize_t ret = fxstat(int fd,
>                              struct xstat *buffer,
>                              size_t buflen);
> 
> 
> The dfd, filename, atflag and fd parameters indicate the file to query.  There
> is no equivalent of lstat() as that can be emulated with xstat(), passing 0
> instead of AT_SYMLINK_NOFOLLOW as atflag.

Do we actually need the fxstat variant? IIRC, some *at syscalls just
operate on dfd when filename==NULL, which would be trivial to do here.

	Arnd
