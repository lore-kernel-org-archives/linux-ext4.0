From: Karel Zak <kzak@redhat.com>
Subject: Re: uti-linux-ng libblkid
Date: Mon, 9 Mar 2009 12:45:55 +0100
Message-ID: <20090309114555.GD3278@nb.net.home>
References: <1235410733-4193-1-git-send-email-kzak@redhat.com> <20090309010833.GE5578@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZCILqA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 07:46:00 -0400
Content-Disposition: inline
In-Reply-To: <20090309010833.GE5578@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 08, 2009 at 09:08:33PM -0400, Theodore Tso wrote:
> Also note there have been a couple of blkid fixes that have been made
> to e2fsprogs git tree, I'll look into getting those pushed to you.

Applied/ported from your tree:

  commit eb630fd8708ae433e55e384079c08e0f0f040d22
  Author: Eric Sandeen <sandeen@redhat.com>
  Date:   Tue Feb 24 23:15:33 2009 -0600
  e2fsprogs: blkid.static make target

  commit a90f5391dda78f7bc4a8196a78355584ace0adf5
  Author: Eric Sandeen <sandeen@redhat.com>
  Date:   Tue Feb 24 23:17:54 2009 -0600
  blkid: recognize ext4(dev) without journal

  commit 1361821e7e248166f0740c832b164e6cd6b89de9
  Author: Theodore Ts'o <tytso@mit.edu>
  Date:   Sun Mar 8 18:56:41 2009 -0400
  blkid: Add fallback to ext4 for 2.6.29+ kernels if ext2 is not present


Our trees should be synced now.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
