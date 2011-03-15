From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 15:33:00 +0100
Message-ID: <20110315143300.GC1699@bitwizard.nl>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <4D7E8005.4030201@cfl.rr.com> <20110314215249.GE8120@thunk.org> <4D7EA83D.20400@cfl.rr.com> <20110315001448.GG8120@thunk.org> <4D7F7134.7080209@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:47142 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753304Ab1COOdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 10:33:04 -0400
Content-Disposition: inline
In-Reply-To: <4D7F7134.7080209@cfl.rr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 10:01:24AM -0400, Phillip Susi wrote:
> To try and clarify this point a bit, are you saying that applications
> like tar and rsync should be patched to sort the directory by inode
> number, rather than it being the job of the fs to return entries in a
> good order?

IMHO, it is the job of the FS to perform well in common cases.

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
