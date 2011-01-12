From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH 0/2] Add rbtree backend for storing bitmaps
Date: Wed, 12 Jan 2011 14:44:37 +0200
Message-ID: <AANLkTinh6u9LN3U8EHGbt1U0MRNqZ3zLuaxDxn2=GxaJ@mail.gmail.com>
References: <1294672737-10850-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
	adilger@dilger.ca, kalpak@clogeny.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42034 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1ALMoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Jan 2011 07:44:38 -0500
Received: by qyk12 with SMTP id 12so616852qyk.19
        for <linux-ext4@vger.kernel.org>; Wed, 12 Jan 2011 04:44:37 -0800 (PST)
In-Reply-To: <1294672737-10850-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 10, 2011 at 5:18 PM, Lukas Czerner <lczerner@redhat.com> wr=
ote:
> Hi all,
>
> as I mentioned a while ago I am working on reducing e2fsprogs memory
> utilization. The first thing which need to be addressed is mechanism =
of
> storing bitmaps. So far bitarrays was used for this purpose however t=
oday
> this approach might hit its limits with todays huge data storage devi=
ces,
> because of its memory utilization.
>
> Bitarrays stores bitmaps as ..well, as bitmaps. But this is in most
> cases highly unefficient because we need to allocate memory even for =
the
> big parts of bitmaps we will never use, resulting in high memory
> utilization especially for huge filesystem, when bitmaps might occupy
> gigabytes of space.
>
> To address this I have created rbtree backend for storing bitmaps. It=
 stores
> just used extents of bitmaps, it means, that it can be more memory ef=
ficient
> in most cases and also with careful use it might be much faster as we=
ll.
>
> Rbtree implementation itself is ripped of linux kernel with some mino=
r changes
> to make it work outside kernel. So this should not cause any problems=
 at all
> since it has been really extensively tested through out its life.
>
> I have done a lot of testing to validate my new backend and to find a=
s many
> bugs as possible. Now it seems to be quite reliable, however since th=
is is the
> most crucial part of the e2fsprogs it has to be tested most widely on=
 various
> scenarios. So this is my appeal to you guys, please take it, make it =
and test
> it and test it some more, to really make sure this is doing what it i=
s
> supposed to.
>
> The other side of the thing is, does it really help with memory utili=
zation ?
> So my answer is YES, (...but). Of course there is a "but". That is be=
cause one
> rbtree node on 64-bit system takes 40B of data, which is 320 bits of
> information. So there might be a situation when one single rbtree nod=
e does
> not cover even 320 bits of bitmap it stores, it this case this node i=
s not
> very efficient. In case we have a lot of unefficient nodes we might a=
ctually
> end up with bigger memory utilization than bitarrays itself and that'=
s bad.
>
> Now, the answer for this problem is benchmarking, to figure out how p=
robable
> this situation is and how (and when) bad it can get. We would probabl=
y need to
> create some fallback switch which will convert bitmaps from one backe=
nd
> (rbtree) to another (bitarray) depending on which appears more effici=
ent for
> the situation, but let's keep it simple for now and lets figure out h=
ow bad
> the problem actually is.
>
> I have done some limited benchmarking. Limited, because it takes time=
 (a lot
> of it) and also huge storages, because we do not really care about me=
mory
> utilization differences in megabytes, but rather in hundreds and thou=
sands of
> megabytes. So this is my second appeal to you guys, take it, make it,=
 test it
