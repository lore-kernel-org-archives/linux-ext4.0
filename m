From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [LSF/FS TOPIC] Journal guided RAID resync
Date: Tue, 8 Mar 2011 13:28:11 -0700
Message-ID: <D0E540E7-B1D0-4C89-BD0C-262915EE8A28@dilger.ca>
References: <AANLkTik72=3h4T=MNnaqLFdfYHraYp8T=eaNyijFiY9f@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTik72=3h4T=MNnaqLFdfYHraYp8T=eaNyijFiY9f@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[I've removed LSF-PC from the CC list, since I believe the attendee/topic selection is long past]

One reason that we didn't use this patch is that it is essentially the opposite of "ordered" mode when it comes to data reliability. It requires that the journal be updated with the blocks to be modified _before_ the data blocks are written. 

This means that stale data may be exposed to userspace in case of a crash, unless a two-phase commit is done where the declare blocks are committed to one transaction, and only after that the data blocks are written.

 The other option is a WAFL mode where writes are done into RAID stripe-aligned free space so that parity loss is not harmful to existing data. This is not unreasonable with mballoc for new blocks, but not necessarily overwrites. It may tie in with snapshots nicely, since it has the same COW requirements. 

Cheers, Andreas

On 2011-03-08, at 8:35, Amir Goldstein <amir73il@gmail.com> wrote:

> Hi All,
> 
> I have picked up the old ext3/jbd patches a while ago and
> was trying to figure out how difficult would it be to port them
> to ext4/jbd2.
> 
> The gain from these patches to anyone using software RAID
> should be clear, see:
> http://lwn.net/Articles/363490/
> 
> What is not clear to me at this point is what are the
> performance implications, if any, of withholding "declared" data
> writeback until journal commit.
> 
> I also did not get to estimating the effort involved in the porting
> to ext4/jbd2. The absence of ext3/jbd "dirty data" buffers list is
> going to be one of the issues to deal with.
> 
> Does anyone out there have interest in pushing this forward?
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
