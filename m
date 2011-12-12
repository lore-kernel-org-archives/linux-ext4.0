From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix crash due to getting bogus eh_depth value
Date: Mon, 12 Dec 2011 11:00:40 -0500
Message-ID: <20111212160040.GB4243@thunk.org>
References: <20111212104952.GA14659@bloggs.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35171 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1LLQAm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Dec 2011 11:00:42 -0500
Content-Disposition: inline
In-Reply-To: <20111212104952.GA14659@bloggs.ozlabs.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 12, 2011 at 09:49:52PM +1100, Paul Mackerras wrote:
> Commit 1939dd84b3 ("ext4: cleanup ext4_ext_grow_indepth code") added a
> reference to ext4_extent_header.eh_depth, but forget to pass the value
> read through le16_to_cpu.  The result is a crash on big-endian
> machines, such as this crash on a POWER7 server:

Thanks for finding this!  While I was driving to work I had started
thinking that 0x0101 was a very suspicious number, and I was thinking
that it might have been a missing byte swap somewhere.

I'll get this pushed to Linus ASAP as a regression fix.

     	      				- Ted
