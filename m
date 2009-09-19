From: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Subject: Re: howto downgrade ext4 to ext3
Date: Sat, 19 Sep 2009 22:29:50 +0200
Message-ID: <4AB53F3E.4040007@it-sudparis.eu>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu> <4AB3F9C4.1010702@it-sudparis.eu> <20090918225834.GC28781@mit.edu>
Reply-To: jehan.procaccia@it-sudparis.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:34034 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZISU3z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Sep 2009 16:29:55 -0400
In-Reply-To: <20090918225834.GC28781@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso a =E9crit :
> On Fri, Sep 18, 2009 at 11:21:08PM +0200, jehan procaccia wrote:
>  =20
>> I would love to test that option (-o nodelalloc) instead of move bac=
k to =20
>> ext3.
>> however I don't understand what it is ... Am I taking risk in term o=
f =20
>> integrity of data if I set it ?, or just losing performances ?
>> anyway, I'am not sure it is available, when I search it in "man moun=
t", =20
>> I can't find it, is it an undocumennted option ?
>>    =20
>
> The mount man page is part of the util-linux package, and so it tends
> to get updated a bit slower than the kernel.  The ext4 mount options
> are fully documented in the kernel documentation; so if you install
> the kernel-doc RPM, and look in the Documentation/filesystems/ext4.tx=
t
> you'll get a comprehensive list of ext4 mount options.  (Well, as
> comprehensive as we can make it; occasionally we forget to update it,
> but in general we've been pretty good at documenting everything.)
>
> (Checking....)
>
> Ugh, the description for nodelalloc in ext4.txt is pretty horrible;
> it doesn't even parse as a valid English sentence.  I don't know how
> that slipped by me (Mingming, Eric; can either of you see if your
> respective companies can snag us a tech writer resource for a day or
> two?), but I'll get that one fixed up.
>  =20
indeed, there's not a lot, and not very well understandable :
$ less /usr/share/doc/kernel-doc-2.6.18/Documentation/filesystems/ext4.=
txt
delalloc        (*)     Deferring block allocation until write-out time=
=2E
nodelalloc              Disable delayed allocation. Blocks are allocati=
on
                        when data is copied from user to page cache.
> Anyway, delayed allocation is a feature of ext4 which allow us to
> delay allocating blocks until the very last minute --- when the VM
> page writeback routine decides it times to write dirty pages to disk
> (aka "cleaning pages", or "when the page cleaner runs" --- yeah, OS
> programmers sometimes like to perpetuate some really horrible puns),
> or when a program explicitly forces a file to be written to disk via
> the fsync() system call.  This allows the block allocator to make mor=
e
> intelligent decisions, which tends to avoid disk fragmentation and
> tends to increase performance.  Delayed allocation is one of the
> reasons why simply mounting an uncoverted ext2 or ext3 filesystem
> using the ext4 file system driver can result in better performance.
>
>  =20
OK, understood ...
> The problem is that in older kernel programs, we didn't properly
> account for quota.  Since we don't attempt to allocate files until
> when the page cleaner runs, which could potentially be well after the
> program which wrote the program has exited, the out-of-quota error
> only gets noticed when the delayed allocation writepages function is
> trying to clean up dirty pages.  This is a "should never happen
> situation", and to avoid causing the VM to loop forever to write page=
s
> where the write operation would never succeed, the writepages program
> prints an extremely scary message and --- and then throws away the
> user's data.
>  =20
That chapter becomes a bit obscure to me ... If I well understood, you=20
described the situation I ran into ?
> By using the nodelalloc mount option, ext4 will try to allocate block=
s
> while processing each and every write(2) system call.  This allows
> quota to be checked right away, and if the user is over quota, the
> write system call will return an error right away.  This is less
> efficient in terms of CPU usage, and the block allocater will not be
> able to do as good of a job, since it doesn't know how big the file
> will ultimately be when it is doing block-by-block allocation.
> However, it avoids the nasty bug that happens when the user has a
> over-quota situation in the delalloc writepage function --- and it's
> no worse than what ext3 does.
>  =20
Ok, that's where I should go now by mounting with nodelalloc, lower=20
performances, but no more "should never happen situation" ;-) .
> In more modern kernels, we've added quota checking in the write(2)
> system call such that if we're not allocating the blocks right away,
> so we don't know where the block will be located on disk, we charge
> the block against user's quota right away, so the write(2) system cal=
l
> can signal the over quota situation to the user program.
> Unfortunately, these patches aren't present in the version of ext4
> that was backported to RHEL 5.4.
>
>  =20
 From which kernel version you " 've added quota checking in the=20
