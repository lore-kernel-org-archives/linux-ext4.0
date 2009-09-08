From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 3/4]ext4: Return exchanged blocks count to user space
 in 	failure
Date: Tue, 08 Sep 2009 13:11:48 +0900
Message-ID: <4AA5D984.6030607@rs.jp.nec.com>
References: <4A9DE3EA.1080602@rs.jp.nec.com> <4A9E9521.2010701@gmail.com>	 <87f94c370909021359p171c6f6dte9b700cd48a5fde0@mail.gmail.com> <6149e97b0909022213p2b8463fdm796c8687d36ae54c@mail.gmail.com> <4AA0E419.7010707@rs.jp.nec.com> <4AA143B2.6060401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Peng Tao <bergwolf@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34027 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZIHEMQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 00:12:16 -0400
In-Reply-To: <4AA143B2.6060401@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Peng,

Peng Tao wrote:
> Hi, Akira,
> 
> Akira Fujita wrote:
>> Hi Peng,
>> Peng Tao wrote:
>>> Hi, Greg,
>>>
>>> On Thu, Sep 3, 2009 at 4:59 AM, Greg Freemyer<greg.freemyer@gmail.com> wrote:
>>>> Peng,
>>>>
>>>> I have not looked at the code very closely, but can you tell me where
>>>> a file corruption can take place?   Not completing the replacement of
>>>> extents with donor extents is one thing.  Corrupting the original file
>>>> contents is another.
>>> The file corruption is mainly because of the half done replacement.
>>>
>>> My test case is here:
>>> http://marc.info/?l=linux-ext4&m=124992522305319&w=2
>>>
>> This patch solves your test case problem.
>>
>>> $dd if=/dev/zero of=zero.img bs=10M count=0 seek=50
>>> $dd if=../609xp.img of=first.img bs=10M count=1
>>> $dd if=/dev/zero of=first.img bs=10M count=0 seek=50
>>> $dd if=../609xp.img of=last.img bs=10M count=1 seek=49
>>> $dd if=../609xp.img of=middle.img bs=10M count=1 seek=24
>>> $dd if=/dev/zero of=middle.img bs=10M count=0 seek=50
>>
>> This problem is caused by the fact that logical offset of
>> orig file is different from donor file's.
>> To detect the logical offset difference in EXT4_IOC_MOVE_EXT,
>> add checks to mext_calc_swap_extents() and handles it as error,
>> since data exchange must be done between the same blocks.
>>
>> Note: This problem does not happen in ext4 online defrag
>>       (means with e4defrag command), because the donor file
>>       which is created by e4defrag in user space is
>>       file constitution same as orig file.
>>
>> And add the extent null check to ext_get_path() for
>> followings test case.
>>> $dd if=/dev/zero of=zero.img bs=10M count=0 seek=50
>> More test cases are needed for EXT4_IOC_MOVE_EXT,
>> so this patch may not be complete,
>> but the problem you reported is fixed at least.
>> I am now testing EXT4_IOC_MOVE_EXT hard.
>>
>> BTW, I'm now looking into the empty extent issue which
>> you reported, so I will release the patch soon.
>> http://marc.info/?l=linux-ext4&m=124975192830024&w=2
>>
>> Could you do your test case again with this patch?
> After applying the two patches, I run my test case with first.img as the orig file (and middle.img or
> last.img as donor file). My kernel panics and I find following message in /var/log/messages after reboot:

I could not reproduce this panic.
Would you tell me about your test environment (1-5)?

1. What is your kernel version? (2.6.31-rc2 + ext4 patch queue + my patch?)
2. What FS mount options are enabled?
3. What options are enabled to create ext4?
4. Are image files  (first.img, middle.img and last.img)
   same as your previous mail?
   http://marc.info/?l=linux-ext4&m=124992522305319&w=2
5. What arguments are set to EXT4_IOC_MOVE_EXT in your test case?

Regards,
Akira Fujita


