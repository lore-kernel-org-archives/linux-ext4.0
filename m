From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add a new spinlock i_raw_lock to protect the
 ext4's raw inode
Date: Sat, 12 Apr 2014 19:03:01 -0400
Message-ID: <20140412230301.GB14599@thunk.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53326 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbaDLXDD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 19:03:03 -0400
Content-Disposition: inline
In-Reply-To: <1397343317-14669-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 12, 2014 at 06:55:14PM -0400, Theodore Ts'o wrote:
> To avoid potential data races, use a spinlock which protects the raw
> (on-disk) inode.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Sigh, sorry, left over patch in the /tmp/p directory.  Please ignore....

      	     	       	     	    - Ted
