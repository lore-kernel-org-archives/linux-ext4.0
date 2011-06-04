From: Ted Ts'o <tytso@mit.edu>
Subject: Re: big allocation status
Date: Fri, 3 Jun 2011 23:38:05 -0400
Message-ID: <20110604033805.GD2614@thunk.org>
References: <4DE83F83.6070302@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54887 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1FDDiJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2011 23:38:09 -0400
Content-Disposition: inline
In-Reply-To: <4DE83F83.6070302@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 03, 2011 at 09:57:23AM +0800, Tao Ma wrote:
> Hi Ted,
> 
> Do you have any new branch or patch set that can be used for testing
> about big allocation? The latest patch set in the mailist is what you
> have sent at the beginning of May. Do you have an updated one? We will
> try to test it soon and it would grateful if we are on the same page.

There is a patch set available at:

git://repo.or.cz/ext4-patch-queue.git

The bigalloc patches are after the stable-boundary, and will apply
against 3.0-rc1.

Note that I've fixed them up so that they apply on top of the punch
changes; however, the punch ioctl will not work correctly if bigalloc
is enabled, since that hasn't been fixed up yet.

Also, I'm still working on the e2fsprogs support.

						- Ted
