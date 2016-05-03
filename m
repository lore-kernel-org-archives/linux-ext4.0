From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] statx: Ext4: Return enhanced file attributes
Date: Tue, 03 May 2016 21:24:40 +0100
Message-ID: <10499.1462307080@warthog.procyon.org.uk>
References: <ABA29DAB-BDD2-44E9-8E2B-AE227A823ECD@dilger.ca> <20160429125736.23636.47874.stgit@warthog.procyon.org.uk> <20160429125759.23636.10635.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ABA29DAB-BDD2-44E9-8E2B-AE227A823ECD-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Content-ID: <10498.1462307080.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> > (3) FS_xxx_FL flags are returned as for ioctl(FS_IOC_GETFLAGS), setting
> >     STATX_IOC_FLAGS.
> 
> I don't see where this is implemented in this patch, and it should be
> removed from the commit message to avoid confusion.

Oops - I forgot to remove it from the other patches.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
