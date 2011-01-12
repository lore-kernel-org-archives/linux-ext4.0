From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC PATCH 0/2] Add rbtree backend for storing bitmaps
Date: Wed, 12 Jan 2011 16:19:26 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1101121611200.19882@dhcp-lab-213.englab.brq.redhat.com>
References: <1294672737-10850-1-git-send-email-lczerner@redhat.com> <AANLkTinh6u9LN3U8EHGbt1U0MRNqZ3zLuaxDxn2=GxaJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-1957485869-1294845572=:19882"
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	kalpak@clogeny.com
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab1ALPTh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Jan 2011 10:19:37 -0500
In-Reply-To: <AANLkTinh6u9LN3U8EHGbt1U0MRNqZ3zLuaxDxn2=GxaJ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-1957485869-1294845572=:19882
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 12 Jan 2011, Amir Goldstein wrote:

> On Mon, Jan 10, 2011 at 5:18 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > Hi all,
> >
> > as I mentioned a while ago I am working on reducing e2fsprogs memory
> > utilization. The first thing which need to be addressed is mechanism of
> > storing bitmaps. So far bitarrays was used for this purpose however today
> > this approach might hit its limits with todays huge data storage devices,
> > because of its memory utilization.
> >
> > Bitarrays stores bitmaps as ..well, as bitmaps. But this is in most
> > cases highly unefficient because we need to allocate memory even for the
> > big parts of bitmaps we will never use, resulting in high memory
> > utilization especially for huge filesystem, when bitmaps might occupy
> > gigabytes of space.
> >
> > To address this I have created rbtree backend for storing bitmaps. It stores
> > just used extents of bitmaps, it means, that it can be more memory efficient
> > in most cases and also with careful use it might be much faster as well.
> >
> > Rbtree implementation itself is ripped of linux kernel with some minor changes
> > to make it work outside kernel. So this should not cause any problems at all
> > since it has been really extensively tested through out its life.
> >
> > I have done a lot of testing to validate my new backend and to find as many
> > bugs as possible. Now it seems to be quite reliable, however since this is the
> > most crucial part of the e2fsprogs it has to be tested most widely on various
> > scenarios. So this is my appeal to you guys, please take it, make it and test
> > it and test it some more, to really make sure this is doing what it is
> > supposed to.
> >
> > The other side of the thing is, does it really help with memory utilization ?
> > So my answer is YES, (...but). Of course there is a "but". That is because one
> > rbtree node on 64-bit system takes 40B of data, which is 320 bits of
> > information. So there might be a situation when one single rbtree node does
> > not cover even 320 bits of bitmap it stores, it this case this node is not
> > very efficient. In case we have a lot of unefficient nodes we might actually
> > end up with bigger memory utilization than bitarrays itself and that's bad.
> >
> > Now, the answer for this problem is benchmarking, to figure out how probable
> > this situation is and how (and when) bad it can get. We would probably need to
> > create some fallback switch which will convert bitmaps from one backend
> > (rbtree) to another (bitarray) depending on which appears more efficient for
> > the situation, but let's keep it simple for now and lets figure out how bad
> > the problem actually is.
> >
> > I have done some limited benchmarking. Limited, because it takes time (a lot
> > of it) and also huge storages, because we do not really care about memory
> > utilization differences in megabytes, but rather in hundreds and thousands of
> > megabytes. So this is my second appeal to you guys, take it, make it, test it
> > and benchmark it.
> >
> > For measuring memory utilization I have used valgrind (massif tool to be
> > specific). All the numbers I will show you are peak memory utilization. So
> > here is an example how to use massif.
> >
> >        valgrind --tool=massif ./e2fsck/e2fsck -fn /dev/loop0
> >        ms_print massif.out.5467 | less
> >
> > Now, I can show you some (rather optimistic) graphs of e2fsck memory
> > utilization I have done. Here is the link (description included):
> >
> > http://people.redhat.com/lczerner/e2fsprogs_memory/graphs.pdf
> >
> > Now the simple description of the graphs. The first one is showing the e2fsck
> > memory utilization depending on filesystem size. The benchmark was performed
> > right after the fs creation so it shows the best scenario for the rbtree
> > backend. The amount of saved memory grows approx by 8.5MB per 100MB of
> > filesystem size - this is the best what we can get.
> >
> > The second graph shows memory utilization per inode depending on inode count.
> > We can see that with growing number of inodes the Bytes per inode ratio is
> > dropping significantly, moreover it is dropping faster for bitarrays than for
> > rbtrees, which tells us that inode count is in fact the main factor which
> > impact the memory utilization difference between the rbtree and bitattay
> > backend on the filesystem of constant size. However it strongly depends also
> > on how are the files created on the filesystem - some loads might be more
> > rbtree-friendly than others.
> >
> > The threshold is, when the Bytes per Inode is equal for both backends, this is
> > the last point where we will need to convert rbtree backend to bitarrays,
> > because above this threshold rbtree approach is no longer efficient. In my
> > load (copying content of /usr/share several times) it means that rbtree memory
> > utilization is growing by 20B per inode, however bitarray mem. util. is
> > growing by 4B per inode (on 10TB filesystem). So the rbtree memory consumption
> > is growing 5 times faster then bitarrays.
> >
> > Let's simplify situation and let's say that the Bytes per Inode growing ratio
> > will not change with inode count (which is not true, but this is yet to be
> > tested). In this case we hit the threshold when we fill 33% of inodes, which
> > means 20% of filesystem size. Not very promising, however is this load the
> > typical real-life load ? - this we need to find out.
> >
> > Next graph shows e2fsck memory utilization depending on inode count which is
> > practically the same thing as in previous graph.
> >
> > The last two graphs were created on filesystem aged with Impression in default
> > configuration, rather than copying /usr/share. It should provide more
> > real-live filesystem images. The filesystem is rather small now, only 312GB.
> > So the fourth graph shows running times of e2fsck for both backends, rbtree
> > and bitarrays. We can see that rbtree backend performs quite bad, however I
> > believe that I know the source of the slowdown. It is the rb_test_bit()
> > function which need to walk the tree every time e2fsck needs to test the bit
> > and since this usually happen in sequential order (bit-by-bit), we can easily
> > improve performance by adding simple cache (similar to write cache in
> > rb_set_bit()). Also with the little improvement of e2fsck bitmap handling (use
> > the advantage of extents) we can improve performance even more. But I leave
> > those optimization to after we are done with memory utilization optimization.
> >
> > Finally, the last graph shows Memory utilization per inode depending on inode
> > count. This is the similar graph as the second one, however this one is a bit
> > more optimistic. The rbtree memory utilization grows by avg. 8B per Inode, and
> > bitarray grows by avg. 7B per inode, which is quite good and in this scenario
> > with stable Bytes per inode grow the rbtree backend will be always better than
> > bitarray. This show us, that it really depends on the type of load as well as
> > on the size of the filesystem. So we need to test more and more real life
> > filesystems to see the if the rbtree is really a win for most of the users, or
> > just some small groupr group, who does not even care about memory utilization
> > at all (it is clearly numbers from huge filesystems we care about!).
> >
> >
> > There were some people having OOM problems with e2fsck, It would be great if
> > those people can try this patches to see if it helps and get back to us to
> > share the experience. Although I feel that I need to warn you guys, this is
> > not yet stable, and even though I have not seen any problems, it does not mean
> > that it is bug free, so at least try it with '-n' option which should be
> > quite safe.
> >
> > Please, comments are highly appreciated!
> >
> > Thanks!
> > -Lukas
> >
> >
> 
> Hi Lukas,
> 
> Your work is very impressive.
> I would be very much interested in reducing the memory usage of e2fsck
> and reducing it's run-time.
> We have appliances with up to 16TB of storage and only 1GB of RAM.
> 
> I have investigated the issue of reducing e2fsck memory usage in the past
> and have a lot of comments/suggestions. I will try the summarize them by topic:
> 
> 1. Analysis of usage pattern per bitmap instance.
> 2. Yet another bitmap backend.
> 3. More ways to reduce memory usage of e2fsck.
> 
> 
> 1. Analysis of usage pattern per bitmap instance.
> 
> As you know, e2fsck uses bitmaps to mark many different things.
> For block bitmaps you have "in-use block map","multiply claimed block
> map" and "ext attr block map".
> While memory usage analysis of an "empty" and an "healthy" file
> systems is important,
> it is very important to look at worst case as well.
> And even a single multiply claimed block or a single extended
> attribute block will
> result is considerable memory savings with rb_trees, which is not
> shown in your graphs.
> 
> There are several inode bitmaps, such as "icount->multiple",
> which are relatively sparse and would benefit a lot from being stored
> in an rb_tree.
> Again, you will only see the benefit once you have hard links in your
> file system.
> 
> As a conclusion, you may want to add a statistics report of the memory usage of
> each bitmap instance, so the optimal backend can be chosen per bitmap instance.
> 
> 2. Yet another bitmap backend.
> 
> It is my *hunch*, that rb_trees are a suitable backend for very sparse bitmaps,
> like the onces I mentioned above and maybe for "in-use block map".
> 
> However, I have a *feeling* that rb_trees may not be the optimal choice for
> "in-use inode map" and maybe also not for "in-use block map".
> The reason is that the average use case can have very dense and quite fragmented
> "in-use" bitmaps.
> 
> It seems to me, that if half of the block groups are not in use and
> the other half
> is dense and fragmented, then neither rb_trees, nor arrays are the
> optimal backend.
> A data structure similar to the page table, could be quite efficient
> in this use case,
> both from the memory usage aspect and the test/set_bit speed aspect.
> 
> While it is rare to see a block group occupied with few used block, it
> could certainly
> happen for inodes, so I would choose a "page" size equal to block size
> for "in-use block bitmap"
> and a much smaller "page" size for "in-use inode" bitmap.
> 
> 
> 3. More ways to reduce memory usage of e2fsck.
> 
> The most recent case of e2fsck OOM I remember showing on this list
> was cause by a file system with many hard links that were created by rsnapshot
> (http://rsnapshot.org/)
> 
> If I recall correctly, the overblown memory usage was caused by the
> icount cache,
> which creates an entry for every inode with nlink > 1.
> 
> Similar problem can be caused by a large ea_count cache, when a file system
> has many multiply referenced extended attribute blocks (ACLs?).
> 
> For that problem, I have a somewhat "crazy" solution.
> If the hard linked inodes are in fact sparsely distributed
> and if the larger the refcounts, the fewer the inodes
> (let's neglect directory hard links, because we've given up on them
>  for #subdirs > 32000 anyway), then it is possible to replace
> the icount cache with 16 inode bitmaps, each one representing
> a single bit in the u16 i_links_count.
> 
> Assuming that in a normal file system the maximum links count is bounded,
> then most of these bitmaps will be empty and the rest very sparse.
> 
> Even in a highly linked file system generated by 256 rsnapshots,
> the memory usage is still only about 8bits per inode, while icount
> cache stores 64bit per inode.
> 
> 
> So that's it. A lot of talking and no benchmarking... Sorry about that.
> 
> If we can come to a definite conclusion of a way to reduce memory usage
> and run-time of e2fsck for both the average and worst case, I think I will be
> able to turn more resources into the implementation and testing of
> such a scheme.
> 
> So Lukas, if you can please try to apply the rb_trees backend to selective
> bitmap instances, like "ext attribute block" and show that it is a clear win
> situation, I am most likely to take the rb_tree patches and run some tests
> on our appliances.
> 
> Thanks,
> Amir.
> 

Hi Amir,

Thanks for useful tips and inspiration. It seems like a good strategy to
divide the memory statistics to a separate bitmaps, so I'll certainly do
that. Also as Andreas noted it would be useful to allow choosing different
bitmap backed for different bitmap types, I'll try to look at it. Right now
I am little bit swamped by other work, but I'll do my best.

Thanks!
-Lukas
--571140353-1957485869-1294845572=:19882--
