From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Use of consistent types in e2fsprogs
Date: Tue, 17 May 2011 06:36:11 -0400
Message-ID: <659D100F-7365-403A-8166-4FDF2B45AFBF@mit.edu>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca> <20110517011648.GC4953@thunk.org> <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:48542 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836Ab1EQKgW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 06:36:22 -0400
In-Reply-To: <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On May 17, 2011, at 1:04 AM, Andreas Dilger wrote:

> I'm not suggesting a global search & replace of "long long" or anything.
> However, the current mish-mash of int vs. long vs. dgrp_t for group numbers,
> __u64 vs blk64_t, etc doesn't make it clear when something is intentionally
> that type, or just happens to be working for now.  Having separate types
> for groups vs. physical blocks vs. logical blocks as we do in the kernel
> will improve the quality of the code itself, I think.

But you are talking about doing a global search and replace of "e2_blkcnt_t"
for something else like "ext2_logblk_t", aren't you?   If we need to better
document all of the types, yes, that will probably help.

But I don't see how a global search and replace of "dgrp_t" for "ext2_group_t"
is going to help us find the places where a group number was assigned to
an int.

Yes, the naming scheme is inconsistent.   e2fsprogs is a very old code base,
and many of these decisions were made a very long time ago.  But I don't
see how a global search and replace of one typedef name for another will
_find _bugs_.   It won't help in the cases where we used a raw type, and it
won't help where we accidentally used the wrong typedef'ed name.

It might help a new comer to the code base when they are writing new code,
yes.   So would better documentation.   Against that we have to weigh
the cost of the code churn, and the fact that patches to the maint branch
won't be easily pulled to master, etc.

-- Ted


