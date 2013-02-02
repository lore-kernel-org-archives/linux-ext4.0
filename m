From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] Optimizing readdir()
Date: Sat, 2 Feb 2013 12:45:36 -0700
Message-ID: <5C77B553-74D5-4C30-861E-B667CA8C68A6@dilger.ca>
References: <20130113152204.GB26803@laptop.redhat.com> <20130114045152.GF29329@thunk.org> <20130115072143.GA21506@laptop.redhat.com> <B52E6F5A-F266-433C-AE80-2E78FD6920B9@dilger.ca> <20130129163846.GA17169@laptop.brq.redhat.com> <alpine.LFD.2.00.1301301227410.28271@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Radek Pazdera <rpazdera@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:42589 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab3BBTpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2013 14:45:38 -0500
Received: by mail-da0-f49.google.com with SMTP id v40so2154395dad.36
        for <linux-ext4@vger.kernel.org>; Sat, 02 Feb 2013 11:45:38 -0800 (PST)
In-Reply-To: <alpine.LFD.2.00.1301301227410.28271@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-01-30, at 4:34 AM, Luk=E1=9A Czerner wrote:
> On Tue, 29 Jan 2013, Radek Pazdera wrote:
>> Radek Pazdera <rpazdera@redhat.com> wrote:
>> On Tue, Jan 15, 2013 at 03:44:57PM -0700, Andreas Dilger wrote:
>>> Having an upper limit on the directory cache is OK too.  Read all
>>> of the entries that fit into the cache size, sort them, and return
>>> them to the caller.  When the caller has processed all of those
>>> entries, read another batch, sort it, return this list, repeat.
>>>=20
>>> As long as the list is piecewise ordered, I suspect it would gain
>>> most of the benefit of linear ordering (sequential inode table
>>> reads, avoiding repeated lookups of blocks).  Maybe worthwhile if
>>> you could test this out?
>>=20
>> I did the tests last week. I modified the spd_readdir preload to
>> read at most $SPD_READDIR_CACHE_LIMIT entries, sort them and repeat.
>> The patch is here:
>>=20
>>    http://www.stud.fit.vutbr.cz/~xpazde00/soubory/dir-index-test-ext=
4/
>>=20
>> I tested it with the limit set to 0 (i.e., no limit), 1000, 10000,
>> 50000, and completely without the preload. The test runs were
>> performed on the same directory, so the results shouldn't be
>> affected by positioning on disk.
>>=20
>> Directory sizes went from 10k to 1.5M. The tests were run twice.
>> The first run is only with metadata. In the second run, each file
>> has 4096B of data.
>>=20
>> The times seem to decrease accordingly as the limit of the cache
>> increases. The differences are bigger in case of 4096B files, where
>> the data blocks start to evict the inode tables. However, copying is
>> still more than two times slower for 1.5M files when 50000 entries
>> are cached.

Still, caching 50k entries is twice as fast as caching none for
the 1.5M directory entries.  How much memory is that in total?
 Maybe 2.5MB, which isn't too bad at all for any kind of modern
system,=20

>> It might be interesting to test what happens when the size of the
>> files in the directory increases.

Hopefully ext4 will move the large files into a different group.

> those are interesting results and it supports the idea that you can
> get most of the performance of completely sorted inode list by doing
> it in "batches" as long as the size of the batch is sufficiently
> large. However I do not think that using spd_readdir is the best
> approach for the problem, nor do I think that it should be part of
> the generic library. Aside from it's "hackish" nature and the fact
> you will never be able to tell how much memory you can actually use
> for the sorting, the fact is that other file systems can handle this
> problem well enough in comparison with ext4 and we should really
> focus on fixing it, rather than going around it.

I would argue that even if some on-disk optimization is found, it
will not help the majority of users that do not have their files
laid out with the new format.  Also, the spd-readdir can help all
filesystems, not just ext4.  It will help ext2, ext3, ext4, isofs,
etc.  It could statfs() and detect the filesystem type, and skip
XFS and Btrfs if this proves to not help for them...

I'm not against fixing this in the filesystem as well, but I think
it will be several years before the majority of users see it in a
kernel they are using.

Cheers, Andreas--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
