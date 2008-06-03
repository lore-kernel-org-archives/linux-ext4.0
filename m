From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] ext3 : Remove redundant condition in ext3_free_blocks_sb()
Date: Tue, 3 Jun 2008 07:20:30 -0600
Message-ID: <20080603132030.GD8434@parisc-linux.org>
References: <ea11fea30805311156q7488714ftf8b0b8b8cea85b76@mail.gmail.com> <20080531190527.GG28946@ZenIV.linux.org.uk> <ea11fea30805311210o15de2373m71d91228356f9bfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34864 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYFCNUq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 09:20:46 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30805311210o15de2373m71d91228356f9bfd@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 01, 2008 at 12:40:32AM +0530, Manish Katiyar wrote:
> Oooops....my bad, but I doubt if we pass such values in ext* code anywhere.

If we have a corrupt filesystem, we can pass total garbage here.  This
check prevents that from corrupting the filesystem further.  Patch NAKed
with extreme prejudice.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
