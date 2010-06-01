From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 1 Jun 2010 10:49:57 -0400
Message-ID: <070DAF41-4DD5-4F20-B9F1-3B472147C499@mit.edu>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org> <4C0358B1.1050605@uni-konstanz.de> <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>,
	"Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:56715 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab0FAOuN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 10:50:13 -0400
In-Reply-To: <AANLkTin3rfw04Shsmmd2O0URjWqbUhf-HOw4r2dXaprH@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jun 1, 2010, at 9:54 AM, Greg Freemyer wrote:
> 
> It has always been marked experimental in 2.6.27, not stable so I'm
> totally lost about this effort.
> 
> See http://lxr.linux.no/#linux+v2.6.27.47/fs/Kconfig

This is one of the things that confuses me, actually.  Why is it that there are a number of people who want to use ext4 on 2.6.27?   Even the enterprise distro's have moved on; SLES 11 SP1 upgraded their users from 2.6.27 to 2.6.32, for example.  I wonder if it's time to start a new "stable anchor point" around 2.6.32, given that Ubuntu's latest Long-Term Stable (Lucid LTS) is based on 2.6.32, as is SLES 11 SP1.  The RHEL 6 beta is also based on 2.6.32.  (And I just spent quite a bit of time over the past week backporting a lot of ext4 bug fixes to 2.6.32.y :-)

If there are people who want to work on trying to backport more ext4 fixes to 2.6.27, they're of course free to do so.  I am really curious  as to *why*, though.

Regards,

-- Ted

