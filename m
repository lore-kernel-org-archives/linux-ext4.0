From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user specific
 flag
Date: Fri, 05 Sep 2014 09:37:05 +0900
Message-ID: <540905B1.1050200@lge.com>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com> <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jack@suse.cz, tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
	peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
	js1304@gmail.com, gunho.lee@lge.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



2014-09-05 =EC=98=A4=EC=A0=84 7:16, Andrew Morton =EC=93=B4 =EA=B8=80:
> On Thu,  4 Sep 2014 16:29:38 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>> This patch try to solve problem that a long-lasting page caches of
>> ext4 superblock and journaling of superblock disturb page migration.
>>
>> I've been testing CMA feature on my ARM-based platform
>> and found that two page caches cannot be migrated.
>> They are page caches of superblock of ext4 filesystem and its journa=
ling data.
>>
>> Current ext4 reads superblock with sb_bread() that allocates page
>> from movable area. But the problem is that ext4 hold the page until
>> it is unmounted. If root filesystem is ext4 the page cannot be migra=
ted
>> forever.
>> And also the journaling data for the superblock cannot be migreated.
>>
>> I introduce new APIs that allocates page cache with specific flag pa=
ssed by an
>> argument.
>> *_gfp APIs are for user want to set page allocation flag for page ca=
che
>> allocation.
>> And *_unmovable APIs are for the user wants to allocate page cache f=
rom
>> non-movable area.
>>
>> It is useful for ext4/ext3 and others that want to hold page cache f=
or a long
>> time.
>
> Could we please have some detailed information about the real-world
> effect of this patchset?
>
> You earlier said "My test platform is currently selling item in the
> market.  And also I test my patch when my platform is working as if
> real user uses it.".

OK. I'm writing details as possible as I can.
Please feel free to request me more information.

My platform is TV and 1GB system memory and 256MB CMA memory.
I want to use full 256MB CMA memory.

>
> But what were the problems which were observed in standard kernels an=
d
> what effect did this patchset have upon them?  Some quantitative
> measurements will really help here.

The problem is that I cannot allocate entire CMA memory.
Actually the problem is not found without Joonsoo's patch: https://lkml=
=2Eorg/lkml/2014/5/28/64.
Without it CMA memory is free and every CMA-memory allocation is succes=
sed.

If the Joonsoo's patch is applied, the CMA memory is allocated generall=
y when system boots-up.
Therefore superblocks of mounted filesystem and buffer cache of it are =
allocation from CMA memory.

I have three ext4 partitions and one squash partition.
The squash filesystem has no problem. It holds buffer-cache temporarily=
=2E

But each ext4 partition holds 2 buffer-cache until unmounted (one for s=
b and one for journal)
so that I found 2 or 3 pages, the page are storing buffer-cache, are bu=
sy in my platform
when I try to allocate 256MB, entiry CMA memory.
So my allocation fails.

This patchset makes the long-lasting buffer-caches be allocated in non-=
CMA area.
Therefore I can success to allocate the entire CMA memory always.

Please tell me what I have to measure quantitatively?
What I know is every ext4 filesystem has 2 long-lasting buffer-cache
that are released when it is unmounted.

I applied this patch and try to allocate the entire CMA memory almost 1=
00-times.
And I successed always.

>
> I'm trying to get an understanding of how effective and important the
> change is, whether others will see similar benefits.  I'd also like t=
o
> understand how *complete* the fix is - were the problems which you
> observed completely fixed, or do outstanding problems remain?

I think this patch has benefits only for systems that use CMA or HOTPLU=
G feature.
As I mentioned above, the problem is not occured without Joonsoo's patc=
h that allocates CMA area frequently.

If a system want to use CMA/HOTPLUG feature, I think, this patch is ver=
y important.
The problem is only several pages but several MB can be wasted consider=
ing an align of allocation size.
If allocation size align is 16MB and one page is busy, 16MB can be wast=
ed.
=46or embedded system like TV 16MB is really big issue.

I beleive the problem is completely fixed with my patch.
I've tested many times for several days and reviewed ext4 code that dea=
ls with buffer-header.
I couldn't find any other problem.

I'm sorry to confuse you with my poor English.
Please reply me whatever you need.

Next week is Korean thanksgiving holidays.
I think I can reply on Fri.

>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
