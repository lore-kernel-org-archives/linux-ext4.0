From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: INFO: task umount:1524 blocked for more than 120 seconds
Date: Mon, 10 May 2010 16:40:55 -0700
Message-ID: <4BE89987.3070704@gmail.com>
References: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com> <4BE88705.9030105@gmail.com> <4BE890E8.9010700@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65155 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab0EJXkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 May 2010 19:40:39 -0400
In-Reply-To: <4BE890E8.9010700@s5r6.in-berlin.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/10/2010 04:04 PM, Stefan Richter wrote:
> Justin P. Mattock wrote:
>> On 05/10/2010 02:46 PM, Justin Mattock wrote:
>>> I have a reproduceable problem  happening over here
>>> with unmount and ext4
>>> if I sudo cp -R xserver(all libs/apps from git)
>>> to an external
>>> SmartDsk FireLite
>>> then after the cp is done
>>> sudo umount /dev/sdb1
>>>
>>> I get this:
>>>
>>>    type=1400 audit(1273526248.814:27): avc:  denied  { unmount } for
>>> pid=1524 comm="umount" scontext=justin:staff_r:staff_sudo_t:s0
>>> tcontext=system_u:object_r:fs_t:s0 tclass=filesystem
>>> [  360.669140] INFO: task umount:1524 blocked for more than 120 seconds.
>>> [  360.685771] "echo 0>   /proc/sys/kernel/hung_task_timeout_secs"
>>> disables this message.
>>> [  360.702221] umount        D 0000000000000000     0  1524   1472
>>> 0x00000080
>>> [  360.702227]  ffff880080909c88 0000000000000086 ffff880080909da8
>>> 0000000000000000
>>> [  360.702233]  ffff880080909fd8 ffff88013845c4a0 0000000000013fc0
>>> ffff880080909fd8
>>> [  360.702238]  0000000000013fc0 0000000000013fc0 0000000000013fc0
>>> 0000000000013fc0
>>> [  360.702243] Call Trace:
>>> [  360.702252]  [<ffffffff8106e3f4>] ? spin_unlock_irqrestore+0x9/0xb
>>> [  360.702266]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
>>> [  360.702270]  [<ffffffff810fb21d>] bdi_sched_wait+0x9/0xd
>>> [  360.702276]  [<ffffffff813e2126>] __wait_on_bit+0x43/0x76
>>> [  360.702342]  [<ffffffff813e21c2>] out_of_line_wait_on_bit+0x69/0x74
>>> [  360.702346]  [<ffffffff810fb214>] ? bdi_sched_wait+0x0/0xd
>>> [  360.702350]  [<ffffffff8106e3bd>] ? wake_bit_function+0x0/0x2e
>>> [  360.702356]  [<ffffffff81051599>] ? wake_up_process+0x10/0x12
>>> [  360.702360]  [<ffffffff810fc00b>] T.732+0x19/0x1b
>>> [  360.702364]  [<ffffffff810fc06c>] bdi_sync_writeback+0x5f/0x66
>>> [  360.702368]  [<ffffffff810fc090>] sync_inodes_sb+0x1d/0xde
>>> [  360.702373]  [<ffffffff810ff04b>] __sync_filesystem+0x47/0x7e
>>> [  360.702377]  [<ffffffff810ff229>] sync_filesystem+0x47/0x4b
>>> [  360.702382]  [<ffffffff810e2df4>] generic_shutdown_super+0x22/0xf4
>>> [  360.702386]  [<ffffffff810e2ee8>] kill_block_super+0x22/0x3a
>>> [  360.702390]  [<ffffffff810e35f4>] deactivate_super+0x4c/0x64
>>> [  360.702394]  [<ffffffff810f6221>] mntput_no_expire+0xb0/0xde
>>> [  360.702397]  [<ffffffff810f679a>] sys_umount+0x2d9/0x304
>>> [  360.702402]  [<ffffffff810e899e>] ? path_put+0x1d/0x21
>>> [  360.702408]  [<ffffffff81024502>] system_call_fastpath+0x16/0x1b
>>> [  400.536564] ieee1394: Node changed: 0-01:1023 ->   0-00:1023
>>> [  400.536587] ieee1394: Node paused: ID:BUS[0-00:1023] GUID[00d0010d0001eaa9]
>>> [  403.551124] ieee1394: Node removed: ID:BUS[0-00:1023] GUID[00d0010d0001eaa9]
>>> [  403.551263] end_request: I/O error, dev sdb, sector 54795503
>>> [  403.564505] Aborting journal on device sdb1-8.
>>> [  403.577816] JBD2: I/O error detected when updating journal superblock for sdb1-8.
>>> [  403.591168] journal commit I/O error
>>>
>>>
>>> disk just sits there with the light on.
>>>
>>> if I disconnect, then re execute mount,cp,umount
>>> I can get this again:
> [...]
>
>> maybe this is cable related i.g.
>> using a firewire cable from the apple
>> store($40big ones),on an imac gives this
>> message., but if I use the
>> cable from the firewire(slighty thicker), on
>> a macbook, I can do the above mount,cp,unmount
>> with the kernel, and hit nothing.
>
> It is strange then that you don't get any I/O error messages from sbp2
> or from scsi.  Or do you?

the above happens when I umount /dev/sdb1
seems to only happen on my imac9,1,with large files
i.g. umounting after transferring small packages
works o.k.



>
> Was the "Node paused" message in the log above from when you actually
> unplugged or switched off the disk, or didn't do you anything to it at
> that moment?