write(2) system call" ?,
the problem should not arise anymore with recent kernel, and still usin=
g=20
delalloc ? 2.6.30 should be OK ?
for RHEL, there's fedora project that has more recent kernel packages i=
n=20
source RPMS:
kernel-2.6.29.4-167.fc11.src.rpm or kernel-2.6.31-33.fc12.src.rpm
probably recompiling these for rhel 5.4 could be a workaround instead o=
f=20
using nodelalloc ?
>> but now, how can I check that there's no more pb on that specific =20
>> partition( /disk00)?
>> when kernel complains this way for example:
>> Sep 16 18:06:45 gizeh kernel: mpage_da_map_blocks block allocation =20
>> failed for inode 39419 at logical offset 0 with max blocks 2 with er=
ror =20
>> -122
>> Sep 16 18:06:45 gizeh kernel: This should not happen.!! Data will be=
 lost
>> I've no indication from which partition that inode is. there's so ma=
ny =20
>> error message like this that is won't be easy to tell that none  com=
es =20
>> from /disk00 .
>>    =20
>
> Well, error code 122 is EDQUOT, or "Quota exceeded".  So it's very
> likely that this some other partition.  This is a bug; we really
> should print the disk that was involved, and not just inode number.
> I'll fix that in future kernels (but of course that won't help you fo=
r
> RHEL 5.4).  What you can do to prove this is to check a quota report,
> and see which users are over quota.  You can then check all of your
> ext4 partitions to see which has an inode 39419 which is owned by one
> of your over-quota users, using debugfs:
>
>    debugfs -c -R "stat <39419>" /dev/sdXXX
>
>  =20
good, indeed, I only get -122 errors, and thanks to the search example =
I=20
noticed that those error do happened only for apparently over-quota=20
users, here's an example:

gizeh kernel: mpage_da_map_blocks block allocation failed for inode=20
3542694 at logical offset 0 with max blocks 1 with error -122
Message from syslogd@ at Sat Sep 19 21:08:03 2009 ...

[root@gizeh ~]
$ debuge4fs -c -R "stat <3542694>" /dev/mapper/VolGroup02S2IA-LVVG02Use=
rs07
debuge4fs 1.41.5 (23-Apr-2009)
/dev/mapper/VolGroup02S2IA-LVVG02Users07: catastrophic mode - not=20
reading inode or group bitmaps
Inode: 3542694   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 2336084861    Version: 0x00000000:00000001
User: 42658   Group:   426   Size: 0
=46ile ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 0
=46ragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4ab52c13:81a9f0d4 -- Sat Sep 19 21:08:03 2009
 atime: 0x4ab52c13:816ce76c -- Sat Sep 19 21:08:03 2009
 mtime: 0x4ab52c13:816ce76c -- Sat Sep 19 21:08:03 2009
crtime: 0x4ab52c13:812fde04 -- Sat Sep 19 21:08:03 2009
Size of extra inode fields: 28
BLOCKS:

[root@gizeh ~]
$ getent passwd |grep 42658
karipha:x:42658:426:Karipha BOUMER:/mci/mast2008/karipha:/usr/local/bin=
/bash
[root@gizeh ~]
$ quota -s karipha
Disk quotas for user karipha (uid 42658):
     Filesystem  blocks   quota   limit   grace   files   quota  =20
limit   grace
/dev/mapper/VolGroup02S2IA-LVVG02Users07
                   603M*   489M    538M   39:07    6622   50000   55000

$ find /disk07 -inum 3542694
/disk07/mast2008/karipha/.recently-used.xbel

Other inodes incriminated showed the same result -> over-quota . So if=20
user data finally cannot be written, after all ... quota wouldn't allow=
=20
it anyway .

> Hope this helps you understand what's going on.
> 							- Ted
>  =20
Yes, thanks for that detailed answer.
regards , jehan .
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
