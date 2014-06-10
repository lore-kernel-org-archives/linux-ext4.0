From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] tests: fix left-over e2fsprogs-tmp files not getting
 clean up
Date: Mon, 9 Jun 2014 21:41:34 -0400
Message-ID: <20140610014134.GC8092@thunk.org>
References: <20140609144901.GE8418@thunk.org>
 <1402325451-5275-1-git-send-email-tytso@mit.edu>
 <3C6E678A-D052-40A1-BDEE-84A386CEB887@dilger.ca>
 <20140609234550.GD8993@thunk.org>
 <3A214723-2502-4839-A68F-2566DE6AD6CE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"bensberg@justemail.net" <bensberg@justemail.net>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58636 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaFJBnq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jun 2014 21:43:46 -0400
Content-Disposition: inline
In-Reply-To: <3A214723-2502-4839-A68F-2566DE6AD6CE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 09, 2014 at 06:47:51PM -0600, Andreas Dilger wrote:
> 
> It would also be good to fix the "make clean" rule to clean up
> these temp files. 

The second patch should take care of nuking them the temp file when
the user types control-C.  I wouldn't be against deleting tmp files in
the build directory, but I wouldn't want to delete files in /tmp as
part of a make clean rule --- consider what might happen if the the
user types "make clean" in one build tree while running "make check"
in another.

					- Ted
