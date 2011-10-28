From: Tao Ma <tm@tao.ma>
Subject: Re: bigalloc and max file size
Date: Fri, 28 Oct 2011 11:31:35 +0800
Message-ID: <4EAA2217.5020002@tao.ma>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:48852 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754844Ab1J1Dbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Oct 2011 23:31:42 -0400
In-Reply-To: <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
On 10/28/2011 05:42 AM, Theodore Tso wrote:
> 
> On Oct 27, 2011, at 11:08 AM, Andreas Dilger wrote:
> 
>>>
>>> That may be true if the cluster size is 64k, but if the cluster size is 1MB, the requirement to zero out 1MB chunks each time a 4k block is written would be painful. 
>>
>> But it should be up to the admin not to configure the filesystem in a foolish way like this. One wouldn't expect good performance with real 1MB block size and random 4kB writes either, so don't do that. 
> 
> Yes, but with the current bigalloc scheme, we don't have to zero out the whole 1MB cluster, and there are reasons why 1MB cluster sizes makes sense in some situations.   Your variation would require the whole 1MB cluster to be zeroed, with the attendant performance hit, but I see that as a criticism of your proposed change, not of the intelligence of the system administrator.   :-)
> 
>> It's taken 3+ years to get an e2fsprogs release out with 64-bit blocksize support, and we can't wait a couple if weeks to see id there is an easy way make bigalloc useful for large file sizes?  Don't you think this would be a lot easier to fix now compared to e.g. having to create a new extent format or adding yet another feature that would allow the extents to specify either logical block vs logical chunks?
> 
> Well, in addition to the e2fsprogs 1.42-WIP being in Debian testing (as well as other community distro's like Arch and Gentoo), there's also the situation that we're in the middle of the merge window, and I have a whole stack of patches on top of the Bigalloc patches, some of which would have to be reworked if the bigalloc patches were to be yanked out.   So removing the bigalloc patches before I push to Linus is going to be a bit of a bother (as well as violating our newly in-place rule that commits in between the dev and master branch heads could be mutated, but commits that are in the master branch were considered non-rewindable).
> 
> One could argue that I could add a patch which disabled the bigalloc patch, and then make changes in the next merge window, but to be completely honest I have my own selfish reason for not wanting to do that, which is the bigalloc patches have also been integrated into Google's internal kernels already, and changing the bigalloc format without a new flag would make things complicated for me.   Given that we decided to lock down the extent leaf format (even though I had wanted to make changes to it, for example to support a full 64-bit block number) in deference to the fact that it was in ClusterFS deployed kernels, there is precedent for taking into account the status of formats used in non-mainline kernels by the original authors of the feature.
> 
>>> This is also a bit hand-wavy, but if we also can handle 64k directory blocks, then we could mount 64k block file systems as used in IA64/Power HPC systems on x86 systems, which would be really cool.
>>
>> At that point, would there be any value in using bigalloc at all?  The one benefit I can see is that bigalloc would help the most common case of linear file writes (if the extent still stores the length in blocks instead of chunks) because it could track the last block written and only have to zero out the last block.
> 
> Well, it would also have the benefit of sparse, random 4k writes into a file system with a large cluster size (going back to the discussion in the first paragraph).
> 
> In general, the current bigalloc approach is more suited for very large cluster sizes (>> 64k), whereas using a block size > page size approach makes more sense in the 4k-64k range, especially since it provides better cross-architecture compatibility with large block size file systems that are already in existence today.   Note too that the large block size approach completely tops out at 256k because of the dirent length encoding issue, where as with bigalloc we can support cluster sizes even larger than 1MB if that were to be useful for some storage scenarios.
Forget to say, if we increase the extent length to be cluster, there are
also a good side effect. ;) Current bigalloc has a severe performance
regression in the following test case:
mount -t ext4 /dev/sdb1 /mnt/ext4
cp linux-3.0.tar.gz /mnt/ext4
cd /mnt/ext4
tar zxvf linux-3.0.tar.gz
umount /mnt/ext4

Now it will take more than 60 secs in my SAS env. While the old solution
will take only 20s. With the new extent length of cluster, it is also
around 20s.

btw, Robin's work is almost finished in the kernel part except the
delayed allocation(the e2fsprogs hasn't been started yet), and he told
me that a V1 will be sent out early next week.

Thanks
Tao
