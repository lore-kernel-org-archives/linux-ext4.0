From: Jan Kara <jack@suse.cz>
Subject: Re: Fwd: Need help with Data Recovery on Ext4 partitions that became
 corrupted on running OS
Date: Thu, 26 Sep 2013 22:18:33 +0200
Message-ID: <20130926201833.GD21811@quack.suse.cz>
References: <CAOWv6b1Jq0MAtELB_brhg_G3S2svEW8EaW9A8ciddTUdqDWFdQ@mail.gmail.com>
 <CAOWv6b1m8A2S3sjDsJxOrRVztch6iq4zH9eFq5DKFMqtWWWpEw@mail.gmail.com>
 <CAOWv6b3+rzK4a6Oc29R2gNTv-mX+9QvnsuE0O3dCL8F8-PfjTQ@mail.gmail.com>
 <20130925161259.GA5404@quack.suse.cz>
 <CAOWv6b3xh34_86QWy7O24U-voQ2JXw5JFDThgoiXD27WOMCZxQ@mail.gmail.com>
 <20130925212834.GA10542@quack.suse.cz>
 <CAOWv6b3OPaSMRvE8cG5_6Qkq-gUGheX7hccmLtO=z7wkekq8ZA@mail.gmail.com>
 <20130926085310.GA13976@quack.suse.cz>
 <CAOWv6b0zJLBLf3y_WW=LNHoCwBZWu0oohPHvRDrirLKFnb41LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: InvTraySts <invtrasys@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOWv6b0zJLBLf3y_WW=LNHoCwBZWu0oohPHvRDrirLKFnb41LA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu 26-09-13 13:45:34, InvTraySts wrote:
> root@server:~# debugfs /dev/sdf1
> debugfs 1.42.5 (29-Jul-2012)
> debugfs:  stat /
> stat: A block group is missing an inode table while reading inode 2
> debugfs:  dump /etc/
> dump: Usage: dump_inode [-p] <file> <output_file>
> debugfs:  dump /etc/passwd /root/passwd.recovery
> /etc/passwd: A block group is missing an inode table
> debugfs:  ls /etc/
> /etc/: A block group is missing an inode table
> 
> So now I am getting a different error message, even though literally
> nothing has changed other than the time I ran the command. I figured
> the passwd file would be the easiest thing to recover, since I don't
> remember the exact paths for other application configurations without
> doing some digging for the paths and such.
> 
> At one point, before the mailing list and me joining the #ext channel,
> I was able to see that there was a lost and found folder, I just
> couldn't navigate it. So, I am not sure why that has changed either. I
> assume logical corruption to the extent it has could cause almost
> anything.
  Isn't the fs already modified from fsck? Anyway, the fs really looks
hopelessly damaged so I'm afraid we won't be able to get any data from it.

								Honza

