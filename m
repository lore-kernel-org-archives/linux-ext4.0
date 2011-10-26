From: Aditya Kali <adityakali@google.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Wed, 26 Oct 2011 16:39:23 -0700
Message-ID: <CAGr1F2Fuuoowh59k-_e6cK1v0Z2TMEtM4FpDTf2APjmViqUu-g@mail.gmail.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com>
 <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com>
 <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca> <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
 <4EA1952B.9070404@redhat.com> <20111021155428.GA21564@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:26659 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1JZXjp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 19:39:45 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p9QNdimC000678
	for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 16:39:45 -0700
Received: from pzk1 (pzk1.prod.google.com [10.243.19.129])
	by hpaq2.eem.corp.google.com with ESMTP id p9QNcS0u001482
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 16:39:43 -0700
Received: by pzk1 with SMTP id 1so8279625pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 16:39:43 -0700 (PDT)
In-Reply-To: <20111021155428.GA21564@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks all for your feedback. Summarizing from the discussion so far,
there seem to be three main solutions suggested for replicating
metadata:
1) Use mke2fs hack to store all metadata in 1st block group and use dm
and raid1 to mirror 1st block group (most of the metadata).
    Pros: Simple approach that does not require any ext4 changes.
    Cons: Added overhead of raid and device mapper will be significant
for fast SSDs
    Cons: Management overhead on large number of machines
    Cons: Need to add support in raid to read from the mirror if primary fails.
2) Have a separate metadata device and access all ext4 metadata from
it. This device could be raid1 or whatever.
    Pros: No need for device mapper
    Pros: Solves many other problems (SSDs can be used to cache
metadata for disks, etc.)
    Cons: Will need to significantly over allocate space (running out
of space on this device potentially means no more writes to
filesystem).
    Cons: Lot of ext4 code change
3) A replica inode that resides on either same device or an external
device (this proposal)
    Pros: No need for device mapper or other additional layers
    Pros: Simpler management in production
    Cons: Not generic (Ext4 specific)
    Cons: Complicates Ext4 for questionable gain (specially with inode
being on same device)

#2 seems to be an ideal solution, but it would be substantial amount
of efforts and will require lot of ext4 changes.
One other alternative that comes to mind is to have an external
"replica device" (hybrid of ideas #2 and #3) instead of an entire
"metadata device" with an option for the filesystem to read from the
replica first. All metadata writes that go to the original will also
go to the replica device. In addition, the filesystem can choose to
read from the replica first. With this, we get the benifits of #2 and
#3 without needing lot of ext4 (or any other filesystem) changes.
What do you think? Will this be something that could be implemented
without much intrusion into ext4 codebase?

Thanks,

On Fri, Oct 21, 2011 at 8:54 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Oct 21, 2011 at 10:52:11AM -0500, Eric Sandeen wrote:
>> With an SSD, you -really- don't know the independent failure domains,
>> with all the garbage collection & remapping that they may do, right?
>
> In fact some popular consumer SSDs do some fairly efficient data
> de-duplication which completly runs any metadata redundancy on a single
> of these devices void.
>
>



-- 
Aditya
