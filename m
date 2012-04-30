From: djwong <djwong@us.ibm.com>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata
 checksumming
Date: Mon, 30 Apr 2012 08:53:41 -0700
Message-ID: <20120430155341.GC6938@tux1.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
 <20120428141933.GB29481@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Ted Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35246 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2D3Pyi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2012 11:54:38 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 30 Apr 2012 09:54:33 -0600
Content-Disposition: inline
In-Reply-To: <20120428141933.GB29481@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 28, 2012 at 10:19:33AM -0400, Ted Ts'o wrote:
> On Tue, Mar 06, 2012 at 12:49:41PM -0800, Darrick J. Wong wrote:
> > @@ -177,11 +189,17 @@ typedef struct journal_block_tag_s
> >  	__be32		t_blocknr;	/* The on-disk block number */
> >  	__be32		t_flags;	/* See below */
> >  	__be32		t_blocknr_high; /* most-significant high 32bits. */
> > +	__be32		t_checksum;	/* crc32c(uuid+seq+block) */
> >  } journal_block_tag_t;
> >  
> >  #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
> >  #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))
> 
> There's a problem with this patch here --- we are changing the size of
> journal_block_tag_t, which is an on-disk data structure.  So for
> 64-bit journals, this represents a format change.  This means that if
> you have a 64-bit file system that needs to have its journal
> recovered, if the journal was written with an older kernel, and then
> we try to recover it with a new kernel, things won't be good.
> Similarly, for e2fsck's recovery code, it's not going to be able to
> recover 64-bit file systems using current coding, since this patch
> series changes the size of JBD2_TAG_SIZE64.
> 
> What we need to do is something like this:
> 
> #define JBD2_TAG_SIZE64 (offsetof(journal_block_tag_t, t_checksum))
> #define JBD2_TAG_SIZE_CSUM (sizeof(journal_block_tag_t))
> 
> And then change the code appropriately in e2fsprogs and in the kernel
> to use the correct tag size depending on the journal options.

Oops.  I forgot to update JBD2_TAG_SIZE64.

I have a question, though -- it looks as though the code that handles reading
and writing tags from raw disk blocks calls journal_tag_bytes() to determine
the tag size, and manually increments a pointer "tagp" to step through the
block.  This construction seems to be be sufficient to deal with possible
differences between sizeof(journal_block_tag_t) and the on-disk tag size, and
both increases over the 32bit tag size are gated on INCOMPAT_64BIT and
INCOMPAT_CSUM_V2.

Had I defined JBD2_TAG_SIZE64 with offsetof() as Ted did above, I think that
journal_tag_bytes() would return the correct on-disk tag size, which should fix
the scenario Ted outlined above.  The tag checksum set/verify functions would
also need to be taught where t_checksum is (in the space occupied by
t_blocknr_high) on a 32bit journal.  Could those two suggestions fix the
problem without causing us to discard half the checksum bits?



Well, not quite -- the calculation of tags per block in journal.c below the
comment "journal descriptor can store up to n blocks -bzzz" probably ought to
be using journal_tag_bytes(), not sizeof(journal_block_tag_t) to figure out how
many tags can be crammed into a disk block, since right now I think it
underreports the number of tags per block on a 32bit journal.
journal_tag_disk_size() is a more descriptive name for journal_tag_bytes().

As for putting half the checksum into the upper 16 bits of the flags field --
is journal space at such a premium that we need to overload the field and
reduce the strength of the checksum?  Enabling journal checksums on a 4k block
filesystem causes tags_per_block to decrease from 512 to 341 on a 32bit journal
and from 341 to 256 on a 64bit journal.  Do transactions typically have that
many blocks?  I didn't think most transactions had 1-2MB of dirty data.

--D
> 
>        	   	       	    	      	     - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

