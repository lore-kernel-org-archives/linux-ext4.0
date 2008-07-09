From: Brad Boyer <flar@allandria.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Tue, 8 Jul 2008 21:21:47 -0700
Message-ID: <20080709042147.GB20695@cynthia.pants.nu>
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org,
	viro@ZenIV.linux.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [76.245.85.235] ([76.245.85.235]:59050 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYGIFva (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Jul 2008 01:51:30 -0400
Content-Disposition: inline
In-Reply-To: <20080709010922.GE9957@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 08, 2008 at 09:09:22PM -0400, Theodore Tso wrote:
> I had argued for the timeout (and so it's mostly my fault that
> Takashi-San included it as a feature) mainly because I was (and still
> amm) deeply paranoid about the competence of the application
> programers who might use this feature.  I could see them screwing up
> leaving it locked forever --- perhaps when their program core dumps or
> when the user types ^C and they forgot to install a signal handler,
> leaving the filesystem frozen forever.
> 
> In the meantime, user applications that try to create files on that
> filesystem, or write to files already opened when the filesystem are
> frozen will accumulate dirty pages in the page cache, until the system
> finally falls over.
> 
> Think about some of the evil perpetrated by hal and the userspace
> suspend-resume scripts (and how much complexity with random XML
> fragments getting parsed by various dbus plugins), and tell me with a
> straight face that you would trust these modern-day desktop
> application writers with this interface.  Because they *will* find
> some interesting way to (ab)use it.....
> 
> Also, I didn't think the extra code complexity to implements timeouts
> was *that* bad --- it seemed fairly small for the functionality.

Just as an extra point of reference, VxFS supports a freeze/thaw by
ioctl very similar to this including a timeout in seconds. This
means someone else thought it was a useful feature.

http://sfdoccentral.symantec.com/sf/5.0/linux/manpages/vxfs/vxfsio_7.html

	Brad Boyer
	flar@allandria.com

