From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: prefix printks with JBD2: not JBD:
Date: Sun, 11 May 2014 20:17:26 -0400
Message-ID: <20140512001726.GF5480@thunk.org>
References: <536A652C.7080509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33530 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaELAR3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 20:17:29 -0400
Content-Disposition: inline
In-Reply-To: <536A652C.7080509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2014 at 11:54:04AM -0500, Eric Sandeen wrote:
> I was looking at some debugging logs from a test on ext4,
> and wondered why I saw messages from JBD: not JBD2:
> 
> This is why!  Probably worth changing for consistency.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

What kernel version is this against?  This has been fixed since 3.13:

commit a67c848a8b9aa9e471f9eaadd2cb29cc527462cf
Author: Dmitry Monakhov <dmonakhov@openvz.org>
Date:   Sun Dec 8 21:14:59 2013 -0500

    jbd2: rename obsoleted msg JBD->JBD2
    
    Rename performed via: perl -pi -e 's/JBD:/JBD2:/g' fs/jbd2/*.c
    
    Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

					- Ted
