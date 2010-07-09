From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: Repost (from LKML): EXT3 FS and 64K blocks error
Date: Fri, 9 Jul 2010 15:32:22 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEEE@wdscexbe07.sc.wdc.com>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com> <7D7CBABC-08DF-4D5D-9655-D378529882B0@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: "Theodore Tso" <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wdscspam2.wdc.com ([129.253.170.131]:59835 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0GIWcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Jul 2010 18:32:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <7D7CBABC-08DF-4D5D-9655-D378529882B0@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 

> -----Original Message-----
> From: Theodore Tso [mailto:tytso@MIT.EDU] 
> Sent: Friday, July 09, 2010 5:04 AM
> To: Daniel Taylor
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: Repost (from LKML): EXT3 FS and 64K blocks error
> 
> 
> On Jul 8, 2010, at 8:10 PM, Daniel Taylor wrote:
> 
> > We're getting the following error with an EXT3 file sytem that
> > has 64K blocks (2.6.32.12, on a powerpc), although I don't see
> > any fixes for later kernels in a diff against 2.6.35-rc3):
> > 
> > ext3_readdir: bad entry in directory #11: rec_len is 
> smaller than minimal -
> > offset=0, inode=0, rec_len=0, name_len=0
> > 
> > That message is generated in fs/ext3/dir.c:ext3_check_dir_entry()
> > when called from fs/ext3/dir.c:ext3_readdir(), AFAICT.
> > 
> > Did something get missed when EXT3 handling for 64K blocks was
> > implemented or when a new feature was added?
> > 
> > FWIW, I do NOT see this on EXT4.
> 
> I very much doubt anyone has ever tested 64k blocks on ext3.  
> There were
> some extensions made to support 64k blocks with ext4, that had to do
> with encoding the directory entry rec_len fields (which is 16 
> bits and will
> overflow when trying to store the value 65536, as you have 
> discovered).
> 
> Bottom line, it's not so much that EXT3 handling for 64k 
> blocks was ever
> *implemented*, as much as no one really thought about it much when
> they set the #define's for maximum block size supported.  :-)
> 
> 64k block sizes hasn't received much testing on ext4 as far 
> as I know, but 
> there was one developer who noted the dirent encoding problem and
> proposed a fix.

I guess we'll find out how well they work ;)  we're putting them into
pre-production test now.  The main reason is that we're building a NAS
that will see significant use as a media server (we hope) and we do see
a performance improvement with the larger file system blocks in our
engineering tests.

> 
> Is there a particular reason why you care about this with 
> ext3?   Ext4 does
> provide a superset of the features in ext3...

We're switching to ext4.  I just thought someone might want to take
a look at the error message.  I can do some more testing, next
week, if there are suggestions of what to try.

> 
> -- Ted
> 
> 
