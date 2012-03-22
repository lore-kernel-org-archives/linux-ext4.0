From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Date: Thu, 22 Mar 2012 10:42:32 -0700
Message-ID: <1332438152.4677.25.camel@joe2Laptop>
References: <cover.1331856299.git.joe@perches.com>
	 <ceb0e02f9f0c1548a654e8718fbadc147595f8ee.1331856300.git.joe@perches.com>
	 <20120319040950.GG31682@thunk.org> <1332131137.23125.44.camel@joe2Laptop>
	 <4F6762F1.7050902@gmail.com> <1332176943.1983.28.camel@joe2Laptop>
	 <4F684673.1050309@suse.cz> <1332235315.7847.63.camel@joe2Laptop>
	 <4F684D00.4040102@suse.cz> <1332236803.7847.85.camel@joe2Laptop>
	 <4F6B5B1E.9090402@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51673 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754447Ab2CVRmd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 13:42:33 -0400
In-Reply-To: <4F6B5B1E.9090402@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2012-03-22 at 18:02 +0100, Jiri Slaby wrote:
> On 03/20/2012 10:46 AM, Joe Perches wrote:
> > On Tue, 2012-03-20 at 10:25 +0100, Jiri Slaby wrote:
> >> On 03/20/2012 10:21 AM, Joe Perches wrote:
> >>> the ath5k pr_ conversion patches are to
> >>> standardize prefixes and to reduce code size by
> >>> centralizing tests.
> >> What is the "standard" prefix?
> > KBUILD_MODNAME
> 
> Instead, we should switch as many printks to dev_* and similar as
> possible, right?

I believe logging message use should be selected
to be as specific as possible (from high to low):

o <subsystem>_<level>
o netif_<level>
o netdev_<level>
o dev_<level>
o pr_<level>
o printk(KERN_<LEVEL>

> They are standard and provide a good interface for
> extensions: one has a device to work with. This is something what pr_*
> does not offer.

I completely agree.

I'd like to see some new subsystem prefixes
created and used as well.  Maybe:

fs_<level> (like Ted's ext4_<foo>)
io_<level> (scsi/ide/mtd)
mm_<level>

There are probably a few others like
cpu/video/sound that might be useful.

> Frankly, moving the debug code to a separate function should make the
> code rather faster. By moving the unlikely code out of the instruction
> cache.

I think it's better still to eliminate debug
code altogether via if (0) when reasonable
or use dynamic_debug (jump_tables) when
overall code size isn't an issue.

cheers, Joe

