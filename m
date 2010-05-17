From: tytso@mit.edu
Subject: Re: [PATCH] libblkid: support for GUID Partition Table (GPT),
 please?
Date: Mon, 17 May 2010 13:54:53 -0400
Message-ID: <20100517175453.GC18161@thunk.org>
References: <87632ql0pg.fsf@violet.siamics.net>
 <87vdapkgnk.fsf@violet.siamics.net>
 <20100517094753.GK2209@nb.net.home>
 <87hbm6k5g9.fsf@violet.siamics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ivan Shmakov <oneingray@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50738 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab0EQRzE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 May 2010 13:55:04 -0400
Content-Disposition: inline
In-Reply-To: <87hbm6k5g9.fsf@violet.siamics.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 17, 2010 at 08:45:10PM +0700, Ivan Shmakov wrote:
> 
> 	(Huh?  util-linux-ng has its own libblkid?  And, BTW, any chance
> 	of having the changes accepted into e2fsprogs?)

The blkid library has been transitioned to util-linux-ng.  I'll put in
critical bug fixes, but at this point, there is significant new
functionality in the version of blkid in util-linux-ng, and the major
distributions are using the one from util-linux-ng.

	      	  	    	     - Ted
