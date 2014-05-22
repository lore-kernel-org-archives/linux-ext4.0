From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] debugfs: fix string_to_time for MacOS strptime()
Date: Thu, 22 May 2014 17:53:03 -0400
Message-ID: <20140522215303.GC11448@thunk.org>
References: <1400625070-61813-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56499 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaEVVxH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2014 17:53:07 -0400
Content-Disposition: inline
In-Reply-To: <1400625070-61813-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 20, 2014 at 04:31:10PM -0600, Andreas Dilger wrote:
> The strptime() function does not update fields in struct tm that are
> not specified in the input format.  The glibc implementation sets the
> tm_yday field (%j) when any of the year (%Y), month (%m), or day (%d)
> fields are changed, but the MacOS strptime() does not set tm_yday in
> this case.  This caused string_to_time() to calculate the wrong Unix
> epoch on MacOS. If tm_yday is unset, compute it in string_to_time().
> 
> Signed-off-by: Andreas Dilger <adilger@dilger.ca>

Thanks, applied.

						- Ted
