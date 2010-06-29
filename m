From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation	available by xattrs
Date: Tue, 29 Jun 2010 12:13:54 -0600
Message-ID: <E7B61059-6CF2-4269-A1E7-E398F7B97CCF@dilger.ca>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca> <8831.1277753903@redhat.com> <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikhZn15GmOTe-fsM2IgxHFxtZIRBOb_4kPWSR4E-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-06-28, at 13:41, Steve French wrote:
> I think backing them up makes sense, even if they can't easily
> be restored (ie just for reporting).

Right.  I think being able to restore the crtime (as root) makes sense, I don't think restoring i_generation and i_version make sense however, given that we can't preserve the inode number.  The filesystem can silently ignore them when they are written as xattrs (returning an error gives "tar" and "cp" heartburn, we've found).

> Are there security differences between the "trusted" namespace that
> would make it harder for an app to read them (the man page did not list
> the security differences between trusted and user xattrs).

"trusted." is only writeable by root and the kernel.  "user." is writeable by regular users.

Cheers, Andreas
