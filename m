From: tytso@mit.edu
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 09:55:31 -0400
Message-ID: <20100326135531.GG21658@thunk.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
 <20100326004738.GJ3145@quack.suse.cz>
 <87ljdf7bc8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:58480 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0CZN4R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Mar 2010 09:56:17 -0400
Content-Disposition: inline
In-Reply-To: <87ljdf7bc8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 26, 2010 at 11:09:59AM +0300, Dmitry Monakhov wrote:
> Please excuse my naive question, but is it easy enough to allocate
> space during fsck?  If we allow to do this then each fsck will result
> in sb-changes because of new tmp quota-file creation/rename/deletion
> even if sb and quota is ok.

We can usually allocate space in fsck --- if there's space available
in the file system, of course!  Of course with the quota file most of
the time we should be able to update the quota file in place, so we
wouldn't need to allocate space most of the time.

	      	 	  	     	    - Ted
