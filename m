From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: move_extent explicitly invalidate page buffers
Date: Tue, 13 Jan 2015 16:32:41 +0300
Message-ID: <87twzu3ix2.fsf@openvz.org>
References: <1414064938-2496-1-git-send-email-dmonakhov@openvz.org> <87a94n0wgs.fsf@openvz.org> <548810AE.6050901@cn.fujitsu.com> <87ppbrby37.fsf@openvz.org> <54B24762.400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dave Chinner <david@fromorbit.com>
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61277 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbAMNdm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Jan 2015 08:33:42 -0500
Received: by mail-qa0-f43.google.com with SMTP id v10so2034993qac.2
        for <linux-ext4@vger.kernel.org>; Tue, 13 Jan 2015 05:33:41 -0800 (PST)
In-Reply-To: <54B24762.400@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> writes:

> Hi,
>
> On 12/10/2014 06:25 PM, Dmitry Monakhov wrote:
>> Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com> writes:
>>=20
>>> Hi,
>>>
>>> On 10/23/2014 09:03 PM, Dmitry Monakhov wrote:
>>>> Dmitry Monakhov <dmonakhov@openvz.org> writes:
>>>>
>>>>> In hard core test-cases such as ext4/301, ext4/302 some bh may
>>>>> becomes dirty so try_to_release_page() will fail and result in
>>>>> false positive EBUSY failures. We can easily fix that by
>>>>> explicit ->invalidatepage() after we holds page which is locked
>>>>> and uptodate.
>>>> Sorry. This patch is not correct. Please ignore it.
>>>
>>> Sorry to bother.
>>> I'd like to know whether you're going to send patches to fix this issue=
, thanks?
>> My initial patch was wrong. It is incorrect to use ->invalidatepage()
>> inside ext4_move_extents
>>>
>>> If try_to_release_page(...) failed, some bh's state would be BH_Uptodat=
e, BH_Dirty,
>>> BH_Mapped and BH_Unwritten. In this patch, against such page, you call =
mext_page_mkuptodate(),
>>> but it then calls bh_submit_read()... I wonder whether we should start =
some write
>>> operation, thanks!
>> If we found BH_Dirty page the only thing we can to is  to drop all locks
>> and start writeback on that page and then repeat attempt. Normally pages=
 are
>> not dirty, because sane users call fsync before move_extents.
>> At the same time xfstests ext4/301,ext4/302, ext4/303 are stress tests s=
o EBUSY is
>> expected to happen. IMHO it is reasonable to add explicit
>> filemap_write_and_wait_range() at the beginning of ext4_move_extents()
>> But this can not helps avoid EBUSY on stress tests complitely.
>> So I'll change xfstests to ignore EBUSY similar to ENOSPC.
>> I'll be back with the patches.
> I spent some time to look into this case again, trying to figure out how =
it fails and
> how to fix it. Here is my conclusion, please have a check.
> As we know, there are 3 different data modes: writeback, ordered and jour=
nal, and
> enableing journal would disable delayed allocation and O_DIRECT support. =
So I think
> indeed we have 5 choices:
>   ordered mode with delalloc
>   ordered mode with nodelalloc
>   writeback mode with delalloc
>   writeback mode with nodelalloc
>   journal mode.
>
> When 302 test case fails to me, its data mode is ordered mode with delall=
oc. I think the
> reason is that:
>     ext4/302 test case is ext4 defragmentation stress test, which perform=
s defragmentation
>     on file under buffered io while third task does direct io to donor fi=
le.
>
>     1, this test case first uses fio to create a file(using fallocate()),=
 so this file's
>        corresponding extents' status will be unwritten.
>     2, When one process writes to this file, because delalloc is enabled =
and corresponding
>        extent status is unwritten, ext4_ext_convert_to_initialized() won'=
t also be called,
>        data buffer will not be managed by jbd2, and its status would be B=
H_Uptodate, BH_Dirty,
>        BH_Mapped and BH_Unwritten.
>     3. When another process does ioctl(EXT4_IOC_MOVE_EXT) against this fi=
le with a donor file,
>        the below code: in move_extent_per_page() in fs/ext4/move_extent.c.
>
>        if (unwritten) {
> 		...
> 		if ((page_has_private(pagep[0]) &&
> 		     !try_to_release_page(pagep[0], 0)) ||
> 		    (page_has_private(pagep[1]) &&
> 		     !try_to_release_page(pagep[1], 0))) {
> 			*err =3D -EBUSY;
> 			goto drop_data_sem;
> 		}
> 		...
> 	}
>
> 	Here the try_to_release_page(pagep[0], 0) will surely return 0. Some buf=
fers in this
>         page is not managed by jbd2, and is dirty. I think it will wait t=
hat mm writeback
>         subsystem to write back this page, every 30 seconds? So we will g=
et a EBUSY error.
>         Meanwhile for this EBUSY error, I think this code in move_extent_=
per_page() won't make
>         much sense(As it's not managed by jbd2):
>         	if (*err =3D=3D -EBUSY && retries++ < 4 && EXT4_SB(sb)->s_journa=
l &&
> 	    	    jbd2_journal_force_commit_nested(EXT4_SB(sb)->s_journal))
page can be busy due to JBD or because it is dirty, so force_commit is
reasonable, and as you already said it does not helps if page was dirty
in order to fix that we have to force writeback for that region, but it
can be redirtied again, so we can not avoid EBUSY completely
> 			goto again;
>=20=20=20=20=20=20=20=20
> As Dmitry has said, sane users should call fsync before move_extents, but=
 302 test case does not do that.
> So as a workaround, I'd like to have 302 test case run in ordered mode wi=
th nodelalloc, this case
> will starts to succeed in my test environment.
>
> Ted and Dmitry, would you please have a check my analysis, if you agree s=
o, I'll send patches to
> fix 302 case :) And I think 303 fails to me because of the same reason, t=
hanks!
We can change 302 and 303 to simply ignore EBUSY, IMHO this acceptable
since this is hard-core stress test.
>
> Regards,
> Xiaoguang Wang
>
>>> I attached a log, which I once sent to you, thanks!
>>>
>>> Regards,
>>> Xiaoguang Wang
>>>
>>>>>
>>>>> Tested-by: Xiaoguang Wang<wangxg.fnst@cn.fujitsu.com>
>>>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>>>> ---
>>>>>  fs/ext4/move_extent.c |   10 +++++++---
>>>>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
>>>>> index c2b2b02..76c45b6 100644
>>>>> --- a/fs/ext4/move_extent.c
>>>>> +++ b/fs/ext4/move_extent.c
>>>>> @@ -348,8 +348,9 @@ again:
>>>>>  		     !try_to_release_page(pagep[0], 0)) ||
>>>>>  		    (page_has_private(pagep[1]) &&
>>>>>  		     !try_to_release_page(pagep[1], 0))) {
>>>>> -			*err =3D -EBUSY;
>>>>> -			goto drop_data_sem;
>>>>> +			/* One of buffers is busy, fall back data copy */
>>>>> +			ext4_double_up_write_data_sem(orig_inode, donor_inode);
>>>>> +			goto data_copy;
>>>>>  		}
>>>>>  		replaced_count =3D ext4_swap_extents(handle, orig_inode,
>>>>>  						   donor_inode, orig_blk_offset,
>>>>> @@ -360,12 +361,15 @@ again:
>>>>>  		goto unlock_pages;
>>>>>  	}
>>>>>  data_copy:
>>>>> -	*err =3D mext_page_mkuptodate(pagep[0], from, from + replaced_size);
>>>>> +	/* In order to drop all buffers we have to make page fully uptodate=
 */
