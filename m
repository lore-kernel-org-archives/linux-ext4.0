From: Theodore Tso <tytso@mit.edu>
Subject: Re: Trying out 2.6.26-ext4-3
Date: Sun, 27 Jul 2008 16:23:03 -0400
Message-ID: <20080727202302.GA7922@mit.edu>
References: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Peter Meier <meiepeter@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44230 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757693AbYG0UXL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jul 2008 16:23:11 -0400
Content-Disposition: inline
In-Reply-To: <c354edc90807270328gb835f39g530dc8173e7284f8@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2008 at 10:28:49AM +0000, Peter Meier wrote:
> Hi,
> 
> well, the timely release of 2.6.26-ext4-3 seemed like a good
> omen, and so I decided to try and put my new home box in-
> stall on ext4 today, using that latest patchset and e2fsprogs
> 1.41.0. So far I'm not getting very far.
> 
> I'm attempting to install Gentoo Linux, which involves copying
> an initial tarball to the root file system and unpacking it. Already
> while downloading the tarball into the FS my console an dmesg
> were getting spammed with messages of the type:
> 
> JBD: pdflush wants too many credits (x > y)

Serves me right for not testing things after reordering the patches.
I just pulled mingming journal's credit patch for now until we can
figure out what's wrong.  I've just released 2.6.26-git6-ext4-2 and
2.6.26-ext4-4 with the patch pulled.  I'll do a bit more testing
before I send out a full announcement.

							- Ted
