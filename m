From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: jbd2 inside a device mapper module
Date: Sat, 27 Dec 2008 14:29:50 -0500
Message-ID: <20081227192950.GB30198@mit.edu>
References: <20081224211038.GT4127@blitiri.com.ar>
	<20081224234915.GA23723@mit.edu>
	<20081225143535.GA4127@blitiri.com.ar>
	<20081225155248.GJ9871@mit.edu>
	<20081226000005.GB4127@blitiri.com.ar>
	<20081226033736.GK9871@mit.edu>
	<20081226161708.GC4127@blitiri.com.ar>
	<20081226180642.GO9871@mit.edu>
	<20081227030020.GD4127@blitiri.com.ar>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081227030020.GD4127@blitiri.com.ar>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 27, 2008 at 01:00:20AM -0200, Alberto Bertogli wrote:
> I have a couple of alternatives in mind, the most decent one at the
> moment is having two metadatas (M1 and M2) for the each block, and
> update M1 on the first write to the given block, M2 on the second, M1 on
> the third, and so on.

I don't see how this would help.  You still have to do synchronous
writes for safety, which is what is going to kill your performance.

What you want to do is to batch as many writes as possible.  Until the
underlying filesystem requests a flush, you can afford to hold off
writing the block to disk.  Otherwise, you'll end up turning each 4k
write into two 8k synchronous writes, which will be a performance
disaster.  If you hold off, it's much more likely that the you'll be
able to patch a large number of blocks into a single transaction.
Also, if a block gets modified multiple times (for example, with an
inode table block where tar writes one file, and then another), if you
hold off the write as long as possible, you can only write the inode
table block once, instead of multiple times.

Note that this means that you have to wait until the last minute to
calculate the checksum, since the buffer could be modified after the
write request.  OCFS2 does this, by using a commit-time callback to
calculate the checksums used.

The bottom line doing something like this in an efficient way is
tricky.

> > Why not just use the ext3/4 external journal format?
> 
> Wouldn't that lead to confusion, because people can think the device
> holds an ext3/4 external journal, while it actually holds a
> device-mapper backing device that happens to contain a journal?

Not really; the external journal has a label and uuid, and the journal
superblock has a place to store the uuid of the "client" of the
journal.  So there is plenty of information available to tie an
external journal to some device-mapper backing device.

> What would be the advantages of using the ext3/4 journal format, over a
> simple initial sector and the journal following?

There already existing tools to find the external journal, using the
blkid library.  So you only have to store the UUID of the journal in
the superblock of the device-mapper backing device, and then you can
easily find the external journal as follows:

       journal_fn = blkid_get_devname(ctx->blkid, "UUID", uuid);

       		    				  	  - Ted