> and benchmark it.
>
> For measuring memory utilization I have used valgrind (massif tool to=
 be
> specific). All the numbers I will show you are peak memory utilizatio=
n. So
> here is an example how to use massif.
>
> =A0 =A0 =A0 =A0valgrind --tool=3Dmassif ./e2fsck/e2fsck -fn /dev/loop=
0
> =A0 =A0 =A0 =A0ms_print massif.out.5467 | less
>
> Now, I can show you some (rather optimistic) graphs of e2fsck memory
> utilization I have done. Here is the link (description included):
>
> http://people.redhat.com/lczerner/e2fsprogs_memory/graphs.pdf
>
> Now the simple description of the graphs. The first one is showing th=
e e2fsck
> memory utilization depending on filesystem size. The benchmark was pe=
rformed
> right after the fs creation so it shows the best scenario for the rbt=
ree
> backend. The amount of saved memory grows approx by 8.5MB per 100MB o=
f
> filesystem size - this is the best what we can get.
>
> The second graph shows memory utilization per inode depending on inod=
e count.
> We can see that with growing number of inodes the Bytes per inode rat=
io is
> dropping significantly, moreover it is dropping faster for bitarrays =
than for
> rbtrees, which tells us that inode count is in fact the main factor w=
hich
> impact the memory utilization difference between the rbtree and bitat=
tay
> backend on the filesystem of constant size. However it strongly depen=
ds also
> on how are the files created on the filesystem - some loads might be =
more
> rbtree-friendly than others.
>
> The threshold is, when the Bytes per Inode is equal for both backends=
, this is
> the last point where we will need to convert rbtree backend to bitarr=
ays,
> because above this threshold rbtree approach is no longer efficient. =
In my
> load (copying content of /usr/share several times) it means that rbtr=
ee memory
> utilization is growing by 20B per inode, however bitarray mem. util. =
is
> growing by 4B per inode (on 10TB filesystem). So the rbtree memory co=
nsumption
> is growing 5 times faster then bitarrays.
>
> Let's simplify situation and let's say that the Bytes per Inode growi=
ng ratio
> will not change with inode count (which is not true, but this is yet =
to be
> tested). In this case we hit the threshold when we fill 33% of inodes=
, which
> means 20% of filesystem size. Not very promising, however is this loa=
d the
> typical real-life load ? - this we need to find out.
>
> Next graph shows e2fsck memory utilization depending on inode count w=
hich is
> practically the same thing as in previous graph.
>
> The last two graphs were created on filesystem aged with Impression i=
n default
> configuration, rather than copying /usr/share. It should provide more
> real-live filesystem images. The filesystem is rather small now, only=
 312GB.
> So the fourth graph shows running times of e2fsck for both backends, =
rbtree
> and bitarrays. We can see that rbtree backend performs quite bad, how=
ever I
> believe that I know the source of the slowdown. It is the rb_test_bit=
()
> function which need to walk the tree every time e2fsck needs to test =
the bit
> and since this usually happen in sequential order (bit-by-bit), we ca=
n easily
> improve performance by adding simple cache (similar to write cache in
> rb_set_bit()). Also with the little improvement of e2fsck bitmap hand=
ling (use
> the advantage of extents) we can improve performance even more. But I=
 leave
> those optimization to after we are done with memory utilization optim=
ization.
>
> Finally, the last graph shows Memory utilization per inode depending =
on inode
> count. This is the similar graph as the second one, however this one =
is a bit
> more optimistic. The rbtree memory utilization grows by avg. 8B per I=
node, and
> bitarray grows by avg. 7B per inode, which is quite good and in this =
scenario
> with stable Bytes per inode grow the rbtree backend will be always be=
tter than
> bitarray. This show us, that it really depends on the type of load as=
 well as
> on the size of the filesystem. So we need to test more and more real =
life
> filesystems to see the if the rbtree is really a win for most of the =
users, or
> just some small groupr group, who does not even care about memory uti=
lization
> at all (it is clearly numbers from huge filesystems we care about!).
>
>
> There were some people having OOM problems with e2fsck, It would be g=
reat if
> those people can try this patches to see if it helps and get back to =
us to
> share the experience. Although I feel that I need to warn you guys, t=
his is
> not yet stable, and even though I have not seen any problems, it does=
 not mean
> that it is bug free, so at least try it with '-n' option which should=
 be
