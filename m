From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Mon, 27 Feb 2012 16:16:46 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202271611090.5597@dhcp-27-109.brq.redhat.com>
References: <20120227090901.GA13953@gmail.com> <alpine.LFD.2.00.1202271234250.5597@dhcp-27-109.brq.redhat.com> <20120227131829.GA14666@gmail.com> <alpine.LFD.2.00.1202271417350.5597@dhcp-27-109.brq.redhat.com> <20120227150908.GA15097@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2B0PQu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 10:16:50 -0500
In-Reply-To: <20120227150908.GA15097@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 27 Feb 2012, Zheng Liu wrote:

> On Mon, Feb 27, 2012 at 02:33:28PM +0100, Lukas Czerner wrote:
> > On Mon, 27 Feb 2012, Zheng Liu wrote:
> > 
> > > On Mon, Feb 27, 2012 at 01:00:07PM +0100, Lukas Czerner wrote:
> > > > On Mon, 27 Feb 2012, Zheng Liu wrote:
> > > > 
> > > > > Hi list,
> > > > > 
> > > > > Now, in ext4, we have multi-block allocation and delay allocation. They work
> > > > > well for most scenarios. However, in some specific scenarios, they cannot help
> > > > > us to optimize block allocation. For example, the user may want to indicate some
> > > > > file set to be allocated at the beginning of the disk because its speed in this
> > > > > position is faster than its speed at the end of disk.
> > > > > 
> > > > > I have done the following experiment. The experiment is on my own server, which
> > > > > has 16 Intel(R) Xeon(R) CPU E5620 @ 2.40GHz, 48G memory and a 1T sas disk. I
> > > > > split this disk into two partitions, one has 900G, and another has 100G. Then I
> > > > > use dd to get the speed of read/write. The result is as following.
> > > > > 
> > > > > [READ]
> > > > > # dd if=/dev/sdk1 of=/dev/null bs=128k count=10000 iflag=direct
> > > > > 1310720000 bytes (1.3 GB) copied, 9.41151 s, 139 MB/s
> > > > > 
> > > > > # dd if=/dev/sdk2 of=/dev/null bs=128k count=10000 iflag=direct
> > > > > 1310720000 bytes (1.3 GB) copied, 17.952 s, 73.0 MB/s
> > > > > 
> > > > > [WRITE]
> > > > > # dd if=/dev/zero of=/dev/sdk1 bs=128k count=10000 oflag=direct
> > > > > 1310720000 bytes (1.3 GB) copied, 8.46005 s, 155 MB/s
> > > > > 
> > > > > # dd if=/dev/zero of=/dev/sdk2 bs=128k count=10000 oflag=direct
> > > > > 1310720000 bytes (1.3 GB) copied, 15.8493 s, 82.7 MB/s
> > > > > 
> > > > > So filesystem can provide a new feature to let the user to indicate a value
> > > > > for reserving some blocks from the beginning of the disk. When the user needs
> > > > > to allocate some blocks for an important file that needs to be read/write as
> > > > > quick as possible, the user can use ioctl(2) and/or other ways to notify
> > > > > filesystem to allocate these blocks in the reservation area. Thereby, the user
> > > > > can obtain the higher performance for manipulating this file set.
> > > > > 
> > > > > This idea is very trivial. So any comments or suggestions are appreciated.
> > > > > 
> > > > > Regards,
> > > > > Zheng
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > 
> > > > 
> > > > Hi Zheng,
> > > > 
> > > > I have to admit I do not like it :). I think that this kind of
> > > > optimization is useless in the long run. There are several reasons for
> > > > this:
> > > 
> > > Hi Lukas,
> > > 
> > > Thank you for your opinion. ;-)
> > > 
> > > > 
> > > >  - the test you've done is purely fabricated and does not respond to
> > > >    real workload at all. Especially because it is done on a huge files.
> > > >    I can imagine this approach improving boot speed, but you will
> > > >    usually have to load just small files, so for single file it does not
> > > >    make much sense. Moreover with small files more seeks would have to
> > > >    be done hugely reducing the advantage you can see with dd.
> > > 
> > > I will describe the problem that we encounter. the problem shows that
> > > even if files are small, the performance can be improved in some
> > > specific scenarios using this block allocation.
> > > 
> > > >  - HDD might have more platters than just one
> > > >  - Your file system might span across several drives
> > > >  - On thinly provisioned storage this does not make sense at all
> > > >  - SSD's are more and more common and this optimization is useless for
> > > >    them.
> > > > 
> > > > Is there any 'real' problem you would want to solve with this ? Or is it
> > > > just something that came to you mind ? I agree that we want to improve
> > > > our allocators, but IMHO especially for better scalability, not to cover
> > > > this disputable niche.
> > > 
> > > We encounter a problem in our product system. In a 2TB sata disk, the
> > > file can be divided into two categories. One is index file, and another
> > > is block file. The average size of index files is about 128k and will
> > > increase as time goes on. The size of block files is 70M and they are
> > > created by fallocate(2). Thus, index file is allocated at the end of the
> > > disk. When application starts up, it needs to load all of index files
> > > into memory. So it costs too much time. If we can allocate index files
> > > at the beginning of the disk, we will cut down the startup time and
> > > increase the service time of this application.
> > > 
> > > Therefore, I think that it might be as a generic mechanism to provide
> > > other users that have the similar requirement.
> > 
> > Ok, so this seems like a valid use case. However I think that this is
> > exactly something that can be quite easily solved without having to
> > modify file system code, right ?
> > 
> > You can simply use separate drive for the index files, or even raid. Or
> > you can actually use an SSD for this, which I believe will give you *a
> > lot* better performance improvements and you wont be bothered by the
> > size/price ratio for SSD as you would only store indexes there, right ?
> > 
> > Or, if you really do not want to, or can not, but a new hardware for
> > some reason, you can always partition a 2TB disk and put all your index
> > files on the smaller, close to the disk center partition. I really do
> > not see a reason to modify the code.
> > 
> > What might be even more interesting is, that you might generally benefit
> > from splitting the index/data file systems. The reason is that your data
> > file and your index file filesystem might benefit from bigalloc if you
> > split them, because you can set different cluster sizes on both file
> > system depending on the file sizes you would actually store there, since
> > as I understand the index and data files differs in size significantly.
> 
> You are right. I am trying this solution in our test environment. I have
> splitted a 2TB disk into 2 partitions. One is for index file and is
> formated with big alloc, and another is for block file.

