From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 00:58:12 +0100
Message-ID: <7BE97618-725C-4BFA-9FE5-59C893BDA097@dilger.ca>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <AANLkTik0DkQa7NrGbpSVVAkhQ4O9+kenPSr2dP=+Ej94@mail.gmail.com> <C0A67981-AF1A-40FF-91BA-93ECF6F72B58@dilger.ca> <201103212005.37108.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andrei Warkentin <andreiw@motorola.com>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31773 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab1CVADM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Mar 2011 20:03:12 -0400
In-Reply-To: <201103212005.37108.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-21, at 8:05 PM, Arnd Bergmann wrote:
> On Monday 21 March 2011 19:03:09 Andreas Dilger wrote:
>> Note that mballoc was specifically designed to handle allocation
>> requests that are aligned on RAID stripe boundaries, so it should
>> be able to handle this for MMC as well.  What is needed is to tell
>> the filesystem what the underlying alignment is.  That can be done
>> at format time with mke2fs or afterward with tune2fs by using the
>> "-E stripe_width" option.
> 
> Ah, that sounds useful. So would I set the stripe_width to the
> erase block size, and the block group size to a multiple of that?

When you write "block group size" do you mean the ext4 block group?  Then yes it would help.  You could also consider setting the flex_bg size to a multiple of this, so that the bitmap blocks are grouped as a multiple of this size.  However, they may not be aligned correctly, which needs extra effort that isn't obvious.  

I think it would be nice to have mke2fs take the stripe_width and/or flex_bg factor into account when sizing/aligning the bitmaps, but it doesn't yet.

> Does this also work in (rare) cases where the erase block size is
> not a power of two?

It does (or is supposed to), but that isn't code that is exercised very much (most installations use a power-of-two size).

Cheers, Andreas





