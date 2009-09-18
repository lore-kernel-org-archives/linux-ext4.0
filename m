From: Theodore Tso <tytso@mit.edu>
Subject: Re: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 13:58:51 -0400
Message-ID: <20090918175851.GH26991@mit.edu>
References: <4AB39EC5.6070107@it-sudparis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49708 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbZIRR6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 13:58:53 -0400
Content-Disposition: inline
In-Reply-To: <4AB39EC5.6070107@it-sudparis.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2009 at 04:52:53PM +0200, jehan procaccia wrote:
> some of you might have followed my miseries about quota support and ext4 ...
> http://marc.info/?l=linux-ext4&m=125320312905576&w=2
>
> Apparently the only sure and secure solution offered to me is to  
> downgrade my ext4 FS to ext3 :-( .
> now , is there a procedure to do that ?

There isn't a procedure to do this, other than backup, reformat, and
restore.  Sorry about that; it's just one of those things we haven't
had the resources to create --- and it would not be a trivial task.

Looking at the problems you had, have you tried simply mounting your
ext4 filesystem with -o nodelalloc?  The RHEL5.4 kernel doesn't have
various delalloc patches, and I can certainly understand why Red Hat
might not be willing to try to engage in backporting all of the
delalloc fixes to its kernel, but you might be able to use the -o
nodelalloc feature to simply disable the ext4 feature which appears to
be causing the problem.  This will cause you to give up some
performance, but not as much as dropping back to ext3.

Regards,

	     	     	     		 - Ted
