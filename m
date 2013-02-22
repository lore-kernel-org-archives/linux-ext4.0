From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix free clusters calculation in bigalloc
 filesystem
Date: Fri, 22 Feb 2013 00:10:48 -0500
Message-ID: <20130222051048.GC13667@thunk.org>
References: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49391 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3BVFKx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2013 00:10:53 -0500
Content-Disposition: inline
In-Reply-To: <1361433665-16880-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2013 at 09:01:05AM +0100, Lukas Czerner wrote:
> 
> Moreover when calculating number of root clusters we should be using
> macro EXT4_NUM_B2C() instead of EXT4_C2B() otherwise the result will
> usually be off by one.

That should be "instead of EXT4_B2C()", and I don't think this is
true, since the number of blocks should always be a multiple of the
cluster ratio.  So the use of EXT4_B2C() is a bit of an optimization
(it avoids an add and mask operation), but it's probably not a
measurable optimizatoin in practice.

							- Ted
