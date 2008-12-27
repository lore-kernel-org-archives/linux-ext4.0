From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: jbd2 inside a device mapper module
Date: Sat, 27 Dec 2008 01:00:20 -0200
Message-ID: <20081227030020.GD4127@blitiri.com.ar>
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu> <20081226000005.GB4127@blitiri.com.ar> <20081226033736.GK9871@mit.edu> <20081226161708.GC4127@blitiri.com.ar> <20081226180642.GO9871@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:3806 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYL0DBy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Dec 2008 22:01:54 -0500
Content-Disposition: inline
In-Reply-To: <20081226180642.GO9871@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 26, 2008 at 01:06:42PM -0500, Theodore Tso wrote:
> On Fri, Dec 26, 2008 at 02:17:08PM -0200, Alberto Bertogli wrote:
> > 
> > At this moment I'm trying to keep it simple, so I plan to batch two for
> > each sector written to the device: one for the metadata and one for the
> > data.
> > 
> 
> I think I can pretty much guarantee that your performance will be so
> horrible that it won't be worth using.

Thanks for the warning.

I have a couple of alternatives in mind, the most decent one at the
moment is having two metadatas (M1 and M2) for the each block, and
update M1 on the first write to the given block, M2 on the second, M1 on
the third, and so on.

So, if a block has written "A" and M1 holds crc("A"), and the user wants
to write "B" to the block, I would first write crc("B") in M2, and then
write "B" to the block.

The biggest problem I can see with this approach is that I require
either a timestamp on the metadata so I can determine where to write (if
M1 or M2).

And I'm not sure if it'd perform better than the journal, tho.

Do you have any suggestions as to how can I handle this issue?


> > > Yes, this is necessary because in a production system you need to be
> > > able to identify the external journal by UUID, and the ext2/3/4
> > > superblock makes it easy to add a label, UUID, et. al.  It also
> > > significantly lowers the chance that an external journal will get
> > > misidentified as some other filesystem based on the data stored in the
> > > journal.
> > 
> > Yes, it makes sense. I've reserved the first sector for that purpose.
> 
> Why not just use the ext3/4 external journal format?

Wouldn't that lead to confusion, because people can think the device
holds an ext3/4 external journal, while it actually holds a
device-mapper backing device that happens to contain a journal?

What would be the advantages of using the ext3/4 journal format, over a
simple initial sector and the journal following?

Thanks,
		Alberto

