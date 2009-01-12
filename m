From: Theodore Tso <tytso@mit.edu>
Subject: Re: Online ext4 defragmention
Date: Mon, 12 Jan 2009 09:15:39 -0500
Message-ID: <20090112141539.GD21793@mit.edu>
References: <20090111134443.581cfc83@lithium.local.net> <20090111202838.GA29383@mit.edu> <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Buell <alex.buell@munted.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:39955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbZALOPo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Jan 2009 09:15:44 -0500
Content-Disposition: inline
In-Reply-To: <170fa0d20901120539w4e3bbc03na39f01edde206d25@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 12, 2009 at 08:39:33AM -0500, Mike Snitzer wrote:
> 
> Hi Ted,
> 
> Could you elaborate on which allocation patches you're referring to in
> the ext4 patch queue (2.6.28-ext4-3?) ?

They haven't been implemented yet.  They've been discussed on the ext4
mailing list, however.  Basically, the Orlov algorithm was disabled
for flex_bg, and I want to optimize how directory blocks are allocated
to hopefully speed up fsck times a tad bit more.  The design has been
roughly worked out; but it's a matter of me finding time to code and
test it...

						- Ted
