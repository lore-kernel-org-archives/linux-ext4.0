From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Mount option "nouser_xattr" will be removed by 3.5
Date: Mon, 20 Nov 2017 21:51:25 -0500
Message-ID: <20171121025125.ajsmpx4na4uvlhh3@thunk.org>
References: <TGfF7VK3OWYxx6BtJw5zngrrIZF1T9cC@mail.emailn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: elanTea <elanTea@emailn.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37784 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752010AbdKUCv2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 20 Nov 2017 21:51:28 -0500
Content-Disposition: inline
In-Reply-To: <TGfF7VK3OWYxx6BtJw5zngrrIZF1T9cC@mail.emailn.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 17, 2017 at 04:55:22PM +0100, elanTea wrote:
> Hi
> please do not remove this option. I need a filesystem without the
> posibility to hide information and files from the User. You can remove
> the funktion of write user_xattr but not the posibility to switch it of.

Can you say more?  I don't understand why you believe that userspace
settable (and visible) extended attribute gives "the possibility to
hide informatoin and files from the user".

What is your use case and what are you trying to protect against?

And are you using Posix ACL's and/or SELinux?  If not, you could just
turn off the file system' extended attriute feature altogether.

     	     	  	  	   	    	    - Ted
