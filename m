From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 11:05:56 +0100
Message-ID: <CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54829 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab2CBKF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Mar 2012 05:05:59 -0500
In-Reply-To: <20120301143859.GX5054@shiny>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/3/1 Chris Mason <chris.mason@oracle.com>:
> On Wed, Feb 29, 2012 at 11:44:31PM -0500, Theodore Tso wrote:
>> You might try sorting the entries returned by readdir by inode numbe=
r before you stat them. =A0 =A0This is a long-standing weakness in ext3=
/ext4, and it has to do with how we added hashed tree indexes to direct=
ories in (a) a backwards compatible way, that (b) was POSIX compliant w=
ith respect to adding and removing directory entries concurrently with =
reading all of the directory entries using readdir.
>>
>> You might try compiling spd_readdir from the e2fsprogs source tree (=
in the contrib directory):
>>
>> http://git.kernel.org/?p=3Dfs/ext2/e2fsprogs.git;a=3Dblob;f=3Dcontri=
b/spd_readdir.c;h=3Df89832cd7146a6f5313162255f057c5a754a4b84;hb=3Dd9a5d=
37535794842358e1cfe4faa4a89804ed209
>>
>> =85 and then using that as a LD_PRELOAD, and see how that changes th=
ings.
>>
>> The short version is that we can't easily do this in the kernel sinc=
e it's a problem that primarily shows up with very big directories, and=
 using non-swappable kernel memory to store all of the directory entrie=
s and then sort them so they can be returned in inode number just isn't=
 practical. =A0 It is something which can be easily done in userspace, =
though, and a number of programs (including mutt for its Maildir suppor=
t) does do, and it helps greatly for workloads where you are calling re=
addir() followed by something that needs to access the inode (i.e., sta=
t, unlink, etc.)
>>
>
> For reading the files, the acp program I sent him tries to do somethi=
ng
> similar. =A0I had forgotten about spd_readdir though, we should consi=
der
> hacking that into cp and tar.
>
> One interesting note is the page cache used to help here. =A0Picture =
two
> tests:
>
> A) time tar cf /dev/zero /home
>
> and
>
> cp -a /home /new_dir_in_new_fs
> unmount / flush caches
> B) time tar cf /dev/zero /new_dir_in_new_fs
>
> On ext, The time for B used to be much faster than the time for A
> because the files would get written back to disk in roughly htree ord=
er.
> Based on Jacek's data, that isn't true anymore.

I've took both on tests. The subject is acp and spd_readdir used with
tar, all on ext4:
1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_rea=
dir.png
3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.png

The acp looks much better than spd_readdir but directory copy with
spd_readdir decreased to 52m 39sec (30 min less).

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