> On Thu, Sep 26, 2013 at 4:53 AM, Jan Kara <jack@suse.cz> wrote:
> > On Wed 25-09-13 20:08:38, InvTraySts wrote:
> >> (Going to merge these two back, because both of you are actually
> >> helping me, but with the two conversations being segregated like this
> >> it makes it hard to correlate with you both)
> >> The partprobe did work with getting the partition table reread.
> >> After that, the tune2fs sorta worked.
> >> root@server:~# tune2fs -f -O ^has_journal /dev/sdf1
> >> tune2fs 1.42.5 (29-Jul-2012)
> >> root@server:~# mount /dev/sdf1 /media/tmp
> >> root@server:~# ls -l /media/tmp/
> >> total 0
> >>
> >> When I try and use the debugfs /dev/sdf1
> >>
> >> root@server:~# debugfs /dev/sdf1
> >> debugfs 1.42.5 (29-Jul-2012)
> >> debugfs:  ls
> >> EXT2 directory corrupted
> >> debugfs:  ls /
> >> /: EXT2 directory corrupted
> >>
> >> The drive is supposed to be ext4.
> >   'EXT2' in the message doesn't mean anything. It is always there. But we
> > see that even root directory is corrupted. That's bad. You can try what
> > 'stat /' says in debugfs? Possibly also run 'dump / <somefile>' to dump raw
> > directory data to <somefile> and attach the file here. But also given the
> > output of e2fsck I'm afraid there won't be much to save on the drive...
> >
> >                                                                 Honza
> >
> >> root@server:~# dumpe2fs /dev/sdf1
> >> dumpe2fs 1.42.5 (29-Jul-2012)
> >> Filesystem volume name:   root
> >> Last mounted on:          /media/ubuntu/root
> >> Filesystem UUID:         removed
> >> Filesystem magic number:  0xEF53
> >> Filesystem revision #:    1 (dynamic)
> >> Filesystem features:      ext_attr resize_inode dir_index filetype
> >> extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink
> >> extra_isize
> >> Filesystem flags:         signed_directory_hash
> >> Default mount options:    user_xattr acl
> >> Filesystem state:         not clean with errors
> >> Errors behavior:          Continue
> >> Filesystem OS type:       Linux
> >> Inode count:              4849664
> >> Block count:              19398144
> >> Reserved block count:     969907
> >> Free blocks:              17066988
> >> Free inodes:              4592929
> >> First block:              0
> >> Block size:               4096
> >> Fragment size:            4096
> >> Reserved GDT blocks:      1019
> >> Blocks per group:         32768
> >> Fragments per group:      32768
> >> Inodes per group:         8192
> >> Inode blocks per group:   512
> >> Flex block group size:    16
> >> Filesystem created:       Sat May 25 14:59:50 2013
> >> Last mount time:          Wed Sep 25 19:59:07 2013
> >> Last write time:          Wed Sep 25 19:59:51 2013
> >> Mount count:              1
> >> Maximum mount count:      -1
> >> Last checked:             Sat Aug 24 16:56:09 2013
> >> Check interval:           0 (<none>)
> >> Lifetime writes:          107 GB
> >> Reserved blocks uid:      0 (user root)
> >> Reserved blocks gid:      0 (group root)
> >> First inode:              11
> >> Inode size:               256
> >> Required extra isize:     28
> >> Desired extra isize:      28
> >> Default directory hash:   half_md4
> >> Directory Hash Seed:      01a8f605-b2bc-41ee-b7b5-11d843ab622f
> >> Journal backup:           inode blocks
> >> FS Error count:           9
> >> First error time:         Sat Aug 24 13:44:55 2013
> >> First error function:     ext4_iget
> >> First error line #:       3889
> >> First error inode #:      8
> >> First error block #:      0
> >> Last error time:          Wed Sep 25 19:59:12 2013
> >> Last error function:      htree_dirblock_to_tree
> >> Last error line #:        892
> >> Last error inode #:       2
> >> Last error block #:       20037
> >>
> >> [...]
> >> [output scrolls very fast, and is very large]
> >> Group 10: (Blocks 327680-360447) [ITABLE_ZEROED]
> >>   Checksum 0xecaa, unused inodes 0
> >>   Block bitmap at 1035 (bg #0 + 1035), Inode bitmap at 1051 (bg #0 + 1051)
> >>   Inode table at 6177-6688 (bg #0 + 6177)
> >>   0 free blocks, 16 free inodes, 0 directories
> >>   Free blocks: 327680, 327683-327685, 327687, 327689-327690,
> >> 327692-327693, 327695-327697, 327700-327701, 327703, 327705,
> >> 327707-327709, 327711-327715, 327718-327727, 327730-327808,
> >> 327810-327823, 327825-327842, 327846-327855, 327857-327875, 327878,
> >> 327881
> >>
> >> (the total amount of pages that the dumpe2fs comes out with is about
> >> 240 pages. something that can't be pasted. If attachments would be
> >> required, I can attach a file with it).
> >>
> >> On Wed, Sep 25, 2013 at 5:28 PM, Jan Kara <jack@suse.cz> wrote:
> >> > On Wed 25-09-13 15:24:34, InvTraySts wrote:
> >> >> And am cloning the drive without the sync parameter this time.
> >> >> root@server:~# dd if=/dev/sda of=/dev/sdf bs=4096 conv=notrunc,noerror
> >> >> After it finished, I attempted to run dumpe2fs and it still responds with:
> >> >> root@server:~# dumpe2fs /dev/sdf1
> >> >> dumpe2fs 1.42.5 (29-Jul-2012)
> >> >> dumpe2fs: Bad magic number in super-block while trying to open /dev/sdf1
> >> >> Couldn't find valid filesystem superblock.
> >> >   Well, that's likely because the partition table on /dev/sdf didn't get
> >> > reread. You can run 'partprobe /dev/sdf' to tell the kernel about the new
> >> > partition table.
> >> >
> >> >                                                                 Honza
> >> >
> >> >> So I went ahead and tried to run the tune2fs command:
> >> >> root@server:~# tune2fs -f -O ^has_journal /dev/sda1
> >> >> tune2fs 1.42.5 (29-Jul-2012)
> >> >> tune2fs: Bad magic number in super-block while trying to open /dev/sda1
> >> >> Couldn't find valid filesystem superblock.
> >> >>
> >> >> Which also fails, yet dumpe2fs on /dev/sda1 works fine.
> >> >>
> >> >>
> >> >> On Wed, Sep 25, 2013 at 12:12 PM, Jan Kara <jack@suse.cz> wrote:
> >> >> > On Tue 24-09-13 22:25:49, InvTraySts wrote:
> >> >> >> So long story short, I had a server running that had a processor fail
> >> >> >> while powered on, causing the file systems to become corrupt. I
> >> >> >> replaced the motherboard, processor and power supply just to be on the
> >> >> >> safe side. However, I am at a bit of a loss as to what to do now. I
> >> >> >> was working sandeen in the OFTC IRC channel, but, on his
> >> >> >> recommendation he suggested me to post something to the mailing list.
> >> >> >>
> >> >> >> Lets start off with one drive at a time (I have 4 that are corrupt).
> >> >> >> The specific logical drive in question was in RAID1 on a Dell PERC 5/i
> >> >> >> card.
> >> >> >> If I try to mount this using:
> >> >> >> mount -t ext4 /dev/sda1 /media/tmp
> >> >> >>
> >> >> >> It complains in dmesg with the following output:
> >> >> >> 685621.845207] EXT4-fs error (device sda1): ext4_iget:3888: inode #8:
> >> >> >> comm mount: bad extra_isize (18013 != 256)
> >> >> >> [685621.845213] EXT4-fs (sda1): no journal found
> >> >> >>
> >> >> >>
> >> >> >> However, if I run dumpe2fs -f /dev/sda1 I get the following output:
> >> >> >> root@server:~# dumpe2fs -f /dev/sda1
> >> >> >> dumpe2fs 1.42.5 (29-Jul-2012)
> >> >> >> Filesystem volume name:   root
> >> >> >> Last mounted on:          /media/ubuntu/root
> >> >> >> Filesystem UUID:          f959e195-[removed]
> >> >> >> Filesystem magic number:  0xEF53
> >> >> >> Filesystem revision #:    1 (dynamic)
> >> >> >> Filesystem features:      has_journal ext_attr resize_inode dir_index
> >> >> >> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
> >> >> >> dir_nlink extra_isize
> >> >> >> Filesystem flags:         signed_directory_hash
> >> >> >> Default mount options:    user_xattr acl
> >> >> >> Filesystem state:         not clean with errors
> >> >> >> Errors behavior:          Continue
> >> >> >> Filesystem OS type:       Linux
> >> >> >> Inode count:              4849664
> >> >> >> Block count:              19398144
> >> >> >> Reserved block count:     969907
> >> >> >> Free blocks:              17034219
> >> >> >> Free inodes:              4592929
> >> >> >> First block:              0
> >> >> >> Block size:               4096
> >> >> >> Fragment size:            4096
> >> >> >> Reserved GDT blocks:      1019
> >> >> >> Blocks per group:         32768
> >> >> >> Fragments per group:      32768
> >> >> >> Inodes per group:         8192
> >> >> >> Inode blocks per group:   512
> >> >> >> Flex block group size:    16
> >> >> >> Filesystem created:       Sat May 25 14:59:50 2013
> >> >> >> Last mount time:          Sat Aug 24 11:04:25 2013
> >> >> >> Last write time:          Tue Sep 24 13:55:36 2013
> >> >> >> Mount count:              0
> >> >> >> Maximum mount count:      -1
> >> >> >> Last checked:             Sat Aug 24 16:56:09 2013
> >> >> >> Check interval:           0 (<none>)
> >> >> >> Lifetime writes:          107 GB
> >> >> >> Reserved blocks uid:      0 (user root)
> >> >> >> Reserved blocks gid:      0 (group root)
> >> >> >> First inode:              11
> >> >> >> Inode size:               256
> >> >> >> Required extra isize:     28
> >> >> >> Desired extra isize:      28
> >> >> >> Journal inode:            8
> >> >> >> Default directory hash:   half_md4
> >> >> >> Directory Hash Seed:      01a8f605-b2bc-41ee-b7b5-11d843ab622f
> >> >> >> Journal backup:           inode blocks
> >> >> >> FS Error count:           8
> >> >> >> First error time:         Sat Aug 24 13:44:55 2013
> >> >> >> First error function:     ext4_iget
> >> >> >> First error line #:       3889
> >> >> >> First error inode #:      8
> >> >> >> First error block #:      0
> >> >> >> Last error time:          Tue Sep 24 13:55:36 2013
> >> >> >> Last error function:      ext4_iget
> >> >> >> Last error line #:        3888
> >> >> >> Last error inode #:       8
> >> >> >> Last error block #:       0
> >> >> >> dumpe2fs: Corrupt extent header while reading journal super block
> >> >> >   OK, so really journal inode (inode #8) looks toast but superblock looks
> >> >> > OK.
> >> >> >
> >> >> >> So I attempted to clone the drive to a 2TB backup drive that is empty,
> >> >> >> and currently I am having more problems with the cloned drive than I
> >> >> >> am with the original.
> >> >> >>
> >> >> >> sandeen said something about using tune2fs to tell it to remove the
> >> >> >> has_journal flag, but I might need some assistance with that.
> >> >> >   Yes, you can do that with:
> >> >> > tune2fs -f -O ^has_journal /dev/sda1
> >> >> >
> >> >> >   Let's see what mount will say after that.
> >> >> >
> >> >> >   Another option is to run
> >> >> > debugfs /dev/sda1
> >> >> >
> >> >> >   Then you can use ls, cd, and other debugfs commands to move within the
> >> >> > filesystem and investigate things. If that will work, you have a reasonable
> >> >> > chance of getting at least some data back.
> >> >> >
> >> >> >                                                                 Honza
> >> >> > --
> >> >> > Jan Kara <jack@suse.cz>
> >> >> > SUSE Labs, CR
> >> >>
> >> >>
> >> >> On Wed, Sep 25, 2013 at 12:12 PM, Jan Kara <jack@suse.cz> wrote:
> >> >> > On Tue 24-09-13 22:25:49, InvTraySts wrote:
> >> >> >> So long story short, I had a server running that had a processor fail
> >> >> >> while powered on, causing the file systems to become corrupt. I
> >> >> >> replaced the motherboard, processor and power supply just to be on the
> >> >> >> safe side. However, I am at a bit of a loss as to what to do now. I
> >> >> >> was working sandeen in the OFTC IRC channel, but, on his
> >> >> >> recommendation he suggested me to post something to the mailing list.
> >> >> >>
> >> >> >> Lets start off with one drive at a time (I have 4 that are corrupt).
> >> >> >> The specific logical drive in question was in RAID1 on a Dell PERC 5/i
> >> >> >> card.
> >> >> >> If I try to mount this using:
> >> >> >> mount -t ext4 /dev/sda1 /media/tmp
> >> >> >>
> >> >> >> It complains in dmesg with the following output:
> >> >> >> 685621.845207] EXT4-fs error (device sda1): ext4_iget:3888: inode #8:
> >> >> >> comm mount: bad extra_isize (18013 != 256)
> >> >> >> [685621.845213] EXT4-fs (sda1): no journal found
> >> >> >>
> >> >> >>
> >> >> >> However, if I run dumpe2fs -f /dev/sda1 I get the following output:
> >> >> >> root@server:~# dumpe2fs -f /dev/sda1
> >> >> >> dumpe2fs 1.42.5 (29-Jul-2012)
> >> >> >> Filesystem volume name:   root
> >> >> >> Last mounted on:          /media/ubuntu/root
> >> >> >> Filesystem UUID:          f959e195-[removed]
> >> >> >> Filesystem magic number:  0xEF53
> >> >> >> Filesystem revision #:    1 (dynamic)
> >> >> >> Filesystem features:      has_journal ext_attr resize_inode dir_index
> >> >> >> filetype extent flex_bg sparse_super large_file huge_file uninit_bg
> >> >> >> dir_nlink extra_isize
> >> >> >> Filesystem flags:         signed_directory_hash
> >> >> >> Default mount options:    user_xattr acl
> >> >> >> Filesystem state:         not clean with errors
> >> >> >> Errors behavior:          Continue
> >> >> >> Filesystem OS type:       Linux
> >> >> >> Inode count:              4849664
> >> >> >> Block count:              19398144
> >> >> >> Reserved block count:     969907
> >> >> >> Free blocks:              17034219
> >> >> >> Free inodes:              4592929
> >> >> >> First block:              0
> >> >> >> Block size:               4096
> >> >> >> Fragment size:            4096
> >> >> >> Reserved GDT blocks:      1019
> >> >> >> Blocks per group:         32768
> >> >> >> Fragments per group:      32768
> >> >> >> Inodes per group:         8192
> >> >> >> Inode blocks per group:   512
> >> >> >> Flex block group size:    16
> >> >> >> Filesystem created:       Sat May 25 14:59:50 2013
> >> >> >> Last mount time:          Sat Aug 24 11:04:25 2013
> >> >> >> Last write time:          Tue Sep 24 13:55:36 2013
> >> >> >> Mount count:              0
> >> >> >> Maximum mount count:      -1
> >> >> >> Last checked:             Sat Aug 24 16:56:09 2013
> >> >> >> Check interval:           0 (<none>)
> >> >> >> Lifetime writes:          107 GB
> >> >> >> Reserved blocks uid:      0 (user root)
> >> >> >> Reserved blocks gid:      0 (group root)
> >> >> >> First inode:              11
> >> >> >> Inode size:               256
> >> >> >> Required extra isize:     28
> >> >> >> Desired extra isize:      28
> >> >> >> Journal inode:            8
> >> >> >> Default directory hash:   half_md4
> >> >> >> Directory Hash Seed:      01a8f605-b2bc-41ee-b7b5-11d843ab622f
> >> >> >> Journal backup:           inode blocks
> >> >> >> FS Error count:           8
> >> >> >> First error time:         Sat Aug 24 13:44:55 2013
> >> >> >> First error function:     ext4_iget
> >> >> >> First error line #:       3889
> >> >> >> First error inode #:      8
> >> >> >> First error block #:      0
> >> >> >> Last error time:          Tue Sep 24 13:55:36 2013
> >> >> >> Last error function:      ext4_iget
> >> >> >> Last error line #:        3888
> >> >> >> Last error inode #:       8
> >> >> >> Last error block #:       0
> >> >> >> dumpe2fs: Corrupt extent header while reading journal super block
> >> >> >   OK, so really journal inode (inode #8) looks toast but superblock looks
> >> >> > OK.
> >> >> >
> >> >> >> So I attempted to clone the drive to a 2TB backup drive that is empty,
> >> >> >> and currently I am having more problems with the cloned drive than I
> >> >> >> am with the original.
> >> >> >>
> >> >> >> sandeen said something about using tune2fs to tell it to remove the
> >> >> >> has_journal flag, but I might need some assistance with that.
> >> >> >   Yes, you can do that with:
> >> >> > tune2fs -f -O ^has_journal /dev/sda1
> >> >> >
> >> >> >   Let's see what mount will say after that.
> >> >> >
> >> >> >   Another option is to run
> >> >> > debugfs /dev/sda1
> >> >> >
> >> >> >   Then you can use ls, cd, and other debugfs commands to move within the
> >> >> > filesystem and investigate things. If that will work, you have a reasonable
> >> >> > chance of getting at least some data back.
> >> >> >
> >> >> >                                                                 Honza
> >> >> > --
> >> >> > Jan Kara <jack@suse.cz>
> >> >> > SUSE Labs, CR
> >> > --
> >> > Jan Kara <jack@suse.cz>
> >> > SUSE Labs, CR
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
