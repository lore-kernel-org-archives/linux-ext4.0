From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: count hits/misses of extent cache and expose in
 sysfs.
Date: Sun, 22 May 2011 21:30:29 -0400
Message-ID: <20110523013029.GF10009@thunk.org>
References: <1305671213-7624-1-git-send-email-haldar@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vivek Haldar <haldar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60792 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1EWBad (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 May 2011 21:30:33 -0400
Content-Disposition: inline
In-Reply-To: <1305671213-7624-1-git-send-email-haldar@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 17, 2011 at 03:26:53PM -0700, Vivek Haldar wrote:
> The number of hits and misses for each filesystem is exposed in
> /sys/fs/ext4/<dev>/extent_cache_{hits, misses}.
> 
> Tested: fsstress, manual checks.
> Signed-off-by: Vivek Haldar <haldar@google.com>

Added to the ext4 tree, thanks.

-- Ted
