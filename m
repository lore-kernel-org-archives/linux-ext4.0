From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bigalloc and max file size
Date: Sun, 30 Oct 2011 15:49:55 -0400
Message-ID: <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu>
References: <51BECC2B-2EBC-4FCB-B708-8431F7CB6E0D@dilger.ca> <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: i@coly.li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:63501 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348Ab1JaA4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 Oct 2011 20:56:09 -0400
In-Reply-To: <4EACE2B7.9070402@coly.li>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Oct 30, 2011, at 1:37 AM, Coly Li wrote:

> Forgive me if this is out of topic.
> In our test, allocating directories W/ bigalloc and W/O inline-data m=
ay occupy most of disk space. By now Ext4
> inline-data is not merged yet, I just wondering how Google uses bigal=
loc without inline-data patch set ?

It depends on how many directories you have (i.e, how deep your directo=
ry structure is) and how many small files you have in the file system a=
s to whether bigalloc w/o inline-data has an acceptable overhead or not=
=2E

As I've noted before, for at least the last 7-8 years, and probably a d=
ecade, average seek times for 7200rpm drives have remained constant at =
10ms, even as disk capacities have grown from 200GB in 2004, to 3TB in =
2011.   Yes, you can spin the platters faster, but the energy requireme=
nts go up with the square of the revolutions per minute, while the seek=
 times only go up linearly; and so platter speeds don't get any faster =
than 15000rpm due to diminishing returns, and in fact some "green" driv=
es only go at 5400rpm or even slower (interestingly enough, they tend n=
ot to advertise either the platter speed or the average seek time; funn=
y, that=85.)

At 10ms per seek, that means that if the HDD isn't doing _anything_ els=
e, it can do at most 100 seeks per second.   Hence, if you have a workl=
oad where latency is at a premium, as disk capacities grow, disks are e=
ffectively getting slower for  given data set size.  For example, in 20=
04, if you wanted to serve 5TB of data, you'd need 25 200GB disks, so y=
ou had at your disposal 2500 random read/write operations per second at=
 your disposal.  In 2011, with 3TB disks, you'd have an order of magnit=
ude fewer random writes when you only need to use 2 HDD's.   (Yes, you =
could use flash, or flash-backed cache, but if the working set is reall=
y large this can get very expensive, so it's not a solution suitable fo=
r all situations.)

Another way of putting things is if latency really matters, and you hav=
e a random read/write workload, capacity management can become more abo=
ut seeks than actual number of gigabytes.  Hence, "wasting" space by us=
ing a larger cluster size may be a win if you are doing a large number =
of block allocations/deallocations, and memory pressure keeps on throwi=
ng the block bitmaps out of memory, so you have to keep seeking to read=
 them back into memory.  By using a large cluster size, we reduce fragm=
entation, and we reduce the number of block bitmaps, which makes them m=
ore likely to stay in memory.

=46urthermore, reducing the number of the bitmap blocks makes it more t=
enable to pin them in memory, if there is a desire to guarantee that th=
ey stay in memory.   (Dave Chinner was telling me that XFS manages its =
own metadata block lifespan, with its own shrinkers, instead of leaving=
 when cached metadata gets ejected from memory.  That might be worth do=
ing at some point in ext4, but of course that would add complexity as w=
ell.)

The bottom line is that if you are seek constrained, wasting space by u=
sing a large cluster size may not be a huge concern.   And if nearly al=
l of your files are larger than 1MB, with many significantly larger, in=
-line data isn't going to help you a lot.

On the other hand, it may be that using 128 byte inode is a bigger win =
than using a larger inode size and storing the data in the inode table.=
   Using a small inode size reduces metadata I/O by doubling the number=
 of inodes/block compared to a 256 byte inode, never mind a 1k or 4k in=
ode.   Hence, if you don't need extended attributes or ACL's or sub-sec=
ond timestamp resolution, you might want to consider using 128 byte ino=
des as possibly being a bigger win than in-line data.   All of this req=
uires benchmarking with your specific workload, of course.

I'm not against your patch set, however; I just haven't had time to loo=
k at them, at all (nor the secure delete patch set, etc.) .   Between o=
rganizing the kernel summit, the kernel.org compromise, and some high p=
riority bugs at $WORK, things have just been too busy.  Sorry for that;=
 I'll get to them after the merge window and post-merge bug fixing is u=
nder control.

-- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
