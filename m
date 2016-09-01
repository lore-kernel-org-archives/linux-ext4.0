From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [sparc64] sigbus in e2fsck
Date: Wed, 31 Aug 2016 21:26:20 -0400
Message-ID: <20160901012620.au5syxdjha4aedlm@thunk.org>
References: <CADxRZqwws+5t-hjO=70yP84p4+1_YYZO5ER3-=faFh1JbWjTeA@mail.gmail.com>
 <6a774a5e-b2e5-6276-c272-2b737bd098f0@physik.fu-berlin.de>
 <20160830145810.rgms25xlnatnyxir@thunk.org>
 <CADxRZqzQ+hnjVLkN+4L1u=k4iMOa_6j7UjGX-40F=uy9oUAppA@mail.gmail.com>
 <20160830191644.hoqnviqcj2odxcpu@thunk.org>
 <CADxRZqx1QQNPXyzw7qXKPGH40yA9UsvZPYHaW0=i=z_tAix2Aw@mail.gmail.com>
 <20160830202510.GA8258@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anatoly Pugachev <matorola@gmail.com>, linux-ext4@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35618 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbcIBGC5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 2 Sep 2016 02:02:57 -0400
Content-Disposition: inline
In-Reply-To: <20160830202510.GA8258@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 30, 2016 at 01:25:10PM -0700, Darrick J. Wong wrote:
> 
> AFAICT, each bh is malloc'd via e2fsck_allocate_memory and nothing seems
> to guarantee that the char b_data[1024] will be aligned to a multiple of
> 8 (it certainly isn't on x64), so I guess this isn't much of a surprise.
> 
> We could change b_data to a pointer and then posix_memalign it.

Actually, all we need to do is to rearrange the structure elements so
it looks like this:

	unsigned long long b_blocknr;
	char            b_data[1024];
};

Since b_blocknr will need to be eight byte aligned, this will also
ensure that b_data will also be aligned correctly.

       	    	   	     		- Ted




