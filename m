From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: fsck performance.
Date: Thu, 24 Feb 2011 10:02:32 +0100
Message-ID: <20110224090232.GG16661@bitwizard.nl>
References: <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl> <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca> <20110222221304.GH2924@thunk.org> <20110223044427.GM21917@bitwizard.nl> <DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu> <20110223205309.GA16661@bitwizard.nl> <F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca> <20110224072945.GE16661@bitwizard.nl> <AANLkTinv-JPaiPzKC4xSqh0shmzjf4rKeQShRwiOznoz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.101.171.8]:53721 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755299Ab1BXJCf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Feb 2011 04:02:35 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTinv-JPaiPzKC4xSqh0shmzjf4rKeQShRwiOznoz@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 10:59:23AM +0200, Amir Goldstein wrote:

> That tool is e2image -r, which creates a sparse file image of your
> fs (only metadata is written, the rest is holes), so you need to be
> careful when copying/transferring it to another machine to do it
> wisely (i.e. bzip or dd directly to a new HDD) Not sure what you
> will do if fsck fixes errors on that image...  Mostly (if it didn't
> clone multiply claimed blocks for example), you would be able to
> write the fixed image back onto your original fs, but that would be
> risky.

I can then run the fsck tests on the image. I expect fsck to find
errors: I'm using the filesystem when I'm making that image.... It 
won't be consistent. 


	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
