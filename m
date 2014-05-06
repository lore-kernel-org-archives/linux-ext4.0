From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Tue, 6 May 2014 15:23:26 -0400
Message-ID: <20140506192325.GB5012@thunk.org>
References: <1399382357-12703-1-git-send-email-lczerner@redhat.com>
 <20140506174301.GQ8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	nikola.ciprich@linuxbox.cz
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52755 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaEFTXd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 15:23:33 -0400
Content-Disposition: inline
In-Reply-To: <20140506174301.GQ8434@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2014 at 10:43:01AM -0700, Darrick J. Wong wrote:
> 
> Minor complaint: "contains" makes me think that cat'ing that file will return
> either 0 or 1, not a string of error text.  Perhaps we could shorten it to
> /sys/fs/ext4/sda/errors ?

What I'd suggest doing is simply calling it errors_count, and
returning s_error_count.  While we're at it, we could also return
s_first_error_time and s_last_error_time as well, since I imagine
those would could be quite useful for someone trying to create a
system health monitoring daemon.

Cheers,

						- Ted
