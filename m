From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/4]ext4: Fix possible recursive locking warning in
	EXT4_IOC_MOVE_EXT
Date: Tue, 10 Nov 2009 16:55:33 -0500
Message-ID: <20091110215533.GE13262@mit.edu>
References: <4AEA98C9.8030707@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55454 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373AbZKJVz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2009 16:55:29 -0500
Content-Disposition: inline
In-Reply-To: <4AEA98C9.8030707@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 30, 2009 at 04:42:01PM +0900, Akira Fujita wrote:
> ext4: Fix possible recursive locking warning in EXT4_IOC_MOVE_EXT
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>

Thanks, I've added this patch to the ext4 patch queue, but with the
following updated commit description:

ext4: Fix possible recursive locking warning in EXT4_IOC_MOVE_EXT

From: Akira Fujita <a-fujita@rs.jp.nec.com>

If CONFIG_PROVE_LOCKING is enabled, the double_down_write_data_sem()
will trigger a false-positive warning of a recursive lock.  Since we
take i_data_sem for the two inodes ordered by their inode numbers,
this isn't a problem.  Use of down_write_nested() will notify the lock
dependency checker machinery that there is no problem here.

This problem was reported by Brian Rogers:

     http://marc.info/?l=linux-ext4&m=125115356928011&w=1

Reported-by: Brian Rogers <brian@xyzw.org>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
