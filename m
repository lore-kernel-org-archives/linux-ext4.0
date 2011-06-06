From: Ted Ts'o <tytso@mit.edu>
Subject: Re: big allocation status
Date: Mon, 6 Jun 2011 19:04:21 -0400
Message-ID: <20110606230421.GF20818@thunk.org>
References: <4DE83F83.6070302@tao.ma>
 <20110604033805.GD2614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57407 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1FFXEZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 19:04:25 -0400
Content-Disposition: inline
In-Reply-To: <20110604033805.GD2614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 03, 2011 at 11:38:05PM -0400, Ted Ts'o wrote:
> On Fri, Jun 03, 2011 at 09:57:23AM +0800, Tao Ma wrote:
> > Hi Ted,
> > 
> > Do you have any new branch or patch set that can be used for testing
> > about big allocation? The latest patch set in the mailist is what you
> > have sent at the beginning of May. Do you have an updated one? We will
> > try to test it soon and it would grateful if we are on the same page.
> 
> There is a patch set available at:
> 
> git://repo.or.cz/ext4-patch-queue.git
> 
> The bigalloc patches are after the stable-boundary, and will apply
> against 3.0-rc1.

I've updated the bigalloc patch set to fix a number of bugs that I and
a colleague of mine at Google have found.

This patch set known have problems with i_blocks getting out of sync
if delalloc is enabled (particularly with sparse files and truncates),
and as mentioned before, doesn't work correctly with the punch ioctl.
These are bugs that we plan to fix before anything gets pushed into
upstream, of course.

	      					- Ted
