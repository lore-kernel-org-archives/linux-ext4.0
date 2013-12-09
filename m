From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 projects for 2014
Date: Mon, 9 Dec 2013 14:50:31 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1312091448540.2143@localhost.localdomain>
References: <20131209014330.GA9195@thunk.org> <alpine.LFD.2.00.1312091335440.2143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-567540897-1386597033=:2143"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab3LINug (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Dec 2013 08:50:36 -0500
In-Reply-To: <alpine.LFD.2.00.1312091335440.2143@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-567540897-1386597033=:2143
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 9 Dec 2013, Luká¨ Czerner wrote:

> Date: Mon, 9 Dec 2013 14:20:31 +0100 (CET)
> From: Luká¨ Czerner <lczerner@redhat.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Ext4 projects for 2014
> 
> On Sun, 8 Dec 2013, Theodore Ts'o wrote:
> 
> > Date: Sun, 8 Dec 2013 20:43:30 -0500
> > From: Theodore Ts'o <tytso@mit.edu>
> > To: linux-ext4@vger.kernel.org
> > Subject: Ext4 projects for 2014
> > 
> > Unfortunately, I forgot my notes from our last conference call before
> > heading off to the airport.  My fault for taking the notes on paper
> > instead of electronically in the first place.  :-(
> > 
> > This is my best reconstruction of some of the ext4 projects for 2014.
> > Please let me know if I've forgotten anything.

Btw I think that what is lacking in this list is:

- XIP support (even though we have some patches with some
  functionality)
- range locking (Jan Kara was working on this, but I am not sure
  what is the status of his work)

> > 
> > 1)  Support for Shingled (SMR) Drives
> > 
> > 2)  Data block compression -- Lukas
> 
> I think you meant data block checksums ?
> 
> I was thinking about this a little bit and the best way seems to be
> to create a new checksum tree with pointers to extent tree and add
> pointers from extent tree into the checksum tree.
> 
> Other possibility would not require any additional tree - checksum
> would be sored directly in the blocks itself, with additional
> information making data block self describing which would be great
> for file system resilience, repair, misplaced writes and all sorts
> of other failures. However this would make the file system with
> checksum support unreadable by older version of the ext4.
> 
> I am interested to know what people thinks about that.
> 
> > 3)  reflink support --- Mingming
> >        block-level snapshot support
> >        Use case:  (a) VM guest images which are mostly derived from
> >        	   	      the same common master image
> 
> I think this will be very useful functionality, however I think that
> ext4 design is not really prepared for this kind of functionality
> so we should be looking at how to enable this without actually
> bending ext4 to do this on it's own.
> 
> The first idea I've had was to use device mapper for that. Simply
> design a interface where we can tell block layer (DM) to create
> snapshots from provided list of extents. That way we could use it
> by other file system as well. However there might be some
> shortcomings like for example the fact that DM thinp target is
> operating of larger blocks of data (chunk size) then is the size of
> the block.
> 
> We could always configure smaller chunk size for the thinp target
> however that might be suboptimal as DM is not really designed for
> fast and effective metadata processing since they usually do not
> have that much metadata. But it's still a possibility with the
> advantage to be generic solution for all file system and if the
> major usecase for this would be databases or VM images (big files)
> then the negatives of this approach might be negligible.
> 
> 
> There is also other possibility. Alasdair mentioned to be that they
> are planning to create deduplication target which should be fairly
> easy to create. This might be very useful when implementing reflink
> support for any file system. We would only need to pass down the tag
> saying that we're writing duplicate data so the target does not
> actually need to write anything.
> 
> 
> > 
> > 4)  Subvolume quotas (aka project quotas) -- Zheng
> > 
> > 5)  block improvements -- raid support / flash block size
> > 
> > 6)  Better support for non-rotating media
> >        Differences between thinp and flash?
> >        General problem: how do we measure improvements in the
> >        block allocator?
> 
> This is obviously a big problem since the "improvement" is
> inherently bound to "workload". So the main question might be what
> "workload" do we test this on ?
> 
> Having a set of micro benchmarks each for different aspect of the
> allocator might be useful, however in reality allocator will not
> have ideal condition to make its decisions and often than not the real
> workload is a combination of different things.
> 
> The other important thing when talking about testing block
> allocator is to age the file system, because we really need to know
> how well the allocator (or the file system itself) will do in the
> long run, but just immediately after mkfs. This is especially true
> for block allocation since its decisions are driven by the
> fragmentation of the free space.
> 
> Thanks!
> -Lukas
> 
> > 
> > Other more minor todo items:
> > 
> > A)  Finish integration of inline support in e2fsprogs
> > 
> > B)  Dioread nolock cleanup
> > 
> > C)  Extent status tree shrinker
> > 
> > 
> > 						- Ted
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-567540897-1386597033=:2143--
