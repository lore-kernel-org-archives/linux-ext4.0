From: Amir Goldstein <amir73il@gmail.com>
Subject: Regression with ext4 in kernel 2.6.39-rc7? (Was: testing ext4 master branch)
Date: Fri, 13 May 2011 12:17:03 +0300
Message-ID: <BANLkTikW57S9emEFG9w9RXvq5O7v_MrsYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39324 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab1EMJRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 May 2011 05:17:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

I double checked myself and made a clean build of 2.6.39-rc7
and I am still getting this crash below with xfstest 232.
All xfstests used to pass when I was runing kernel 2.6.38, so
this must be a regression.

Unfortunately, I cannot double check there is no crash with previous ke=
rnel,
because I lost connection with my test server and there is no one to
push the reset button over the weekend.

Can anyone try to reproduce the error with xfstest 005 and the crash
with xfstest 232?

Thanks,
Amir.

[ 1319.112544] EXT4-fs (sda8): mounted filesystem with ordered data
mode. Opts: acl,user_xattr,usrquota,grpquota
[ 1319.270023] EXT4-fs (sda8): re-mounted. Opts: (null)
[ 1319.271464] EXT4-fs (sda8): re-mounted. Opts: (null)
[ 1368.214854] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[ 1368.219348] IP: [<ffffffff8122e152>] ext4_quota_off+0x42/0xd0
[ 1368.221628] PGD 0
[ 1368.222978] Oops: 0000 [#2] SMP
[ 1368.222978] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 1368.222978] CPU 0
[ 1368.222978] Modules linked in: binfmt_misc parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec i915 snd_hwdep
snd_pcm drm_kms_helper drm snd_seq_midi snd_rawmidi e1000e
snd_seq_midi_event i2c_algo_bit snd_seq lp firewire_ohci firewire_core
snd_timer snd_seq_device snd soundcore snd_page_alloc psmouse parport
pata_marvell usbhid hid video intel_agp intel_gtt tpm_tis crc_itu_t
serio_raw tpm tpm_bios
[ 1368.222978]
[ 1368.222978] Pid: 2691, comm: quotaon Tainted: G   M  D
2.6.39-rc7 #9                  /DQ35JO
[ 1368.222978] RIP: 0010:[<ffffffff8122e152>]  [<ffffffff8122e152>]
ext4_quota_off+0x42/0xd0
[ 1368.222978] RSP: 0018:ffff8800c4bb3e28  EFLAGS: 00010292
[ 1368.222978] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000=
000000018
[ 1368.222978] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000=
000000246
[ 1368.222978] RBP: ffff8800c4bb3e48 R08: 0000000000000001 R09: 0000000=
000000000
[ 1368.222978] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880=
114576000
[ 1368.222978] R13: ffff880114576000 R14: 0000000000000001 R15: 0000000=
000000000
[ 1368.222978] FS:  00007f5c2bf97720(0000) GS:ffff88012bc00000(0000)
knlGS:0000000000000000
[ 1368.222978] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1368.222978] CR2: 0000000000000018 CR3: 00000000c693f000 CR4: 0000000=
0000006f0
[ 1368.222978] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 1368.222978] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 1368.222978] Process quotaon (pid: 2691, threadinfo
ffff8800c4bb2000, task ffff880116bc5ee0)
[ 1368.222978] Stack:
[ 1368.222978]  0000000000800003 0000000000000001 ffff880114576000
00000000ffffffda
[ 1368.222978]  ffff8800c4bb3ef8 ffffffff811c9e05 0000000000000000
0000000000000000
[ 1368.222978]  ffff8800c4bb3e78 ffff880114576068 ffff880115009800
ffff880114576068
[ 1368.222978] Call Trace:
[ 1368.222978]  [<ffffffff811c9e05>] do_quotactl+0x4e5/0x560
[ 1368.222978]  [<ffffffff815d376c>] ? down_read+0x4c/0x70
[ 1368.222978]  [<ffffffff811711cf>] ? get_super+0x9f/0xd0
[ 1368.222978]  [<ffffffff81189f78>] ? iput+0x48/0x200
[ 1368.222978]  [<ffffffff811c9f4c>] sys_quotactl+0xcc/0x1a0
[ 1368.222978]  [<ffffffff8116be26>] ? filp_close+0x66/0x90
[ 1368.222978]  [<ffffffff812fd76e>] ? trace_hardirqs_on_thunk+0x3a/0x3=
f
[ 1368.222978]  [<ffffffff815dd2c2>] system_call_fastpath+0x16/0x1b
[ 1368.222978] Code: 89 74 24 18 0f 1f 44 00 00 48 63 c6 49 89 fc 41
89 f6 48 8b 9c c7 60 03 00 00 48 8b 87 90 04 00 00 f6 40 73 08 0f 85
7e 00 00 00
[ 1368.222978]  8b 7b 18 be 01 00 00 00 e8 c0 fb ff ff 48 3d 00 f0 ff f=
f 49
[ 1368.222978] RIP  [<ffffffff8122e152>] ext4_quota_off+0x42/0xd0
[ 1368.222978]  RSP <ffff8800c4bb3e28>
[ 1368.222978] CR2: 0000000000000018
[ 1368.310246] ---[ end trace 62a147f050ade229 ]---