>>>>> +	*err =3D mext_page_mkuptodate(pagep[0], 0, PAGE_CACHE_SIZE);
>>>>>  	if (*err)
>>>>>  		goto unlock_pages;
>>>>>=20=20
>>>>>  	/* At this point all buffers in range are uptodate, old mapping lay=
out
>>>>>  	 * is no longer required, try to drop it now. */
>>>>> +	do_invalidatepage(pagep[0], 0, PAGE_CACHE_SIZE);
>>>>> +	do_invalidatepage(pagep[1], 0, PAGE_CACHE_SIZE);
>>>>>  	if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0=
)) ||
>>>>>  	    (page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0=
))) {
>>>>>  		*err =3D -EBUSY;
>>>>> --=20
>>>>> 1.7.1
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> >From a94dae03e2064548c2532ba7786a6cbc29b7bbc9 Mon Sep 17 00:00:00 2001
>>> From: Dmitry Monakhov <dmonakhov@openvz.org>
>>> Date: Fri, 17 Oct 2014 11:24:37 +0400
>>> Subject: [PATCH] patch bh-debug.patch
>>>
>>>
>>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>>> ---
>>>  fs/ext4/move_extent.c |   33 ++++++++++++++++++++++++++++-----
>>>  1 files changed, 28 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
>>> index c2b2b02..84ceed1 100644
>>> --- a/fs/ext4/move_extent.c
>>> +++ b/fs/ext4/move_extent.c
>>> @@ -239,6 +239,21 @@ out:
>>>  	return 0;
>>>  }
>>>=20=20
>>> +
>>> +static void dump_buffers(struct page *page)
>>> +{
>>> +	struct buffer_head *head =3D page_buffers(page);
>>> +	struct buffer_head *bh;
>>> +
>>> +	printk("%s ino:%ld page:%p idx:%lx fl:%lx\n", __FUNCTION__,
>>> +	       page->mapping->host->i_ino, page, page->index, page->flags);
>>> +	bh =3D head;
>>> +	do {
>>> +		printk("bh:%p count:%d state:%lx\n",
>>> +		       bh, atomic_read(&bh->b_count), bh->b_state);
>>> +		bh =3D bh->b_this_page;
>>> +	} while (bh !=3D head);
>>> +}
>>>  /**
>>>   * move_extent_per_page - Move extent data per page
>>>   *
>>> @@ -344,10 +359,17 @@ again:
>>>  			ext4_double_up_write_data_sem(orig_inode, donor_inode);
>>>  			goto data_copy;
>>>  		}
>>> -		if ((page_has_private(pagep[0]) &&
>>> -		     !try_to_release_page(pagep[0], 0)) ||
>>> -		    (page_has_private(pagep[1]) &&
>>> -		     !try_to_release_page(pagep[1], 0))) {
>>> +		if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0)=
)) {
>>> +			if (retries > 95)
>>> +				dump_buffers(pagep[0]);
>>> +
>>> +			*err =3D -EBUSY;
>>> +			goto drop_data_sem;
>>> +		}
>>> +		if ((page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0)=
)) {
>>> +			if (retries > 95)
>>> +				dump_buffers(pagep[1]);
>>> +
>>>  			*err =3D -EBUSY;
>>>  			goto drop_data_sem;
>>>  		}
>>> @@ -408,10 +430,11 @@ stop_journal:
>>>  	/* Buffer was busy because probably is pinned to journal transaction,
>>>  	 * force transaction commit may help to free it. */
>>>  	if (*err =3D=3D -EBUSY &&
>>> -	    (retries++ < 4 && EXT4_SB(orig_inode->i_sb)->s_journal &&
>>> +	    (retries++ < 100 && EXT4_SB(orig_inode->i_sb)->s_journal &&
>>>  	     jbd2_journal_force_commit_nested(
>>>  		     EXT4_SB(orig_inode->i_sb)->s_journal)))
>>>  		goto again;
>>> +
>>>  	return replaced_count;
>>>=20=20
>>>  repair_branches:
>>> --=20
>>> 1.7.1
>>>
>>> [    0.000000] Initializing cgroup subsys cpuset
>>> [    0.000000] Initializing cgroup subsys cpu
>>> [    0.000000] Initializing cgroup subsys cpuacct
>>> [    0.000000] Linux version 3.17.0-rc2+ (root@localhost.localdomain) (=
gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #7 SMP Tue Oct 21 03:=
22:38 EDT 2014
>>> [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.17.0-rc2+ roo=
t=3DUUID=3D181da3e4-9fad-4bea-8f45-0d7fca5ae2b6 ro vconsole.keymap=3Dus cra=
shkernel=3Dauto vconsole.font=3Dlatarcyrheb-sun16 rhgb quiet LANG=3Den_US.U=
TF-8 /dev/sda3
>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] u=
sable
>>> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] r=
eserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] r=
eserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] u=
sable
>>> [    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] r=
eserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] r=
eserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] r=
eserved
>>> [    0.000000] NX (Execute Disable) protection: active
>>> [    0.000000] SMBIOS 2.4 present.
>>> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
>>> [    0.000000] Hypervisor detected: KVM
>>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
reserved
>>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>>> [    0.000000] AGP: No AGP bridge found
>>> [    0.000000] e820: last_pfn =3D 0x7fffe max_arch_pfn =3D 0x400000000
>>> [    0.000000] MTRR default type: write-back
>>> [    0.000000] MTRR fixed ranges enabled:
>>> [    0.000000]   00000-9FFFF write-back
>>> [    0.000000]   A0000-BFFFF uncachable
>>> [    0.000000]   C0000-FFFFF write-protect
>>> [    0.000000] MTRR variable ranges enabled:
>>> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
>>> [    0.000000]   1 disabled
>>> [    0.000000]   2 disabled
>>> [    0.000000]   3 disabled
>>> [    0.000000]   4 disabled
>>> [    0.000000]   5 disabled
>>> [    0.000000]   6 disabled
>>> [    0.000000]   7 disabled
>>> [    0.000000] PAT not supported by CPU.
>>> [    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped=
 at [ffff8800000fda90]
>>> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size =
24576
>>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>>> [    0.000000] BRK [0x01f9c000, 0x01f9cfff] PGTABLE
>>> [    0.000000] BRK [0x01f9d000, 0x01f9dfff] PGTABLE
>>> [    0.000000] BRK [0x01f9e000, 0x01f9efff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x7fc00000-0x7fdfffff]
>>> [    0.000000]  [mem 0x7fc00000-0x7fdfffff] page 2M
>>> [    0.000000] BRK [0x01f9f000, 0x01f9ffff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x7c000000-0x7fbfffff]
>>> [    0.000000]  [mem 0x7c000000-0x7fbfffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
>>> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
>>> [    0.000000]  [mem 0x00200000-0x7bffffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x7fe00000-0x7fffdfff]
>>> [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
>>> [    0.000000] BRK [0x01fa0000, 0x01fa0fff] PGTABLE
>>> [    0.000000] RAMDISK: [mem 0x34d30000-0x3668ffff]
>>> [    0.000000] ACPI: Early table checksum verification disabled
>>> [    0.000000] ACPI: RSDP 0x00000000000FD8B0 000014 (v00 BOCHS )
>>> [    0.000000] ACPI: RSDT 0x000000007FFFE380 000034 (v01 BOCHS  BXPCRSD=
T 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: FACP 0x000000007FFFFF80 000074 (v01 BOCHS  BXPCFAC=
P 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: DSDT 0x000000007FFFE3C0 0011A9 (v01 BXPC   BXDSDT =
  00000001 INTL 20100528)
>>> [    0.000000] ACPI: FACS 0x000000007FFFFF40 000040
>>> [    0.000000] ACPI: SSDT 0x000000007FFFF6E0 000858 (v01 BOCHS  BXPCSSD=
T 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: APIC 0x000000007FFFF5B0 000090 (v01 BOCHS  BXPCAPI=
C 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: HPET 0x000000007FFFF570 000038 (v01 BOCHS  BXPCHPE=
T 00000001 BXPC 00000001)
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] No NUMA configuration found
>>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007fffd=
fff]
>>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffdfff]
>>> [    0.000000]   NODE_DATA [mem 0x7ffd8000-0x7fffdfff]
>>> [    0.000000] kexec: crashkernel: memory value expected
>>> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
>>> [    0.000000] kvm-clock: cpu 0, msr 0:7ff58001, primary cpu clock
>>> [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d6=
00000-ffff88007f5fffff] on node 0
>>> [    0.000000] Zone ranges:
>>> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>>> [    0.000000]   Normal   empty
>>> [    0.000000] Movable zone start for each node
>>> [    0.000000] Early memory node ranges
>>> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
>>> [    0.000000]   node   0: [mem 0x00100000-0x7fffdfff]
>>> [    0.000000] On node 0 totalpages: 524188
>>> [    0.000000]   DMA zone: 64 pages used for memmap
>>> [    0.000000]   DMA zone: 21 pages reserved
>>> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
>>> [    0.000000]   DMA32 zone: 8128 pages used for memmap
>>> [    0.000000]   DMA32 zone: 520190 pages, LIFO batch:31
>>> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
>>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
>>> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
>>> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GS=
I 0-23
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high lev=
el)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high l=
evel)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high l=
evel)
>>> [    0.000000] ACPI: IRQ0 used by override.
>>> [    0.000000] ACPI: IRQ5 used by override.
>>> [    0.000000] ACPI: IRQ9 used by override.
>>> [    0.000000] ACPI: IRQ10 used by override.
>>> [    0.000000] ACPI: IRQ11 used by override.
>>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>>> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
>>> [    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
>>> [    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
>>> [    0.000000] e820: [mem 0x80000000-0xfeffbfff] available for PCI devi=
ces
>>> [    0.000000] Booting paravirtualized kernel on KVM
>>> [    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:4 nr_cpu_ids:=
4 nr_node_ids:1
>>> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88007fc00000 s87232 r=
8192 d23360 u524288
>>> [    0.000000] pcpu-alloc: s87232 r8192 d23360 u524288 alloc=3D1*2097152
>>> [    0.000000] pcpu-alloc: [0] 0 1 2 3=20
>>> [    0.000000] KVM setup async PF for cpu 0
>>> [    0.000000] kvm-stealtime: cpu 0, msr 7fc0e000
>>> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  =
Total pages: 515975
>>> [    0.000000] Policy zone: DMA32
>>> [    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.17.0-r=
c2+ root=3DUUID=3D181da3e4-9fad-4bea-8f45-0d7fca5ae2b6 ro vconsole.keymap=
=3Dus crashkernel=3Dauto vconsole.font=3Dlatarcyrheb-sun16 rhgb quiet LANG=
=3Den_US.UTF-8 /dev/sda3
>>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>>> [    0.000000] AGP: Checking aperture...
>>> [    0.000000] AGP: No AGP bridge found
>>> [    0.000000] Memory: 2020524K/2096752K available (6864K kernel code, =
1463K rwdata, 3240K rodata, 1724K init, 2640K bss, 76228K reserved)
>>> [    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D=
4, Nodes=3D1
>>> [    0.000000] Hierarchical RCU implementation.
>>> [    0.000000] 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_ids=
=3D4.
>>> [    0.000000] 	Offload RCU callbacks from all CPUs
>>> [    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
>>> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu=
_ids=3D4
>>> [    0.000000] NR_IRQS:524544 nr_irqs:456 0
>>> [    0.000000] Console: colour VGA+ 80x25
>>> [    0.000000] console [tty0] enabled
>>> [    0.000000] allocated 8388608 bytes of page_cgroup
>>> [    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't=
 want memory cgroups
>>> [    0.000000] hpet clockevent registered
>>> [    0.000000] tsc: Detected 3192.746 MHz processor
>>> [    0.002000] Calibrating delay loop (skipped) preset value.. 6385.49 =
BogoMIPS (lpj=3D3192746)
>>> [    0.002000] pid_max: default: 32768 minimum: 301
>>> [    0.002000] ACPI: Core revision 20140724
>>> [    0.002000] ACPI: All ACPI Tables successfully acquired
>>> [    0.002000] Security Framework initialized
>>> [    0.002000] SELinux:  Initializing.
>>> [    0.002000] SELinux:  Starting in permissive mode
>>> [    0.002000] Dentry cache hash table entries: 262144 (order: 9, 20971=
52 bytes)
>>> [    0.002356] Inode-cache hash table entries: 131072 (order: 8, 104857=
6 bytes)
>>> [    0.002529] Mount-cache hash table entries: 4096 (order: 3, 32768 by=
tes)
>>> [    0.002532] Mountpoint-cache hash table entries: 4096 (order: 3, 327=
68 bytes)
>>> [    0.002649] Initializing cgroup subsys memory
>>> [    0.002652] Initializing cgroup subsys devices
>>> [    0.002654] Initializing cgroup subsys freezer
>>> [    0.002656] Initializing cgroup subsys net_cls
>>> [    0.002657] Initializing cgroup subsys blkio
>>> [    0.002658] Initializing cgroup subsys perf_event
>>> [    0.002660] Initializing cgroup subsys hugetlb
>>> [    0.002706] mce: CPU supports 10 MCE banks
>>> [    0.002739] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
>>> Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
>>> [    0.002877] Freeing SMP alternatives memory: 28K (ffffffff81cff000 -=
 ffffffff81d06000)
>>> [    0.005420] ftrace: allocating 25457 entries in 100 pages
>>> [    0.011272] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
>>> [    0.011275] smpboot: CPU0: Intel QEMU Virtual CPU version 1.4.2 (fam=
: 06, model: 02, stepping: 03)
>>> [    0.012000] APIC calibration not consistent with PM-Timer: 116ms ins=
tead of 100ms
>>> [    0.012000] APIC delta adjusted to PM-Timer: 6249964 (7250436)
>>> [    0.012000] Performance Events: unsupported p6 CPU model 2 no PMU dr=
iver, software events only.
>>> [    0.012015] NMI watchdog: disabled (cpu0): hardware events not enabl=
ed
>>> [    0.012044] x86: Booting SMP configuration:
>>> [    0.012045] .... node  #0, CPUs:      #1
>>> [    0.012000] kvm-clock: cpu 1, msr 0:7ff58041, secondary cpu clock
>>> [    0.025011] KVM setup async PF for cpu 1
>>> [    0.025016] kvm-stealtime: cpu 1, msr 7fc8e000
>>> [    0.025091]  #2
>>> [    0.025014] kvm-clock: cpu 2, msr 0:7ff58081, secondary cpu clock
>>> [    0.038011] KVM setup async PF for cpu 2
>>> [    0.038016] kvm-stealtime: cpu 2, msr 7fd0e000
>>> [    0.038085]  #3
>>> [    0.038016] kvm-clock: cpu 3, msr 0:7ff580c1, secondary cpu clock
>>> [    0.051032] x86: Booted up 1 node, 4 CPUs
>>> [    0.051036] smpboot: Total of 4 processors activated (25541.96 BogoM=
IPS)
>>> [    0.051016] KVM setup async PF for cpu 3
>>> [    0.051020] kvm-stealtime: cpu 3, msr 7fd8e000
>>> [    0.055004] devtmpfs: initialized
>>> [    0.056661] evm: security.selinux
>>> [    0.056663] evm: security.ima
>>> [    0.056663] evm: security.capability
>>> [    0.057559] atomic64_test: passed for x86-64 platform with CX8 and w=
ith SSE
>>> [    0.057637] NET: Registered protocol family 16
>>> [    0.057746] cpuidle: using governor menu
>>> [    0.058042] ACPI: bus type PCI registered
>>> [    0.058044] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>> [    0.058143] PCI: Using configuration type 1 for base access
>>> [    0.061021] ACPI: Added _OSI(Module Device)
>>> [    0.061023] ACPI: Added _OSI(Processor Device)
>>> [    0.061024] ACPI: Added _OSI(3.0 _SCP Extensions)
>>> [    0.061025] ACPI: Added _OSI(Processor Aggregator Device)
>>> [    0.062323] ACPI: Interpreter enabled
>>> [    0.062326] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te [\_S1_] (20140724/hwxface-580)
>>> [    0.062329] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te [\_S2_] (20140724/hwxface-580)
>>> [    0.062336] ACPI: (supports S0 S3 S4 S5)
>>> [    0.062338] ACPI: Using IOAPIC for interrupt routing
>>> [    0.062348] PCI: Using host bridge windows from ACPI; if necessary, =
use "pci=3Dnocrs" and report a bug
>>> [    0.064186] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>>> [    0.064191] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segment=
s MSI]
>>> [    0.064195] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling A=
SPM
>>> [    0.064272] acpi PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
>>> [    0.064505] acpiphp: Slot [3] registered
>>> [    0.064521] acpiphp: Slot [4] registered
>>> [    0.064536] acpiphp: Slot [5] registered
>>> [    0.064551] acpiphp: Slot [6] registered
>>> [    0.064567] acpiphp: Slot [7] registered
>>> [    0.064583] acpiphp: Slot [8] registered
>>> [    0.064599] acpiphp: Slot [9] registered
>>> [    0.064614] acpiphp: Slot [10] registered
>>> [    0.064628] acpiphp: Slot [11] registered
>>> [    0.064643] acpiphp: Slot [12] registered
>>> [    0.064659] acpiphp: Slot [13] registered
>>> [    0.064675] acpiphp: Slot [14] registered
>>> [    0.064691] acpiphp: Slot [15] registered
>>> [    0.064705] acpiphp: Slot [16] registered
>>> [    0.064720] acpiphp: Slot [17] registered
>>> [    0.064735] acpiphp: Slot [18] registered
>>> [    0.064751] acpiphp: Slot [19] registered
>>> [    0.064766] acpiphp: Slot [20] registered
>>> [    0.064782] acpiphp: Slot [21] registered
>>> [    0.064798] acpiphp: Slot [22] registered
>>> [    0.064812] acpiphp: Slot [23] registered
>>> [    0.064827] acpiphp: Slot [24] registered
>>> [    0.064842] acpiphp: Slot [25] registered
>>> [    0.064857] acpiphp: Slot [26] registered
>>> [    0.064871] acpiphp: Slot [27] registered
>>> [    0.064887] acpiphp: Slot [28] registered
>>> [    0.064902] acpiphp: Slot [29] registered
>>> [    0.064917] acpiphp: Slot [30] registered
>>> [    0.064932] acpiphp: Slot [31] registered
>>> [    0.064940] PCI host bridge to bus 0000:00
>>> [    0.064942] pci_bus 0000:00: root bus resource [bus 00-ff]
>>> [    0.064943] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>>> [    0.064945] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
>>> [    0.064946] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000=
bffff]
>>> [    0.064948] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfeb=
fffff]
>>> [    0.064977] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
>>> [    0.065262] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
>>> [    0.065654] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
>>> [    0.069415] pci 0000:00:01.1: reg 0x20: [io  0xc0e0-0xc0ef]
>>> [    0.071027] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f=
0-0x01f7]
>>> [    0.071029] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f=
6]
>>> [    0.071030] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x017=
0-0x0177]
>>> [    0.071031] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x037=
6]
>>> [    0.071177] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
>>> [    0.075002] pci 0000:00:01.2: reg 0x20: [io  0xc040-0xc05f]
>>> [    0.077042] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
>>> [    0.077311] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by =
PIIX4 ACPI
>>> [    0.077318] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by =
PIIX4 SMB
>>> [    0.077485] pci 0000:00:02.0: [1b36:0100] type 00 class 0x030000
>>> [    0.079007] pci 0000:00:02.0: reg 0x10: [mem 0xf4000000-0xf7ffffff]
>>> [    0.081006] pci 0000:00:02.0: reg 0x14: [mem 0xf8000000-0xfbffffff]
>>> [    0.083005] pci 0000:00:02.0: reg 0x18: [mem 0xfc024000-0xfc025fff]
>>> [    0.085002] pci 0000:00:02.0: reg 0x1c: [io  0xc060-0xc07f]
>>> [    0.091005] pci 0000:00:02.0: reg 0x30: [mem 0xfc000000-0xfc00ffff p=
ref]
>>> [    0.091176] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
>>> [    0.092663] pci 0000:00:03.0: reg 0x10: [io  0xc080-0xc09f]
>>> [    0.094003] pci 0000:00:03.0: reg 0x14: [mem 0xfc026000-0xfc026fff]
>>> [    0.100648] pci 0000:00:03.0: reg 0x30: [mem 0xfc010000-0xfc01ffff p=
ref]
>>> [    0.101025] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
>>> [    0.101733] pci 0000:00:04.0: reg 0x10: [mem 0xfc020000-0xfc023fff]
>>> [    0.106070] pci 0000:00:05.0: [1af4:1003] type 00 class 0x078000
>>> [    0.107003] pci 0000:00:05.0: reg 0x10: [io  0xc0a0-0xc0bf]
>>> [    0.108743] pci 0000:00:05.0: reg 0x14: [mem 0xfc027000-0xfc027fff]
>>> [    0.115257] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
>>> [    0.116644] pci 0000:00:06.0: reg 0x10: [io  0xc000-0xc03f]
>>> [    0.118015] pci 0000:00:06.0: reg 0x14: [mem 0xfc028000-0xfc028fff]
>>> [    0.125150] pci 0000:00:07.0: [1af4:1002] type 00 class 0x00ff00
>>> [    0.125841] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0df]
>>> [    0.130272] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
>>> [    0.130337] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
>>> [    0.130399] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
>>> [    0.130455] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
>>> [    0.130485] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
>>> [    0.130856] ACPI: Enabled 16 GPEs in block 00 to 0F
>>> [    0.131051] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,=
owns=3Dio+mem,locks=3Dnone
>>> [    0.131053] vgaarb: loaded
>>> [    0.131054] vgaarb: bridge control possible 0000:00:02.0
>>> [    0.131113] SCSI subsystem initialized
>>> [    0.131132] ACPI: bus type USB registered
>>> [    0.131145] usbcore: registered new interface driver usbfs
>>> [    0.131151] usbcore: registered new interface driver hub
>>> [    0.131178] usbcore: registered new device driver usb
>>> [    0.131178] PCI: Using ACPI for IRQ routing
>>> [    0.131178] PCI: pci_cache_line_size set to 64 bytes
>>> [    0.131236] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
>>> [    0.131238] e820: reserve RAM buffer [mem 0x7fffe000-0x7fffffff]
>>> [    0.131316] NetLabel: Initializing
>>> [    0.131317] NetLabel:  domain hash size =3D 128
>>> [    0.131317] NetLabel:  protocols =3D UNLABELED CIPSOv4
>>> [    0.131328] NetLabel:  unlabeled traffic allowed by default
>>> [    0.131371] HPET: 3 timers in total, 0 timers will be used for per-c=
pu timer
>>> [    0.131382] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>>> [    0.131385] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
>>> [    0.135064] Switched to clocksource kvm-clock
>>> [    0.140209] pnp: PnP ACPI init
>>> [    0.140272] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
>>> [    0.140303] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (activ=
e)
>>> [    0.140321] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (activ=
e)
>>> [    0.140342] pnp 00:03: [dma 2]
>>> [    0.140352] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (activ=
e)
>>> [    0.140422] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (activ=
e)
>>> [    0.140587] pnp: PnP ACPI: found 5 devices
>>> [    0.151666] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>>> [    0.151669] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>>> [    0.151670] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>>> [    0.151671] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
>>> [    0.151709] NET: Registered protocol family 2
>>> [    0.151823] TCP established hash table entries: 16384 (order: 5, 131=
072 bytes)
>>> [    0.151851] TCP bind hash table entries: 16384 (order: 6, 262144 byt=
es)
>>> [    0.151882] TCP: Hash tables configured (established 16384 bind 1638=
4)
>>> [    0.151895] TCP: reno registered
>>> [    0.151898] UDP hash table entries: 1024 (order: 3, 32768 bytes)
>>> [    0.151905] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
>>> [    0.151938] NET: Registered protocol family 1
>>> [    0.151948] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
>>> [    0.151965] pci 0000:00:01.0: PIIX3: Enabling Passive Release
>>> [    0.151979] pci 0000:00:01.0: Activating ISA DMA hang workarounds
>>> [    0.152214] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
>>> [    0.152666] pci 0000:00:02.0: Boot video device
>>> [    0.152704] PCI: CLS 0 bytes, default 64
>>> [    0.152769] Unpacking initramfs...
>>> [    0.443991] Freeing initrd memory: 25984K (ffff880034d30000 - ffff88=
0036690000)
>>> [    0.444414] microcode: CPU0 sig=3D0x623, pf=3D0x0, revision=3D0x1
>>> [    0.444452] microcode: CPU1 sig=3D0x623, pf=3D0x0, revision=3D0x1
>>> [    0.444490] microcode: CPU2 sig=3D0x623, pf=3D0x0, revision=3D0x1
>>> [    0.444527] microcode: CPU3 sig=3D0x623, pf=3D0x0, revision=3D0x1
>>> [    0.444614] microcode: Microcode Update Driver: v2.00 <tigran@aivazi=
an.fsnet.co.uk>, Peter Oruba
>>> [    0.445044] futex hash table entries: 1024 (order: 4, 65536 bytes)
>>> [    0.445067] Initialise system trusted keyring
>>> [    0.445096] audit: initializing netlink subsys (disabled)
>>> [    0.445120] audit: type=3D2000 audit(1413877341.862:1): initialized
>>> [    0.445707] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>>> [    0.447094] zpool: loaded
>>> [    0.447096] zbud: loaded
>>> [    0.447316] VFS: Disk quotas dquot_6.5.2
>>> [    0.447345] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>>> [    0.447570] msgmni has been set to 3997
>>> [    0.447607] Key type big_key registered
>>> [    0.447610] SELinux:  Registering netfilter hooks
>>> [    0.449183] alg: No test for stdrng (krng)
>>> [    0.449189] NET: Registered protocol family 38
>>> [    0.449195] Key type asymmetric registered
>>> [    0.449197] Asymmetric key parser 'x509' registered
>>> [    0.449235] Block layer SCSI generic (bsg) driver version 0.4 loaded=
 (major 252)
