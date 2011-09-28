From: Tao Ma <tm@tao.ma>
Subject: Re: [RFC] Add inline data support in ext4
Date: Wed, 28 Sep 2011 17:06:12 +0800
Message-ID: <4E82E384.80405@tao.ma>
References: <4E81770D.8090309@tao.ma> <4E1AC23D-3CC8-4C8C-BA54-F2AB9958D13A@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:34212 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751839Ab1I1JGR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 05:06:17 -0400
In-Reply-To: <4E1AC23D-3CC8-4C8C-BA54-F2AB9958D13A@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,
	Thanks for the feedback.
On 09/28/2011 03:34 AM, Andreas Dilger wrote:
> On 2011-09-27, at 1:11 AM, Tao Ma wrote:
>> Hi Ted, Andreas and the list,
>> 	As you may already know, we are beginning to evaluate the
>> bigalloc features in our production system. The performance looks
>> promising, but we have also met with a severe problem with bigalloc.
>>
>> As ext4 now allocates one block for the directory even if it is empty,
>> it is really space-consuming for some applications which uses hashes
>> and create large numbers of directories(AUFS in squid for example).
>>
>> ocfs2 now uses inline data for a new created file/dir so that some
>> small ones can have their data within the inodes. It is really helpful
>> and we are considering adding the same to ext4.
>>
>> What is your option? I haven't been involved in ext4 for a long time,
>> so I am not sure whether there was a similar try which was abandoned
>> finally. Anyway, with bigalloc added, it is really needed for us to
>> support inline data now.
> 
> At one time we discussed storing file tails in xattrs to allow small
> files stored inside the inode itself.  There is already an EXT2_TAIL_FL
> that was used on reiserfs that could be reused for ext4, though it
> would need a new INCOMPAT feature flag.  This idea could be expanded
> to sharing a single bigalloc chunk as an xattr block between multiple
> files, and each one storing their file/dir data in a "system.data"
> xattr (or something similar).
> 
> For small directories, the "." and ".." entries could even be stored
> inside the inode in this "system.data" xattr, since they are only 24
> bytes in size and there are ~100 bytes of xattr space in a 256-byte
> inode.  By making all "small data" (smaller than, say 1/2 of a chunk)
> an xattr, the xattr code can use the most efficient location for the
> storage, either inside the inode, or in a shared block.
> 
> I read once that there are many directories with only one or two
> files in them, and 100 bytes could hold 3 or 4 dirents, or more
> for larger inodes.  This would probably be an improvement even for
> non-bigalloc filesystems, since small directories could be handled
> without seeks, as could very small files.
> 
> A quick check of my home directory shows mostly small subdirectories:
> 
> dirs=44859 files=677028 filename_chars=12909288 mean_chars=19
> dirs: zero_dirent=1609 one_dirent=12937 two_dirent=2456 mean_dirent=17
> 
> so more 37% of directories have 2 or fewer files/subdirs, and the
> average size of a directory is ((19 + 3 + 8) * 17) = 510 bytes.
> The +3 is for rounding the name up to a multiple of 4, and +8 is
> for the inode, length, and type fields in the dirent.  The same looks
> to be true for /usr as well.
> 
> So, in this case, close to half of directories could be held entirely
> within the system.data xattr inside a 512-byte inode.
yeah, actually my home are similar like yours. So I guess others have
similar ones which makes in-inode data very beneficial. And actually
ocfs2 works like what you describes above. It shares the spaces after
the field of an inode with xattr and it works well. So I will try to
generate some rough codes to test how it works.

Thanks
Tao
