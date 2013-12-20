From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: possible unintended integer truncation in
 fs/ext4/extents.c:get_implied_cluster_alloc
Date: Thu, 19 Dec 2013 23:59:20 -0500
Message-ID: <20131220045920.GB23508@thunk.org>
References: <52ACDBBE.32014.145F911E@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, re.emese@gmail.com
To: PaX Team <pageexec@freemail.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41870 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3LTE7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Dec 2013 23:59:25 -0500
Content-Disposition: inline
In-Reply-To: <52ACDBBE.32014.145F911E@pageexec.freemail.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 14, 2013 at 11:29:18PM +0100, PaX Team wrote:
> Hello folks,
> 
> while running a simple analyzer plugin on linux 3.12.5 written by Emese Revfy
> we found a case in ext4 that looks like a potential problem. the code looks
> like this:
> 
> 4082 		map->m_pblk = (ee_start & ~(sbi->s_cluster_ratio - 1)) +
> 4083 			c_offset;
> 
> here the expression ~(sbi->s_cluster_ratio - 1) will first do the negation
> on an unsigned int then extend the result to unsigned long long (i.e, there's
> a 32->64 bit conversion on both 32 and 64 bit archs) and stores it as such.
> now this will obviously lose the higher 32 bits of ee_start and the question
> is: is this intended behaviour or a bug? later the code compares map->m_pblk
> against ee_block which is as unsigned int only so there's some mixture of
> integer types here that may warrant further review.

So C's integer promotion and sign extension rules are very obscure and
confusing, and that may be a reason why we should put in an explicit
cast, but it looks like the right thing is happening here.  Here's a
test program --- what am I missing?

					- Ted

#include <stdio.h>

typedef unsigned long long ext4_fsblk_t;


/* Mask out the the low */
#define EXT4_PHYS_CMASK(cr, pblk) (pblk & \
				    ~((ext4_fsblk_t) cr - 1))

int main(int argc, char **argv)
{

	ext4_fsblk_t	b, pblk;
	unsigned short	cr = 32;
	

	pblk = 0x123456789ABC;
	printf("%llx\n", pblk);

	b = ~(cr - 1);
	printf("%llx\n", b);

	b = (pblk & ~(cr - 1));
	printf("%llx\n", b);

	b = EXT4_PHYS_CMASK(cr, pblk);
	printf("%llx\n", b);

	return 0;
}