> Sep  4 23:21:05 bergwolf -- MARK --
>  [ 3183.602852] Modules linked in: ext4 ppdev lp parport binfmt_misc i915 kvm_intel kvm uinput ipv6 cpufreq_userspace cpufreq_conservative cpufreq_powersave jbd2 crc16 fuse dm_snapshot dm_mirror dm_region_hash dm_log dm_mod zlib_deflate crc32c acpi_cpufreq sbp2 snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss pcmcia rtc_cmos snd_pcm rtc_core i2c_i801 rtc_lib snd_timer snd_page_alloc psmouse yenta_socket rsrc_nonstatic thinkpad_acpi pcmcia_core serio_raw evdev uhci_hcd firewire_ohci firewire_core crc_itu_t video output ehci_hcd e1000e usbcore [last unloaded: ext4]
>  [ 3183.602951] 
>  [ 3183.602958] Pid: 6937, comm: a.out Not tainted (2.6.31-rc2-drm-intel-next #2) 7676A26
>  [ 3183.602965] EIP: 0060:[<c01cfa26>] EFLAGS: 00210287 CPU: 1
>  [ 3183.602977] EIP is at journal_start+0x39/0xb9
>  [ 3183.602982] EAX: f61a2a80 EBX: f26f048c ECX: f6995200 EDX: f6995000
>  [ 3183.602988] ESI: f26f048c EDI: f6f59c88 EBP: f1a77c90 ESP: f1a77c7c
>  [ 3183.602994]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>  [ 3183.603010]  00000002 f6995000 f6f59c88 f26f048c f6f59c88 f1a77c98 c01c9cc6 f1a77cac
>  [ 3183.603024] <0> c01c0b51 f6f59c88 00000001 f6995200 f1a77cc0 c0192799 004cba00 f6f59c88
>  [ 3183.603039] <0> f68b3840 f1a77cd4 c018ab14 004cba00 00000000 ff7fc000 f1a77d44 c015c7ec
>  [ 3183.603070]  [<c01c9cc6>] ? ext3_journal_start_sb+0x40/0x42
>  [ 3183.603076]  [<c01c0b51>] ? ext3_dirty_inode+0x24/0x67
>  [ 3183.603087]  [<c0192799>] ? __mark_inode_dirty+0x23/0xc6
>  [ 3183.603097]  [<c018ab14>] ? file_update_time+0x7a/0xa3
>  [ 3183.603108]  [<c015c7ec>] ? __generic_file_aio_write_nolock+0x2d6/0x3fe
>  [ 3183.603151]  [<fa29d3b4>] ? ext4_ext_find_extent+0x3f/0x230 [ext4]
>  [ 3183.603161]  [<c015d0e3>] ? generic_file_aio_write+0x57/0xb4
>  [ 3183.603200]  [<fa2a6c26>] ? mext_replace_branches+0x31f/0x329 [ext4]
>  [ 3183.603209]  [<c01bef56>] ? ext3_file_write+0x1a/0x88
>  [ 3183.603219]  [<c017b6e2>] ? do_sync_write+0xab/0xe9
>  [ 3183.603229]  [<c0137403>] ? autoremove_wake_function+0x0/0x33
>  [ 3183.603239]  [<c013dbda>] ? getnstimeofday+0x52/0xda
>  [ 3183.603249]  [<c014d027>] ? do_acct_process+0x68d/0x6b2
>  [ 3183.603257]  [<c015b46c>] ? find_get_page+0x1d/0x81
>  [ 3183.603268]  [<c018df9f>] ? mntput_no_expire+0x19/0xb3
>  [ 3183.603276]  [<c017c9c7>] ? __fput+0x17c/0x184
>  [ 3183.603286]  [<c014d09f>] ? acct_process+0x53/0x66
>  [ 3183.603294]  [<c012a318>] ? do_exit+0x174/0x573
>  [ 3183.603303]  [<c012a778>] ? do_group_exit+0x61/0x88
>  [ 3183.603311]  [<c012a7b2>] ? sys_exit_group+0x13/0x17
>  [ 3183.603320]  [<c0102994>] ? sysenter_do_call+0x12/0x28
>  [ 3183.603419] ---[ end trace cba419e95b73d96f ]---
> 
> I'm not sure why ext3 journal is involved. I've run the case twice and both
> turned out with the same trace messages.

