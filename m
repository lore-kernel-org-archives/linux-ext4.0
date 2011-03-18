From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: mkdir performance.
Date: Fri, 18 Mar 2011 09:57:42 +0100
Message-ID: <20110318085742.GA20480@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:49330 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756408Ab1CRI5o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Mar 2011 04:57:44 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Guys, 

I'm seeing more and more mkdir performance problems.

On the big partition where I most often NEED the performance an
strace -tttT mkdir asdlkfj results in: 

1300437461.968657 mkdir("asdklfj", 0777) = 0 <0.065133>

On my homedir (older machine) the same mkdir is a lot faster:

1300437428.294018 mkdir("asdklfj", 0777) = 0 <0.003813>

Only 3 milliseconds. Ten times faster! That would be great!

On my local workstation I get: 

1300437803.200227 mkdir("askldjf", 0777) = 0 <0.000092>

92 microseconds. even 30 times faster than that!

That 65 milliseconds. For just one it's not that bad. Not even
noticable. In my current (data-recovery) project I have (/ my client
has) about 30000 directories. This means that to do the recovery I
wait an additional 32 minutes just for all the mkdirs.

But I'm not waiting just once for "all the mkdirs". During the course
of a datarecovery I reconstruct the tree many times over, making
backups of the current state over and over again. In this project I've
been waiting that half hour over ten times, so it's cost me over 5
hours in productivity.

IIRC, a fix was available, right?

To "fix" this, all I need to do is to switch to the most recent
kernel, right? Or was the fix not yet integrated with Linus?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
