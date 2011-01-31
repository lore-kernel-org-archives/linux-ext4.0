From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 27912] New: Set 'err' in ext4_init_fs() if
 kset_create_and_add() fails
Date: Mon, 31 Jan 2011 20:31:34 GMT
Message-ID: <bug-27912-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:36781 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1AaUbf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Jan 2011 15:31:35 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0VKVYax032174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 31 Jan 2011 20:31:34 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=27912

           Summary: Set 'err' in ext4_init_fs() if kset_create_and_add()
                    fails
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dame_eugene@mail.ru
        Regression: No


Set 'err' in ext4_init_fs() if kset_create_and_add() fails
------------------------

In ext4_init_fs() (super.c), consider the following fragment:

ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
if (!ext4_kset)
    goto out4;

If kset_create_and_add() fails for some reason, 'err' variable will remain 0,
so ext4_init_fs() will return 0 despite this failure. It will look like as if
the module has initialized itself successfully while it has not. 

On my system this results in a kernel oops as soon as I try to unload ext4
module. To be exact, when destroy_inodecache() is invoked, it tries to call
kmem_cache_destroy(ext4_inode_cachep) but ext4_inode_cachep is NULL because it
was not initialized due to that incomplete init. So, 

BUG_ON(!cachep || in_interrupt()) 

triggers in kmem_cache_destroy().

The problem can be reproduced as follows (it is assumed that ext4 is compiled
as a module): load ext4.ko, unload it and then load it again. For some reason,
/sys/fs/ext4/ directory is not deleted when the module is unloaded and that is
why kset_create_and_add() fails when I try to load it the second time. From the
system log:

---------------------------------
[ 3077.802232] WARNING: at
/home/eugene/distrib/kernel/mainline.git/linux-2.6/fs/sysfs/dir.c:455
sysfs_add_one+0x8a/0xb0()
[ 3077.802236] Hardware name: VirtualBox
[ 3077.802239] sysfs: cannot create duplicate filename '/fs/ext4'
[ 3077.802242] Modules linked in: ext4(+) jbd2 crc16 kedr_controller
kedr_fsim_indicator_kmalloc kedr_fsim_indicator_common
kedr_fsim_user_space_access kedr_fsim_cmm kedr_fault_simulation kedr_trace
kedr_base fuse snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd af_packet
mperf loop dm_mod snd_intel8x0 snd_ac97_codec ac97_bus e1000 snd_pcm snd_timer
ppdev button sg snd soundcore snd_page_alloc parport_pc sr_mod parport cdrom
i2c_piix4 ac pcspkr ohci_hcd ehci_hcd usbcore rtc_cmos sd_mod rtc_core rtc_lib
fan processor ata_generic thermal thermal_sys hwmon ata_piix ahci libahci
libata scsi_mod [last unloaded: kedr_base]
[ 3077.802275] Pid: 5388, comm: modprobe Not tainted 2.6.38-rc2-testbox+ #1
[ 3077.802278] Call Trace:
[ 3077.802286]  [<c02450fd>] ? warn_slowpath_common+0x6d/0xa0
[ 3077.802290]  [<c035267a>] ? sysfs_add_one+0x8a/0xb0
[ 3077.802293]  [<c035267a>] ? sysfs_add_one+0x8a/0xb0
[ 3077.802298]  [<c02451ae>] ? warn_slowpath_fmt+0x2e/0x30
[ 3077.802301]  [<c035267a>] ? sysfs_add_one+0x8a/0xb0
[ 3077.802305]  [<c03526fc>] ? create_dir+0x5c/0xa0
[ 3077.802309]  [<c03527de>] ? sysfs_create_dir+0x6e/0xa0
[ 3077.802314]  [<c03d337d>] ? kobject_add_internal+0x9d/0x230
[ 3077.802318]  [<c03dd383>] ? kvasprintf+0x43/0x60
[ 3077.802322]  [<c03d3a87>] ? kset_register+0x27/0x60
[ 3077.802326]  [<c03d3b27>] ? kset_create_and_add+0x67/0xa0
[ 3077.802336]  [<f8fc4143>] ? ext4_init_fs+0x37/0x114 [ext4]
[ 3077.802340]  [<c0201230>] ? do_one_initcall+0x30/0x170
[ 3077.802349]  [<f8fc410c>] ? ext4_init_fs+0x0/0x114 [ext4]
[ 3077.802354]  [<c0278936>] ? sys_init_module+0x116/0x19c0
[ 3077.802359]  [<c0202ddc>] ? sysenter_do_call+0x12/0x28
[ 3077.802362] ---[ end trace 8b7776f89b6ab60b ]---
[ 3077.802367] kobject_add_internal failed for ext4 with -EEXIST, don't try to
register things with the same name in the same directory.
[ 3077.802371] Pid: 5388, comm: modprobe Tainted: G        W  
2.6.38-rc2-testbox+ #1
[ 3077.802374] Call Trace:
[ 3077.802378]  [<c03d3434>] ? kobject_add_internal+0x154/0x230
[ 3077.802382]  [<c03dd383>] ? kvasprintf+0x43/0x60
[ 3077.802386]  [<c03d3a87>] ? kset_register+0x27/0x60
[ 3077.802389]  [<c03d3b27>] ? kset_create_and_add+0x67/0xa0
[ 3077.802398]  [<f8fc4143>] ? ext4_init_fs+0x37/0x114 [ext4]
[ 3077.802402]  [<c0201230>] ? do_one_initcall+0x30/0x170
[ 3077.802411]  [<f8fc410c>] ? ext4_init_fs+0x0/0x114 [ext4]
[ 3077.802416]  [<c0278936>] ? sys_init_module+0x116/0x19c0
[ 3077.802420]  [<c0202ddc>] ? sysenter_do_call+0x12/0x28 
---------------------------------

I suppose a trivial change in ext4_init_fs() would be enough to fix this
problem:

ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
if (!ext4_kset) {
    err = -EEXIST;
    goto out4;
}

Not sure about which error code to return though. As far as I can see from the
code, kset_create_and_add() can fail due to other reasons as well (out of
memory conditions, for example).

Besides that, it is still unclear to me why that sysfs directory is not deleted
when ext4.ko is unloaded. kset_unregister(ext4_kset) seems to be in place in
ext4_exit_fs(). I could probably analyze this a bit further. Anyway, it is
another story. Should I file another bug for this?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
