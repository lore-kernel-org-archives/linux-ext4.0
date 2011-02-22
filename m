From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Tue, 22 Feb 2011 14:36:52 +0100
Message-ID: <20110222133652.GI21917@bitwizard.nl>
References: <20110220170931.GB3017@thunk.org> <20110220193406.GC3017@thunk.org> <20110220215531.GA21917@bitwizard.nl> <20110220222013.GA2849@thunk.org> <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Pawe?? Brodacki <pawel.brodacki@googlemail.com>,
	Amir Goldstein <amir73il@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:57737 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752041Ab1BVNgy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Feb 2011 08:36:54 -0500
Content-Disposition: inline
In-Reply-To: <20110222102056.GH21917@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 22, 2011 at 11:20:56AM +0100, Rogier Wolff wrote:
> I wouldn't be surprised if I'd need more than 3G of RAM. When I
> extrapolated "more than a few days" it was at under 20% of the
> filesystem and had already allocated on the order of 800Gb of
> memory. Now I'm not entirely sure that this is fair: memory use seems
> to go up quickly in the beginning, and then stabilize: as if it has
> decided that 800M of memory use is "acceptable" and somehow uses a
> different strategy once it hits that limit.

OK. Good news. It's finished pass1. It is currently using about 2100Mb
of RAM (ehh. mostly swap, I have only 1G in there). Here is the patch.

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
