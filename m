From: tytso@mit.edu
Subject: Re: [incomplete PATCH] ext4: avoid overflow in fiemap
Date: Sat, 6 Mar 2010 22:38:18 -0500
Message-ID: <20100307033818.GA6241@thunk.org>
References: <1267553925-6308-1-git-send-email-tytso@mit.edu>
 <1267553925-6308-12-git-send-email-tytso@mit.edu>
 <4B8E1410.1010107@rs.jp.nec.com>
 <20100303175217.GA3530@thunk.org>
 <4B8F47C6.9060408@rs.jp.nec.com>
 <1267739098.4204.12.camel@michlmayr>
 <1267741715.13886.4.camel@michlmayr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57126 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0CGDiY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Mar 2010 22:38:24 -0500
Content-Disposition: inline
In-Reply-To: <1267741715.13886.4.camel@michlmayr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 04, 2010 at 11:28:35PM +0100, Leonard Michlmayr wrote:
> A __u32 cannot hold the maximum number of blocks in a file. This may
> lead to an overflow if a fiemap request has length = s_maxbytes.
> 
> I still get a segfault, I have to go through it again. This is just for
> your information. I will work on it tomorrow.

Check and see if it's still a problem with what I ultimately ended up
pushing to Linus.  Yes, the way I chose to fix things means that we'll
never do more than 2**32-1 blocks at a time with fiemap, but in
practice there's a limit to the number of extents that can be returned
in a single fiemap call anyway, so in practice this shouldn't be a
problem.

						- Ted