>>> [    0.449296] io scheduler noop registered
>>> [    0.449299] io scheduler deadline registered (default)
>>> [    0.449322] io scheduler cfq registered
>>> [    0.449388] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>>> [    0.449399] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
>>> [    0.449426] intel_idle: does not run on family 6 model 2
>>> [    0.449473] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/=
input/input0
>>> [    0.449476] ACPI: Power Button [PWRF]
>>> [    0.449716] GHES: HEST is not enabled!
>>> [    0.449766] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>> [    0.471023] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1152=
00) is a 16550A
>>> [    0.471309] Non-volatile memory driver v1.3
>>> [    0.471311] Linux agpgart interface v0.103
>>> [    0.471393] rdac: device handler registered
>>> [    0.471472] hp_sw: device handler registered
>>> [    0.471474] emc: device handler registered
>>> [    0.471476] alua: device handler registered
>>> [    0.471499] libphy: Fixed MDIO Bus: probed
>>> [    0.471523] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
>>> [    0.471526] ehci-pci: EHCI PCI platform driver
>>> [    0.471533] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> [    0.471535] ohci-pci: OHCI PCI platform driver
>>> [    0.471541] uhci_hcd: USB Universal Host Controller Interface driver
>>> [    0.472109] uhci_hcd 0000:00:01.2: UHCI Host Controller
>>> [    0.472135] uhci_hcd 0000:00:01.2: new USB bus registered, assigned =
bus number 1
>>> [    0.472149] uhci_hcd 0000:00:01.2: detected 2 ports
>>> [    0.472218] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c040
>>> [    0.472271] usb usb1: New USB device found, idVendor=3D1d6b, idProdu=
ct=3D0001
>>> [    0.472273] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, =
SerialNumber=3D1
>>> [    0.472274] usb usb1: Product: UHCI Host Controller
>>> [    0.472275] usb usb1: Manufacturer: Linux 3.17.0-rc2+ uhci_hcd
>>> [    0.472276] usb usb1: SerialNumber: 0000:00:01.2
>>> [    0.472337] hub 1-0:1.0: USB hub found
>>> [    0.472341] hub 1-0:1.0: 2 ports detected
>>> [    0.472435] usbcore: registered new interface driver usbserial
>>> [    0.472439] usbcore: registered new interface driver usbserial_gener=
ic
>>> [    0.472444] usbserial: USB Serial support registered for generic
>>> [    0.472462] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at=
 0x60,0x64 irq 1,12
