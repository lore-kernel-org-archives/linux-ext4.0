From: Nick Warne <nick@ukfsn.org>
Subject: Re: [QUESTION] root ext4 strange couldn't mount/can mount report
Date: Tue, 27 Jan 2009 14:37:14 +0000
Message-ID: <20090127143714.2389b5c2@sauron.linicks.net>
References: <20090127134231.6daf4cbb@sauron.linicks.net>
	<20090127141426.GC11843@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:45864 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbZA0OhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 09:37:17 -0500
In-Reply-To: <20090127141426.GC11843@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 27 Jan 2009 09:14:26 -0500
Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Jan 27, 2009 at 01:42:31PM +0000, Nick Warne wrote:
> > 
> > Jan 27 12:54:57 sauron kernel: EXT3-fs: sda2: couldn't mount
> > because of unsupported optional features (40). Jan 27 12:54:57
> > sauron kernel: VFS: Mounted root (ext4 filesystem) readonly.
> > 
> > i.e. root / -> /dev/sda2 couldn't mount, but it does mount, and
> > system boots normally and functions fine.
> 
> That's normal; what happens is that the kernel tries to mount it as
> ext3 first, which takes a pass since it can't support certain
> filesystems features, and then ext4 mounts it.  The ext4 filesystem
> code will happily mount an ext3 filesystem, so that's why the kernel
> tries ext3 first.

Hi Ted,

I see.  I currently build ext3 in the kernel (as well as ext4), as
I keep /boot partition ext3 for bootloader lilo.

So I can remove ext3 now, and lilo and kernel ext4 will happily read
and use /boot partition as ext3 OK? 

Nick
-- 
Free Software Foundation Associate Member 5508
http://linicks.net/
