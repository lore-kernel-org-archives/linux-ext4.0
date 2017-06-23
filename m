From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e4defrag: Add a version number
Date: Fri, 23 Jun 2017 18:07:58 -0400
Message-ID: <20170623220758.t5ope7c7snc2nkcg@thunk.org>
References: <115cbcc0-1e18-f45a-d043-237508e89a08@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38338 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753849AbdFWWIA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 18:08:00 -0400
Content-Disposition: inline
In-Reply-To: <115cbcc0-1e18-f45a-d043-237508e89a08@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 09, 2017 at 01:58:32PM +0100, Marc Thomas wrote:
> Add the e2fsprogs version number to e4defrag.
> Display the version number prior to the usage message.
> 
> Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>

I've changed this to print the e2fsprogs version number when the
e4defrag program first starts, to be consistent with where we print
the version string with most of the other e2fsprogs programs
(especially those that are very verbose).

    	    	      	     	 - Ted