>>> [    0.473029] serio: i8042 KBD port at 0x60,0x64 irq 1
>>> [    0.473035] serio: i8042 AUX port at 0x60,0x64 irq 12
>>> [    0.473103] mousedev: PS/2 mouse device common for all mice
>>> [    0.473339] rtc_cmos 00:00: RTC can wake from S4
>>> [    0.473599] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
>>> [    0.473762] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, h=
pet irqs
>>> [    0.473910] hidraw: raw HID events driver (C) Jiri Kosina
>>> [    0.474128] usbcore: registered new interface driver usbhid
>>> [    0.474130] usbhid: USB HID core driver
>>> [    0.474165] drop_monitor: Initializing network drop monitor service
>>> [    0.474268] TCP: cubic registered
>>> [    0.474277] Initializing XFRM netlink socket
>>> [    0.474430] NET: Registered protocol family 10
>>> [    0.475079] NET: Registered protocol family 17
>>> [    0.475799] input: AT Translated Set 2 keyboard as /devices/platform=
/i8042/serio0/input/input1
>>> [    0.475890] Loading compiled-in X.509 certificates
>>> [    0.477235] Loaded X.509 cert 'Magrathea: Glacier signing key: 2fe90=
51af95b7482e9d55ea1ec379806e2f72232'
>>> [    0.477262] registered taskstats version 1
>>> [    0.479676] Key type trusted registered
>>> [    0.482046] Key type encrypted registered
>>> [    0.484077] ima: No TPM chip found, activating TPM-bypass!
>>> [    0.484109] evm: HMAC attrs: 0x1
>>> [    0.484740] rtc_cmos 00:00: setting system clock to 2014-10-21 07:42=
:21 UTC (1413877341)
>>> [    0.485729] Freeing unused kernel memory: 1724K (ffffffff81b50000 - =
ffffffff81cff000)
>>> [    0.489335] systemd[1]: systemd 208 running in system mode. (+PAM +L=
IBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
>>> [    0.489391] systemd[1]: Detected virtualization 'kvm'.
>>> [    0.489396] systemd[1]: Running in initial RAM disk.
>>> [    0.489459] systemd[1]: Set hostname to <localhost.localdomain>.
>>> [    0.503906] random: systemd urandom read with 5 bits of entropy avai=
lable
>>> [    0.533840] systemd[1]: Expecting device dev-disk-by\x2duuid-181da3e=
4\x2d9fad\x2d4bea\x2d8f45\x2d0d7fca5ae2b6.device...
>>> [    0.533861] systemd[1]: Starting -.slice.
>>> [    0.534268] systemd[1]: Created slice -.slice.
>>> [    0.534324] systemd[1]: Starting System Slice.
>>> [    0.534419] systemd[1]: Created slice System Slice.
>>> [    0.534466] systemd[1]: Starting Slices.
>>> [    0.534481] systemd[1]: Reached target Slices.
>>> [    0.534519] systemd[1]: Starting Timers.
>>> [    0.534532] systemd[1]: Reached target Timers.
>>> [    0.534574] systemd[1]: Starting udev Kernel Socket.
>>> [    0.534605] systemd[1]: Listening on udev Kernel Socket.
>>> [    0.534649] systemd[1]: Starting udev Control Socket.
>>> [    0.534687] systemd[1]: Listening on udev Control Socket.
>>> [    0.534730] systemd[1]: Starting Journal Socket.
>>> [    0.534785] systemd[1]: Listening on Journal Socket.
>>> [    0.535550] systemd[1]: Starting dracut cmdline hook...
>>> [    0.536124] systemd[1]: Starting Create list of required static devi=
ce nodes for the current kernel...
>>> [    0.536700] systemd[1]: Started Load Kernel Modules.
>>> [    0.536721] systemd[1]: Starting Sockets.
>>> [    0.536735] systemd[1]: Reached target Sockets.
>>> [    0.536786] systemd[1]: Starting Setup Virtual Console...
>>> [    0.537189] systemd[1]: Starting Journal Service...
>>> [    0.537601] systemd[1]: Started Journal Service.
>>> [    0.543609] systemd-journald[108]: Vacuuming done, freed 0 bytes
>>> [    0.654429] systemd-udevd[213]: starting version 208
>>> [    0.683839] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
>>> [    0.690338] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
>>> [    0.690471] libata version 3.00 loaded.
>>> [    0.691758] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
>>> [    0.707546] ata_piix 0000:00:01.1: version 2.13
>>> [    0.709232] virtio-pci 0000:00:06.0: irq 24 for MSI/MSI-X
>>> [    0.709248] virtio-pci 0000:00:06.0: irq 25 for MSI/MSI-X
>>> [    0.709255] virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
>>> [    0.709276] virtio-pci 0000:00:03.0: irq 27 for MSI/MSI-X
>>> [    0.709290] virtio-pci 0000:00:03.0: irq 28 for MSI/MSI-X
>>> [    0.709522] scsi host0: ata_piix
>>> [    0.709640] scsi host1: ata_piix
>>> [    0.709675] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0e0 i=
rq 14
>>> [    0.709676] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0e8 i=
rq 15
>>> [    0.743717] [drm] Initialized drm 1.1.0 20060810
>>> [    0.743895] FDC 0 is a S82078B
>>> [    0.792255] [drm] Device Version 0.0
>>> [    0.792257] [drm] Compression level 0 log level 0
>>> [    0.792258] [drm] Currently using mode #0, list at 0x488
>>> [    0.792259] [drm] 12286 io pages at offset 0x1000000
>>> [    0.792260] [drm] 16777216 byte draw area at offset 0x0
>>> [    0.792260] [drm] RAM header offset: 0x3ffe000
>>> [    0.792261] [drm] rom modes offset 0x488 for 118 modes
>>> [    0.792569] [TTM] Zone  kernel: Available graphics memory: 1024130 k=
iB
>>> [    0.792571] [TTM] Initializing pool allocator
>>> [    0.792575] [TTM] Initializing DMA pool allocator
>>> [    0.792581] [drm] qxl: 16M of VRAM memory size
>>> [    0.792581] [drm] qxl: 63M of IO pages memory ready (VRAM domain)
>>> [    0.792582] [drm] qxl: 64M of Surface memory size
>>> [    0.794057] usb 1-1: new full-speed USB device number 2 using uhci_h=
cd
>>> [    0.795164] [drm] main mem slot 1 [f4000000,3ffe000]
>>> [    0.795166] [drm] surface mem slot 2 [f8000000,4000000]
>>> [    0.796755] [drm] fb mappable at 0xF4000000, size 3145728
>>> [    0.796759] [drm] fb: depth 24, pitch 4096, width 1024, height 768
>>> [    0.796851] fbcon: qxldrmfb (fb0) is primary device
>>> [    0.800086]  vda: vda1
>>> [    0.807924] Console: switching to colour frame buffer device 128x48
>>> [    0.809915] qxl 0000:00:02.0: fb0: qxldrmfb frame buffer device
>>> [    0.809916] qxl 0000:00:02.0: registered panic notifier
>>> [    0.817301] [drm] Initialized qxl 0.1.0 20120117 for 0000:00:02.0 on=
 minor 0
>>> [    0.893432] ata2.01: NODEV after polling detection
>>> [    0.893695] ata2.00: ATAPI: QEMU DVD-ROM, 1.4.2, max UDMA/100
>>> [    0.894291] ata2.00: configured for MWDMA2
>>> [    0.895457] ata1.01: NODEV after polling detection
>>> [    0.895828] ata1.00: ATA-7: QEMU HARDDISK, 1.4.2, max UDMA/100
>>> [    0.895832] ata1.00: 83886080 sectors, multi 16: LBA48=20
>>> [    0.896380] ata1.00: configured for MWDMA2
>>> [    0.896478] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK  =
  2    PQ: 0 ANSI: 5
>>> [    0.896983] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM   =
  1.4. PQ: 0 ANSI: 5
>>> [    0.916776] sd 0:0:0:0: [sda] 83886080 512-byte logical blocks: (42.=
9 GB/40.0 GiB)
>>> [    0.916801] sd 0:0:0:0: [sda] Write Protect is off
>>> [    0.916803] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> [    0.916813] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
>>> [    0.917922]  sda: sda1 sda2 sda3
>>> [    0.918117] sd 0:0:0:0: [sda] Attached SCSI disk
>>> [    0.927868] sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 =
tray
>>> [    0.927871] cdrom: Uniform CD-ROM driver Revision: 3.20
>>> [    0.928004] sr 1:0:0:0: Attached scsi CD-ROM sr0
>>> [    0.942668] usb 1-1: New USB device found, idVendor=3D0627, idProduc=
t=3D0001
>>> [    0.942673] usb 1-1: New USB device strings: Mfr=3D1, Product=3D3, S=
erialNumber=3D5
>>> [    0.942676] usb 1-1: Product: QEMU USB Tablet
>>> [    0.942679] usb 1-1: Manufacturer: QEMU
>>> [    0.942681] usb 1-1: SerialNumber: 42
>>> [    0.951947] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:=
00:01.2/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
>>> [    0.952225] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID =
v0.01 Pointer [QEMU QEMU USB Tablet] on usb-0000:00:01.2-1/input0
>>> [    1.324142] input: ImExPS/2 Generic Explorer Mouse as /devices/platf=
orm/i8042/serio1/input/input3
>>> [    1.447051] tsc: Refined TSC clocksource calibration: 3192.751 MHz
>>> [    2.344620] random: nonblocking pool is initialized
>>> [    6.156783] EXT4-fs (vda1): mounted filesystem with ordered data mod=
e. Opts: (null)
>>> [    6.455997] systemd-journald[108]: Received SIGTERM
>>> [    7.125358] audit: type=3D1404 audit(1413877348.140:2): enforcing=3D=
1 old_enforcing=3D0 auid=3D4294967295 ses=3D4294967295
>>> [    7.227565] SELinux: 2048 avtab hash slots, 106409 rules.
>>> [    7.239107] SELinux: 2048 avtab hash slots, 106409 rules.
>>> [    7.259541] SELinux:  8 users, 86 roles, 4801 types, 280 bools, 1 se=
ns, 1024 cats
>>> [    7.259544] SELinux:  83 classes, 106409 rules
>>> [    7.263004] SELinux:  Permission audit_read in class capability2 not=
 defined in policy.
>>> [    7.263014] SELinux: the above unknown classes and permissions will =
be allowed
>>> [    7.263017] SELinux:  Completing initialization.
>>> [    7.263018] SELinux:  Setting up existing superblocks.
>>> [    7.263022] SELinux: initialized (dev rootfs, type rootfs), uses gen=
fs_contexts
>>> [    7.263030] SELinux: initialized (dev bdev, type bdev), uses genfs_c=
ontexts
>>> [    7.263033] SELinux: initialized (dev proc, type proc), uses genfs_c=
ontexts
>>> [    7.263055] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
>>> [    7.263106] SELinux: initialized (dev devtmpfs, type devtmpfs), uses=
 transition SIDs
>>> [    7.263552] SELinux: initialized (dev sockfs, type sockfs), uses tas=
k SIDs
>>> [    7.263555] SELinux: initialized (dev debugfs, type debugfs), uses g=
enfs_contexts
>>> [    7.264107] SELinux: initialized (dev pipefs, type pipefs), uses tas=
k SIDs
>>> [    7.264110] SELinux: initialized (dev anon_inodefs, type anon_inodef=
s), uses genfs_contexts
>>> [    7.264111] SELinux: initialized (dev aio, type aio), not configured=
 for labeling
>>> [    7.264113] SELinux: initialized (dev devpts, type devpts), uses tra=
nsition SIDs
>>> [    7.264124] SELinux: initialized (dev hugetlbfs, type hugetlbfs), us=
es transition SIDs
>>> [    7.264128] SELinux: initialized (dev mqueue, type mqueue), uses tra=
nsition SIDs
>>> [    7.264132] SELinux: initialized (dev selinuxfs, type selinuxfs), us=
es genfs_contexts
>>> [    7.264139] SELinux: initialized (dev securityfs, type securityfs), =
uses genfs_contexts
>>> [    7.264142] SELinux: initialized (dev sysfs, type sysfs), uses genfs=
_contexts
>>> [    7.264286] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
>>> [    7.264290] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
>>> [    7.264348] SELinux: initialized (dev tmpfs, type tmpfs), uses trans=
ition SIDs
>>> [    7.264368] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264371] SELinux: initialized (dev pstore, type pstore), uses gen=
fs_contexts
>>> [    7.264373] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264374] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264376] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264380] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264382] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264383] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264385] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264389] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264391] SELinux: initialized (dev cgroup, type cgroup), uses gen=
fs_contexts
>>> [    7.264393] SELinux: initialized (dev configfs, type configfs), uses=
 genfs_contexts
