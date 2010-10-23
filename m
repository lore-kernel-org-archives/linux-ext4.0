From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 0/6] ext4: use the bio layer directly
Date: Sat, 23 Oct 2010 19:03:39 -0400
Message-ID: <20101023230338.GD24650@thunk.org>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40281 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0JWXDl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 19:03:41 -0400
Content-Disposition: inline
In-Reply-To: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 23, 2010 at 04:40:14PM -0400, Theodore Ts'o wrote:
> This set of patches passes xfstests for both 1k and 4k block sizes.  For
> streaming I/O writes, it reduces the number of block I/O queue
> submissions by a factor of 1024 in the ideal case.  (i.e., instead of
> submitting 4k requests at a time, we can now submit up to 512k writes at
> a time, a 128 factor of improvement.)

Sigh, this paragraph isn't quite right.  Let me reword:

This set of patches passes xfstests for both 1k and 4k block sizes.  For
streaming I/O writes, it reduces the number of block I/O queue
submissions by a factor of 128 in the ideal case.  (i.e., instead of
submitting 4k requests at a time, we can now submit up to 512k writes at
a time.)

						- Ted
