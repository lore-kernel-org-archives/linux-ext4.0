From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: [PATCH 1/1] lseek - SEEK_HOLE/SEEK_DATA support
Date: Tue, 17 Oct 2006 08:36:51 -0500
Message-ID: <1161092211.14171.22.camel@kleikamp.austin.ibm.com>
References: <946a3fda0610161830u2070c903h7faa93d2dda3786f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:28308 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750872AbWJQNg7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Oct 2006 09:36:59 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9HDasnQ023951
	for <linux-ext4@vger.kernel.org>; Tue, 17 Oct 2006 09:36:54 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9HDarij272148
	for <linux-ext4@vger.kernel.org>; Tue, 17 Oct 2006 09:36:54 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9HDaqGF020485
	for <linux-ext4@vger.kernel.org>; Tue, 17 Oct 2006 09:36:53 -0400
To: Eric L <e.codemonkey@gmail.com>
In-Reply-To: <946a3fda0610161830u2070c903h7faa93d2dda3786f@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2006-10-16 at 20:30 -0500, Eric L wrote:
> Hi All,
> 
> This small patch set implements the SEEK_HOLE/SEEK_DATA options to the
> lseek system call described in Jeff Bonwick's weblog -
> http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data  The first
> patch is a small change to the core VFS layer to pass through the
> options.  The second implements the actual functionality in ext3.

It's easier to reply to the patch set if the patches are sent inline in
separate emails.

> Signed-off-by: Eric Lorimer <e.codemonkey@gmail.com>

vfs_lseek.patch:

Can you add definititions of SEEK_HOLE and SEEK_DATA to fs.h?  I really
don't like that the code doesn't use the symbolic constants.

+       /* this condition is the same as: NOT (hole XOR physblock) and allows 
+        * us to search for holes and data with the same code */
+       while ( (!(hole || physblock) || (hole && physblock)) 
+                       && block < maxblock )

The comment helps, but it's still a bit confusing.  How about this?

	while ((hole ? physblock : !physblock) && (block < maxblock))

I think this is easier to conceptualize.

+                       /* we need to carry... */
+                       int lvl = 1;
+                       while ( (n-lvl > 0) && offsets[n-lvl] > ptrblock[n-lvl] ) {

How about adding parens to the second half to be more consistent?

+       switch (origin) {
+               case 4:         /* SEEK_HOLE */
+               case 3:         /* SEEK_DATA */

		case SEEK_HOLE:
		case SEEK_DATA:

+                       index = ext3_seek_holedata(inode, index, (origin-3), maxblock+1);

			index = ext3_seek_holedata(inode, index, (origin == SEEK_HOLE), maxblock + 1);

+                       if ( (index << blkshift) > inode->i_size )
+                               offset = inode->i_size;
+                       else if ( index > (offset >> blkshift) )
+                               offset = index << blkshift;
+                       break;
+               case 2:

		case SEEK_END:

+                       offset += inode->i_size;
+                       break;
+               case 1:

		case SEEK_CUR:

+                       offset += filp->f_pos;
+       }


-- 
David Kleikamp
IBM Linux Technology Center
