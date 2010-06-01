From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 01 Jun 2010 15:06:37 -0500
Message-ID: <4C05684D.5050204@jaysonking.com>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org> <4C0358B1.1050605@uni-konstanz.de> <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com> <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Kay Diederichs <kay.diederichs@uni-konstanz.de>,
	"Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout08.eigbox.net ([66.96.190.8]:47594 "EHLO
	bosmailout08.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab0FAUhg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 16:37:36 -0400
In-Reply-To: <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/01/2010 09:49 AM, Theodore Tso wrote:
> This is one of the things that confuses me, actually.  Why is it that there are a number of people who want to use ext4 on 2.6.27?   Even the enterprise distro's have moved on; SLES 11 SP1 upgraded their users from 2.6.27 to 2.6.32, for example.  I wonder if it's time to start a new "stable anchor point" around 2.6.32, given that Ubuntu's latest Long-Term Stable (Lucid LTS) is based on 2.6.32, as is SLES 11 SP1.  The RHEL 6 beta is also based on 2.6.32.  (And I just spent quite a bit of time over the past week backporting a lot of ext4 bug fixes to 2.6.32.y :-)
>
> If there are people who want to work on trying to backport more ext4 fixes to 2.6.27, they're of course free to do so.  I am really curious  as to *why*, though.

2.6.27 is still a good kernel and ext4 is a good filesystem, IMO 
(existing deadlock notwithstanding).

Like Kay Diederichs mentioned, .27 has received ext4 updates in the 
past, even as recently as April this year ("ext4: Avoid null pointer 
dereference..."). Though this of course does not imply that .27 should 
receive ext4 fixes (or other fixes) forever, but it is nice to fix the 
most serious, show-stopping problems if it is feasable.

(maybe OT?: When I made an attempt to switch to kernel .31 or .32 
earlier, the kernel would not boot for me. Surely, I can do some 
investigating and get it to boot some day, but I wasn't motivated to 
solve it at the time and stuck with .27 instead.)

Thanks for the comments.

Rgds,

Jayson

