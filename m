From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: process hangs in ext4_sync_file
Date: Mon, 6 Jan 2014 09:32:03 -0500
Message-ID: <20140106143203.GA13648@thunk.org>
References: <CAEfL3KniKZNzehPH1Z4eWhhNF_RHrE4vHoRTHDPrfYj4t_2LtA@mail.gmail.com>
 <CAEfL3K=vEaZ+-pj=QCogJvcvf0xgsEsAT9DX8eExMjSiNmcNLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sandeep Joshi <sanjos100@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46264 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbaAFOcG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jan 2014 09:32:06 -0500
Content-Disposition: inline
In-Reply-To: <CAEfL3K=vEaZ+-pj=QCogJvcvf0xgsEsAT9DX8eExMjSiNmcNLQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 06, 2014 at 03:58:58PM +0530, Sandeep Joshi wrote:
> I reported a problem with process hanging in ext4 sync on a SSD a few weeks ago
> See this thread http://www.spinics.net/lists/linux-ext4/msg40369.html
> 
> That was on a SSD with discard option enabled.  I was asked to turn
> that off which I did and never hit the issue again.
> 
> Today I saw the same problem on an ext4 filesystem mounted on a loop
> device.  The stack is *identical*.

What model SSD are you using?  This looks like the we're just waiting
for the SSD to acknowledge that the write has been completed.  This
really smells like a case of a crappy SSD....

					- Ted
