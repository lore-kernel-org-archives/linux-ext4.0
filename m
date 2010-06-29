From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Wed, 30 Jun 2010 00:29:52 +0100
Message-ID: <32322.1277854192@redhat.com>
References: <20100629224844.GF4150@mail.oracle.com> <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk> <26026.1277851016@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joel Becker <Joel.Becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100629224844.GF4150-0Ol/1UON5C7fiIqoQl7HmA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Joel Becker <Joel.Becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> 	The less variable length stuff the better, I think.  At least,
> for the stuff stat(2) already returns, you should have a fixed-size
> structure.  Even if I only pass the GIVE_ME_UIDS flag, I don't want to
> have to deal with the variable size stuff until I've actually asked for
> esoteric things.  I'll know that the non-UIDS fields are garbage by the
> fact that I didn't ask for them.

I was thinking of the fixed length xstat struct plus appendable extensions to
be defined later.

I could live with each defined extension being of a fixed length, so for
example, you set bit 20, and it adds, say, a 16-byte volume ID in the
appropriate order, padded out appropriately for the filesystem.

David
