From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] ext4: ext4_ext_convert_to_initialized bug found in
 extended FSX testing
Date: Mon, 16 May 2011 10:19:01 -0400
Message-ID: <20110516141901.GB4953@thunk.org>
References: <4DCFEC6D.1040508@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36380 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab1EPOTE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 10:19:04 -0400
Content-Disposition: inline
In-Reply-To: <4DCFEC6D.1040508@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've added this to the ext4 patch queue (dev branch).  Many thanks for
all of your work testing the punch series, and finding other bugs
while you were at it!

I'm about to start merging the punch patches into the dev branch.

Just one tiny request for the future:

On Sun, May 15, 2011 at 08:08:29AM -0700, Allison Henderson wrote:
> v1 -> v2
> - Extent is now zeroed starting from map.m_len
> - Return value changed to return the number of 
>   blocks split out
> 
> v2 -> v3
> - Corrected patch description

I really appreciate the fact that you write great commit descriptions
and keep a version history of your patches; it helps me out a lot.  If
you could move the version history to after the "---" and before the
diff stats (or actual patch if there are no diff stats), that would
make my life a just a tiny bit easier.

Awesome work, and thanks again!

							- Ted
