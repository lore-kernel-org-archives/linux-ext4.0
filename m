From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 06:48:22 -0600
Message-ID: <20090511124822.GD8112@parisc-linux.org>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu> <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu> <20090511124325.GC6585@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: J??rn Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33481 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZEKMsW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 May 2009 08:48:22 -0400
Content-Disposition: inline
In-Reply-To: <20090511124325.GC6585@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 02:43:25PM +0200, J??rn Engel wrote:
> Given the hardware braindamage it is relatively sane.  As always, it
> would be much better to fix the problem and not add workarounds, but we
> seem to lack the gods favor this time around.
> 
> Can't anyone explain to the SATA folks that a discard is much closer to
> a write than to a secure erase or some other rare and slow command?

I've heard the ATA committee are working on an NCQ version of TRIM.
Don't expect support soon.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
