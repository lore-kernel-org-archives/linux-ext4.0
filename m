From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 23/54] libext2fs: Support readonly filesystem images
Date: Sat, 28 Mar 2015 23:42:59 -0400
Message-ID: <20150329034259.GD19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073803.13308.37011.stgit@birch.djwong.org>
 <20150319213237.GH11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38564 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbbC2DnE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2015 23:43:04 -0400
Content-Disposition: inline
In-Reply-To: <20150319213237.GH11031@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 19, 2015 at 02:32:37PM -0700, Darrick J. Wong wrote:
> Finish adding the new rocompat feature, "readonly", which marks a
> filesystem image read-only.  This also fixes a bug in Ted's patch to
> add the feature flag; RO_COMPAT_READONLY needs to be kept out of the
> RO_COMPAT supported feature list.

This really goes to the question of how many user space utilities
should be expected to be able to write a read-only file system.  I was
taking the position that the flag was primarily meant for the kernel,
and that it was fair game for e2fsck to repair a corrupted file
system, etc.

I can accept the position that we shouldn't enable applications which
use libext2fs to be able to modify READONLY file systems by default
--- but I'm not really comfortable putting RO_COMPAT_READONLY on
SOFTSUPP and then enabling e2fsck, resize2fs, et. al to manipulate all
SOFTSUPP features.  The original intent of SOFTSUPP was to allow
debugfs to be able to look at a file system which had some feature
that was under development, but where it was *not* yet safe to let
e2fsck to try to handle such a file system.

So if we want to remove RO_COMPAT_READONLY from the RO_COMPAT
supported feature list, we shouldn't add it to SOFTSUPP, but instead
manually enable it for each of the e2fsprogs program where we want to
allow them to work with a read-only file system.  Which begs the
question whether it makes sense to allow e2fsck to repair a corrupted
read-only file system, or to resize a read-only file system, without
first removing the read-only feature flag.  I think the answer is yes,
we should allow it, but it seems you think the answer should be no, at
least for the latter?

   	  	    	   	     - Ted
