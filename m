From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Adjust mineln with discard_granularity in
 FITRIM code
Date: Wed, 23 Feb 2011 12:58:35 -0500
Message-ID: <20110223175835.GO2924@thunk.org>
References: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
 <1297789585-5986-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41847 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1BWR6i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Feb 2011 12:58:38 -0500
Content-Disposition: inline
In-Reply-To: <1297789585-5986-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 06:06:25PM +0100, Lukas Czerner wrote:
> Discard granularity tells us the minimum size of extent to be discarded.
> Use that information to adjust minlen properly in FITRIM code. Smaller
> extents will be ignored anyway, so we can optimize by not even trying to
> discard them.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the ext4 patch queue, with a rewritten commit description.

"Always write with a deep sympathy for the reader"

	      	     	  	       - Ted

ext4: Adjust minlen with discard_granularity in the FITRIM ioctl

From: Lukas Czerner <lczerner@redhat.com>

Discard granularity tells us the minimum size of extent that can be
discard by the device.  If the user supplies a minimum extent that
should be discarded (range.minlen) which is smaller than the discard
granularity, increase minlen to the discard granularity, since there's
no point submitting trim requests that the device will reject anyway.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
