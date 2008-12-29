From: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: Re: jbd2 inside a device mapper module
Date: Mon, 29 Dec 2008 19:30:38 -0200
Message-ID: <20081229213038.GO4127@blitiri.com.ar>
References: <20081224211038.GT4127@blitiri.com.ar> <20081224234915.GA23723@mit.edu> <20081225143535.GA4127@blitiri.com.ar> <20081225155248.GJ9871@mit.edu> <20081226000005.GB4127@blitiri.com.ar> <20081226033736.GK9871@mit.edu> <20081226161708.GC4127@blitiri.com.ar> <20081226180642.GO9871@mit.edu> <20081227030020.GD4127@blitiri.com.ar> <20081227192950.GB30198@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:4678 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbYL2Vbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Dec 2008 16:31:48 -0500
Content-Disposition: inline
In-Reply-To: <20081227192950.GB30198@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 27, 2008 at 02:29:50PM -0500, Theodore Tso wrote:
> On Sat, Dec 27, 2008 at 01:00:20AM -0200, Alberto Bertogli wrote:
> > I have a couple of alternatives in mind, the most decent one at the
> > moment is having two metadatas (M1 and M2) for the each block, and
> > update M1 on the first write to the given block, M2 on the second, M1 on
> > the third, and so on.
> 
> I don't see how this would help.  You still have to do synchronous
> writes for safety, which is what is going to kill your performance.

I was thinking of queueing the writes to the metadata, and then queue
the writes of the data marked with bio_barrier(); when the data write
completes I end the original bio.

Although if they metadata is on a different device, I do have to wait
for the metadata to be written because the barrier is useless; but OTOH
if I use a journal I can't split my data and metadata in two different
devices, can I? (without using two journals or doing more complex
stuff).


> What you want to do is to batch as many writes as possible.  Until the
> underlying filesystem requests a flush, you can afford to hold off
> writing the block to disk.  Otherwise, you'll end up turning each 4k

I think I can't do this at the device-mapper layer. There's a .flush
function pointer, but I think it's suspend-related; and in any case I
gave it a try and it's never called during normal operation.


> > > Why not just use the ext3/4 external journal format?
> > 
> > Wouldn't that lead to confusion, because people can think the device
> > holds an ext3/4 external journal, while it actually holds a
> > device-mapper backing device that happens to contain a journal?
> 
> Not really; the external journal has a label and uuid, and the journal
> superblock has a place to store the uuid of the "client" of the
> journal.  So there is plenty of information available to tie an
> external journal to some device-mapper backing device.
> 
> > What would be the advantages of using the ext3/4 journal format, over a
> > simple initial sector and the journal following?
> 
> There already existing tools to find the external journal, using the
> blkid library.  So you only have to store the UUID of the journal in
> the superblock of the device-mapper backing device, and then you can
> easily find the external journal as follows:
> 
>        journal_fn = blkid_get_devname(ctx->blkid, "UUID", uuid);

Thanks a lot for the suggestions!

As I said in the other email, I'll give the writes a try and see how it
goes. If their performance suck (what, from what you tell me, it's
likely) at least I'll have something that works.

Thanks a lot,
		Alberto

