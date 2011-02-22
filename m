From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck performance.
Date: Tue, 22 Feb 2011 09:32:28 -0700
Message-ID: <386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
References: <20110220193406.GC3017@thunk.org> <20110220215531.GA21917@bitwizard.nl> <20110220222013.GA2849@thunk.org> <20110220231514.GC21917@bitwizard.nl> <20110220234131.GC4001@thunk.org> <AANLkTikJs8mBHGvHkJAp-aC719aG6QSJaUH-uvwpx0JK@mail.gmail.com> <AANLkTinWOSBqkXhgOa4qdfK+iiLcJSP9LeZaYmUHH9KF@mail.gmail.com> <C5662C0F-10E3-4AC3-8ACA-4CBBF4F36D70@dilger.ca> <20110222102056.GH21917@bitwizard.nl> <20110222133652.GI21917@bitwizard.nl> <20110222135431.GK21917@bitwizard.nl>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>,
	Pawe?? Brodacki <pawel.brodacki@googlemail.com>,
	Amir Goldstein <amir73il@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:11068 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1BVQmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Feb 2011 11:42:07 -0500
In-Reply-To: <20110222135431.GK21917@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Roger,
Any idea what the hash size does to memory usage?  I wonder if we can scale this based on the directory count, or if the memory usage is minimal (only needed in case of tdb) then just make it the default. It definitely appears to have been a major performance boost.

Another possible optuzatiom is to use the in-memory icount list (preferably with the patch to reduce realloc size) until the allocations fail and only then dump the list into tdb?  That would allow people to run with a swapfile configured by default, but only pay the cost of on-disk operations if really needed. 

Cheers, Andreas

On 2011-02-22, at 6:54, Rogier Wolff <R.E.Wolff@BitWizard.nl> wrote:

> On Tue, Feb 22, 2011 at 02:36:52PM +0100, Rogier Wolff wrote:
>> On Tue, Feb 22, 2011 at 11:20:56AM +0100, Rogier Wolff wrote:
>>> I wouldn't be surprised if I'd need more than 3G of RAM. When I
>>> extrapolated "more than a few days" it was at under 20% of the
>>> filesystem and had already allocated on the order of 800Gb of
>>> memory. Now I'm not entirely sure that this is fair: memory use seems
>>> to go up quickly in the beginning, and then stabilize: as if it has
>>> decided that 800M of memory use is "acceptable" and somehow uses a
>>> different strategy once it hits that limit.
>> 
>> OK. Good news. It's finished pass1. It is currently using about 2100Mb
>> of RAM (ehh. mostly swap, I have only 1G in there). Here is the patch.
> 
> Forgot the patch. 
> 
>    Roger. 
> 
> -- 
> ** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
> **    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
> *-- BitWizard writes Linux device drivers for any device you may have! --*
> Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
> Does it sit on the couch all day? Is it unemployed? Please be specific! 
> Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
> <cputimefix.patch>