On Fri, May 13, 2011 at 12:19 AM, Amir Goldstein <amir73il@gmail.com> w=
rote:
> On Thu, May 12, 2011 at 9:03 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Thu, May 12, 2011 at 7:27 PM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
>>> Hi Jan,
>>>
>>> During testing of Ted's master branch merged with 2.6.39-rc7, I
>>> encountered 2 errors,
>>> before the system was hung.
>>>
>>> One error is consistent in xfstest 005 (Test symlinks & ELOOP):
>>> QA output created by 005
>>> *** touch deep symlinks
>>>
>>> No ELOOP? =A0Unexpected!
>>>
>>> *** touch recusive symlinks
>>>
>>> ELOOP returned. =A0Good.
>>>
>>>
>>> The other error is critical and you may be able to provide some inp=
ut:
>>> while running xfstest 232 (Run fsstress with quotas enabled and ver=
ify
>>> accounted quotas in the end):
>>>
>>
>> FYI, this crash reproduced the second time I tried to run the test.
>> Now building kernel 2.6.39-rc7 (without ext4 master branch changes).
>> If my remote server doesn't hang over the weekend I will let you kno=
w
>> the test result.
>>
>
> Both bugs are reproduced on 2.6.39-rc7.
> Does anybody else see those results???
>
> Amir.
>
>>>
>>> [18339.351033] EXT4-fs (sda8): mounted filesystem with ordered data
>>> mode. Opts: acl,user_xattr,usrquota,grpquota
>>> [18339.386612] EXT4-fs (sda8): re-mounted. Opts: (null)
>>> [18339.397322] EXT4-fs (sda8): re-mounted. Opts: (null)
>>> [18406.012595] BUG: unable to handle kernel NULL pointer dereferenc=
e
>>> at 0000000000000018
>>> [18406.012664] IP: [<ffffffff8122e202>] ext4_quota_off+0x42/0xd0
>>> [18406.012711] PGD 0
>>> [18406.012730] Oops: 0000 [#1] SMP
>>> [18406.012810] CPU 2
>>> [18406.012826] Modules linked in: next4 binfmt_misc parport_pc ppde=
v
>>> snd_hda_codec_realtek snd_hda_intel snd_hda_codec i915 snd_hwdep
>>> drm_kms_helper snd_pcm snd_seq_midi drm firewire_ohci firewire_core
>>> usbhid snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_dev=
ice
>>> snd e1000e psmouse tpm_tis serio_raw lp i2c_algo_bit hid tpm intel_=
agp
>>> pata_marvell parport soundcore crc_itu_t tpm_bios intel_gtt video
>>> snd_page_alloc
>>> [18406.013187]
>>> [18406.013201] Pid: 26309, comm: quotaon Tainted: G =A0 M
>>> 2.6.39-rc7+ #6 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/DQ35JO
>>> [18406.013269] RIP: 0010:[<ffffffff8122e202>] =A0[<ffffffff8122e202=
>]
>>> ext4_quota_off+0x42/0xd0
>>> [18406.013325] RSP: 0018:ffff88011cd57e28 =A0EFLAGS: 00010292
>>> [18406.013361] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000018
>>> [18406.013406] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000=
0000000000246
>>> [18406.013451] RBP: ffff88011cd57e48 R08: 0000000000000001 R09: 000=
0000000000000
>>> [18406.013497] R10: 0000000000000000 R11: 0000000000000000 R12: fff=
f8800ca9b8800
>>> [18406.013541] R13: ffff8800ca9b8800 R14: 0000000000000001 R15: 000=
0000000000000
>>> [18406.013587] FS: =A000007f602698b720(0000) GS:ffff88012bd00000(00=
00)
>>> knlGS:0000000000000000
>>> [18406.013639] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [18406.013676] CR2: 0000000000000018 CR3: 000000011332b000 CR4: 000=
00000000006e0
>>> [18406.013721] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
>>> [18406.013766] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000=
0000000000400
>>> [18406.013812] Process quotaon (pid: 26309, threadinfo
>>> ffff88011cd56000, task ffff880111bddee0)
>>> [18406.013864] Stack:
>>> [18406.013880] =A00000000000800003 0000000000000001 ffff8800ca9b880=
0
>>> 00000000ffffffda
>>> [18406.013939] =A0ffff88011cd57ef8 ffffffff811c9e05 000000000000000=
0
>>> 0000000000000000
>>> [18406.013998] =A0ffff88011cd57e78 ffff8800ca9b8868 ffff880124621e0=
0
>>> ffff8800ca9b8868
>>> [18406.014057] Call Trace:
>>> [18406.014079] =A0[<ffffffff811c9e05>] do_quotactl+0x4e5/0x560
>>> [18406.014118] =A0[<ffffffff815d2b1c>] ? down_read+0x4c/0x70
>>> [18406.014155] =A0[<ffffffff811711cf>] ? get_super+0x9f/0xd0
>>> [18406.014190] =A0[<ffffffff81189f78>] ? iput+0x48/0x200
>>> [18406.014224] =A0[<ffffffff811c9f4c>] sys_quotactl+0xcc/0x1a0
>>> [18406.014260] =A0[<ffffffff8116be26>] ? filp_close+0x66/0x90
>>> [18406.014298] =A0[<ffffffff812fcb1e>] ? trace_hardirqs_on_thunk+0x=
3a/0x3f
>>> [18406.014343] =A0[<ffffffff815dc642>] system_call_fastpath+0x16/0x=
1b
>>> [18406.014382] Code: 89 74 24 18 0f 1f 44 00 00 48 63 c6 49 89 fc 4=
1
>>> 89 f6 48 8b 9c c7 60 03 00 00 48 8b 87 90 04 00 00 f6 40 73 08 0f 8=
5
>>> 7e 00 00 00
>>> [18406.014601] =A08b 7b 18 be 01 00 00 00 e8 c0 fb ff ff 48 3d 00 f=
0 ff ff 49
>>> [18406.014712] RIP =A0[<ffffffff8122e202>] ext4_quota_off+0x42/0xd0
>>> [18406.014756] =A0RSP <ffff88011cd57e28>
>>> [18406.014780] CR2: 0000000000000018
>>> [18406.079351] ---[ end trace 2924f13a8b419b9a ]---
>>>
>>>
>>> The test was hung at quotacheck -u -g for a long time, so I dumped
>>> waiting tasks and got:
>>>
>>>
>>> [21278.671419] SysRq : Show Blocked State
>>> [21278.671427] =A0 task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PC stack =A0 pid father
>>> [21278.671457] quotacheck =A0 =A0 =A0D 00000001001ba0b0 =A0 =A0 0 2=
6321 =A026123 0x00000000
>>> [21278.671464] =A0ffff8801123f7da8 0000000000000046 ffff8801123f7df=
8
>>> 0000000017059fa0
>>> [21278.671472] =A0ffff880100000000 ffff8801123f7fd8 ffff8801123f600=
0
>>> ffff8801123f7fd8
>>> [21278.671480] =A0ffff880124f43f40 ffff880117059fa0 ffff8800ca9b887=
0
>>> 00000001ca9b8868
>>> [21278.671487] Call Trace:
>>> [21278.671498] =A0[<ffffffff815d3775>] rwsem_down_failed_common+0xc=
5/0x160
>>> [21278.671504] =A0[<ffffffff815d3823>] rwsem_down_write_failed+0x13=
/0x20
>>> [21278.671511] =A0[<ffffffff812fca83>] call_rwsem_down_write_failed=
+0x13/0x20
>>> [21278.671517] =A0[<ffffffff811904ce>] ? do_mount+0x21e/0x7e0
>>> [21278.671523] =A0[<ffffffff815d2ac5>] ? down_write+0x65/0x70
>>> [21278.671527] =A0[<ffffffff811904ce>] ? do_mount+0x21e/0x7e0
>>> [21278.671532] =A0[<ffffffff811904ce>] do_mount+0x21e/0x7e0
>>> [21278.671537] =A0[<ffffffff812fce81>] ? strncpy_from_user+0x31/0x4=
0
>>> [21278.671543] =A0[<ffffffff81179dd4>] ? getname_flags+0x74/0x240
>>> [21278.671548] =A0[<ffffffff81190e50>] sys_mount+0x90/0xe0
>>> [21278.671554] =A0[<ffffffff815dc642>] system_call_fastpath+0x16/0x=
1b
>>>
>>>
>>> I have had problems running xfstests on my machine (now Ubuntu 11.4=
).
>>> umount keep failing on some specific tests (sometimes) and reportin=
g:
>>> +umount: /mnt/test/scratch: device is busy.
>>> + =A0 =A0 =A0 =A0(In some cases useful info about processes that us=
e
>>> + =A0 =A0 =A0 =A0 the device is found by lsof(8) or fuser(1))
>>>
>>> Naturally, those partitions are dedicated for xfstests.
>>> I was never able to solve this problem so I set USE_REMOUNT=3D1 to =
avoid umount
>>> at least on the TEST partition.
>>>
>>> Any ideas?
>>>
>>> Amir.
>>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
