From: Andreas Dilger <adilger@sun.com>
Subject: Re: Reoccurring ext3 errors: attempt to access beyond end of	device,
 freeing blocks not in datazone
Date: Thu, 22 May 2008 12:18:27 -0600
Message-ID: <20080522181827.GA3516@webber.adilger.int>
References: <4832941A.70806@tuxes.nl> <20080520123505.GP15035@mit.edu>
 <48334A82.6020508@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Bas van Schaik <bas@tuxes.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42414 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbYEVSSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2008 14:18:33 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4MIIVBO017598
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 11:18:32 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1A00D01834R000@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 22 May 2008 11:18:31 -0700 (PDT)
In-reply-to: <48334A82.6020508@tuxes.nl>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 21, 2008  00:02 +0200, Bas van Schaik wrote:
> Theodore Tso wrote:
> > 15629775440 / 8 = 0x74736E4A   (or in ascii 'Inst')
> > 13075964688 / 8 = 0x616C6C62   (or in ascii 'blla')
> > 15354014352 / 8 = 0x72657552   (or in ascii 'Ruer')
> >
> > Converting these numbers to hex:
> >
> > 1953721929 = 0x74736E49  (or in ascii 'Jnst')
> > 1634495585 = 0x616C6C61  (or in ascii 'alla'
> >  543517044 = 0x20656974  (or in ascii 'tie ')
> > 1919251793 = 0x72657551  (or in ascii 'Quer')
> >
> > Given that it's all ascii, it looks like the indirect block somehow
> > was overwritten, or was substituted by text.
>
> Ah, such a lead was exactly what I was looking for, now I at least know
> where those bogus numbers were coming from. Maybe a very dump question:
> you seem to have reverse the ascii "translation", why? And shouldn't
> "Jnst" be "Inst"? Note also that the "translations" seem to resemble
> each other a little bit: "Jnst" = "Jnst", "alla" looks like "blla" and
> "Ruer" looks like "Quer". Coincidence?

Or it is possible you are getting single-bit errors somewhere along
your IO path, and another single-bit error has resulted in this data
being written to the wrong block to begin with...


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

