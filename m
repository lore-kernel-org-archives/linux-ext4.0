From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: The patch at 'patchwork.ozlabs.org/patch/192079'
Date: Mon, 22 Oct 2012 00:42:52 -0400
Message-ID: <20121022044252.GE4768@thunk.org>
References: <507FE1C9.3070301@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Volodymyr Mieshkov <volodymyr.mieshkov@ti.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56752 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2JVEm6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2012 00:42:58 -0400
Content-Disposition: inline
In-Reply-To: <507FE1C9.3070301@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 18, 2012 at 02:02:33PM +0300, Volodymyr Mieshkov wrote:
> Hi,
> 
> My name is Volodymyr. Sorry, I don't know your name, but I'd like to
> ask you about some issue.
> Recently I got an Linux kernel panic on my system and submitted the
> patch to prevent it here: http://patchwork.ozlabs.org/patch/192079/.
> Before that I found at one of the forum a thread that described a
> similar problem,
> and you suggested the patch to fix it:
> http://www.gossamer-threads.com/lists/linux/kernel/1326686.
> I used your idea, and I would like to re-submit the path with your
> authorship.
> Sorry, I must ask you before I've submitted the patch. I don't want
> to break your authorship.

Hi Volodymyr,

The patch which I suggested in the thread which you referenced was
intended to debug the bug to find the real root cause of the issue.
If in fact the WARN() is triggering on your 3.0 system, then there's a
bug that we should be trying to fix.

Instead of using this patch to paper over the problem, I'd much rather
see if we can figure out why jinode was NULL in the first place.  Can
you reliably reproduce this failure?

Regards,

					- Ted
