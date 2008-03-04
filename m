From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/1] add a jbd option to force an unclean journal
 state
Date: Tue, 4 Mar 2008 15:58:01 -0800
Message-ID: <20080304155801.6f48bf08.akpm@linux-foundation.org>
References: <200803041339.42544.jbacik@redhat.com>
	<20080304190109.GD24335@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: jbacik@redhat.com, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYCDX7O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Mar 2008 18:59:14 -0500
In-Reply-To: <20080304190109.GD24335@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 4 Mar 2008 20:01:09 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
> On Tue 04-03-08 13:39:41, Josef Bacik wrote:
> > jbd and I want a way to verify that I'm not screwing anything up in the 
> > process, and this is what I came up with.  Basically this option would only be 
> > used in the case where someone mounts an ext3 image or fs, does a specific IO 
> > operation (create 100 files, write data to a few files etc), unmounts the fs 
> > and remounts so that jbd does its journal recovery and then check the status of 
> > the fs to make sure its exactly the way its expected to be.  I'm not entirely 
> > sure how usefull of an option like this would be (or if I did it right :) ), 
> > but I thought I'd throw it out there in case anybody thinks it may be useful, 
> > and in case there is some case that I'm missing so I can fix it and better make 
> > sure I don't mess anything up while doing stuff.  Basically this patch keeps us 
> > from resetting the journal's tail/transaction sequence when we destroy the 
> > journal so when we mount the fs again it will look like we didn't unmount 
> > properly and recovery will occur.  Any comments are much appreciated,
>   Actually, there is a different way how we've done checking like this (and
> I think also more useful), at least for ext3. Basically you mounted a
> filesysteem with some timeout and after the timeout, device was forced
> read-only. And then you've checked that the fs is consistent after journal
> replay. I think Andrew had the patches somewhere...

About a billion years ago...

But the idea was (I think) good:

- mount the filesystem with `-o ro_after=100'

- the fs arms a timer to go off in 100 seconds

- now you start running some filesystem stress test

- the timer goes off.  At timer-interrupt time, flags are set which cause
  the low-level driver layer to start silently ignoring all writes to the
  device which backs the filesystem.

  This simulates a crash or poweroff.

- Now up in userspace we

  - kill off the stresstest
  - unmount the fs
  - mount the fs (to run recovery)
  - unmount the fs
  - fsck it
  - mount the fs
    - check the data content of the files which the stresstest was writing:
      look for uninitialised blocks, incorrect data, etc.
  - unmount the fs

- start it all again.


So it's 100% scriptable and can be left running overnight, etc.  It found
quite a few problems with ext3/jbd recovery which I doubt could be found by
other means.  This was 6-7 years ago and I'd expect that new recovery bugs
have crept in since then which it can expose.

I think we should implement this in a formal, mergeable fashion, as there
are numerous filesystems which could and should use this sort of testing
infrastructure.

