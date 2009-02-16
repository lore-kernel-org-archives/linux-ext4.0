From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Mon, 16 Feb 2009 10:01:56 -0500
Message-ID: <20090216150156.GD22619@mini-me.lan>
References: <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45641 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZBPPUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Feb 2009 10:20:21 -0500
Content-Disposition: inline
In-Reply-To: <49994FEF.2020908@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 16, 2009 at 12:37:19PM +0100, Andres Freund wrote:
> Hi All,
>
> "Luckily", to prove that I am not completly mad I recently found this  
> problem again. On a more recent kernel:
> 2.6.29-rc3-andres-00498-g68e80d5
> (upstream 2.6.29 + Theodore's ext4 debug patches)
>
> Again I got:
> open("/home/andres/tt", O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK, 0666) = -1  
> ENOSPC (No space left on device)

So /home/andres/tt does not exist, correct?  Does this happen for any
attempt to create a new zero-length file using the "touch" command?
(Even in other directories)   Can you append to a file using "cat
/etc/mailcap >> some_existing_file"?

If it is "yes" to the first two questions, and "no" the third, it
looks like this might be an inode allocation failure as opposed to a
block allocation failure.

Once this triggers, does it reliably continue to fail if you reboot?
Or does it go away when you reboot?

					- Ted
