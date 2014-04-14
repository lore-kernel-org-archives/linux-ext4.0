From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] build: fix miscellaneous build warnings
Date: Mon, 14 Apr 2014 12:23:21 -0400
Message-ID: <20140414162321.GB26487@thunk.org>
References: <1395384462-30244-1-git-send-email-andreas.dilger@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <andreas.dilger@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54196 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaDNQX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Apr 2014 12:23:26 -0400
Content-Disposition: inline
In-Reply-To: <1395384462-30244-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 21, 2014 at 12:47:42AM -0600, Andreas Dilger wrote:
> Fix various unused variable and use-uninitialized warnings.
> 
> Add generated files into .gitignore.
> 
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>

Thanks, applied.

					- Ted
