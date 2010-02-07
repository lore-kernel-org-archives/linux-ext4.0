From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.33-rc6: ext4 triggers warning about high order allocations
Date: Sun, 07 Feb 2010 13:00:53 -0600
Message-ID: <4B6F0DE5.7060100@redhat.com>
References: <20100203060854.GA12489@redhat.com> <4B69AB60.5070609@redhat.com> <20100203175836.GA16907@redhat.com> <4B69CCE4.3000904@redhat.com> <20100207123032.GA3220@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab0BGTA7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Feb 2010 14:00:59 -0500
In-Reply-To: <20100207123032.GA3220@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Michael S. Tsirkin wrote:
> On Wed, Feb 03, 2010 at 01:22:12PM -0600, Eric Sandeen wrote:
>> Michael S. Tsirkin wrote:
>>> On Wed, Feb 03, 2010 at 10:59:12AM -0600, Eric Sandeen wrote:
>>>> Michael S. Tsirkin wrote:
>>>>> Hi!
>>>>> I got this warning at boot with 2.6.33-rc6:
>>>>>
>>>>> [   12.374168] ------------[ cut here ]------------
>>>>> [   12.375798] WARNING: at mm/page_alloc.c:1813 __alloc_pages_nodemask+0x180/0x666()
>>>>> [   12.377401] Hardware name: 2241B48
>>>>> [   12.378984] Modules linked in: [last unloaded: scsi_wait_scan]
>>>>> [   12.380593] Pid: 1, comm: init Not tainted 2.6.33-rc6-aa-nopat #50
>>>>> [   12.382194] Call Trace:
>>>>> [   12.383781]  [<ffffffff810b6b3e>] ? __alloc_pages_nodemask+0x180/0x666
>>>>> [   12.385390]  [<ffffffff81041cda>] warn_slowpath_common+0x77/0xa4
>>>>> [   12.386996]  [<ffffffff81041d16>] warn_slowpath_null+0xf/0x11
>>>>> [   12.388577]  [<ffffffff810b6b3e>] __alloc_pages_nodemask+0x180/0x666
>>>>> [   12.390168]  [<ffffffff81036a9b>] ? finish_task_switch+0x4b/0xb1
>>>>> [   12.391758]  [<ffffffff810b7036>] __get_free_pages+0x12/0x4f
>>>>> [   12.393354]  [<ffffffff810de892>] __kmalloc+0x42/0x116
>>>>> [   12.394934]  [<ffffffff812405bf>] match_number+0x35/0x98
>>>>> [   12.396493]  [<ffffffff8124064d>] match_int+0xb/0xd
>>>>> [   12.398045]  [<ffffffff81169c8c>] parse_options+0x5fe/0x733
>>>>> [   12.399594]  [<ffffffff811058c3>] ? __wait_on_buffer+0x1f/0x21
>>>>> [   12.401157]  [<ffffffff8116a2dc>] ext4_fill_super+0x373/0x2070
>>>> Are you mounting with any interesting options?
>>>>
>>>> -Eric
>>> Hmm yes:
>>>
>>> UUID=4670fcf0-09a8-4011-bf25-6e5e97f263c6 /                       ext4
>>> relatime,errors=remount-ro,auto_da_alloc,commit=300,journal_ioprio=7
>>                              ^^^^
>>
>> it's the auto_da_alloc option, which optionally takes a =X argument.
>> I think someone changed match_one() and broke it;
> 
> patch?

http://marc.info/?l=linux-ext4&m=126523161410367&w=2

should fix it.  I'm not sure what started tripping this upstream.

>> auto_da_alloc is
>> the default anyway, so you can just drop this for now.
>>
>> -Eric
> 
> 
> I have removed auto_da_alloc option, but still see a warning at boot:

Any chance you've still got it in an initrd or grub rootfs options, or similar?

if not, perhaps you can narrow it down to which filesystem & which mount
option is triggering this.

Thanks,
-Eric
