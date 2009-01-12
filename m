From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix unhandled ext4_free_data allocation failure
Date: Mon, 12 Jan 2009 10:03:36 -0500
Message-ID: <20090112150336.GE21793@mit.edu>
References: <20081223104016.GC7217@localhost.localdomain> <20081223142915.GA23303@unused.rdu.redhat.com> <961aa3350812231437x4debaf9byf230a63582561010@mail.gmail.com> <20090111020352.GA4285@localhost.localdomain> <20090111143942.GA28488@unused.rdu.redhat.com> <496A0648.9050100@redhat.com> <20090112035835.GA16898@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eric Sandeen <sandeen@redhat.com>, Josef Bacik <jbacik@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	adilger@sun.com, li
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59586 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZALPED (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jan 2009 10:04:03 -0500
Content-Disposition: inline
In-Reply-To: <20090112035835.GA16898@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 11, 2009 at 10:58:35PM -0500, Theodore Tso wrote:
> On Sun, Jan 11, 2009 at 08:46:32AM -0600, Eric Sandeen wrote:
> > 
> > Well, this will now force a filesystem error (then remount-ro or panic
> > (or ignore) if the allocation fails.  I'm not sure that's better...?
> > 
> 
> Well, our choices basically are:
> 
> 1)  Force a filesystem error
> 2)  Sleep and retry the allocation
> 3)  Don't add the freed blocks to the list regions that mballoc should
>     be allowed to allocate from after the transaction commits.  This 
>     results in the blocks getting "leaked" until the filesystem is
>     mounted/unounted.

I just thought of another alternative:

4) Mark the buddy cache has being in need of being completely rebuilt
after the transaction commits. 

Someone want to try coding that up?

						- Ted
