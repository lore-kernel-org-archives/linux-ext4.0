From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Remove arbitrary block value in
 __es_remove_extent()
Date: Thu, 17 Apr 2014 12:19:44 -0400
Message-ID: <20140417161944.GJ18591@thunk.org>
References: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56685 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaDQQTr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 12:19:47 -0400
Content-Disposition: inline
In-Reply-To: <1397585302-27175-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 08:08:21PM +0200, Lukas Czerner wrote:
> In __es_remove_extent() we're storing seemingly arbitrary value
> 0x7FDEADBEEF into block variable. I assume that the reason is just to
> initialize the variable before the use because the actual value does not
> matter at this point.
> 
> Just remove the arbitrary value and initialized block variable to zero
> which is much less suspicious.

The whole point was for the value to be suspicious.  That way, if
there is a bug, and we try to use that value, it is a large enough
value that for most storage devices, we will get an I/O error (because
the disk isn't that big :-) referencing that block value, and we'll
have a bit of a hint where that suspicious value might have come from.

       	      	     	   		   - Ted
