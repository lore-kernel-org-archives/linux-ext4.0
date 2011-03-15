From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: Large directories and poor order correlation
Date: Tue, 15 Mar 2011 14:33:27 +0100
Message-ID: <20110315133327.GG22577@bitwizard.nl>
References: <4D7E7990.90209@cfl.rr.com> <4D7E7C7F.1040509@redhat.com> <8239molspy.fsf@mid.bfk.de> <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Weimer <fweimer@bfk.de>, Eric Sandeen <sandeen@redhat.com>,
	Phillip Susi <psusi@cfl.rr.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:49672 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1757822Ab1CONd3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Mar 2011 09:33:29 -0400
Content-Disposition: inline
In-Reply-To: <4C11D2E5-75CD-4A9F-A534-EEC16CDD836B@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 15, 2011 at 07:06:34AM -0400, Theodore Tso wrote:
> So in an absolute cold cache situations, what I'd recommend is
> readdir, sort by inode, FIEMAP, sort by block, and then read in the
> dpkg files.  Of course an RPM partisan might say, "it would help if
> you guys had used a real database instead of ab(using) the file
> system.  And then the dpkg guys could complain about what happens
> when RPM has to deal with corrupted rpm database, and how this
> allows dpkg to use shell scripts to access their package
> information.  Life is full of tradeoffs.

IMHO, the most important part is "up to and including the stat". It
should be possible to get the directory, and inode info all inside the
same "16Mb" part of the disk. This would result in (after a few seeks)
the rest of the accesses coming from the disk's cache. 

This would mean that you should allocate directory blocks from the end
PREVIOUS block group.... 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
