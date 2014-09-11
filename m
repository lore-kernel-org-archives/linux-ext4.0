From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: add sysfs entry showing whether the fs
 contains errors
Date: Thu, 11 Sep 2014 11:19:20 -0400
Message-ID: <20140911151920.GB26178@thunk.org>
References: <1410262340-13713-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51177 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaIKPTY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 11:19:24 -0400
Content-Disposition: inline
In-Reply-To: <1410262340-13713-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 01:32:19PM +0200, Lukas Czerner wrote:
> Currently there is no easy way to tell that the mounted file system
> contains errors other than checking for log messages, or reading the
> information directly from superblock.
> 
> This patch adds new sysfs entries:
> 
> errors_count		(number of fs errors we encounter)
> first_error_time	(unix timestamp for the first error we see)
> last_error_time		(unix timestamp for the last error we see)
> 
> If the file system is not marked as containing errors then any of the
> file will return 0. Otherwise it will contain valid information. More
> details about the errors should as always be found in the logs.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks.

					- Ted
