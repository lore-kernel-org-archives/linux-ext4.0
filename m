From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [6/6] mke2fs: Add discard option into mke2fs.conf
Date: Tue, 23 Nov 2010 10:18:37 -0500
Message-ID: <20101123151837.GF32759@thunk.org>
References: <1290087521-9123-7-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, adilger@dilger.ca, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52326 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab0KWPSs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 10:18:48 -0500
Content-Disposition: inline
In-Reply-To: <1290087521-9123-7-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 03:38:41AM -0000, Lukas Czerner wrote:
> Allow to specify discard in mke2fs.conf. Also change the way how to
> specify default value for lazy_itable_init. It is better to have all
> this defaulting done in the same place so do it in definition (as we do
> with discard).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied to the maint branch, so it will git e2fsprogs 1.41.13.

	       	     	     	   	- Ted
