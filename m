From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: inline_data feature
Date: Fri, 24 Jan 2014 11:21:13 -0500
Message-ID: <20140124162113.GA11421@thunk.org>
References: <loom.20140122T171340-153@post.gmane.org>
 <loom.20140124T170451-340@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ian Nartowicz <claws@nartowicz.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51317 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaAXQVR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Jan 2014 11:21:17 -0500
Content-Disposition: inline
In-Reply-To: <loom.20140124T170451-340@post.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 24, 2014 at 04:05:48PM +0000, Ian Nartowicz wrote:
> > I have been trying to test the inline_data feature of EXT4.  I am using
> > kernel 3.9.5 and have compiled e2fsprogs from the pu branch.  I am able to
> > set the feature and apparently to use the filesystem, but I get a lot of
> > warnings from the kernel and fsck reports several errors and then crashes.
> 
> Seems like fsck is the culprit.  No errors until I try to check the filesystem.

Can you send us the fsck transcript?

Thanks,

					- Ted
