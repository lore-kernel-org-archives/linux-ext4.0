From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Remove VLAIS usage from JBD2 code
Date: Tue, 30 Oct 2012 15:00:32 -0400
Message-ID: <20121030190032.GB5044@thunk.org>
References: <1351622404-18214-1-git-send-email-behanw@converseincode.com>
 <1351622404-18214-2-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58500 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934036Ab2J3TAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 15:00:35 -0400
Content-Disposition: inline
In-Reply-To: <1351622404-18214-2-git-send-email-behanw@converseincode.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 30, 2012 at 02:40:04PM -0400, Behan Webster wrote:
> From: Mark Charlebois <charlebm@gmail.com>
> 
> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
> precludes the use of compilers which don't implement VLAIS (for instance the
> Clang compiler). Since ctx is always a 32-bit CRC, hard coding a size of 4
> bytes accomplishes the same thing without the use of VLAIS. This is the same
> technique already employed in fs/ext4/ext4.h
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>

That's reasonable, but in order to be safe to make sure we don't
accidentally introduce a stack overrun bug at some point in the
future, we should do something like this instead

+	#define JBD_MAX_CHECKSUM_SIZE 4
	.
	.
	.

-		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
+		char ctx[JBD_MAX_CHECKSUM_SIZE];
	.
	.
	.
+		BUG_ON(crypto_shash_descsize(journal->j_chksum_driver) >
+ 		       JBD_MAX_CHECKSUM_SIZE);


I just like being careful and paranoid; using magic numeric constants
for buffer sizes is just a scary thing to do.  If you could resubmit
the patch with this change, I'd really appreciate it.  Thanks!!

    	       	    	    	       - Ted
