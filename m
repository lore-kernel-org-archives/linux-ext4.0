From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
	i_generation available by xattrs
Date: Tue, 29 Jun 2010 15:59:44 -0700
Message-ID: <20100629225944.GA22924@samba1>
References: <20100628164854.GA9979@samba1> <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com> <26197.1277851477@redhat.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <26197.1277851477-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 29, 2010 at 11:44:37PM +0100, David Howells wrote:
> Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > We already have code in Samba to detect "birthtime"
> > (st_btime) as a returned member of a stat struct.
> 
> Is it, though?
> 
> Googling for st_btime suggests it could also be taken as the time last
> archived.  That may just be a NetWareism though.

It's a *BSD'ism.

http://www.daemon-systems.org/man/fstat.2.html

     #if defined(_NETBSD_SOURCE)
         struct timespec st_birthtimespec;   /* time of inode creation */
     #else
         time_t    st_birthtime;             /* time of inode creation */
         long      st_birthtimensec;         /* nsec of inode creation */
     #endif

http://www.unix.com/man-page/FreeBSD/2/stat/

st_birthtime  Time when the inode was created.

Of course, for Samba's use we also have to be
able to *write* to st_birthtime as Windows clients
can change this. But that's what the EA is for
(and I'm happy with a system that can only read
st_birthtime, not write it).

Jeremy.
