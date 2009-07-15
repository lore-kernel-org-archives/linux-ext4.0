From: Alexey Fisher <bug-track-M18mAb7Tlt0yCq4wW13eYl6hYfS7NtTn@public.gmane.org>
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
 all .data.* sections on X86_64)
Date: Wed, 15 Jul 2009 10:54:17 +0200
Message-ID: <4A5D9939.3000500@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net> <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com> <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com> <4A5C5A59.5080304@fisher-privat.net> <1247567499.28240.48.camel@pc1117.cambridge.arm.com> <4A5C5FD0.3020204@fisher-privat.net> <1247574390.28240.67.camel@pc1117.cambridge.arm.com> <20090715080336.GA4823@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>,
	Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>,
	Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090715080336.GA4823@skywalker>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

This patch work for me.

Aneesh Kumar K.V schrieb:
> On Tue, Jul 14, 2009 at 01:26:30PM +0100, Catalin Marinas wrote:
>> (I cc'ed linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org as well)
>>
>> On Tue, 2009-07-14 at 12:37 +0200, Alexey Fisher wrote:
>>> this is complete trace from debug/kmemleak .
>> [...]
>>> i will compile now latest linux-arm.org/linux-2.6.git
>>> unreferenced object 0xffff880132c48890 (size 1024):
>>>    comm "exe", pid 1612, jiffies 4294894130
>>>    backtrace:
>>>      [<ffffffff810fbaca>] create_object+0x13a/0x2c0
>>>      [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
>>>      [<ffffffff810f596b>] __kmalloc+0x11b/0x210
>>>      [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
>>>      [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
>>>      [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
>>>      [<ffffffff81195413>] ext4_get_sb+0x13/0x20
>>>      [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
>>>      [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
>>>      [<ffffffff81118ee7>] do_mount+0x307/0x8b0
>>>      [<ffffffff8111951f>] sys_mount+0x8f/0xe0
>>>      [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>>>      [<ffffffffffffffff>] 0xffffffffffffffff
>> After some investigation, this looks to me like a real leak.
>>
>> I managed to reproduce something similar (though the size may differ, I
>> think depending on filesystem size - only tried with a 64MB loop
>> device):
>>
>> unreferenced object 0xde468300 (size 32):
>>   comm "mount", pid 1445, jiffies 4294950074
>>   backtrace:
>>     [<c006d473>] __save_stack_trace+0x17/0x1c
>>     [<c006d545>] create_object+0xcd/0x188
>>     [<c01efe43>] kmemleak_alloc+0x1b/0x3c
>>     [<c006c013>] __kmalloc+0xd7/0xe4
>>     [<c00c1029>] ext4_mb_init+0x14d/0x374
>>     [<c00b7d7d>] ext4_fill_super+0x1385/0x16b4
>>     [<c0070891>] get_sb_bdev+0xa9/0xe4
>>     [<c00b574b>] ext4_get_sb+0xf/0x14
>>     [<c006fd3f>] vfs_kern_mount+0x33/0x64
>>     [<c006fda5>] do_kern_mount+0x25/0x8c
>>     [<c007e11f>] do_mount+0x47f/0x4c4
>>     [<c007e1b5>] sys_mount+0x51/0x80
>>     [<c0027c01>] ret_fast_syscall+0x1/0x40
>>     [<ffffffff>] 0xffffffff
>>
>> The above block is the meta_group_info allocated in
>> ext4_mb_init_backend() and stored in sbi->s_group_info[i] (i = 0 in my
>> case). Adding printk's and and inspecting the memory at
>> sbi->s_group_info[] shows different value stored, not the pointer
>> reported as leak.
>>
>> About the new pointer at sbi->s_group_info[0], kmemleak has this
>> information (via the dump= option in my branch; it isn't a leak report):
>>
>> kmemleak: Object 0xdfebfa80 (size 128):
>> kmemleak:   comm "mount", pid 1445, jiffies 4294950075
>> kmemleak:   min_count = 1
>> kmemleak:   count = 1
>> kmemleak:   flags = 0x1
>> kmemleak:   backtrace:
>>      [<c006d473>] __save_stack_trace+0x17/0x1c
>>      [<c006d545>] create_object+0xcd/0x188
>>      [<c01efe43>] kmemleak_alloc+0x1b/0x3c
>>      [<c006c013>] __kmalloc+0xd7/0xe4
>>      [<c00c0df1>] ext4_mb_add_groupinfo+0x29/0x114
>>      [<c00c107f>] ext4_mb_init+0x1a3/0x374
>>      [<c00b7d7d>] ext4_fill_super+0x1385/0x16b4
>>      [<c0070891>] get_sb_bdev+0xa9/0xe4
>>      [<c00b574b>] ext4_get_sb+0xf/0x14
>>      [<c006fd3f>] vfs_kern_mount+0x33/0x64
>>      [<c006fda5>] do_kern_mount+0x25/0x8c
>>      [<c007e11f>] do_mount+0x47f/0x4c4
>>      [<c007e1b5>] sys_mount+0x51/0x80
>>      [<c0027c01>] ret_fast_syscall+0x1/0x40
>>      [<ffffffff>] 0xffffffff
>>
>> So, ext4_mb_add_groupinfo() is overriding the pointers stored in
>> sbi->s_group_info[] by the ext4_mb_init_backend() function without
>> freeing them first.
>>
>> Maybe the ext4 people could clarify what is happening here as I'm not
>> familiar with the code.
>>
> 
> Can you try this patch ?
> 
> commit 4cc505d4c16c86f8f590ce4b288c920572bf2be9
> Author: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Date:   Wed Jul 15 13:20:37 2009 +0530
> 
>     ext4: Memory leak fix ext4_group_info allocation.
>     
>     commit 5f21b0e642d7bf6fe4434c9ba12bc9cb96b17cf7  was done to
>     reallocate groupinfo struct during resize properly. That goal
>     was to allocate new groupinfo struct when we are adding new block
>     groups during resize. Calling ext4_mb_add_group_info in the
>     mballoc initialization code path resulted in we reallocating
>     the group info struct . Fix this by not separately allocating
>     group info in the mballoc init path and always depend on
>     ext4_mb_add_group_info to allocate group info struct.
>     
>     The earlier code also had a bug that we allocated less number of
>     group info struct for the last meta group. But on resize we
>     expected that we had EXT4_DESC_PER_BLOCK group info struct for
>     each meta group.
>     
>     Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 519a0a6..96ed1d8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2615,22 +2615,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
>  		goto err_freesgi;
>  	}
>  	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
> -
> -	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);
> -	for (i = 0; i < num_meta_group_infos; i++) {
> -		if ((i + 1) == num_meta_group_infos)
> -			metalen = sizeof(*meta_group_info) *
> -				(ngroups -
> -					(i << EXT4_DESC_PER_BLOCK_BITS(sb)));
> -		meta_group_info = kmalloc(metalen, GFP_KERNEL);
> -		if (meta_group_info == NULL) {
> -			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
> -			       "buddy group\n");
> -			goto err_freemeta;
> -		}
> -		sbi->s_group_info[i] = meta_group_info;
> -	}
> -
>  	for (i = 0; i < ngroups; i++) {
>  		desc = ext4_get_group_desc(sb, i, NULL);
>  		if (desc == NULL) {
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
