From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] e2fsprogs: report minimal resize size when given size
	is too small
Date: Mon, 17 Mar 2008 12:04:19 -0400
Message-ID: <20080317160418.GA8499@unused.rdu.redhat.com>
References: <20080314140506.GD20444@unused.rdu.redhat.com> <20080315030840.GG13733@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbYCQQHO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 12:07:14 -0400
Content-Disposition: inline
In-Reply-To: <20080315030840.GG13733@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2008 at 11:08:40PM -0400, Theodore Tso wrote:
> On Fri, Mar 14, 2008 at 10:05:06AM -0400, Josef Bacik wrote:
> > Hello,
> > 
> > Munged the subject on the last resend and didn't add the
> > Signed-off-by, so here's the 3rd try.  This patch will spit out the
> > minimum number of blocks the fs can be resized if the resize size it
> > is given is too small.  This is usefull for those creating live boot
> > images who create large images to install what they need onto, and
> > then resize down to the smalles size that they can.  Thanks much,
> > 
> > Signed-off-by: Josef Back <jbacik@redhat.com>
> 
> Hmm.... so I tried creating a filesystem using a 1k blocksize, to make
> sure that your code does the right thing when the number of block
> group descriptors goes down.  And it doesn't work correctly.
> 
> So first, I create a logical volume for doing testing, with a 1024
> blocksize, and populate it with e2fsprogs sources.  The we run e2fsck
> so that reszie2fs will be able to run with it:
> 
> # lvcreate --size 1G --name testresize /dev/closure
>   Logical volume "testresize" created
> # mke2fs -b 1024 -jq /dev/closure/testresize
> Warning: 256-byte inodes not usable on older systems
> # mount /dev/closure/testresize /mnt
> # tar -C /mnt -xzf /usr/projects/e2fsprogs/e2fsprogs-1.40.8.tar.gz 
> # umount /mnt
> # e2fsck -fp /dev/closure/testresize 
> e2fsck 1.40.8 (13-Mar-2008)
> /dev/closure/testresize: 1177/65536 files (0.9% non-contiguous), 72811/1048576 blocks
> 
> OK, let's create s snapshot, and then try resizing it using your
> patched resize2fs:
> 
> # lvcreate --snapshot --size 1G --name resizesnap /dev/closure/testresize
>   Logical volume "resizesnap" created
> # ./resize/resize2fs /dev/closure/resizesnap 0
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 0 (1k) blocks.
> 0 blocks is too small, minimum size is 55254 blocks
> ./resize/resize2fs: Not enough space to build proposed filesystem while trying to resize /dev/closure/resizesnap
> # ./resize/resize2fs /dev/closure/resizesnap 55254
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55254 (1k) blocks.
> The filesystem on /dev/closure/resizesnap is now 55254 blocks long.
> 
> OK, so we resized it down to 55,254.   Are we done?
> 
> # ./resize/resize2fs /dev/closure/resizesnap 0
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 0 (1k) blocks.
> 0 blocks is too small, minimum size is 55242 blocks
> # ./resize/resize2fs /dev/closure/resizesnap 55242
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55242 (1k) blocks.
> The filesystem on /dev/closure/resizesnap is now 55242 blocks long.
> # lvremove -f /dev/closure/resizesnap 
>   Logical volume "resizesnap" successfully removed
> 
> No wait!  It turns out we can resize it down further, to 55,242
> blocks.
> 
> Now let's try to resize it down to 55,242 blocks directly using an
> unpatched resize2fs:
> 
> # lvcreate --snapshot --size 1G --name resizesnap /dev/closure/testresize
>   Logical volume "resizesnap" created
> # /sbin/resize2fs /dev/closure/resizesnap 55242
> resize2fs 1.40.8 (13-Mar-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55242 (1k) blocks.
> The filesystem on /dev/closure/resizesnap is now 55242 blocks long.
> # lvremove -f /dev/closure/resizesnap 
>   Logical volume "resizesnap" successfully removed
> 
> Gee, look!  It works.
> 
> Can we do it with your patched resize2fs?
> 
> # lvcreate --snapshot --size 1G --name resizesnap /dev/closure/testresize
>   Logical volume "resizesnap" created
> # ./resize/resize2fs /dev/closure/resizesnap 55242
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55242 (1k) blocks.
> 55242 blocks is too small, minimum size is 55254 blocks
> ./resize/resize2fs: Not enough space to build proposed filesystem while trying to resize /dev/closure/resizesnap
> 
> Nope.  It won't let you resize down to 55,254 blocks in one go,
> although you can do it in two steps.  This is a regression, since with
> the unpatched resize2fs, it works with one step.  The problem is that
> your code assumes that ext2fs_calculate_minimum_resize_size() reliably
> returns the minimum size, and if the user specifies a size smaller
> than returned size, it should bomb out with an error.  Unfortunately,
> it *isn't* the minimum possible size.
> 
> # ./resize/resize2fs /dev/closure/resizesnap 55254
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55254 (1k) blocks.
> The filesystem on /dev/closure/resizesnap is now 55254 blocks long.
> # ./resize/resize2fs /dev/closure/resizesnap 55242
> resize2fs 1.40.7 (28-Feb-2008)
> Resizing the filesystem on /dev/closure/resizesnap to 55242 (1k) blocks.
> The filesystem on /dev/closure/resizesnap is now 55242 blocks long.
> # lvremove -f /dev/closure/resizesnap 
>   Logical volume "resizesnap" successfully removed
> 
> 
> What bothers me with your patch, though is that even though it
> apparently isn't doing the right thing when the filesystem changes the
> number of group descriptor blocks after doing the resize:
> 
> # dumpe2fs /dev/closure/testresize | grep "Group descriptors" | head -5
> dumpe2fs 1.40.8 (13-Mar-2008)
>   Primary superblock at 1, Group descriptors at 2-5
>   Backup superblock at 8193, Group descriptors at 8194-8197
>   Backup superblock at 24577, Group descriptors at 24578-24581
>   Backup superblock at 40961, Group descriptors at 40962-40965
>   Backup superblock at 57345, Group descriptors at 57346-57349
> 
> # dumpe2fs /dev/closure/resizesnap | grep "Group descriptors" | head -5
> dumpe2fs 1.40.8 (13-Mar-2008)
>   Primary superblock at 1, Group descriptors at 2-2
>   Backup superblock at 8193, Group descriptors at 8194-8194
>   Backup superblock at 24577, Group descriptors at 24578-24578
>   Backup superblock at 40961, Group descriptors at 40962-40962
> 
> .... yet when I tried doing the test with 4k blocksizes, where I
> started with a filesystem which is 17 gigabytes (with a 4k blocksize,
> every 16gigs there are 128 block groups, which will occupy a single 4k
> block's worth of block group descriptors), and then shrunk it down,
> expecting it to break --- and it didn't.  The fact it should have
> broken, since the number of group descriptors did go down, and it the
> code didn't take that into account --- and yet it didn't, disturbed
> me.  Not knowing why it works when an inspection seems to indicate
> that it should fails always scares me.
> 
> So I can't apply this the way it is.  What I *can* do is set it up so
> that it will only call the calculate minimum size if the specified
> size is 0 blocks.  I'll mention in the known bugs that it can
> sometimes be wrong with its estimates with 1k and 2k block
> filesystems.
> 

So this is all very strange.  I fixed my patch to let resize2fs do what it
always does whether or not my calculation thinks it will work so I could test
it.  With 1k and 2k blocks you are right, when reducing the number of group
descriptors i can always go lower.  However with 4k blocks (which is what I
always tested with) it works completely fine.  For example, a completely cleanly
mkfs.ext3'd 15gb lv I get this

[root@unused resize]# ./resize2fs -P /dev/testvg/testext3 
resize2fs 1.40.8 (13-Mar-2008)
Estimated minimum size of the filesystem: 35758

I try to resize to something smaller

[root@unused resize]# ./resize2fs /dev/testvg/testext3 35757
resize2fs 1.40.8 (13-Mar-2008)
Resizing the filesystem on /dev/testvg/testext3 to 35757 (4k) blocks.
./resize2fs: No space left on device while trying to resize /dev/testvg/testext3

No dice, it won't work, but using my calcluation it works fine

[root@unused resize]# ./resize2fs /dev/testvg/testext3 35758
resize2fs 1.40.8 (13-Mar-2008)
Resizing the filesystem on /dev/testvg/testext3 to 35758 (4k) blocks.
The filesystem on /dev/testvg/testext3 is now 35758 blocks long.

I'll try to figure out whats wrong in the 1k/2k block case, but for 4k it seems
to work fine.  Thanks,

Josef
