From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: Used block count in df
Date: Mon, 11 Feb 2013 11:53:26 -0600
Message-ID: <51193016.5080909@redhat.com>
References: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com> <5113DB2D.4000305@redhat.com> <CANBXnMmbEBgN5j2UvbYvznO9nUrXkmi4m8_xnqytPi3=zSGOPg@mail.gmail.com> <51192B14.4030301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503Ab3BKRxS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Feb 2013 12:53:18 -0500
In-Reply-To: <51192B14.4030301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/11/13 11:32 AM, Eric Sandeen wrote:
> On 2/11/13 12:36 AM, Adil Mujeeb wrote:
>> Thanks Eric.
>>
>>>> I have an observation on EXT4 filesystem. I created filesystem of size
>>>> 1TB, 4TB, and 7TB and then checked the output of df command.
>>>
>>> Telling us which version of e2fsprogs and which kernel would be helpful,
>>> but:
>>
>> its 1.41.12.
>>
>>> It reserves blocks for the superuser (5% by default) and also uses a lot
>>> of blocks up-front for filesytem metadata - inode tables, block bitmaps,
>>> and the like.
>>
>> I also thinks so. But with this assumption, the number of 1KB blocks
>> used should increase as per filesystem size increase. No?
>>
>>>
>>> But what you are seeing here is this:
>>>
>>> It also defaults to "bsd df" which does not count filesystem
>>> metadata when telling you about the number of blocks used.  So in theory,
>>> a freshly made fs should actually tell you 0 blocks used, I think.
>>
>> Agree if "bsd df" assumes so.
>>
>>> Looking at the dumpe2fs output for the 4t file, I see:
>>>
>>> # dumpe2fs -h 4tfile-ext4 | grep -i block
>>> dumpe2fs 1.41.12 (17-May-2010)
>>> Block count:              1073741824
>>> Reserved block count:     53687091
>>> Free blocks:              1056843748
>>> ...
>>>
>>> and 1073741824-1056843748 is 16898076 4k blocks, or 67592304 1k blocks
>>> actually used.
>>>
>>> If we ask for "minix df" by mounting with -o minixdf which is true blocks used, we get:
>>>
>>> # df 4t-ext4/
>>> Filesystem           1K-blocks      Used Available Use% Mounted on
>>> /mnt/test2/mkfs-test/4tfile-ext4
>>>                      4294967296  67592304 4012626628   2% /mnt/test2/mkfs-test/4t-ext4
>>>
>>> I'd say this appears to be a slight inaccuracy in ext4_statfs, coupled with
>>> the strangeness of the "bsd df" reporting.  It is apparently miscalculating
>>> the filesystem metadata "overhead."
>>
>> In your example, dumpe2fs and minix df both are reporting same value, isn't it?
>>
>> I am still not able to understand why increasing the filesystem size
>> decreases used 1K block count :(
>> Am I missing some basic things here? Sorry if i am not able to catch
>> your point :(
> 
> My only point is, default ext4 statfs behavior is quite complicated, and it
> looks like you have found a bug related to the calculation of metadata overhead.
> 
> It should only be a reporting issue, and should not cause any runtime issues.

For more info, take a look at fs/ext4/super.c:

/*
 * Note: calculating the overhead so we can be compatible with
 * historical BSD practice is quite difficult in the face of
 * clusters/bigalloc.  This is because multiple metadata blocks from
 * different block group can end up in the same allocation cluster.
 * Calculating the exact overhead in the face of clustered allocation
 * requires either O(all block bitmaps) in memory or O(number of block
 * groups**2) in time.  We will still calculate the superblock for
 * older file systems --- and if we come across with a bigalloc file
 * system with zero in s_overhead_clusters the estimate will be close to
 * correct especially for very large cluster sizes --- but for newer
 * file systems, it's better to calculate this figure once at mkfs
 * time, and store it in the superblock.  If the superblock value is
 * present (even for non-bigalloc file systems), we will use it.
 */
static int count_overhead(struct super_block *sb, ext4_group_t grp,
                          char *buf)

<much code ensues>

> Thanks,
> -Eric
>  
>> Regards,
>> Adil
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

