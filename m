From: Ted Ts'o <tytso@mit.edu>
Subject: Re: fs: jdb/jbd2: Put identical code in a common header
Date: Thu, 27 Oct 2011 05:13:30 -0400
Message-ID: <20111027091330.GA31921@thunk.org>
References: <alpine.LFD.2.02.1110051328010.18778@ionos>
 <20111018204031.GE4599@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33941 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792Ab1J0JNf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Oct 2011 05:13:35 -0400
Content-Disposition: inline
In-Reply-To: <20111018204031.GE4599@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:40:31PM +0200, Jan Kara wrote:
> On Wed 05-10-11 13:29:29, Thomas Gleixner wrote:
> > The state bits and the lock functions of jbd and jbd2 are
> > identical. Share them.
>   Hum, Ted, I don't think this got picked up. What's your opinion?

It seems reasonable to me.  Factoring out common code is a good
though, although inline functions won't save any text space and since
this part of the jbd header files are rarely changed, so the
maintainability advantages are reduced.

I'll take the patch and include it in the ext4 tree.

     	      	    		   - Ted
