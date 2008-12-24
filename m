From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: jbd2 inside a device mapper module
Date: Wed, 24 Dec 2008 18:49:15 -0500
Message-ID: <20081224234915.GA23723@mit.edu>
References: <20081224211038.GT4127@blitiri.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-mm-cc@lists.laptop.org,
	dm-devel@redhat.com
To: Alberto Bertogli <albertito@blitiri.com.ar>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63700 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330AbYLXXwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Dec 2008 18:52:36 -0500
Content-Disposition: inline
In-Reply-To: <20081224211038.GT4127@blitiri.com.ar>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 24, 2008 at 07:10:38PM -0200, Alberto Bertogli wrote:
> 
> I'm writing a small device mapper module, and I'm interested in placing
> a jbd/jdb2 journal on the backing device.
> 
> I started by trying to do a __bread() manually (just for early tests)
> inside my map function. But it got stucked, as far as I could see,
> waiting for a buffer head in wait_on_buffer() IIRC (I could track it
> down again if it's needed). And I couldn't find why it was locked, since
> it was an unused loopback device, and my code didn't even deal with
> buffer heads.

I have no idea why you would need to do manual __breads().  No doubt
I'm missing some context here.   

> Then, since I was planning on using jbd/jdb2 anyway, I decided to use it
> (and went for jbd2).
> 
> Now, I'm having issues with journal creation.
> 
> I tried using "mkfs.ext3 -O journal_dev", but jbd2_journal_load()
> complains that it can't find the journal superblock.

So I'll tell you how to do this via simple hard drives, and you can
figure out how to make it work with dm.  Note that if the journal
device isn't on a stand-alone spindle, it's probably not going to help
you.  The whole point of using an external journal device is to avoid
the seeking on the journal device, or to take advantage of the speed
of a battery-backed NVRAM device.  I'm not sure how much sense it
makes to use dm-based external journal device.... what exactly do you
hope to achieve.

To create an external journal device on the device /dev/sda:

   mke2fs -O journal_dev /dev/sda

To create a new filesystem on /dev/sdb1 that will use the external
journal found on /dev/sda:

   mke2fs -j -J device=/dev/sda /dev/sdb1

						- Ted

P.S.   All of this is in the mke2fs man page....
