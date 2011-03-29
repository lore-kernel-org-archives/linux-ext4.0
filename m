From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: [PATCH] mke2fs reserved_ratio default value is nonsensical
Date: Tue, 29 Mar 2011 18:00:11 +0200
Message-ID: <20110329160011.GB16888@bitwizard.nl>
References: <AANLkTi=7jMS=yq4-72_CvcyGHuWWV6ixEKtk501wnxUz@mail.gmail.com> <4D90CE41.4030209@redhat.com> <4731EEFB-561D-4393-81C9-B550F45964C6@mit.edu> <4D91FA25.1080402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Oren Elrad <elrad@brandeis.edu>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cust-95-128-94-82.breedbanddelft.nl ([95.128.94.82]:47201 "HELO
	abra2.bitwizard.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751651Ab1C2QAR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Mar 2011 12:00:17 -0400
Content-Disposition: inline
In-Reply-To: <4D91FA25.1080402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 29, 2011 at 10:26:29AM -0500, Eric Sandeen wrote:
> I agree, it seems like at least a decent first step to make it
> more site/admin-configurable. 

If the filesystem developers (that's us on this mailing list) decide
that 5% is a good tradeoff between "wasted space" and "performance
when the FS fills up", I think we should leave it as it is. If 
users really want to fill up their fs to the rim, they can do so 
"as root". Or they can tune the fs. 

If you make it configurable, it becomes too easy to create a badly
performing filesystem. 

People who don't understand the reasons behind the "reserved for root"
percentage will then be tempted to change the default for their system
to zero, and later complain about the bad performance they are getting. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
