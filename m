From: Theodore Tso <tytso@mit.edu>
Subject: Re: EXT4 ENOSPC Bug
Date: Wed, 18 Feb 2009 22:22:44 -0500
Message-ID: <20090219032244.GW3600@mini-me.lan>
References: <200811291418.24672.andres@anarazel.de> <200812100108.04163.andres@anarazel.de> <49994FEF.2020908@anarazel.de> <20090216150156.GD22619@mini-me.lan> <499985C7.8010302@anarazel.de> <20090216190001.GB11788@mini-me.lan> <499AF598.7080400@anarazel.de> <499C7B41.1090800@anarazel.de> <20090218212957.GR3600@mini-me.lan> <499CC185.6050904@anarazel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Buell <alex.buell@munted.org.uk>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	Jonathan Bastien-Filiatrault <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andres Freund <andres@anarazel.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42092 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbZBSFBM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Feb 2009 00:01:12 -0500
Content-Disposition: inline
In-Reply-To: <499CC185.6050904@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 19, 2009 at 03:18:45AM +0100, Andres Freund wrote:
> On 02/18/2009 10:29 PM, Theodore Tso wrote:
>> Ok, that's good.  Good to know the workaround works.
>> Can you send me a dumpe2fs of the filesystem in question?  I'm curious
>> what was going on...
> Will do as soon as I am at the same place as the machine. I guess thats  
> only interesting to you privately (size and so on)?
>
>> Thanks for the report.  I'll push the workaround patch to Linus for
>> 2.6.29 to avoid this problem for now.  I recently sent to linux-ext4
>> for comment a patch to revamp the Orlov allocator for flex_bg and to
>> use that instead of find_group_flex(), but no way that's going into
>> 2.6.29 at this point....
> Would it be helpfull if I test that patch?
>

Sure, I'll take all of the testing I can get.  :-)

The patch is in the ext4 patch queue, and I sent them to the ext4
patch queue.  The patch is also in patch work:

http://patchwork.ozlabs.org/patch/23343/

The patch which I sent you earlier (available below) is a prequisite:

http://patchwork.ozlabs.org/patch/23228/


							- Ted

