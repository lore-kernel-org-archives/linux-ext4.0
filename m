From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Sat, 21 Feb 2009 07:48:32 +1300
Message-ID: <1235155713.22702.25.camel@localhost.localdomain>
References: <1235115642.22702.2.camel@localhost.localdomain>
	 <499ECF5C.7020509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:15394 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZBTSsl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Feb 2009 13:48:41 -0500
Received: by ti-out-0910.google.com with SMTP id d10so738880tib.23
        for <linux-ext4@vger.kernel.org>; Fri, 20 Feb 2009 10:48:38 -0800 (PST)
In-Reply-To: <499ECF5C.7020509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

...I haven't noticed  before, but before that message few more lines
where recorded, which makes sense with the BUG line. Also, running
fsck.ext4 on that filesystem I always got a Segment fault at an specific
point, which it is impossible to fix. I'm in a process to remove files
from that filesystem, as soon it finish I can run fsck again and send
the result. Meanwhile, when removing files, rm stuck at a certain inode,
which caused the first BUG message.

-- Andreas

/* output from rm */

removed `#208971861/HardDisks/fedora_9_i386_03.vdi'
removed `#208971861/HardDisks/freebsd_i386_7.1-rc1.vdi'
removed `#208971861/HardDisks/fedora_10_i386_02.vdi'
removed directory: `#208971861/HardDisks'
removed `#208971861/VirtualBox.xml'
removed directory: `#208971861'
^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C

/* from /var/log/messages just before the BUG message */

Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)
Feb 20 18:27:13 storage kernel: EXT4-fs error (device dm-4):
ext4_ext_find_extent: bad header in inode #208971873: unexpected
eh_depth - magic f30a, entries 1, max 340(0), depth 0(1)


-----Original Message-----
From: Eric Sandeen <sandeen@redhat.com>
To: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: kernel BUG at fs/ext4/extents.c:2738!
Date: Fri, 20 Feb 2009 09:42:20 -0600

Andreas Friedrich Berendsen wrote:
> I have no idea what information you guys will need. Let me know and I'll
> to gather it.
> 
> Feb 20 19:26:11 storage kernel: ------------[ cut here ]------------
> Feb 20 19:26:11 storage kernel: kernel BUG at fs/ext4/extents.c:2738!
> Feb 20 19:26:11 storage kernel: invalid opcode: 0000 [#1] SMP 
> Feb 20 19:26:11 storage kernel: last sysfs
> file: /sys/devices/pci0000:00/0000:00:04.0/host0/target0:0:0/0:0:0:0/block/sda/sda2/dev
> Feb 20 19:26:11 storage kernel: Dumping ftrace buffer:
> Feb 20 19:26:11 storage kernel:   (ftrace buffer empty)
> Feb 20 19:26:11 storage kernel: CPU 0 
> Feb 20 19:26:11 storage kernel: Modules linked in: vboxnetflt vboxdrv
> ext2 ext4 jbd2 crc16 fuse ipt_MASQUERADE iptable_nat nf_nat bridge stp
> nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc bonding ipv6 dm_multipath
> raid456 async_xor async_memcpy async_tx xor kvm_amd kvm uinput usblp
> snd_hda_intel snd_seq_dummy cfi_cmdset_0002 jedec_probe snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss forcedeth
> snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep joydev sata_nv
> usb_storage cfi_probe gen_probe cfi_util serio_raw nvidia(P) snd
> firewire_ohci pcspkr k8temp hwmon ck804xrom soundcore firewire_core
> crc_itu_t mtd chipreg map_funcs i2c_nforce2 i2c_core ata_generic
> pata_acpi pata_amd [last unloaded: vboxdrv]
> Feb 20 19:26:11 storage kernel: Pid: 24313, comm: mv Tainted: P        W
> 2.6.28.5.afb.fc10.3.x86_amd64 #1

since this isn't a stock fc10 kernel (?) i'm nto exactly sure what the
BUG was, I assume it was:

        BUG_ON(path[depth].p_ext == NULL && depth != 0);

?

Can you reproduce this?  Perhaps we can reproduce it from an e2image as
well if so, then it could be investigated ....

(Or, if you can reproduce it, perhaps try a .29 kernel first)

- Eric


