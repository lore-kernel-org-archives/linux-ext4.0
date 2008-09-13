From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 13 Sep 2008 22:59:40 +0100
Message-ID: <29D7C671-F1D5-48BE-AEB4-07669FC3B405@cam.ac.uk>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk> <20080913212903.GF26128@mit.edu>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:36208 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYIMV7n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2008 17:59:43 -0400
In-Reply-To: <20080913212903.GF26128@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 13 Sep 2008, at 22:29, Theodore Tso wrote:
> On Sat, Sep 13, 2008 at 10:17:07PM +0100, Anton Altaparmakov wrote:
>> Just a quick question (not a criticism of the patches in any way):
>>
>> Is there a specific reason that the flag FIEMAP_EXTENT_DATA_ENCRYPTED
>> exists?  I am only asking because there isn't a
>> FIEMAP_EXTENT_DATA_COMPRESSED flag yet the effect on the data is the
>> same.  I suppose one could argue that compression is a form of
>> encryption (as one cannot read the data on disk without decompressing
>> it) and thus for compressed files I can just set
>> FIEMAP_EXTENT_DATA_ENCRYPTED, too?
>
> You could, but actually, the interface isn't really set up well to
> deal with compressed files.  In order to deal with compressed data you
> really would need two fields in struct fiemap_extent:
> fe_length_physical, fe_length_logical, like this:
>
> struct fiemap_extent {
> 	__u64 fe_logical;  /* logical offset in bytes for the start of
> 			    * the extent from the beginning of the file */
> 	__u64 fe_physical; /* physical offset in bytes for the start
> 			    * of the extent from the beginning of the disk */
> 	__u64 fe_length;   /* length in bytes for this extent */
> 	__u64 fe_length_physical;   /* length in bytes for this extent as
> 	      			     * encoded/compressed on disk */
> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
> 	__u32 fe_reserved;
> };

Yes, that could make sense for compressed files although for NTFS at  
least it does not matter because the logical regions which do not  
exist on disk (due to compression having made the corresponding  
physical regions smaller by at least one block) are present in the  
extent list as sparse extents, so the extents for a compressed file  
could look like this for example (lengths are in blocks):

logical ofs	physical ofs	length
0		X		14
14		SPARSE		2
16		Y		4
20		SPARSE		12
32		Z		9
41		SPARSE		7		
...		...		...

As you may have noticed from the above example in NTFS each block of  
16 blocks is compressed independently, hence the sparse extents  
interspersed with the compressed extents to bring the logical offset  
in line with the physical offset.

> Part of the problem/frustration as we go around and round fs-devel is
> that some people would request new features to support new
> filesystems, and other people have been rejecting new features because
> it makes the interface more complicated.
>
> In fact, the previous version of the patch had a flag for compression,
> but Cristoph Hellwig objected because he claimed there were no users
> for it.

He is plain wrong then!  NTFS supports compressed files and always has  
done!  We only support them read-only at present but that does not  
matter for the purposes of FIEMAP.  And in any case one day we will  
have write support for compressed files, too...

> I don't care how this interface ends up, at least as far as this point
> is concerned, but it's really annoying when some people want to add
> features, and other people are objecting and trying to remove
> features, and months and months and months go by while the patch
> languishes while people play tug of war on the d*mned thing.
>
> Probably the best thing to do is to add a much larger number of
> reserved fields, of size __u32 and __u64, appropriately aligned, and
> then when someone adds a compressed filesystem, we can add the
> structure definition without changing the size of the structure.
> Otherwise, the thou-shalt-not-anticipate-the-needs-of-any-future-
> users-of-the-interface nazi's will strike again, and more months will
> go by with absolutely no progress....


We already have two file systems in the mainline kernel tree that  
support transparent compression/decompression: ntfs and zisofs so  
there is no "future" anywhere in sight...  (-;

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

