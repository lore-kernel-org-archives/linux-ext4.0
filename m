From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH 0/8] ext4 online defrag (ver 0.8)
Date: Fri, 11 Apr 2008 13:18:33 -0700
Message-ID: <1207945113.3639.5.camel@localhost.localdomain>
References: <47F60EA7.1050604@rs.jp.nec.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45838 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758093AbYDKUSr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 16:18:47 -0400
In-Reply-To: <47F60EA7.1050604@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-04-04 at 20:19 +0900, Akira Fujita wrote:
> Hi,
> 
> Aneesh Kumar K.V wrote:
> > you would need http://www.kernel.org/pub/software/devel/sparse/
> > to find and fix these warnings.
> 
> I have updated ext4 online defrag to fix sparse warnings.
> I also changed the construction of ext4 online defrag patches
> to compile one-by-one and make them small but there is
> no functional change since previous version.
> 

Thanks, I have updated the patch queue with v8

> Outline for ext4 online defrag:
> Ext4 online defrag has the following three functions.
> 
> 1.[ no option ] Solving a single file fragmentation
>   Single file fragmentation is solved by moving file
>   data to contiguous free blocks.
> 
> 2.[ -r ] Solving a relevant file fragmentation
>   Relevant file fragmentation could be solved by moving
>   the files under the specified directory close together with
>   the block containing the directory data.
> 
> 3.[ -f ] Solving a free space fragmentation
>   If there is no contiguous free blocks in the filesystem,
>   the other files are moved to make sufficient space to allocate
>   contiguous blocks for the target file.
> 
> Next steps:
> 1. Rework of defrag functions based on review comments from Mingming.
> 2. Implement defrag -f mode with FIEMAP ioctl.
> 3. Remove the limit of target file size (now 128MB) in -f mode.
>    * Past mail concerning -f mode.
>    http://marc.info/?l=linux-ext4&m=118239067704899&w=4
> 
> Summary of patches:
> * These patches are replaced with ext4 online defrag patches
>   which are already in the ext4 git tree (linux-2.6.26-rc8).
> 
> [PATCH 1/8]  Exchange the blocks between two inodes
> - Exchange the data blocks between the temporary inode and
>   the original inode.
> 
> [PATCH 2/8] Read and write file data with memory page
> - Read the file data from the old blocks to the page and
>   write the file data on the page into the new blocks.
> 
> [PATCH 3/8] Allocate new contiguous blocks with mballoc
> - Search contiguous free blocks with mutil-block allocation
>   and allocate them for the temporary inode.
> 
> [PATCH 4/8] Main function of ext4 online defrag and ioctl implementation
> - Create the temporary inode and do defrag per
>   defrag_size (defalut 64MB).
> 

I am curious about the ordering here. It seems reverse the order of the
first 4 patches make the logic more clear to me, start from patch 4,
then 3, then 2 and last 1?  At lease when I read the describtion of the
first patch I was puzzled by a minute what is this coming from

Just share my thoughts.

Mingming
> [PATCH 5/8] Defragmentation for the relevant files (-r mode)
> - Relevant file fragmentation could be solved by moving
>   the files under the specified directory close together with
>   the block containing the directory data.
> 
> [PATCH 6/8] Check the free space fragmentation (-f mode)
> - Check the free space fragmentation in the block group
>   where target file is located.
> 
> [PATCH 7/8] Move victim files for the target file (-f mode)
> - Move victim files to make sufficient space and reallocates
>   the contiguous blocks for the target file.
> 
> [PATCH 8/8] Online defrag command
> - The defrag command. Usage is as follows:
>   - Put the multiple files closer together.
>     # e4defrag -r directory-name
>   - Defrag for free space fragmentation.
>     # e4defrag -f file-name
>   - Defrag for a single file.
>     # e4defrag file-name
>   - Defrag for all files on ext4.
>     # e4defrag device-name
> 
> Comments and reviews are welcome.
> 
> Regards,
> Akira
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

