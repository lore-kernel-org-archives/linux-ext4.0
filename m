From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: torrent hash failures since 3.9.0-rc1
Date: Mon, 11 Mar 2013 21:46:25 +0100
Message-ID: <20130311204625.GA433@x4>
References: <20130311171824.GA434@x4>
 <20130311191753.GA439@x4>
 <20130311194159.GB3579@redhat.com>
 <20130311201334.GA444@x4>
 <20130311203738.GB15478@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:46377 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3CKUq3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2013 16:46:29 -0400
Content-Disposition: inline
In-Reply-To: <20130311203738.GB15478@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013.03.11 at 16:37 -0400, Theodore Ts'o wrote:
> On Mon, Mar 11, 2013 at 09:13:34PM +0100, Markus Trippelsdorf wrote:
> > On 2013.03.11 at 15:41 -0400, Dave Jones wrote:
> > > Worked fine for me on two separate machines.  Could it be a network problem
> > > perhaps ? If something is mangling the packet before it hits the disk,
> > > that would explain it.  What NIC do you use ?
> 
> I'm not a torrent expert, but I thought it did enough checksumming
> such that if the packet got mangled, it would get noticd by the
> torrent client before it writes the chunks to disk?

Yes, I think that's the idea.

> > > Or maybe you could isolate it to a filesystem problem using something
> > > like fsx ?
> > 
> > I've found fsx on your homepage, but I've no idea on how to use this
> > tool. Any pointers?
> 
> We actually run fsx in a number of different configruations as part of
> our regression testing before we send Linus a pull request, and
> haven't found any issues.  So unless it's a hardware problem, it seems
> unlikely to me that your running fsx would turn up anything.

Yes, I let it run for a while anyway and it didn't report any failure.

> Can you send a dumpefs -h of the file system in question, and what
> mount options (if any) you are using?  Thanks!!

 # dumpe2fs -h /dev/sda
dumpe2fs 1.42.7 (21-Jan-2013)
Filesystem volume name:   <none>
Last mounted on:          /var
Filesystem UUID:          202f2c93-c6c5-4d70-a63f-d770161138bd
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91578368
Block count:              366284646
Reserved block count:     18314232
Free blocks:              185850075
Free inodes:              90003798
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      936
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Nov 19 16:02:46 2012
Last mount time:          Mon Mar 11 21:16:23 2013
Last write time:          Mon Mar 11 21:16:23 2013
Mount count:              20
Maximum mount count:      -1
Last checked:             Mon Mar  4 13:32:55 2013
Check interval:           0 (<none>)
Lifetime writes:          2891 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       60164803
Default directory hash:   half_md4
Directory Hash Seed:      e86f34a0-390a-49b6-87a9-3336d861ab81
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00079bef
Journal start:            1

noatime is the only mount option.

> BTW, I'm currently running 3.9-rc2 with some additional fixes from the
> ext4 dev branch, and I'm not able to reproduce the problem using
> rtorrent on my laptop.  How reliably is it reproducing for you?  Are
> you seeing the problem every time you try this?

Yes, it's 100% reproducible for me. If I boot a 3.8 kernel the issue
vanishes.

-- 
Markus
