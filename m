From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Unregister features interface on module unload
Date: Tue, 18 Jan 2011 13:41:05 -0600
Message-ID: <4D35ECD1.3070502@redhat.com>
References: <1295276437-27966-1-git-send-email-lczerner@redhat.com> <4D3485BF.4030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1ARTlH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Jan 2011 14:41:07 -0500
In-Reply-To: <4D3485BF.4030100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 01/17/2011 12:09 PM, Eric Sandeen wrote:

> On 01/17/2011 09:00 AM, Lukas Czerner wrote:
>> Ext4 features interface was not properly unregistered which led to
>> problems while unloading/reloading ext4 module. This commit fixes that by
>> adding proper kobject unregistration code into ext4_exit_fs() as well as
>> fail-path of ext4_init_fs()
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Works for me!
>
I may have spoken too soon.  After a few insmod/mount/io/umount/rmmod loops I got:

[   95.625277] general protection fault: 0000 [#1] SMP 

[   95.626002] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/block/sdb/dev

[   95.626002] CPU 0 

[   95.626002] Modules linked in: ext4(+) jbd2 xfs exportfs sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ip6table_filter ip6_tables ipv6 tg3 joydev dcdbas serio_raw i2c_i801 iTCO_wdt iTCO_vendor_support i3000_edac edac_core shpchp ata_generic pata_acpi pata_sil680 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: ext4]

[   95.626002] 

[   95.626002] Pid: 2243, comm: insmod Not tainted 2.6.37+ #95 0RH817/PowerEdge 860

[   95.626002] RIP: 0010:[<ffffffff8110eba8>]  [<ffffffff8110eba8>] __kmalloc_track_caller+0xc0/0x125

[   95.626002] RSP: 0018:ffff880079febcb8  EFLAGS: 00010006

[   95.626002] RAX: 0000000000000000 RBX: ffff88007d002480 RCX: 0000000000000015

[   95.626002] RDX: 0000000000000000 RSI: 0000000000000319 RDI: ffffffff81777e46

[   95.626002] RBP: ffff880079febcf8 R08: ffff88007fc164d0 R09: 0000000000000001

[   95.626002] R10: ffff88007658bd80 R11: ffff880079febcf8 R12: 00000000000000d0

[   95.626002] R13: 0000000000000015 R14: 6465767265736572 R15: ffffffff810c4fd9

[   95.626002] FS:  00007fb94b70c700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000

[   95.626002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b

[   95.626002] CR2: 00007fb94ae7500f CR3: 0000000079247000 CR4: 00000000000006f0

[   95.626002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

[   95.626002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

[   95.626002] Process insmod (pid: 2243, threadinfo ffff880079fea000, task ffff88006dc05c00)

[   95.626002] Stack:

[   95.626002]  00000000000080d0 0000000000000246 ffff88006b62bdc0 ffffffffa0430c2d

[   95.626002]  ffffffffa0430972 ffffffffa0430c2d 0000000000000034 ffff88006b62bdc0

[   95.626002]  ffff880079febd28 ffffffff810e85db 0000000000000034 0000000000000015

[   95.626002] Call Trace:

[   95.626002]  [<ffffffff810e85db>] kstrdup+0x31/0x4a

[   95.626002]  [<ffffffff810c4fd9>] __trace_define_field+0x44/0xc5

[   95.626002]  [<ffffffff810c50b7>] trace_define_field+0x5d/0x62

[   95.626002]  [<ffffffff8119bb34>] ? debugfs_create_file+0x1bf/0x1eb

[   95.626002]  [<ffffffffa040ea96>] ftrace_define_fields_ext4_da_reserve_space+0x16e/0x1a7 [ext4]

[   95.626002]  [<ffffffff810b898d>] ? trace_create_file+0xf/0x30

[   95.626002]  [<ffffffff810c4c12>] __trace_add_event_call+0x2ee/0x370

[   95.626002]  [<ffffffff810c4e93>] trace_module_notify+0x1ff/0x2aa

[   95.626002]  [<ffffffff8141bd96>] notifier_call_chain+0x37/0x63

[   95.626002]  [<ffffffff8106f6ed>] __blocking_notifier_call_chain+0x50/0x67

[   95.626002]  [<ffffffff8106f718>] blocking_notifier_call_chain+0x14/0x16

[   95.626002]  [<ffffffff81082283>] sys_init_module+0x6e/0x1df

[   95.626002]  [<ffffffff8100ac82>] system_call_fastpath+0x16/0x1b

[   95.626002] Code: 68 9c 58 0f 1f 44 00 00 48 89 45 c8 fa 66 0f 1f 44 00 00 4c 8b 03 65 4c 03 04 25 30 db 00 00 4d 8b 30 4d 85 f6 74 0d 48 63 43 18 <49> 8b 04 06 49 89 00 eb 14 4c 89 f9 83 ca ff 44 89 e6 48 89 df 

[   95.626002] RIP  [<ffffffff8110eba8>] __kmalloc_track_caller+0xc0/0x125

[   95.626002]  RSP <ffff880079febcb8>

[   95.626002] ---[ end trace 524b8240b6797f51 ]---

-Eric

> Tested-by: Eric Sandeen <sandeen@redhat.com>
>
> Thanks - probably needs to go to .37-stable too right?
>
> -Eric
>
>> ---
>>  fs/ext4/super.c |   12 ++++++++++--
>>  1 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index cb10a06..124d304 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -4779,7 +4779,7 @@ static struct file_system_type ext4_fs_type = {
>>  	.fs_flags	= FS_REQUIRES_DEV,
>>  };
>>  
>> -int __init ext4_init_feat_adverts(void)
>> +static int __init ext4_init_feat_adverts(void)
>>  {
>>  	struct ext4_features *ef;
>>  	int ret = -ENOMEM;
>> @@ -4803,6 +4803,13 @@ out:
>>  	return ret;
>>  }
>>  
>> +static void ext4_exit_feat_adverts(void)
>> +{
>> +	kobject_put(&ext4_feat->f_kobj);
>> +	wait_for_completion(&ext4_feat->f_kobj_unregister);
>> +	kfree(ext4_feat);
>> +}
>> +
>>  static int __init ext4_init_fs(void)
>>  {
>>  	int err;
>> @@ -4849,7 +4856,7 @@ out1:
>>  out2:
>>  	ext4_exit_mballoc();
>>  out3:
>> -	kfree(ext4_feat);
>> +	ext4_exit_feat_adverts();
>>  	remove_proc_entry("fs/ext4", NULL);
>>  	kset_unregister(ext4_kset);
>>  out4:
>> @@ -4868,6 +4875,7 @@ static void __exit ext4_exit_fs(void)
>>  	destroy_inodecache();
>>  	ext4_exit_xattr();
>>  	ext4_exit_mballoc();
>> +	ext4_exit_feat_adverts();
>>  	remove_proc_entry("fs/ext4", NULL);
>>  	kset_unregister(ext4_kset);
>>  	ext4_exit_system_zone();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

