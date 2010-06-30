From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 13:05:44 +0100
Message-ID: <26505.1277899544@redhat.com>
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, smfrench@gmail.com,
	jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab0F3MGB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 08:06:01 -0400
In-Reply-To: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger@dilger.ca> wrote:

> Doesn't glibc use two 64-bit values for devices?

So it would seem.  Does Linux need to, though?

> I dislike sequential "version" fields (which are "all or nothing"), and
> prefer the ext2/3/4-like "feature flags" that allow the caller to state what
> features and fields it expects and/or understands.  This allows
> extensibility without unduly breaking compatibility.

My aim was to avoid the need to create new stat syscalls in the future by
making it possible to increment the version number you're asking for.

> > 		unsigned int		st_uid;
> > 		unsigned int		st_gid;
> 
> In struct stat64 it uses "unsigned long" for both st_uid and st_gid.  Having
> a 64-bit value here is useful for CIFS servers to be able to remap different
> UID domains into a 32-bit domain and a 32-bit UID.  If you change this,
> please remember to reorder the fields for proper 64-bit alignment.

glibc, on the other hand, only supports 32-bits for these.

My thought was that I could add extension fields to provide access to the
remote username/UID/GID values as well as the local UID/GID (since the latter
are used by the permission checking routines in the local VFS).

> I wouldn't object to having a 128-bit st_ino field, since this is what
> Lustre will be using internally in the next release.

I wonder how best to represent 128-bit numbers.

	unsigned long long long

gives:

	include/linux/stat.h:151: error: 'long long long' is too long for GCC

so perhaps something like:

	struct xstat_u128 { unsigned long long lsw, msw; };

however, I suspect the kernel will require a bit of reengineering to handle a
pgoff_t and loff_t of 128-bits.

> What is also very convenient that I learned Solaris stat() does is it
> returns the device size in st_size for a block device file.  This is very
> convenient, and avoids the morass of ioctls and "binary llseek guessing"
> used by libext2fs and libblkid to determine the size of a block device.  Any
> reason not to add this into this new syscall?

That's a separate problem.  That can be implemented now by overriding getattr
on blockdev files.  You could also set st_blocks and st_blksize to indicate
parameters of the blockdev - though that may upset df, I suppose.

> It is inconsistent to have all the other fields use the "st_" prefix, but
> "query_flags" and "struct_version" do not have this prefix.

They are a different sort of field (metametadata, I suppose).  But I can add
that on if you'd prefer.

> It wouldn't be a bad idea to interleave these flags with each of the fields
> that they represent, to make it more clear what is included in each.

Or comments could be used for that.

> > 	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL
> > 	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL
> 
> Could you provide some information what the semantic distinction between
> these is?  It might be useful to have an "XSTAT_QUERY_LEGACY_STAT" mask that
> returns only the fields that are in the previous struct stat, unless that is
> what "ORDINARY_SET" means, in which case it should be renamed I think.

XSTAT_QUERY_LEGACY_STAT is XSTAT_QUERY__ORDINARY_SET.  Is "legacy" an
appropriate appellation, though?  They're the set most people expect to see
and want to use.

> > 	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL
> 
> It is smart to have a "DEFINED_SET" mask that maps to the
> currently-understood fields.  This ensures that applications compiled
> against a specific set of headers/struct will not request fields which they
> don't understand.  It might be better to call this "XSTAT_QUERY_ALL" so that
> it is more easily understood and used by callers, instead of the incorrect
> "-1" or "~0" that some may be tempted to use if they don't understand what
> "__DEFINED_SET" means.

Passing -1 (or ULONGLONG_MAX) to get everything would be reasonable.

This should probably be an internal kernel constant.

David
