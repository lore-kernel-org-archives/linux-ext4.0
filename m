From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Date: Thu, 21 Jul 2011 18:57:38 -0400
Message-ID: <20110721225738.GA25092@thunk.org>
References: <20110720175918.GB17971@thunk.org>
 <20110721090619.GA26263@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38940 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab1GUW5n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jul 2011 18:57:43 -0400
Content-Disposition: inline
In-Reply-To: <20110721090619.GA26263@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 05:06:19AM -0400, Christoph Hellwig wrote:
> 
> I works fine for me on various releases of Debian, Fedsora, RHEL and
> SLES.  But all he machines I've quickly checked seem to have an autoconf
> that can handle -I, so could you please send this pach with a proper
> signoff and description?

I figured what the core problem is.  There's a subtle and hidden
dependency in xfsprogs for an autoconf version which is 2.50 or above.
In Debian and Ubuntu, if autoconf 2.13 is installed, autoconf will try
to automatically figure out whether the configure.in requires 2.13 or
2.50 (since the autoconf maintainers didn't understand the concept of
"backwards compatibility").  Unfortunately, it got this wrong.

Using an explicit AC_PREREQ(2.50) fixes this.  I'll be sending patches
shortly....

						- Ted
