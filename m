From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
	blocks...
Date: Tue, 21 Apr 2009 12:43:41 -0400
Message-ID: <20090421164341.GA15541@mit.edu>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <m2eivm599b.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Sanders <jss@ast.cam.ac.uk>, linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48985 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685AbZDUQnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Apr 2009 12:43:47 -0400
Content-Disposition: inline
In-Reply-To: <m2eivm599b.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 21, 2009 at 05:14:40PM +0200, Thierry Vignaud wrote:
> For the record, I reproduced this bug with 2.6.30-rc2-git6 on a new
> 1.5Tb disk. Formated as ext4, using relatime, copied 20Gb.
> On reboot, I got such errors.
> The hd was partitionned (all ext4) as:
> / (5Gb)  |  /usr (20Gb)  |  /pub (1.5Tb)

Theirry, are you willing to try to see if you can get a reliable
reproduction case?  That's what we need, very badly.  The fact that
you only copied 20GB is very good; better than than 2TB.  If you can
reliably reproduce the failure 2 or 3 times, can you give us exact
reproduction instructions?  That would be extremely useful.

Thanks in advance,

						- Ted
