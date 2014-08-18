From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock
 in non-movable area
Date: Mon, 18 Aug 2014 10:15:32 +0900
Message-ID: <53F153B4.1060309@lge.com>
References: <53EC4531.1000904@lge.com> <20140814142610.6f0d4194c373fef188870772@linux-foundation.org> <20140816185208.GA1589@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35249 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHRBPg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Aug 2014 21:15:36 -0400
In-Reply-To: <20140816185208.GA1589@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



2014-08-17 =EC=98=A4=EC=A0=84 3:52, Jan Kara =EC=93=B4 =EA=B8=80:
> On Thu 14-08-14 14:26:10, Andrew Morton wrote:
>> On Thu, 14 Aug 2014 14:12:17 +0900 Gioh Kim <gioh.kim@lge.com> wrote=
:
>>
>>> This patch try to solve problem that a long-lasting page caches of
>>> ext4 superblock and journaling of superblock disturb page migration=
=2E
>>>
>>> I've been testing CMA feature on my ARM-based platform
>>> and found that two page caches cannot be migrated.
>>> They are page caches of superblock of ext4 filesystem and its journ=
aling data.
>>>
>>> Current ext4 reads superblock with sb_bread() that allocates page
>>> from movable area. But the problem is that ext4 hold the page until
>>> it is unmounted. If root filesystem is ext4 the page cannot be migr=
ated forever.
>>> And also the journaling data for the superblock cannot be migreated=
=2E
>>>
>>> I introduce a new API for allocating page cache from non-movable ar=
ea.
>>> It is useful for ext4/ext3 and others that want to hold page cache =
for a long time.
>>
>> All seems reasonable to me.  The additional overhead in buffer.c fro=
m
>> additional function arguments is regrettable but I don't see a
>> non-hacky alternative.
>>
>> One vital question which the changelog doesn't really address (it
>> should): how important is this patch?  Is your test system presently
>> "completely dead in the water utterly unusable" or "occasionally not
>> quite as good as it could be".  Somewhere in between?
>    I would be also interested in how much these patches make things b=
etter.
> Because I would expect all metadata that is currently journalled to b=
e
> unmovable as well.
>
> 								Honza
>

I'm so sorry for lacking of detail.

My test platform has totally 1GB memory, 256MB for CMA and 768MB for no=
rmal.
I applied Joonsoo's patch: https://lkml.org/lkml/2014/5/28/64, so that
3/4 of allocation take place in normal area and 1/4 allocation take pla=
ce in CMA area.

And my platform has 4 ext4 partitions. Each ext4 partition has 2 page c=
aches for superblock that
are what this patch tries to move to out of CMA area.
Therefore there are 8 page caches (8 pages size) that can prevent page =
migration.

My test scenario is trying to allocate all CMA area: repeating 16MB all=
ocation until all CMA area are allocated.
In the most cases 2 pages are allocated from CMA area and one allocatio=
n among 16 tries to allocation failed.
It is rare case that every allocation successes.

Applying this patch no page cache is allocation from CMA area and every=
 allocation successes.

Please inform me if you need any information.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