> quite safe.
>
> Please, comments are highly appreciated!
>
> Thanks!
> -Lukas
>
>

Hi Lukas,

Your work is very impressive.
I would be very much interested in reducing the memory usage of e2fsck
and reducing it's run-time.
We have appliances with up to 16TB of storage and only 1GB of RAM.

I have investigated the issue of reducing e2fsck memory usage in the pa=
st
and have a lot of comments/suggestions. I will try the summarize them b=
y topic:

1. Analysis of usage pattern per bitmap instance.
2. Yet another bitmap backend.
3. More ways to reduce memory usage of e2fsck.


1. Analysis of usage pattern per bitmap instance.

As you know, e2fsck uses bitmaps to mark many different things.
=46or block bitmaps you have "in-use block map","multiply claimed block
map" and "ext attr block map".
While memory usage analysis of an "empty" and an "healthy" file
systems is important,
it is very important to look at worst case as well.
And even a single multiply claimed block or a single extended
attribute block will
result is considerable memory savings with rb_trees, which is not
shown in your graphs.

There are several inode bitmaps, such as "icount->multiple",
which are relatively sparse and would benefit a lot from being stored
in an rb_tree.
Again, you will only see the benefit once you have hard links in your
file system.

As a conclusion, you may want to add a statistics report of the memory =
usage of
each bitmap instance, so the optimal backend can be chosen per bitmap i=
nstance.

2. Yet another bitmap backend.

It is my *hunch*, that rb_trees are a suitable backend for very sparse =
bitmaps,
like the onces I mentioned above and maybe for "in-use block map".

However, I have a *feeling* that rb_trees may not be the optimal choice=
 for
"in-use inode map" and maybe also not for "in-use block map".
The reason is that the average use case can have very dense and quite f=
ragmented
"in-use" bitmaps.

It seems to me, that if half of the block groups are not in use and
the other half
is dense and fragmented, then neither rb_trees, nor arrays are the
optimal backend.
A data structure similar to the page table, could be quite efficient
in this use case,
both from the memory usage aspect and the test/set_bit speed aspect.

While it is rare to see a block group occupied with few used block, it
could certainly
happen for inodes, so I would choose a "page" size equal to block size
for "in-use block bitmap"
and a much smaller "page" size for "in-use inode" bitmap.


3. More ways to reduce memory usage of e2fsck.

The most recent case of e2fsck OOM I remember showing on this list
was cause by a file system with many hard links that were created by rs=
napshot
(http://rsnapshot.org/)

If I recall correctly, the overblown memory usage was caused by the
icount cache,
which creates an entry for every inode with nlink > 1.

Similar problem can be caused by a large ea_count cache, when a file sy=
stem
has many multiply referenced extended attribute blocks (ACLs?).

=46or that problem, I have a somewhat "crazy" solution.
If the hard linked inodes are in fact sparsely distributed
and if the larger the refcounts, the fewer the inodes
(let's neglect directory hard links, because we've given up on them
 for #subdirs > 32000 anyway), then it is possible to replace
the icount cache with 16 inode bitmaps, each one representing
a single bit in the u16 i_links_count.

Assuming that in a normal file system the maximum links count is bounde=
d,
then most of these bitmaps will be empty and the rest very sparse.

Even in a highly linked file system generated by 256 rsnapshots,
the memory usage is still only about 8bits per inode, while icount
cache stores 64bit per inode.


So that's it. A lot of talking and no benchmarking... Sorry about that.

If we can come to a definite conclusion of a way to reduce memory usage
and run-time of e2fsck for both the average and worst case, I think I w=
ill be
able to turn more resources into the implementation and testing of
such a scheme.

So Lukas, if you can please try to apply the rb_trees backend to select=
ive
bitmap instances, like "ext attribute block" and show that it is a clea=
r win
situation, I am most likely to take the rb_tree patches and run some te=
sts
on our appliances.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
