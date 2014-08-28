From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Refreshing after OOB file update?
Date: Thu, 28 Aug 2014 19:32:37 -0400
Message-ID: <20140828233237.GA31174@thunk.org>
References: <53FF3E90.1060200@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rob Harris <rob.harris@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54900 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbaH1Xcj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Aug 2014 19:32:39 -0400
Content-Disposition: inline
In-Reply-To: <53FF3E90.1060200@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 28, 2014 at 10:37:04AM -0400, Rob Harris wrote:
> 
> This tells me (probably naively) that the kernel is caching the old file
> contents.

Yes, that's what the page cache is all about.

> Is there a way for me to tell the file system that something out-of-band
> change a file contents and to force a re-read from the disk?

Have your userspace program do an O_DIRECT read.  That will discard
the page cache and do a direct read from the disk.

Cheers,

							- Ted