this happens after I umount(but I'll double check
to make sure).

>
>> (both xserver
>> and all its libs etc.. and the kernel both seem to
>> be pretty large to transfer).
>
> Depends on how much RAM you have.  Could be that there isn't a lot of IO
> going on until umount.
>
> Perhaps there is a bug in the disk's IDE-to-FireWire bridge that went
> unnoticed with older kernels but is now exhibited due to different
> kernel behaviour (writeback related changes, larger requests...).
> Several SmartDisk products have an old Symbios chip that require
> requests limited to 128 kB each.  When sbp2 logs in to the device, does
> it print a "Workarounds for node "... message?  If yes, do the
> workaround flags contain 0x1?

yes, after echoing..

>
> If not, run "echo 1>  /sys/module/sbp2/parameters/workarounds" before
> you plug in the disk.  *If* this fixes the issue, we should add the
> device IDs to sbp2's and firewire-sbp2's hardcoded quirks lists.
>

here is what dmesg shows after doing the echo call to workarounds
(before doing so the workarounds is not present)
this is plugging, and un-plugging the device a few times:

[  806.109104] ieee1394: Error parsing configrom for node 0-00:1023
[  806.109259] ieee1394: Node changed: 0-00:1023 -> 0-01:1023
[  809.877527] ieee1394: Node added: ID:BUS[0-00:1023] 
GUID[00d0010d0001eaa9]
[  809.879303] scsi9 : SBP-2 IEEE-1394
[  809.879459] ieee1394: sbp2: Workarounds for node 0-00:1023: 0x1 
(firmware_revision 0x000470, vendor_id 0x00d001, model_id 0x000000)
[  810.881090] ieee1394: sbp2: Logged into SBP-2 device
[  810.881181] ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max 
payload [2048]
[  810.882537] scsi 9:0:0:0: Direct-Access     SmartDsk FireLite 
  4.70 PQ: 0 ANSI: 0
[  810.882958] sd 9:0:0:0: Attached scsi generic sg2 type 0
[  810.885443] sd 9:0:0:0: [sdb] 117210240 512-byte logical blocks: 
(60.0 GB/55.8 GiB)
[  810.886699] sd 9:0:0:0: [sdb] Write Protect is off
[  810.886703] sd 9:0:0:0: [sdb] Mode Sense: 86 0b 00 02
[  810.888146] sd 9:0:0:0: [sdb] Missing header in MODE_SENSE response
[  810.889415] sd 9:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  810.893453] sd 9:0:0:0: [sdb] Missing header in MODE_SENSE response
[  810.894696]  sdb: sdb1
[  810.972390] sd 9:0:0:0: [sdb] Missing header in MODE_SENSE response
[  810.973927] sd 9:0:0:0: [sdb] Attached SCSI disk
[  834.638222] ieee1394: Node changed: 0-01:1023 -> 0-00:1023
[  834.638241] ieee1394: Node paused: ID:BUS[0-00:1023] 
GUID[00d0010d0001eaa9]
[  837.653064] ieee1394: Node removed: ID:BUS[0-00:1023] 
GUID[00d0010d0001eaa9]
[  837.656224] sd 9:0:0:0: [sdb] Synchronizing SCSI cache
[  837.656278] sd 9:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
[  837.656281] sd 9:0:0:0: [sdb] Stopping disk
[  837.656292] sd 9:0:0:0: [sdb] START_STOP FAILED
[  837.656294] sd 9:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT 
driverbyte=DRIVER_OK
[  840.493108] ieee1394: Error parsing configrom for node 0-00:1023
[  840.493268] ieee1394: Node changed: 0-00:1023 -> 0-01:1023
[  844.261523] ieee1394: Node added: ID:BUS[0-00:1023] 
GUID[00d0010d0001eaa9]
[  844.261962] scsi10 : SBP-2 IEEE-1394
[  844.262126] ieee1394: sbp2: Workarounds for node 0-00:1023: 0x1 
(firmware_revision 0x000470, vendor_id 0x00d001, model_id 0x000000)
[  845.264030] ieee1394: sbp2: Logged into SBP-2 device
[  845.264108] ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max 
payload [2048]
[  845.265477] scsi 10:0:0:0: Direct-Access     SmartDsk FireLite 
   4.70 PQ: 0 ANSI: 0
[  845.265906] sd 10:0:0:0: Attached scsi generic sg2 type 0
[  845.267651] sd 10:0:0:0: [sdb] 117210240 512-byte logical blocks: 
(60.0 GB/55.8 GiB)
[  845.268925] sd 10:0:0:0: [sdb] Write Protect is off
[  845.268929] sd 10:0:0:0: [sdb] Mode Sense: 86 0b 00 02
[  845.270196] sd 10:0:0:0: [sdb] Missing header in MODE_SENSE response
[  845.271406] sd 10:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  845.275385] sd 10:0:0:0: [sdb] Missing header in MODE_SENSE response
[  845.276686]  sdb: sdb1
[  845.350665] sd 10:0:0:0: [sdb] Missing header in MODE_SENSE response
[  845.351927] sd 10:0:0:0: [sdb] Attached SCSI disk

> (By the way, ieee1394/ ohci1394/ sbp2 are kind of end-of-life products;
> firewire-core/ firewire-ohci/ firewire-sbp2 are more actively
> maintained.  OTOH there shouldn't be regressions in the 1394 stack.)

I'll remove ieee1394.ko and use firewire to see if I hit this


Justin P. Mattock

