From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: bh_count undeclared
Date: Sun, 25 May 2008 21:05:39 -0400
Message-ID: <20080526010539.GA3265@mit.edu>
References: <alpine.DEB.1.10.0805251727040.4890@sheep.housecafe.de> <20080525233809.GG5970@mit.edu> <alpine.DEB.1.10.0805260216110.4890@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36612 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843AbYEZBFs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 25 May 2008 21:05:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0805260216110.4890@sheep.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 26, 2008 at 02:19:10AM +0200, Christian Kujau wrote:
> On Sun, 25 May 2008, Theodore Tso wrote:
>> Whoops, my bad.  I was compiling with --enable-jfs-debug, and I didn't
>> notice the change I made broke things without that configuration
>> option.
>
> But even *with* --enable-jfs-debug the error occured.
>

Hmm... it shouldn't have.  It certainly works for me.

>> The right fix is just to surround the bh_count reference with an
>> #ifdef CONFIG_JBD_DEBUG.
>
> Right now the declaration of bh_count is surrounded with an #ifdef:
>
> But you want the refence surrounded by this #ifdef, right?

Yes, that's what I said.

Or grab the latest 'pu' branch that I pushed.  That should fix things
for you.

						- Ted
