From: Forrest Liu <forrestl@synology.com>
Subject: Re: [PATCH 3/3] e2fsck: make sure the extent tree is consistent after
 bogus node in the tree
Date: Fri, 21 Dec 2012 19:02:44 +0800
Message-ID: <CAJSVwFPUnfc+h-KVxkQeh-jWb92Dr6mUTCFzosyVMdo24eNCqQ@mail.gmail.com>
References: <20121220234229.GA22476@thunk.org>
	<1356047023-28367-1-git-send-email-tytso@mit.edu>
	<1356047023-28367-3-git-send-email-tytso@mit.edu>
	<20121221031956.GB5014@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:52380 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab2LULCp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2012 06:02:45 -0500
Received: by mail-ia0-f182.google.com with SMTP id x2so3782228iad.41
        for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2012 03:02:44 -0800 (PST)
In-Reply-To: <20121221031956.GB5014@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have test these patches, and they work fine.
Thanks for the tip
                                             - Forrest

2012/12/21 Theodore Ts'o <tytso@mit.edu>:
> And here is the test case....
>
> BTW, #protip: You can use the split_node command in tst_extents
> debugging program not only to perform node splits (which will make the
> tree wider), but if you try splitting at the root node, it will
> allocate a new extent tree block, and then move all of the extent tree
> nodes at the top-level, in the inode, into the new exterior extent
> tree block.  In effect, this will make the tree deeper.
>
> This should allow you to make fairly arbitrarily deep and complex
> extent trees by hand, without having to resort to using fallocate and
> punch hole commands, which tend to take a lot longer than using the
> "insert_extent", "replace_extent", and "split_node" commands in
> tst_extent when creating test cases.
>
> This also makes it easier to create small test file system images so
> we don't have to bloat the e2fsprogs source tree with huge test file
> systems in our regression test suite (which also tend to very much
> slow down running said regression test suite).
>
> Regards,
>
>                                                - Ted
>
