From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs: last of the incorrect direct group_desc
	accesses
Date: Sun, 6 Sep 2009 12:42:04 -0400
Message-ID: <20090906164204.GL3055@mit.edu>
References: <4AA02ECC.4010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46387 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbZIFQmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Sep 2009 12:42:07 -0400
Content-Disposition: inline
In-Reply-To: <4AA02ECC.4010101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 03, 2009 at 04:02:04PM -0500, Eric Sandeen wrote:
> This should be, I hope, the last of the fixes for accessing
> the group descriptors directly in libext2fs, at least.

Applied to the 64-bit patch set / pu branch of e2fsprogs.

	       	      	    	   	- Ted

