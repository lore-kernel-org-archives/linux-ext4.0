From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: add locking for O_APPEND writes
Date: Tue, 15 Apr 2014 15:36:41 -0400
Message-ID: <20140415193641.GF4456@thunk.org>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
 <1397322161-32148-6-git-send-email-tytso@mit.edu>
 <20140415170540.GC10144@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@ZenIV.linux.org.uk
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54723 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDOTgn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 15:36:43 -0400
Content-Disposition: inline
In-Reply-To: <20140415170540.GC10144@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 15, 2014 at 07:05:40PM +0200, Jan Kara wrote:
> On Sat 12-04-14 13:02:41, Ted Tso wrote:
> > Al Viro pointed out that we need to make sure we only allow one
> > O_APPEND write to proceed at a time so that the the s_bitmap_maxbytes
> > check can be properly checked.
>   But this introduces lock inversion between aio_mutex and i_mutex, doesn't
> it?

Doh!  Thanks for pointing that out.  Fortunately, we don't need to
care about optimizing the AIO/DIO O_APPEND write case, so probably the
best thing to do is to unconditionally take aio_mutex and call
ext4_unwritten_wait() early, before we grab i_mutex.  So in effect
we'll treat all O_APPEND writes as being unaligned in and in need of
serialization.

I'll send out a revised version for this last patch.

     	      			    	      - Ted
