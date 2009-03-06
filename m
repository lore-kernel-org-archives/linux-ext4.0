From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: fix potential null ptr defef in
	check_for_modules()
Date: Fri, 6 Mar 2009 02:38:11 -0500
Message-ID: <20090306073811.GB6514@mit.edu>
References: <49A46303.7070405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59079 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZCFHiQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Mar 2009 02:38:16 -0500
Content-Disposition: inline
In-Reply-To: <49A46303.7070405@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 24, 2009 at 03:13:39PM -0600, Eric Sandeen wrote:
> The coverity scanner found this one.
> 
> If a line in modules.dep has a ":" but no "/" then:
> 
>                 if ((cp = strchr(buf, ':')) != NULL)
>                         *cp = 0;
>                 else
>                         continue;
>                 if ((cp = strrchr(buf, '/')) != NULL)
>                         cp++;
>                 /* XXX else cp is still null */
>                 i = strlen(cp);
> 
> ... we will deref a null pointer (cp).  This can be 
> demonstrated by putting a line like:
> 
> foo.ko:
> 
> into modules.dep.  The below change just says that if no "/" is
> found, treat the whole string as the module name.

Thanks, applied to the e2fsprogs git tree.

					- Ted
