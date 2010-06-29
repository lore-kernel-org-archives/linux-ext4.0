From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions
Date: Tue, 29 Jun 2010 22:11:19 +0100
Message-ID: <24517.1277845879@redhat.com>
References: <201006292307.42440.bernd.schubert@fastmail.fm> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201006292307.42440.bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org> wrote:

> Is there any chance we can use that chance and also add a field 
> 
> unsigned long long st_gen
> 
> to struct_ xstat? Inode generation numbers really would be useful for 
> userspace NFS servers and some fuse filesystems.

That would be st_inode_version (equivalent to i_generation internally).

David
