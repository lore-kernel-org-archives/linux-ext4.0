From: Graham Murray <graham@gmurray.org.uk>
Subject: Re: Block allocation failed
Date: Wed, 19 Aug 2009 18:33:44 +0100
Message-ID: <87ab1vvhc7.fsf@newton.gmurray.org.uk>
References: <87iqgk8jal.fsf@newton.gmurray.org.uk>
	<20090819135006.GB17488@mit.edu> <87zl9vhnfa.fsf@newton.gmurray.org.uk>
	<20090819162054.GG17488@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from newton.gmurray.org.uk ([81.2.114.237]:46393 "EHLO
	newton.gmurray.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZHSRdp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Aug 2009 13:33:45 -0400
Received: from newton.gmurray.org.uk (localhost [127.0.0.1])
	by newton.gmurray.org.uk (8.14.3/8.14.3) with ESMTP id n7JHXits013779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 19 Aug 2009 18:33:45 +0100
In-Reply-To: <20090819162054.GG17488@mit.edu> (Theodore Tso's message of "Wed,
	19 Aug 2009 12:20:54 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

>> It was about 90s after the message showing the filesystem mounted
>
> Hmm, the most likely cause for that would be if the block group
> descriptors had an incorrect number of free blocks.  But you had just
> run e2fsck -f.

No, sorry I was obviously not clear as to the order of things. First the
system rebooted itself a few seconds after writing an oops (spinlock bad
magic) to syslog and subitting it to kerneloops. On the reboot, the
syslog showed a normal (ie no error and no recovery) mount followed
about 90s later by the error dump I posted. After this, I unmounted the
filesystem and ran 'e2fsck /dev/sdb3' which just replayed the journal
and said the fs was clean. I then ran 'e2fsck -f' which made several
prompts for problems.
