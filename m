From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 05:04:40 -0600
Message-ID: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19793 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0F3LEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Jun 2010 07:04:42 -0400
In-Reply-To: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-29, at 19:16, David Howells wrote:
> Implement a pair of new system calls to provide extended and further extensible stat functions.
> 
> The third of the associated patches provides these new system calls:
> 
> 	struct xstat_dev {
> 		unsigned int	major;
> 		unsigned int	minor;
> 	};

Doesn't glibc use two 64-bit values for devices?

> 	struct xstat {
> 		unsigned int		struct_version;
> 	#define XSTAT_STRUCT_VERSION	0

I dislike sequential "version" fields (which are "all or nothing"), and prefer the ext2/3/4-like "feature flags" that allow the caller to state what features and fields it expects and/or understands.  This allows extensibility without unduly breaking compatibility.

> 		unsigned int		st_mode;

Having a separate MODE flag would be great for "ls --color", since that is basically the only information that it needs that isn't already available in the readdir() output.

> 		unsigned int		st_nlink;
> 		unsigned int		st_uid;
> 		unsigned int		st_gid;

In struct stat64 it uses "unsigned long" for both st_uid and st_gid.  Having a 64-bit value here is useful for CIFS servers to be able to remap different UID domains into a 32-bit domain and a 32-bit UID.  If you change this, please remember to reorder the fields for proper 64-bit alignment.

> 		unsigned int		st_blksize;
> Does st_blksize really need to be 64 bits on a 64-bit system?

I don't think so, but adding a 32-bit padding couldn't hurt.

> 		unsigned long long	st_ino;
> 		unsigned long long	st_size;
> Should the inode number and data version number fields be 128-bit?

I wouldn't object to having a 128-bit st_ino field, since this is what Lustre will be using internally in the next release.

Similarly, _filesystems_ are not SO far from hitting the 64-bit size limit (a Lustre filesystem will likely hit 100PB ~= 2^57 bytes in the next year), so having a 128-bit st_size wouldn't be unreasonable, because...

What is also very convenient that I learned Solaris stat() does is it returns the device size in st_size for a block device file.  This is very convenient, and avoids the morass of ioctls and "binary llseek guessing" used by libext2fs and libblkid to determine the size of a block device.  Any reason not to add this into this new syscall?

> 		unsigned long long	st_blocks;

If st_size is 128-bit (or has padding) then st_blocks should have the same.

> 		unsigned long long	query_flags;

It is inconsistent to have all the other fields use the "st_" prefix, but "query_flags" and "struct_version" do not have this prefix.

> 	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL

Can these be split into separate ATIME, MTIME, CTIME flags?

> 	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL

It seems a bit inconsistent to call the field "st_btime" and the mask "CREATION_TIME".  It would be more consistent (if somewhat less clear) to call the mask "BTIME".  The struct definition should get short comments for each field to explain their meaning anyway, so "st_btime" can have "/* birth/creation time */".

> 	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL

This is also a bit inconsistent with the "st_gen" field name.

> 	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL

It wouldn't be a bad idea to interleave these flags with each of the fields that they represent, to make it more clear what is included in each.

> 	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL
> 	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL

Could you provide some information what the semantic distinction between these is?  It might be useful to have an "XSTAT_QUERY_LEGACY_STAT" mask that returns only the fields that are in the previous struct stat, unless that is what "ORDINARY_SET" means, in which case it should be renamed I think.

> 	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL

It is smart to have a "DEFINED_SET" mask that maps to the currently-understood fields.  This ensures that applications compiled against a specific set of headers/struct will not request fields which they don't understand.  It might be better to call this "XSTAT_QUERY_ALL" so that it is more easily understood and used by callers, instead of the incorrect "-1" or "~0" that some may be tempted to use if they don't understand what "__DEFINED_SET" means.


Cheers, Andreas





