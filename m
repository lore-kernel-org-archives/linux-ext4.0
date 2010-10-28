From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 14:01:18 -0400
Message-ID: <20101028180118.GC6814@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
	Arnd Bergmann <arnd@arndb.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44140 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0J1SBW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 14:01:22 -0400
Content-Disposition: inline
In-Reply-To: <20101028175221.GA1578@arch.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 07:52:21PM +0200, Markus Trippelsdorf wrote:
> 
> The same BUG (inode.c:2721) happend here today running latest vanilla
> git. There is nothing in my logs unfortunately, but I shot a photo of
> the trace (see attachment).

I see, it's the page_buffers() call which is triggering.  Looking into
it...

							- Ted
