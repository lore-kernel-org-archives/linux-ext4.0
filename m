From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6 -v3] libext2fs: add ext2fs_bitcount() function
Date: Tue, 27 Nov 2012 14:37:49 -0500
Message-ID: <20121127193749.GA19085@thunk.org>
References: <1353947981-15219-1-git-send-email-tytso@mit.edu>
 <1353947981-15219-4-git-send-email-tytso@mit.edu>
 <20121126231745.GH23854@lenny.home.zabbo.net>
 <20121127014505.GB25222@thunk.org>
 <20121127051617.GA7080@thunk.org>
 <20121127175023.GI23854@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zach Brown <zab@zabbo.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35189 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab2K0Th6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 14:37:58 -0500
Content-Disposition: inline
In-Reply-To: <20121127175023.GI23854@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 27, 2012 at 09:50:23AM -0800, Zach Brown wrote:
> 
> Agreed.  I'll chuck it at the end of my fun-projects-some-day list as
> well, but getting it right for all the platforms that e2fsprogs
> supports.. meh :).

It's not strictly necessary to get things right for all platforms; we
already have some accelerations using asm statements which only work
for one platform already --- although it's already the case that I
didn't bother to make 64-bit set/clear/test bit optimizations for x86,
mainly because I didn't think it was worth it, especially on modern
CPU's.  (And with the red/black tree backend for bitmaps, the asm
bitops are even less important.)

							- Ted
