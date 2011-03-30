From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck.ext4 taking months
Date: Wed, 30 Mar 2011 10:45:05 +0200
Message-ID: <20110330084505.GE30384@bitwizard.nl>
References: <4D8F1F75.8010201@psi5.com> <4D909E92.4080209@redhat.com> <20110329060300.GA27142@bitwizard.nl> <4D92408E.7090008@psi5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Christian Brandt <brandtc@psi5.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:39814 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754722Ab1C3IpG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Mar 2011 04:45:06 -0400
Content-Disposition: inline
In-Reply-To: <4D92408E.7090008@psi5.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2011 at 10:26:54PM +0200, Christian Brandt wrote:
> Am 29.03.2011 08:03, schrieb Rogier Wolff:
> 
> >>> >>> Is the slow performance with lots of hard links a known issue?
> > >
> > > Yes, it is a known issue.
> 
>  At least its not my fault :-) thanks for the info.
> 
> > > You get to test my patch. :-)
> > >
> > > I strongly suspect that (just like me) sometime in the past you've
> > > seen e2fsck run out of memory and were advised to enable the
> > > on-disk-databases.
> 
>  Something like that... The drive has been formatted recently but a bad
> controller corrupted vital information upon mount and some more on the
> next fsck. I Ctrl-C pretty fast when I saw lots of rather confusing
> kernel errors between fsck output. This could have left the drive in a
> similiar state, couldn't it?

The code I "fixed" is the code that uses an on-disk database instead
of in-memory datastructures.

Those in-memory datastructures may move to swap if you have enough of
that and enough addressing space. In my case, normal fsck memory usage
plus those two flexible datastructures would have exceeded 3Gb which
exceeds the 32-bit Linux process size limit.

So if you haven't touched the config file which specifies to put these
structures on disk, you are not experiencing the same problem that I
was.... 

Or someone else changed the configuration file for you....

The patch is against a CVS checkout (or whatever SCM is used) of
e2fsprogs.


	Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
