From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4: Fix 32bit overflow in ext4_ext_find_goal()
Date: Sun, 2 Jan 2011 20:35:39 -0700
Message-ID: <F02D88CD-7463-4E10-A012-D2CE362D1E88@dilger.ca>
References: <4D05B132.3060402@sx.jp.nec.com> <20110102214031.GA10889@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, ext4 <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20727 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1ACDgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Jan 2011 22:36:12 -0500
In-Reply-To: <20110102214031.GA10889@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It was written that way because HPC applications writing to a shared file normally write to an offset of task_num * task_data_size so they do not overlap, and end up with a dense file. Similarly, bittorrent and parallel FTP clients will write dense files after seeking randomly around the file, and database files often end up dense as well. 

I'd rather fix the relatively few applications that expect permanently sparse files to use fadvise() to notify the kernel of this. 

Cheers, Andreas

On 2011-01-02, at 14:40, Ted Ts'o <tytso@mit.edu> wrote:

> On Sun, Dec 12, 2010 at 07:37:54PM -0000, Kazuya Mio wrote:
>> Hi,
>> 
>> ext4_ext_find_goal() returns an ideal physical block number that the block
>> allocator tries to allocate first. However, if a required file offset is
>> smaller than the existing extent's one, ext4_ext_find_goal() returns
>> a wrong block number because it may overflow at
>> "block - le32_to_cpu(ex->ee_block)". This patch fixes the problem.
> 
> Thanks, applied.  One comment which I've added to the code:
> 
> The block placement algorithm in this section of code assumes that we
> are filling in a file which will eventually be non-sparse --- i.e., in
> the case of libbfd writing an ELF object sections out-of-order but in
> a way the eventually results in a contiguous object or executable
> file, or the old BSD dbm library writing dbm files.  However, this is
> actually somewhat non-ideal if we are writing a sparse file such as
> qemu or KVM writing a raw image file, as it will result in the free
> space getting unnecessarily fragmented.  Maybe we should have some
> hueristics to determine whether we are in the first or second case?
> 
> I don't currently think using raw image files is that common in most
> virtualization application, but if someone can think of some common
> use cases where we would care, it might be worth adding either some
> hueristics to detect this, or perhaps some way that userspace can pass
> a hint to the file system that what we're doing is writing a raw
> sparse file.  For now I'm going to consider the first scenario more
> common than the second....
> 
>                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
