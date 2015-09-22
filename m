From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: resize2fs stuck in ext4_group_extend with 100% CPU Utilization
 With Small Volumes
Date: Tue, 22 Sep 2015 14:33:18 -0500
Message-ID: <5601ACFE.5080904@redhat.com>
References: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Pocas, Jamie" <Jamie.Pocas@emc.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbbIVTdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Sep 2015 15:33:19 -0400
In-Reply-To: <06724CF51D6BC94E9BEE7A8A8CB82A6740FE22BCBA@MX01A.corp.emc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 9/22/15 2:12 PM, Pocas, Jamie wrote:
> Hi,
> 
> I apologize in advance if this is a well-known issue but I don't see
> it as an open bug in sourceforge.net. I'm not able to open a bug
> there without permission, so I am writing you here.

the centos bug tracker may be the right place for your distro...

> I have a very reproducible spin in resize2fs (x86_64) on both CentOS
> 6 latest rpms and CentOS 7. It will peg one core at 100%. This
> happens with both e2fsprogs version 1.41.12 on CentOS 6 w/ latest
> 2.6.32 kernel rpm installed and e2fsprogs version 1.42.9 on CentOS 7
> with latest 3.10 kernel rpm installed. The key to reproducing this
> seems to be when creating small filesystems. For example if I create
> an ext4 filesystem on a 100MiB disk (or file), and then increase the
> size of the underlying disk (or file) to say 1GiB, it will spin and
> consume 100% CPU and not finish even after hours (it should take a
> few seconds).
> 
> Here are the flags used when creating the fs.
> 
> mkfs.ext4 -O uninit_bg -E nodiscard,lazy_itable_init=1 -F 0 /dev/sdz

AFAIK -F doesn't take an argument, is that 0 supposed to be there?

but if I test this:

# truncate --size=100m testfile
# mkfs.ext4 -O uninit_bg -E nodiscard,lazy_itable_init=1 -F testfile
# truncate --size=1g testfile
# mount -o loop testfile mnt
# resize2fs /dev/loop0

that works fine on my rhel7 box, with kernel-3.10.0-229.el7 and
e2fsprogs-1.42.9-7.el7

Do those same steps fail for you?

-Eric

> Some of these may not be necessary anymore but were very experimental
> when I first started testing on CentOS 5 way back. I think all of
> these options except "nodiscard" are the defaults now anyway. I only
> use the option because in the application I am using this for, it
> doesn't make sense to discard the existing devices which are
> initially zeroed anyway. I suppose with volumes this small it doesn't
> take much extra time anyway, but I don't want to go down that rat
> hole. I am not doing anything custom with the number of inodes,
> smaller blocksize (1k), etc... just what you see above. So it's
> taking the default settings for those, which maybe are bogus and
> broken for small volumes nowadays. I don't know.
> 
> Here is the stack...
> 
> [root@localhost ~]# cat /proc/8403/stack
> [<ffffffff8106ee1a>] __cond_resched+0x2a/0x40
> [<ffffffff8112860b>] find_lock_page+0x3b/0x80
> [<ffffffff8112874f>] find_or_create_page+0x3f/0xb0
> [<ffffffff811c8540>] __getblk+0xf0/0x2a0
> [<ffffffff811c9ad3>] __bread+0x13/0xb0
> [<ffffffffa056098c>] ext4_group_extend+0xfc/0x410 [ext4]
> [<ffffffffa05498a0>] ext4_ioctl+0x660/0x920 [ext4]
> [<ffffffff811a7372>] vfs_ioctl+0x22/0xa0
> [<ffffffff811a7514>] do_vfs_ioctl+0x84/0x580
> [<ffffffff811a7a91>] sys_ioctl+0x81/0xa0
> [<ffffffff8100b0d2>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> It seems to be sleeping, waiting for a free page, and then sleeping
> again in the kernel. I don't get ANY output after the version heading
> prints out, even with the -d debug flags turned up all the way. It's
> really getting stuck very early on with no I/O going to the disk
> during this CPU spinning. I don't see anything in the dmesg related
> to this activity either.
> 
> I haven't finished binary searching for the specific boundary where
> the problem occurs, but I initially noticed that 1GiB and larger
> always worked and took only a few seconds. Then I stepped down to
> 500MiB and it hung in the same way. Then stepped up to 750MiB and it
> works normally. So there is some kind of boundary between 500-750MiB
> that I haven't found yet.
> 
> I understand that these are really small filesystems nowadays other
> than something that might fit on a CD, but I'm hoping that it's
> something simple that could probably be fixed easily. I suspect that
> due to the disk size, there are probably bad or unusual defaults
> being selected, or there is a structure that is being undersized, or
> with unexpected filesystem dimensions such that the conditions it's
> expecting are invalid and will never be satisfied. On that note I am
> wondering with disks this small if it is relying on the antiquated
> geometry reporting from the device because I know that sometimes with
> small virtual disks like there, there can sometimes be problems
> trying to accurately emulate a fake C/H/S geometry with disks this
> small and sometimes rounding down is necessary. I wonder if a
> mismatch could cause this. I don't want to steer anyone off into the
> weeds though.
> 
> I haven't dug into the code much yet, but I was wondering if anyone
> had any ideas what could be going on. I think at the very least this
> is a bug in the resize code in the ext4 code in the kernel itself
> because even if the resize2fs program is giving bad parameters, I
> would not expect this type of hang to be able to be initiated from
> user space.> 
> Regards,
> Jamie
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

