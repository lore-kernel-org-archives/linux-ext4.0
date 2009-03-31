From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Tue, 31 Mar 2009 08:47:16 -0400
Message-ID: <20090331124716.GG13356@mit.edu>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org> <20090211075914.GC20842@skywalker> <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com> <20090212211935.GE6922@mini-me.lan> <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com> <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com> <20090331123320.GC13356@mit.edu> <b637ec0b0903310540s10ddfdb3vcf8e419ebffa09f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chuck Ebbert <cebbert@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Fabio Comolli <fabio.comolli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59465 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZCaMrW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Mar 2009 08:47:22 -0400
Content-Disposition: inline
In-Reply-To: <b637ec0b0903310540s10ddfdb3vcf8e419ebffa09f9@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 31, 2009 at 02:40:22PM +0200, Fabio Comolli wrote:
> OK. Now I have on my box the 2.6.27.19 kernel. Do you mean that I have
> to apply 19->20, 20->21 and then this patch?

There are ext4-related fixes in the 19->20 patches.  There are no ext4
related patches in 20->21, so whether or not you do this is optional
(from the perspective of applying this patch).

> Then mount the fs as ext4dev?

Yes, same as before.  I will note that there were some enhancements
and some lower-priority bug fixes that don't get backported to 2.6.27
series, since sometimes it is extremely difficult to backport things
as far as 2.6.27.  So if your goal is to use this in production,
2.6.29 will almost certainly be a better bet.  The number of people
who test the 2.6.27 backports of ext4 are also much smaller.  We
provide it as a service those who for whatever reason refuse to update
to newer kernels, but it's hard for me to offer guarantees.

Best regards,

					- Ted
