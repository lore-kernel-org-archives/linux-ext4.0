From: tytso@mit.edu
Subject: Re: Constant access (write) time.
Date: Sat, 6 Mar 2010 18:13:27 -0500
Message-ID: <20100306231327.GI6000@thunk.org>
References: <4B92D10D.8070805@fnac.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Paul Chavent <paul.chavent@fnac.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34493 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab0CFXNa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 6 Mar 2010 18:13:30 -0500
Content-Disposition: inline
In-Reply-To: <4B92D10D.8070805@fnac.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 06, 2010 at 11:02:53PM +0100, Paul Chavent wrote:
> Hello.
> 
> I'm writing a real-time application that have to stream pictures to a SSD.
> 
> The pictures are 640x480x1 pnm that are stored in one tar file. I
> have one picture every 100ms.
> 
> The problem is that the access (write) time (from a userspace point
> of view) is not constant. I join you a piece of code that reproduce
> the problem.

What are you seeing/expecting?  Here's what I'm getting with the X25-M
Intel SSD:

       file size        duration

diff min : 3666548
diff moy : 6639261
diff max : 9429924
101 iterations
major pagefaults : 0
minor pagefaults : 0

It's rarely if ever triggering your "suspect write" fprintf.

> 
> This leads me to ask the following questions : the solution to this
> problem is
> 

If you are seeing something seriously worse, you might want to test
what happens if you write to the SSD directly; it may be the answer is

(4) Buy a competently engineered SSD.  :-)

					- Ted
