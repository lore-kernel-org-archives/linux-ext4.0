From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Regular ext4 error warning with HD in USB dock
Date: Mon, 10 Jan 2011 00:45:17 -0700
Message-ID: <41DF7E1A-4CF0-44CF-AD8F-29176397B7EF@dilger.ca>
References: <20101228081917.GA1351@bitwizard.nl> <AANLkTim_5Yx1RQFHYbmh40xx7c5sU9XsXZEzegC4G=1x@mail.gmail.com> <4D1F6244.7050203@redhat.com> <AANLkTimAe-p1-ApmnueybQY474J3_G9JL+8WJ2WTn+04@mail.gmail.com> <20110107052613.GE2857@thunk.org> <AANLkTinyc+H7t5yF8w81XXts0jfbdt4ROWM8MHEUjNeD@mail.gmail.com> <AANLkTimFA9Can0Oe39Jkw+1X6uxwsgNVW2aKPoV_VLoq@mail.gmail.com> <20110108080520.GE12433@bitwizard.nl> <20110108220059.GV21922@thunk.org> <20110109081249.GA32496@bitwizard.nl> <20110109145838.GA3346@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Con Kolivas <kernel@kolivas.org>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:43340 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1AJHpT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jan 2011 02:45:19 -0500
In-Reply-To: <20110109145838.GA3346@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-09, at 07:58, Ted Ts'o wrote:
> Defensive programming would be something like
> 
> 	  BUG_ON(sizeof(struct ext4_super_block) != 1024);
> 
> (unfortunately #error sizeof(struct ext4_super_block) != 1024 won't
> work since #error is handled by the preprocessor, and I don't think we
> can trigger a compile-time warning for a structure size issue).

We actually use a compile-time assertion in the Lustre code:

/*
* compile-time assertions. @cond has to be constant expression.
* ISO C Standard:
*
*        6.8.4.2  The switch statement
*
*       ....
*
*       [#3] The expression of each case label shall be an integer
*       constant expression and no two of the case constant expressions
*       in the same switch statement shall have the same value after
*       after conversion...
*/
#define CLASSERT(cond) ({ switch(42) { case (cond): case 0: break; } })


Of course, the "cond" expression must be resolvable at compile time, or
it will turn into a compile error because it is not legal to have a
variable "case".

Cheers, Andreas





