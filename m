From: Daniel Phillips <phillips@phunq.net>
Subject: Dot and dotdot need to be physically present?
Date: Wed, 13 Aug 2008 16:36:59 -0700
Message-ID: <200808131636.59436.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from phunq.net ([64.81.85.152]:34673 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752781AbYHMXhB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 19:37:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Many years ago we had a discussion about whether or not the . and ..
directory entries had to be physically present in htree, and I remember
the conclusion was that they had to be, but I forget the argument and
lost track of the email thread.  I think the VFS will happily supply
the . and .. entries to getdents on its own.  So what was the issue?
Something about telldir?

This is in relation to implementing a cleaner successor to htree that
could end up being useful to Ext4 and Lustre as well as Tux3.  See
"phtree" here:

   http://tux3.org/design.html

Regards,

Daniel

p.s. Wow, you still have your MIT email.  There must be a war story.
