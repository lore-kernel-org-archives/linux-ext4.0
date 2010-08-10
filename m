From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -v2 1/3] jbd2: Use atomic variables to avoid taking
 t_handle_lock in jbd2_journal_stop
Date: Tue, 10 Aug 2010 12:30:46 -0400
Message-ID: <20100810163046.GM3635@thunk.org>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
 <1280939957-3277-2-git-send-email-tytso@mit.edu>
 <20100809170216.GB31969@atrey.karlin.mff.cuni.cz>
 <20100809190513.GF3635@thunk.org>
 <20100809194554.GB5356@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51457 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212Ab0HJQas (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Aug 2010 12:30:48 -0400
Content-Disposition: inline
In-Reply-To: <20100809194554.GB5356@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 09:45:55PM +0200, Jan Kara wrote:
>   Ah, OK. You're right. I just thought we eventually want to remove the
> lock but you're right that currently the code is fine. Sorry for the noise.

I would love to get rid of the j_state_lock, but looking through the
code, I couldn't figure out how to do this safely.  Hence my
conversion of the j_state_lock to a rwlock_t, with the downside of
this causing more cache line bounces.  If someone can suggest a way to
drop needing a global spinlock (whether it is an exclusive or rwlock)
in start_this_handle(), I'd love to hear them.

   			    	    	 - Ted
