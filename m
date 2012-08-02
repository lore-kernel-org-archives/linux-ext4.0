From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: resize2fs > 16TB questions
Date: Thu, 2 Aug 2012 13:57:48 -0700
Message-ID: <CAKgsxVTkG4Mf8P-eOQ-SkKCvZzB4d1L1Ji3n7_4hgcGNC07-Zw@mail.gmail.com>
References: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de>
	<2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com>
	<28D780F2-63AA-4FD8-B873-EBE3FD1DF3D3@sportsandbytes.de>
	<4DA51F27-D3C1-4867-9DC2-7040423E4BAD@whamcloud.com>
	<71E9EE6B-0615-4F22-9B7F-37D238F2D683@sportsandbytes.de>
	<82C4FEEB-5926-494D-B68D-6FAC530F098A@whamcloud.com>
	<CAKgsxVSpfmMG5nP=ykQSAkvx8Z1Zem_GM=BPGQy92ov2-0OiEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62992 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2HBU5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2012 16:57:49 -0400
Received: by vbbff1 with SMTP id ff1so8600570vbb.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2012 13:57:49 -0700 (PDT)
In-Reply-To: <CAKgsxVSpfmMG5nP=ykQSAkvx8Z1Zem_GM=BPGQy92ov2-0OiEA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 2, 2012 at 1:15 PM, Andreas Dilger <adilger@whamcloud.com> =
wrote:
>
> On 2012-07-29, at 12:08, Arne H=FCggenberg <hueggenberg@sportsandbyte=
s.de> wrote:
>
> > On Jul 29, 2012, at 8:30 PM, Andreas Dilger wrote:
> >>>> Unfortunately, the group descriptor size is not printed.
> >>>
> >>> how can i get the group descriptor size?
> >>
> >> Possibly with "debugfs stats"?
> >
> > ~ # debugfs /dev/vg0/lvol1
> > debugfs 1.42.4 (12-June-2012)
> > debugfs:  stats
> > debugfs:  stats
> >
> > Filesystem volume name:   <none>
> > Last mounted on:          /home/filestore_extern_1
> > Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
> > Filesystem magic number:  0xEF53
> > Filesystem revision #:    1 (dynamic)
> > Filesystem features:      has_journal ext_attr resize_inode dir_ind=
ex filetype extent 64bit flex_bg sparse_super large_file huge_file unin=
it_bg dir_nlink extra_isize
> > Filesystem flags:         signed_directory_hash
> > Default mount options:    user_xattr acl
> > Filesystem state:         clean
> > Errors behavior:          Continue
> > Filesystem OS type:       Linux
> > Inode count:              521011200
> > Block count:              4168089600
> > Reserved block count:     191127425
> > Free blocks:              2162482117
> > Free inodes:              520936736
> > First block:              0
> > Block size:               4096
> > Fragment size:            4096
> > Reserved GDT blocks:      60
> > Blocks per group:         32768
> > Fragments per group:      32768
> > Inodes per group:         4096
> > Inode blocks per group:   256
> > RAID stride:              16
> > RAID stripe width:        160
> > Flex block group size:    16
> > Filesystem created:       Fri Jul 27 17:16:24 2012
> > Last mount time:          Sun Jul 29 15:22:23 2012
> > Last write time:          Sun Jul 29 20:50:44 2012
> > Mount count:              6
> > Maximum mount count:      -1
> > Last checked:             Fri Jul 27 17:16:24 2012
> > Check interval:           0 (<none>)
> > Lifetime writes:          7662 GB
> > Reserved blocks uid:      0 (user root)
> > Reserved blocks gid:      0 (group root)
> > First inode:              11
> > Inode size:               256
> > Required extra isize:     28
> > Desired extra isize:      28
> > Journal inode:            8
> > Default directory hash:   half_md4
> > Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
> > Journal backup:           inode blocks
> > Directories:              6392
> > Group  0: block bitmap at 2049, inode bitmap at 2065, inode table a=
t 2081
> >           26585 free blocks, 4085 free inodes, 2 used directories, =
4084 unused inodes
> >           [Checksum 0x7d46]
> > Group  1: block bitmap at 2050, inode bitmap at 2066, inode table a=
t 2337
> >           4634 free blocks, 4096 free inodes, 0 used directories, 4=
096 unused inodes
> >           [Inode not init, Checksum 0x97aa]
> > Group  2: block bitmap at 2051, inode bitmap at 2067, inode table a=
t 2593
> >           1020 free blocks, 4096 free inodes, 0 used directories, 4=
096 unused inodes
> >           [Inode not init, Checksum 0x571f]
> > Group  3: block bitmap at 2052, inode bitmap at 2068, inode table a=
t 2849
> >           2047 free blocks, 4096 free inodes, 0 used directories, 4=
096 unused inodes
>
> Surprisingly, the group descriptor size is also not printed here. Loo=
king at the code in mke2fs, it appears the 64-byte size used for filesy=
stems when the 64bit flag is set, regardless of what size the filesyste=
m is, and there is no way to change it.
>
> It looks like my theory is wrong, but I don't have access to a system=
 to test this. Probably worthwhile to ask Yongqiang Yang (CC'd), who wr=
ote the 64-bit resize code.
>

I had the same confusion 11 months ago, when the 64-bit resize
patchset was first posted, and I posted almost the same question here.
 My understanding at the end of the mailing list discussion was that
you still cannot resize your filesystem beyond 16TB -- even if the
64bit flag is set -- and you may never be able to do so on that
filesystem because you are using resize_inode and not meta_bg.  There
was a patchset posted on this list a few months ago by Yongquiang Yang
to do meta_bg expansion, but there hasn't been much action around it
from what I have seen (maybe for the 3.7 merge window?).

You can read on here:
http://permalink.gmane.org/gmane.comp.file-systems.ext4/27718

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
