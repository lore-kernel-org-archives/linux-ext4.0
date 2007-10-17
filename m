From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 update
Date: Wed, 17 Oct 2007 08:59:53 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0710170857490.26902@woody.linux-foundation.org>
References: <E1Ii0UI-0007TW-IM@closure.thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935507AbXJQQAn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 12:00:43 -0400
In-Reply-To: <E1Ii0UI-0007TW-IM@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Wed, 17 Oct 2007, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This conflicts in nontrivial ways with

	commit 7c9e69faa28027913ee059c285a5ea8382e24b5d
	Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
	Date:   Tue Oct 16 23:27:02 2007 -0700

	    ext2/ext3/ext4: add block bitmap validation

which I just merged from -mm.

I suspect it's trivial to fix up for somebody who knows/understands the 
code, but I'm not that person, and I cannot verify the end result.

So can you please do the merge, and I'll pull the merged tree?

		Linus
