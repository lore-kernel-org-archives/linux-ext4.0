From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 15:45:23 -0600
Message-ID: <FB78A152-53D3-4000-ABDB-9D6051ECB887@dilger.ca>
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <26505.1277899544@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26505.1277899544-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-06-30, at 06:05, David Howells wrote:
> Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:
>> In struct stat64 it uses "unsigned long" for both st_uid and st_gid.  Having
>> a 64-bit value here is useful for CIFS servers to be able to remap different
>> UID domains into a 32-bit domain and a 32-bit UID.  If you change this,
>> please remember to reorder the fields for proper 64-bit alignment.
> 
> glibc, on the other hand, only supports 32-bits for these.

For the cost of those extra bytes it would definitely save a lot of extra complexity in every application packing and unpacking the struct.  At a minimum put a 32-bit padding that is zero-filled for now.

>> I wouldn't object to having a 128-bit st_ino field, since this is what
>> Lustre will be using internally in the next release.
> 
> so perhaps something like:
> 
> 	struct xstat_u128 { unsigned long long lsw, msw; };
> 
> however, I suspect the kernel will require a bit of reengineering to handle a
> pgoff_t and loff_t of 128-bits.

Well, not any different from having 32-bit platforms work with two 32-bit values for 64-bit offsets today, except that we would be doing this with two 64-bit values.

>> What is also very convenient that I learned Solaris stat() does is it
>> returns the device size in st_size for a block device file.  This is very
>> convenient, and avoids the morass of ioctls and "binary llseek guessing"
>> used by libext2fs and libblkid to determine the size of a block device.  Any
>> reason not to add this into this new syscall?
> 
> That's a separate problem.  That can be implemented now by overriding getattr
> on blockdev files.  You could also set st_blocks and st_blksize to indicate
> parameters of the blockdev - though that may upset df, I suppose.

I don't know if Solaris does that or not, I'd have to check with someone who has more than anecdotal understanding of it.  Actually, a quick google shows that st_blocks and st_blksize are undefined for block/char devices.

>>> 	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL
>>> 	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL
>> 
>> Could you provide some information what the semantic distinction between
>> these is?  It might be useful to have an "XSTAT_QUERY_LEGACY_STAT" mask that
>> returns only the fields that are in the previous struct stat, unless that is
>> what "ORDINARY_SET" means, in which case it should be renamed I think.
> 
> XSTAT_QUERY_LEGACY_STAT is XSTAT_QUERY__ORDINARY_SET.  Is "legacy" an
> appropriate appellation, though?  They're the set most people expect to see
> and want to use.

I was thinking that most applications using this interface would use it because they have a specific need to, or it would be internal to glibc.  In those cases it is useful to know what the "traditional" stat() returned, but I don't think "__ORDINARY_SET" encompasses that idea.  Other possibilities include "NORMAL_STAT" or "BASIC_STAT", or similar.

>>> 	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL
>> 
>> It is smart to have a "DEFINED_SET" mask that maps to the
>> currently-understood fields.  This ensures that applications compiled
>> against a specific set of headers/struct will not request fields which they
>> don't understand.  It might be better to call this "XSTAT_QUERY_ALL" so that
>> it is more easily understood and used by callers, instead of the incorrect
>> "-1" or "~0" that some may be tempted to use if they don't understand what
>> "__DEFINED_SET" means.
> 
> Passing -1 (or ULONGLONG_MAX) to get everything would be reasonable.

NOOOO.  That is exactly what we _don't_ want, since it makes it impossible for the kernel to actually understand which fields the application is ready to handle.  If the application always uses XSTAT_QUERY_ALL, instead of "-1", then the kernel can easily tell which fields are present in the userspace structure, and what it should avoid touching.

If applications start using "-1" to mean "all fields", then it will work so long as the kernel and userspace agree on the size of struct xstat, but as soon as the kernel understands some new field, but userspace does not, the application will segfault or clobber random memory because the kernel thinks it is asking for XSTAT_QUERY_NEXT_NEW_FIELD|... when it really isn't asking for that at all.

Cheers, Andreas