That's good to hear. So you have your solution maybe ?

> 
> > 
> > How much of the performance boost do you expect by doing this your way -
> > modifying the file system? Note that dd will not tell you that, as I
> > explained earlier. I surely would not match using SSD for index files by
> > far.
> > 
> > What do you think?
> 
> As Yongqiang said, maybe we can allocate faster block for the file which
> needs to be fast read/write when the user sets a flag to notify the file
> system. Maybe we don't need to implement a new block allocation
> algorithm. We only need to modify the current block allocation to
> provide this mechansim.
> 
> Regards,
> Zheng

I am not sure what Yongqiang meant by that. I know that there is a
REQ_META flag which is supposed to set higher priority for metadata
reads. However how do you expect this to work ? It would have to be set
*only* by root, because from user perspective *every* file is a priority
above other users files :). But doing this as root greatly limits it
use.

If the REQ_META thing is what Yongqiang meant, I am not sure if it is
such a good idea to exploit this flag like that.

Thanks!
-Lukas

> 
> > 
> > Thanks!
> > -Lukas
> > 
> > 
> > 
> > > 
> > > Regards,
> > > Zheng
> > > 
> > > > 
> > > > Anyway, you may try to come up with better experiment. Something which
> > > > would actually show how much can we get from the more realistic workload
> > > > rather than showing that contiguous serial writes are faster closely to
> > > > the center of the disk platter, we know that.
> > > > 
> > > > Thanks!
> > > > -Lukas
> > > 
> > 
> > -- 
> 

-- 
