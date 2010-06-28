From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and i_generation available by xattrs
Date: Mon, 28 Jun 2010 20:38:23 +0100
Message-ID: <8831.1277753903@redhat.com>
References: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769@dilger.ca> <20100628162626.6026.26679.stgit@warthog.procyon.org.uk>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19AAF9AA-2445-4C73-808B-4AD9C5C7E769-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> - I'd prefer calling these "file.generation" and "file.version".
>   I don't think there is value in the "i_" prefix adds anything,
>   and it seems more like an internal detail to me

That's reasonable.

> - why not expose the ".version" field for regular files?  It seems
>   that all of them are applicable for all file types.

Because Ext4 doesn't support it for anything other than directories.

> - it would be good to not introduce a new xattr namespace, since
>   tools like tar (even the RHEL-patched one) will not backup and
>   restore these namespaces.  Using "trusted." would allow them to
>   be backed up and restored using existing xattr-patched GNU tar
>   by root, but wouldn't allow them to be modified by regular users.
>   I think this is important for proper backup/restore of a filesystem,
>   but can have correctness implications and shouldn't be accessible
>   to regular users.

Does backing them up make sense, though?  They are filesystem structural
attributes.  Can you restore the inode number, for example?  If not, then you
can't restore i_generation either.  Restoring i_version might make sense, but
what if it winds i_version backwards whilst maintaining i_ino and i_generation,
that means there'll be a time in the future where the three values are once
again what might have been already published - and may already be in someone's
persistent cache.

> > file.crtime=0x53ba244c000000000000000000000000
> 
> Is this a binary (host-endian) struct timespec?

Yes.  That might not be the best representation, however.  It could also be,
say "<decimal-secs>.<decimal-nsecs>", eg: "1234.000000567".

> > file.i_generation=0x0000000000000000
> 
> This seems odd, i_generation should never be zero, AFAIK.

That might be because it's the root directory, and so cannot be replaced.

David
