From: Ted Ts'o <tytso@mit.edu>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
Date: Mon, 7 Feb 2011 15:44:19 -0500
Message-ID: <20110207204419.GE3457@thunk.org>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
 <20110207174552.GC3457@thunk.org>
 <4D503A06.3010403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55725 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1BGUoY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Feb 2011 15:44:24 -0500
Content-Disposition: inline
In-Reply-To: <4D503A06.3010403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 07, 2011 at 07:29:26PM +0100, Milan Broz wrote:
> 
> So it was ext4 only bug in ext4_end_bio(),
> dm-crypt per-cpu code was just trigger here, right?

There appeared to be two bugs that people were discussing on that
particular dm_crypt mail thread.  Some people were complaining about
issues with dm_crypt even when ext4 was not involved.

So I think it's fair to say that there was definitely _a_ ext4 bug
which was most easily seen when dm_crypt was in play, but which was
definitely not dm_crypt specific (it was possible to see it on an
hdd-only system, but the workload was much more severe).  In any case,
as soon as the problem was found, we disabled the ext4 optimization
in 2.6.37-rc5.

So the fact that we found and fixed an ext4 bug that was triggered by
dm_crypt should not be taken as a statement (one way or the other)
that dm_crypt is Bug-Free(tm).  :-)

					- Ted
