From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Call traces on console from a test machine
Date: Mon, 17 Nov 2008 15:30:01 -0500
Message-ID: <20081117203001.GH14523@mit.edu>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net> <20081114170930.GI25117@mit.edu> <4921BEE2.1090700@hq.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kelly Kane <kelly@hq.newdream.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64845 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYKQUbx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2008 15:31:53 -0500
Content-Disposition: inline
In-Reply-To: <4921BEE2.1090700@hq.newdream.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 17, 2008 at 10:58:42AM -0800, Kelly Kane wrote:
> Theodore Tso wrote:
>> e2image -r /dev/sdXX -  | bzip2 > /tmp/sdXX.e2i.bz2
>>
>> ... and send it to me?
>
> http://ext4dev.dreamhosters.com/sdb1.e2i.bz2

Yikes, it is big.  Thanks....  it may take me a few days to find a
place to be able to store it and uncompress it, especially since I'm
travelling at the moment.  I do really appreciate your creating the
raw e2image file.  This should allow me to track down this problem:

> The pass 2 errors still make fsck exit early claiming to be aborted.

Thanks again!!!

						- Ted
