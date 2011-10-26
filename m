From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: handle NULL p_ext in
 ext4_ext_next_allocated_block()
Date: Wed, 26 Oct 2011 04:26:48 -0400
Message-ID: <20111026082648.GP31921@thunk.org>
References: <1318122074-16056-1-git-send-email-curtw@google.com>
 <alpine.LFD.2.00.1110100841380.4851@dhcp-27-109.brq.redhat.com>
 <CAO81RMbLGDUihKORjQ5rGeRHPHg5ivvQtOGJL_oBe4QUiiO0hg@mail.gmail.com>
 <87ipnwnh96.fsf@dmbot.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Curt Wohlgemuth <curtw@google.com>,
	Lukas Czerner <lczerner@redhat.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56357 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1JZI0z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 04:26:55 -0400
Content-Disposition: inline
In-Reply-To: <87ipnwnh96.fsf@dmbot.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 11, 2011 at 11:01:57AM +0400, Dmitry Monakhov wrote:
> > ext4_ext_walk_space() will get the i_data_sem, construct the path
> > array, then release the semaphore.  But then it does a bazillion
> > accesses on the extent/header/index pointers in the path array, with
> > no protection against truncate, growth, or any other changes.  As far
> > as I can tell, this is the only use of a path array retrieved from
> > ext4_ext_find_extent() that isn't completely covered by i_data_sem.
>
> In that case i_data sem protects us from nothing. Path collected can
> simply disappear under us. And in fact i don't understand the
> reason why we drop i_data_sem too soon. Are any reason to do that?

The one concern I have is that I don't want FIEMAP to slow down "real"
ext4 processing.  So what I've hoping we'll be able to do is use a
seq_lock sort of design, where if the pointer changes out from under
us, FIEMAP is forced to redo its sampling.  But if there is some crazy
userspace program which is calling FIEMAP all the time, I'd much
rather that it not block ext4_map_blocks() if possible (which is what
I using a seqlock to protect the FIEMAP routines would help).

  	  	     	     	 	- Ted
