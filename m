From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix trivial build warnings
Date: Sat, 18 Jul 2009 18:32:02 -0400
Message-ID: <20090718223202.GB2416@mit.edu>
References: <4A5D2BED.30009@redhat.com> <20090718180413.GA2416@mit.edu> <4A621062.70301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52099 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZGRWcK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Jul 2009 18:32:10 -0400
Content-Disposition: inline
In-Reply-To: <4A621062.70301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 18, 2009 at 01:11:46PM -0500, Eric Sandeen wrote:
> 
> I think it was this:
> 
> mke2fs.c: In function 'set_os':
> mke2fs.c:667: warning: implicit declaration of function 'strcasecmp'

Thanks, I'm not getting that warning, but according to SUSv3
strcasecmp is only defined in strings.h, and not in string.h.

	      	   	      		     - Ted