>>> [    7.264394] SELinux: initialized (dev drm, type drm), not configured=
 for labeling
>>> [    7.264400] SELinux: initialized (dev vda1, type ext4), uses xattr
>>> [    7.268037] audit: type=3D1403 audit(1413877348.283:3): policy loade=
d auid=3D4294967295 ses=3D4294967295
>>> [    7.271168] systemd[1]: Successfully loaded SELinux policy in 180.91=
4ms.
>>> [    7.388068] systemd[1]: Relabelled /dev and /run in 13.488ms.
>>> [    7.569808] systemd-fstab-generator[336]: Failed to create mount uni=
t file /run/systemd/generator/-.mount, as it already exists. Duplicate entr=
y in /etc/fstab?
>>> [    9.794388] SELinux: initialized (dev autofs, type autofs), uses gen=
fs_contexts
>>> [    9.800800] SELinux: initialized (dev hugetlbfs, type hugetlbfs), us=
es transition SIDs
>>> [    9.986207] systemd-journald[376]: Vacuuming done, freed 0 bytes
>>> [   10.425178] systemd-udevd[386]: starting version 208
>>> [   10.875906] EXT4-fs (vda1): re-mounted. Opts: (null)
>>> [   10.876059] EXT4-fs (vda1): re-mounted. Opts: (null)
>>> [   11.326782] RPC: Registered named UNIX socket transport module.
>>> [   11.326786] RPC: Registered udp transport module.
>>> [   11.326787] RPC: Registered tcp transport module.
>>> [   11.326788] RPC: Registered tcp NFSv4.1 backchannel transport module.
>>> [   11.327476] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), =
uses genfs_contexts
>>> [   11.598578] input: PC Speaker as /devices/platform/pcspkr/input/inpu=
t5
>>> [   11.853365] ppdev: user-space parallel port driver
>>> [   11.905215] virtio-pci 0000:00:05.0: irq 29 for MSI/MSI-X
>>> [   11.905243] virtio-pci 0000:00:05.0: irq 30 for MSI/MSI-X
>>> [   12.125787] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb10=
0, revision 0
>>> [   12.145622] device-mapper: uevent: version 1.0.3
>>> [   12.145859] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initiali=
sed: dm-devel@redhat.com
>>> [   12.907774] systemd-journald[376]: Received request to flush runtime=
 journal from PID 1
