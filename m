From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Tue, 1 Nov 2011 08:35:34 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1111010816520.5603@dhcp-27-109.brq.redhat.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com> <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com> <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca> <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
 <4EA1952B.9070404@redhat.com> <20111021155428.GA21564@infradead.org> <CAGr1F2Fuuoowh59k-_e6cK1v0Z2TMEtM4FpDTf2APjmViqUu-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab1KAHfr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Nov 2011 03:35:47 -0400
In-Reply-To: <CAGr1F2Fuuoowh59k-_e6cK1v0Z2TMEtM4FpDTf2APjmViqUu-g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 26 Oct 2011, Aditya Kali wrote:

> Thanks all for your feedback. Summarizing from the discussion so far,
> there seem to be three main solutions suggested for replicating
> metadata:
> 1) Use mke2fs hack to store all metadata in 1st block group and use dm
> and raid1 to mirror 1st block group (most of the metadata).
>     Pros: Simple approach that does not require any ext4 changes.
>     Cons: Added overhead of raid and device mapper will be significant
> for fast SSDs

I do not think that overhead of raid or device mapper is "significant"
at all. It is used on every day basis in various setups without any
problems. Do you have anything specific in mind ?

>     Cons: Management overhead on large number of machines
>     Cons: Need to add support in raid to read from the mirror if primary fails.
> 2) Have a separate metadata device and access all ext4 metadata from
> it. This device could be raid1 or whatever.
>     Pros: No need for device mapper

Actually yes, you would need device mapper, or md, to protect the
separate metadata device from failures.

>     Pros: Solves many other problems (SSDs can be used to cache
> metadata for disks, etc.)
>     Cons: Will need to significantly over allocate space (running out
> of space on this device potentially means no more writes to
> filesystem).

Not sure why you would need do significantly over allocate space ?
Simply allocating the same amount of space as it is needed for ext4
meta data on the original device (+ some more for extent blocks?) would
be enough, right ? So slightly over provisioning is ok, but I am not
sure why do you think it would be "significant". That said, ext4 meta
data space is more-or-less static (again, except extent blocks I think).

>     Cons: Lot of ext4 code change
> 3) A replica inode that resides on either same device or an external
> device (this proposal)
>     Pros: No need for device mapper or other additional layers
>     Pros: Simpler management in production
>     Cons: Not generic (Ext4 specific)
>     Cons: Complicates Ext4 for questionable gain (specially with inode
> being on same device)
> 
> #2 seems to be an ideal solution, but it would be substantial amount
> of efforts and will require lot of ext4 changes.
> One other alternative that comes to mind is to have an external
> "replica device" (hybrid of ideas #2 and #3) instead of an entire
> "metadata device" with an option for the filesystem to read from the
> replica first. All metadata writes that go to the original will also
> go to the replica device. In addition, the filesystem can choose to
> read from the replica first. With this, we get the benifits of #2 and
> #3 without needing lot of ext4 (or any other filesystem) changes.
> What do you think? Will this be something that could be implemented
> without much intrusion into ext4 codebase?

I think that the efforts with this approach would just be bigger than
with simple #2 solution. Also you will lose the advantage of having fast
SSD device for metadata to speed up metadata intensive loads. On the
other hand with this "hybrid" approach we will have the opportunity to
drop the metadata device any time, since we will still have the original
metadata. However I do not have very good feeling about this. So I am in
favour of simple #2 solution.

Thanks!
-Lukas

> 
> Thanks,
> 
> On Fri, Oct 21, 2011 at 8:54 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Oct 21, 2011 at 10:52:11AM -0500, Eric Sandeen wrote:
> >> With an SSD, you -really- don't know the independent failure domains,
> >> with all the garbage collection & remapping that they may do, right?
> >
> > In fact some popular consumer SSDs do some fairly efficient data
> > de-duplication which completly runs any metadata redundancy on a single
> > of these devices void.
> >
> >
> 
> 
> 
> 

-- 
