From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 e2fsprogs] subst: use 0644 perms
Date: Tue, 29 Sep 2015 10:28:57 -0400
Message-ID: <20150929142857.GB2989@thunk.org>
References: <1442562858-862-1-git-send-email-vapier@gentoo.org>
 <1443489278-6435-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49314 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207AbbI2O3D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Sep 2015 10:29:03 -0400
Content-Disposition: inline
In-Reply-To: <1443489278-6435-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:14:38PM -0400, Mike Frysinger wrote:
> When running on NFS, opening files with 0444 perms for writing can
> sometimes fail.  Delay the permission update until the end (which
> restores behavior to pre-commit 2873927d15ffb9ee9ed0e2700791a0e5).
> 
> URL: https://bugs.gentoo.org/550986
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

I've already applied my version of the patch which uses fchmod instead
of chmod (to avoid static Code Analysis systems from complaining).

Cheers,

   	     	   	       			- Ted
