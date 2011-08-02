From: Ted Ts'o <tytso@mit.edu>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 2 Aug 2011 12:57:57 -0400
Message-ID: <20110802165757.GD2967@thunk.org>
References: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
 <20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goldstein Amir <amir73il@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34717 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557Ab1HBQ6F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2011 12:58:05 -0400
Content-Disposition: inline
In-Reply-To: <20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 03, 2011 at 01:07:08AM +0900, Round Robinjp wrote:
> So that means I have thrown away some important part of
> the filesystem when I did truncate -s 1G, isn't it?
> Will things go wrong if I flash this 1G image to my eMMC
> partition (without using Yongqiang's new 64bit resize patches)?
> I need to understand whether Yongqiang's patch is absolutely
> necessary for this purpose or just a good thing to have.

This is one of the reasons why I originally suggested using zero_free
and make_sparse to write the file system image.  It's a much, much,
MUCH simpler way of handling things, and it doesn't require resizing
the file system image, using truncate (and making sure you truncate to
the right size, etc.).

With the method Amir talked about, it matters whether or not the file
system is mounted when you use resize2fs, whether you have the latest
resize patches, etc., etc.

						- Ted

