From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Thu, 5 Oct 2006 16:25:39 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0610051619540.3952@g5.osdl.org>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com>
 <20061005131939.ccd1fd48.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:5320 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751445AbWJEXZn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Oct 2006 19:25:43 -0400
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20061005131939.ccd1fd48.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Thu, 5 Oct 2006, Andrew Morton wrote:
> 
> Linus, what's the best way of doing this?  Will git dtrt with a patch which
> copies files, or would a script which does the mkdir's and cp's be better?

Git should dtrt.

In fact, if you use

	git diff -C

it should generate the appropriate "file copied" things automatically, and 
you don't need any huge file at all, you'll get a "patch" that looks 
something like

	diff --git a/fs/ext3/inode.c b/fs/ext4/inode.c
	similarity index 100%
	copy from fs/ext3/inode.c
	copy to fs/ext4/inode.c
	diff --git a/fs/ext3/super.c b/fs/ext4/super.c
	similarity index 98%
	copy from fs/ext3/super.c
	copy to fs/ext4/super.c
	index xyz..zzy 100644
	--- a/fs/ext3/super.c
	+++ b/fs/ext4/super.c
	  .. small diff that changes "ext3" to "ext4" goes here ..


ie you'll effectively get the best of both worlds: a "diff", but one that 
is actually readable and shows what is going on.

I hate to beat my own drum (not really), but git really _is_ a lot better 
than anything else out there ;)

		Linus