>>> [   12.909274] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
>>> [   12.909939] SELinux: initialized (dev nfsd, type nfsd), uses genfs_c=
ontexts
>>> [   13.508495] audit: type=3D1305 audit(1413877354.523:4): audit_pid=3D=
464 old=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dsystem_u:system_r:aud=
itd_t:s0 res=3D1
>>> [   14.534154] snd_hda_intel 0000:00:04.0: irq 31 for MSI/MSI-X
>>> [   15.807689] sound hdaudioC0D0: autoconfig: line_outs=3D1 (0x3/0x0/0x=
0/0x0/0x0) type:line
>>> [   15.807693] sound hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/=
0x0)
>>> [   15.807694] sound hdaudioC0D0:    hp_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
>>> [   15.807695] sound hdaudioC0D0:    mono: mono_out=3D0x0
>>> [   15.807696] sound hdaudioC0D0:    inputs:
>>> [   15.807698] sound hdaudioC0D0:      Line=3D0x5
>>> [   16.057312] sd 0:0:0:0: Attached scsi generic sg0 type 0
>>> [   16.057350] sr 1:0:0:0: Attached scsi generic sg1 type 5
>>> [   20.574760] ip_tables: (C) 2000-2006 Netfilter Core Team
>>> [   20.778209] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>>> [   20.987215] ip6_tables: (C) 2000-2006 Netfilter Core Team
>>> [   21.553523] Ebtables v2.0 registered
>>> [   21.944469] Bridge firewalling registered
>>> [   23.491468] cfg80211: Calling CRDA to update world regulatory domain
>>> [   23.517907] cfg80211: World regulatory domain updated:
>>> [   23.517909] cfg80211:  DFS Master region: unset
>>> [   23.517910] cfg80211:   (start_freq - end_freq @ bandwidth), (max_an=
tenna_gain, max_eirp), (dfs_cac_time)
>>> [   23.517912] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/=
A, 2000 mBm), (N/A)
>>> [   23.517914] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/=
A, 2000 mBm), (N/A)
>>> [   23.517915] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/=
A, 2000 mBm), (N/A)
>>> [   23.517916] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/=
A, 2000 mBm), (N/A)
>>> [   23.517917] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/=
A, 2000 mBm), (N/A)
>>> [   23.517918] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz),=
 (N/A, 0 mBm), (N/A)
