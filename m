From: Nick Warne <nick@ukfsn.org>
Subject: Re: [QUESTION] root ext4 strange couldn't mount/can mount report
Date: Tue, 27 Jan 2009 15:44:56 +0000
Message-ID: <20090127154456.1c87f037@sauron.linicks.net>
References: <20090127134231.6daf4cbb@sauron.linicks.net>
	<20090127141426.GC11843@mit.edu>
	<20090127143714.2389b5c2@sauron.linicks.net>
	<20090127153706.GD11843@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:34150 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZA0PpJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 10:45:09 -0500
In-Reply-To: <20090127153706.GD11843@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 27 Jan 2009 10:37:06 -0500
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Jan 27, 2009 at 02:37:14PM +0000, Nick Warne wrote:
> > 
> > I see.  I currently build ext3 in the kernel (as well as ext4), as
> > I keep /boot partition ext3 for bootloader lilo.
> > 
> > So I can remove ext3 now, and lilo and kernel ext4 will happily read
> > and use /boot partition as ext3 OK? 
> 
> The only thing which might not work is automatic type detection with
> mount.  That is, if you specify:
> 
> 	mount /dev/hda1 /boot
> 
> without specifying a filesystem type, /bin/mount will probably do an
> automatic type detection, detect that the filesystem is an ext3
> filesystem, and attempt to mount it as ext3, and not know to try it
> with ext4.  Libraries such as blkid and fsid could be made smart
> enough to do the right thing, but they don't at the moment.
> 
> But if you type "mout -t ext4 /dev/sda1 /boot", you can mount an ext3
> filesystem using the ext4 filesystem driver, and with 2.6.29 and up,
> you'll be able to mount ext2 filesystems using the ext4 filesystem
> code.  (You'll also be able to create extent-based filesystems without
> a journal, which is why Google contributed the support for this.)
> 
>        	     	       	      	       - Ted

Many thanks Ted - you cleared up the 'missing link' in any of the docs I
could find.

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
