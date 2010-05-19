From: tytso@mit.edu
Subject: Re: [PATCH] e2fsck: correct test for EOFBLOCKS
Date: Wed, 19 May 2010 15:08:31 -0400
Message-ID: <20100519190831.GI18161@thunk.org>
References: <4BF42BDD.9090301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52789 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0ESTIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 May 2010 15:08:37 -0400
Content-Disposition: inline
In-Reply-To: <4BF42BDD.9090301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 19, 2010 at 01:20:13PM -0500, Eric Sandeen wrote:
> This test, added to e2fsprogs-1.41.12, is backwards.
> 
> If EOFBLOCKS is set, then the size -should- be less than
> the last physical block...
> 
> xfstests 013 caught this.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Oops, *blush*.   Applied and pushed out.

There will likely be a 1.41.13 happening next week.  Let me know ASAP
if there are any other mistakes or patches that you think should go in
to the release.

      		 	     	    - Ted