>>> [   32.318308] snd_hda_intel 0000:00:04.0: Invalid position buffer, usi=
ng LPIB read method instead.
>>> [   32.484087] snd_hda_intel 0000:00:04.0: IRQ timing workaround is act=
ivated for card #0. Suggest a bigger bdl_pos_adj.
>>> [  120.475365] EXT4-fs (sda1): mounted filesystem with ordered data mod=
e. Opts:=20
>>> [  120.475562] SELinux: initialized (dev sda1, type ext4), uses mountpo=
int labeling
>>> [  124.510163] EXT4-fs (sda2): mounted filesystem with ordered data mod=
e. Opts: acl,user_xattr
>>> [  124.510341] SELinux: initialized (dev sda2, type ext4), uses mountpo=
int labeling
>>> [  125.618362] EXT4-fs (sda1): mounted filesystem with ordered data mod=
e. Opts: acl,user_xattr
>>> [  125.618369] SELinux: initialized (dev sda1, type ext4), uses xattr
>>> [  130.084150] EXT4-fs (sda2): mounted filesystem with ordered data mod=
e. Opts: acl,user_xattr
>>> [  130.084233] SELinux: initialized (dev sda2, type ext4), uses mountpo=
int labeling
>>> [  136.050773] dump_buffers ino:12 page:ffffea00000b4a80 idx:2740 fl:1f=
ffff8000087d
>>> [  136.050777] bh:ffff8800783401a0 count:0 state:1023
>>> [  136.087165] dump_buffers ino:12 page:ffffea00000b4a80 idx:2740 fl:1f=
ffff8000087d
>>> [  136.087167] bh:ffff8800783401a0 count:0 state:1023
>>> [  136.140289] dump_buffers ino:12 page:ffffea00000b4a80 idx:2740 fl:1f=
ffff8000087d
>>> [  136.140294] bh:ffff8800783401a0 count:0 state:1023
>>> [  136.177953] dump_buffers ino:12 page:ffffea00000b4a80 idx:2740 fl:1f=
ffff8000087d
>>> [  136.177957] bh:ffff8800783401a0 count:0 state:1023
>>> [  136.214371] dump_buffers ino:12 page:ffffea00000b4a80 idx:2740 fl:1f=
ffff8000087d
>>> [  136.214374] bh:ffff8800783401a0 count:0 state:1023
>>> [  208.162760] EXT4-fs (sda2): mounted filesystem with ordered data mod=
e. Opts: acl,user_xattr
>>> [  208.162768] SELinux: initialized (dev sda2, type ext4), uses xattr
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUtR55AAoJELhyPTmIL6kBCS8IAKL7kET0d53a/MkFig3HpODW
s3mIckPqtH8rj3ICWAnVS1g3fwYns/MrmH6OLSYJxDuArs1/QSdhe5oVpCMpzclJ
VQ5aFPqugyWSjECq4SQtXjj7rtaLyG2iDx+4kX9MhTU8MtlUfh1/Ue6MgvrhiW8s
30vL7w4BQ5pWwqmnZCwJOy9mwUctgM9EsaI16aMXddwxEt2xb/zXMB/hIjtem/do
6HcZ0sNezOqYQuD4/GUNwqmymR44+lebCQcH+YKh3LXbRUQQdR9v2lVbBqu6/4em
NML5GaZsvS8j7V3qsNMwkFzZ051+UO/nAp7DI1Ugd4l3LDYAZGoDnHhbJIJcdiE=
=yzq6
-----END PGP SIGNATURE-----
--=-=-=--
