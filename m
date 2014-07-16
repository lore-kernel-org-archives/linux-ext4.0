From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: testing result of loop-aio patchset on ext3
Date: Wed, 16 Jul 2014 09:58:10 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407160955010.2431@localhost.localdomain>
References: <53C3A42E.40000@huawei.com> <alpine.LFD.2.00.1407141142520.13527@localhost.localdomain> <53C5F770.9030105@huawei.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1748687669-1405497494=:2431"
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
To: Rui Xiang <rui.xiang@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53C5F770.9030105@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1748687669-1405497494=:2431
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Wed, 16 Jul 2014, Rui Xiang wrote:

> Date: Wed, 16 Jul 2014 11:54:24 +0800
> From: Rui Xiang <rui.xiang@huawei.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Li Zefan <lizefan@huawei.com>
> Subject: Re: testing result of loop-aio patchset on ext3
> 
> On 2014/7/14 17:51, Lukáš Czerner wrote:
> > On Mon, 14 Jul 2014, Rui Xiang wrote:
> > 
> >> Date: Mon, 14 Jul 2014 17:34:38 +0800
> >> From: Rui Xiang <rui.xiang@huawei.com>
> >> To: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-ext4@vger.kernel.org
> >> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
> >>     Li Zefan <lizefan@huawei.com>
> >> Subject: testing result of loop-aio patchset on ext3
> >>
> >> Hi Dave,
> >>
> >> We export a container image file as a block device via loop device, but we
> >> found it's very easy that the container rootfs gets corrupted due to power
> >> loss.
> >>
> >> Your early version of loop-aio patchset said the patchset can make loop
> >> mounted filesystems recoverable(lkml.org/lkml/2012/3/30/317), but we found
> >> it doesn't help.
> >>
> >> Both the guest fs and host fs are ext3.
> >>
> >> The loop-aio patchset is from:
> >> git://github.com/kleikamp/linux-shaggy.git aio_loop
> >>
> >> Steps:
> >> 1. dd a 10G image, mkfs.ext3,
> >>   # dd if=/dev/zero of=./raw_image bs=1M count=10000
> >>   # echo y | mkfs.ext3 raw_image
> >>
> >> 2. losetup a loop device, mount at ./test_dir
> >>   # losetup /dev/loop1 raw_image
> >>   # mount /dev/loop1 ./test_dir
> >>
> >> 3. copy fs_mark into test_dir and run
> >>   # ./fs_mark -d ./tmp/ -s 102400000 -n 80
> >>
> >> 4. during runing fs_mark, make systerm reboot indirectly.
> >>   # echo b > /proc/sysrq-trigger
> >>
> >> After systerm booted up, sometimes fsck reported raw_image fs has been damaged.
> >>
> >> # fsck.ext3 -n raw_image
> >> e2fsck 1.41.9 (22-Aug-2009)
> >> Warning: skipping journal recovery because doing a read-only filesystem check.
> >> raw_image contains a file system with errors, check forced.
> >> Pass 1: Checking inodes, blocks, and sizes
> >> Pass 2: Checking directory structure
> >> Pass 3: Checking directory connectivity
> >> Pass 4: Checking reference counts
> >> Pass 5: Checking group summary information
> >> Free blocks count wrong (2481348, counted=2480577).
> >> Fix? no
> >> Free inodes count wrong (640837, counted=640835).
> >> Fix? no
> >> raw_image: ********** WARNING: Filesystem still has errors **********
> >> raw_image: 11/640848 files (0.0% non-contiguous), 78652/2560000 blocks
> > 
> > It's not damaged, this is expected result if you're using old
> > e2fsprogs which still treats this as an error.
> > 
> > It's not an error because we only update superblock summary at
> > unmount time so with unclean shutdown it's likely that it does not
> > match the reality, but e2fsck can and will easily fix that for you.
> > 
> > Please try e2fsprogs v1.42.3 or newer.
> > 
> 
> Hi Lukas,
> 
> I updated e2fsprogs to v1.42.3, and user the newer fsck.ext3 to check raw_image.
> Exactly, the result seemed normal.

Now I can see that there are much more problems than before, that's
weird. Sorry for not making this clear, but for this kind of
reproducers please use the most recent e2fsprogs. Also , what is the
kernel version you're using in this test ?

Thanks!
-Lukas

> 
> Then, I continue my previous test. And after testing 35 times, "fsck -n" reported image fs
> had been damaged, too.
> 
>  # fsck.ext3 -n image1
> e2fsck 1.42.3.wc1 (28-May-2012)
> Warning: skipping journal recovery because doing a read-only filesystem check.
> image1 has been mounted 36 times without being checked, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Inode 16407, i_size is 597447, should be 602112.  Fix? no
> Inode 16407, i_blocks is 1176, should be 1184.  Fix? no
> Inode 409941, i_blocks is 200208, should be 112.  Fix? no
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -1506836 -1506843 -(1506859--1506860) -(1660941--1661964) -(1661966--1671167) -(1671688--1686473)
> Fix? no
> Free blocks count wrong for group #2 (31558, counted=31556).
> Fix? no
> Free blocks count wrong for group #43 (15871, counted=15867).
> Fix? no
> Free blocks count wrong (2204041, counted=2204035).
> Fix? no
> image1: ********** WARNING: Filesystem still has errors **********
> image1: 13008/655360 files (0.3% non-contiguous), 417399/2621440 blocks
> 
> I backup the image to image_bk, and then mount the image to a dir, and cat all files in the image.
> Steps:
> # dd if=image1 of=image_bk
> # mount image1 err_dir
> # find -name '*' -exec cat > /dev/null {} \;
> 
> There are no issues during catting, and no err in dmesg too.
> 
> *But when I umount the image1 from err_dir, The fsck result didn't show any fs corruption info.
> 
> I mount image_bk to err_dir and umount it with no operation directly. The result is same to iamge1.
> 
> *So, is fs in the image as a block device via loop device damaged really, or does it have some others issues? 
> Could you give me some opinions?
> 
> 
> Thanks.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1748687669-1405497494=:2431--
