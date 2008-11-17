From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Call traces on console from a test machine
Date: Mon, 17 Nov 2008 15:20:04 -0600
Message-ID: <4921E004.7040000@redhat.com>
References: <491CC6E3.7070808@hq.newdream.net> <491CDF90.8070802@hq.newdream.net> <20081114170930.GI25117@mit.edu> <4921BEE2.1090700@hq.newdream.net> <20081117203001.GH14523@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kelly Kane <kelly@hq.newdream.net>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbYKQVU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Nov 2008 16:20:29 -0500
In-Reply-To: <20081117203001.GH14523@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Nov 17, 2008 at 10:58:42AM -0800, Kelly Kane wrote:
>> Theodore Tso wrote:
>>> e2image -r /dev/sdXX -  | bzip2 > /tmp/sdXX.e2i.bz2
>>>
>>> ... and send it to me?
>> http://ext4dev.dreamhosters.com/sdb1.e2i.bz2
> 
> Yikes, it is big.  Thanks....  it may take me a few days to find a
> place to be able to store it and uncompress it, especially since I'm
> travelling at the moment.  I do really appreciate your creating the
> raw e2image file.  This should allow me to track down this problem:
> 
>> The pass 2 errors still make fsck exit early claiming to be aborted.
> 
> Thanks again!!!

Ted, what do you think about putting make-sparse.c into e2fsprogs?
Might be handy for this sort of thing, rather than searching the
innertubes for it each time I need it ;)

(Now, we'll see if ext4 can cope with the bazillions of extents this
will create...)

-Eric

> 						- Ted

