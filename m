From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: Bug#679830: linux-image-2.6.32-5-686: Kernel bug observed in
 syslog when performing an rsync operation.
Date: Sun, 22 Jul 2012 17:21:42 +0900
Message-ID: <CAC5umyikLFP6j-9hjSV814h4tc=4FUyBr2FFK5LWx2rvYFAEuA@mail.gmail.com>
References: <20120701221420.1784.81013.reportbug@altair.ejectdisc.net>
	<1342932566.11373.229.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Imran Chaudhry <ichaudhry@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, 679830@bugs.debian.org,
	linux-ext4@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51029 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GVIVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Jul 2012 04:21:43 -0400
Received: by ghrr11 with SMTP id r11so4844168ghr.19
        for <linux-ext4@vger.kernel.org>; Sun, 22 Jul 2012 01:21:42 -0700 (PDT)
In-Reply-To: <1342932566.11373.229.camel@deadeye.wl.decadent.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/7/22 Ben Hutchings <ben@decadent.org.uk>:
> On Sun, 2012-07-01 at 23:14 +0100, Imran Chaudhry wrote:
>> Package: linux-2.6
>> Version: 2.6.32-45
>> Severity: normal
>>
>> Kernel bug observed in syslog when performing an rsync operation. I
>> use rsnapshot and I believe an rsnapshot operation "conflicted" or
>> "interfered" somehow with my manual rsync command. The source and
>> destination are USB HDDs with ext4 filesystems. After the kernel bug
>> was observed I discovered the source filesystem had a corrupt
>> filesystem. If it is relevant I was using the rsync command with
>> --hard-links and I also observed messages of this sort:
>> "[1075483.039915] EXT4-fs error (device sdb1): htree_dirblock_to_tree:
>> bad entry in directory #7143723: directory entry across blocks -
>> block=34323866offset=0(0), inode=135151872, rec_len=66180,
>> name_len=66" and "Jul  1 06:33:06 altair kernel: [1075335.376996]
>> EXT4-fs error (device sdb1): ext4_lookup: deleted inode referenced:
>> 8954048".
>
> Sorry to hear this.  I cannot recommend using ext4 in Linux 2.6.32.
>
>> Relevant kernel log trace with bug:
>> Jul  1 05:37:53 altair kernel: [1072022.349172] ------------[ cut here ]------------
>> Jul  1 05:37:53 altair kernel: [1072022.352027] kernel BUG at /build/buildd-linux-2.6_2.6.32-45-i386-yQfQSv/linux-2.6-2.6.32/debian/build/source_i386_none/fs/ext4/extents.c:1873!
>> Jul  1 05:37:53 altair kernel: [1072022.352027] invalid opcode: 0000 [#1] SMP
>> Jul  1 05:37:53 altair kernel: [1072022.352027] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:09.1/usb4/4-0:1.0/bInterfaceProtocol
>> Jul  1 05:37:53 altair kernel: [1072022.352027] Modules linked in: xt_multiport iptable_filter ip_tables x_tables fuse nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc ext4 jbd2 crc16 loop raid1 md_mod snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm i2c_i801 snd_timer shpchp snd psmouse evdev soundcore parport_pc parport serio_raw i2c_core snd_page_alloc pcspkr pci_hotplug rng_core processor button ext3 jbd mbcache usb_storage sd_mod crc_t10dif ata_generic ata_piix uhci_hcd e100 libata ehci_hcd thermal floppy r8169 mii usbcore nls_base scsi_mod thermal_sys [last unloaded: scsi_wait_scan]
>> Jul  1 05:37:53 altair kernel: [1072022.352027]
>> Jul  1 05:37:53 altair kernel: [1072022.352027] Pid: 31553, comm: rsync Not tainted (2.6.32-5-686 #1) Deskpro
>> Jul  1 05:37:53 altair kernel: [1072022.352027] EIP: 0060:[<e0ea5b00>] EFLAGS: 00010246 CPU: 0
>> Jul  1 05:37:53 altair kernel: [1072022.352027] EIP is at ext4_ext_get_blocks+0x286/0x1916 [ext4]
>> Jul  1 05:37:53 altair kernel: [1072022.352027] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
>> Jul  1 05:37:53 altair kernel: [1072022.352027] ESI: 00000000 EDI: db1216f4 EBP: 00000000 ESP: dfad7ad0
> [...]
>
> This specific failure mode seems to have been made possible by:
>
> commit 731eb1a03a8445cde2cb23ecfb3580c6fa7bb690
> Author: Akinobu Mita <akinobu.mita@gmail.com>
> Date:   Wed Mar 3 23:55:01 2010 -0500
>
>     ext4: consolidate in_range() definitions
>
> which was backported into a stable update.  If the 'first' and 'len'
> arguments to in_range() are both 0 and either of them is unsigned, it
> wrongly returns true.  This means that:
>
>                 if (in_range(iblock, ee_block, ee_len)) {
>                         ...
>                                 ext4_ext_put_in_cache(inode, ee_block,
>                                                         ee_len, ee_start,
>                                                         EXT4_EXT_CACHE_EXTENT);
>
> may pass ee_len == 0 to ext4_ext_put_in_cache(), triggering the BUG_ON
> there.  Maybe that's just not a valid case so this doesn't matter, but
> it seems like it might be possible with a corrupt filesystem?
>
> Anyway, I think the proper definition of in_range() is:
>
> #define in_range(b, first, len) ((b) >= (first) && ((b) - (first)) < (len))

I agree with this change and it actually resolves the issue:
http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-3015
while my original patch doesn't.
