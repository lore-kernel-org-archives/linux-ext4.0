From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Thu, 20 Sep 2007 14:59:03 -0400
Message-ID: <20070920185903.GH30221@thunk.org>
References: <46F1847E.6080400@redhat.com> <20070919204249.GH25497@thunk.org> <46F2845C.2010000@redhat.com> <20070920144245.GD30221@thunk.org> <46F28DDA.9050203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41416 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031AbXITS7J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 14:59:09 -0400
Content-Disposition: inline
In-Reply-To: <46F28DDA.9050203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

It might also be worthwhile to file a documentation bug against the
mount and fstab man pages, since it doesn't currently seem to specify
(at least on my Ubuntu system; maybe it's been fixed in newer upstream
packages) that you can specify the bind option in the fstab file.  

/src	/dest	ext3	bind,default

It's not clear to me that this should be the preferred form.  Why not?

/src	/dest  bind  defaults

or


/src	/dest  none  bind,defaults


instead?  In any case, how bind mounts are supposed to be specified in
fstab is not documented, and it really should be.

      	     		     	       - Ted
