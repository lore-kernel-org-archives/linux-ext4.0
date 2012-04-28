From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata
 checksumming
Date: Sat, 28 Apr 2012 10:19:33 -0400
Message-ID: <20120428141933.GB29481@thunk.org>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
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
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 06, 2012 at 12:49:41PM -0800, Darrick J. Wong wrote:
> @@ -177,11 +189,17 @@ typedef struct journal_block_tag_s
>  	__be32		t_blocknr;	/* The on-disk block number */
>  	__be32		t_flags;	/* See below */
>  	__be32		t_blocknr_high; /* most-significant high 32bits. */
> +	__be32		t_checksum;	/* crc32c(uuid+seq+block) */
>  } journal_block_tag_t;
>  
>  #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
>  #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))

There's a problem with this patch here --- we are changing the size of
journal_block_tag_t, which is an on-disk data structure.  So for
64-bit journals, this represents a format change.  This means that if
you have a 64-bit file system that needs to have its journal
recovered, if the journal was written with an older kernel, and then
we try to recover it with a new kernel, things won't be good.
Similarly, for e2fsck's recovery code, it's not going to be able to
recover 64-bit file systems using current coding, since this patch
series changes the size of JBD2_TAG_SIZE64.

What we need to do is something like this:

#define JBD2_TAG_SIZE64 (offsetof(journal_block_tag_t, t_checksum))
#define JBD2_TAG_SIZE_CSUM (sizeof(journal_block_tag_t))

And then change the code appropriately in e2fsprogs and in the kernel
to use the correct tag size depending on the journal options.

       	   	       	    	      	     - Ted
