From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Repost (from LKML): EXT3 FS and 64K blocks error
Date: Sat, 10 Jul 2010 16:14:54 -0600
Message-ID: <42752894-1B06-4A05-BAC0-511F9C298143@dilger.ca>
References: <469D2D911E4BF043BFC8AD32E8E30F5B24AEE9@wdscexbe07.sc.wdc.com> <7D7CBABC-08DF-4D5D-9655-D378529882B0@mit.edu> <469D2D911E4BF043BFC8AD32E8E30F5B24AEEE@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:31165 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0GJWPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 10 Jul 2010 18:15:36 -0400
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEEE@wdscexbe07.sc.wdc.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-07-09, at 16:32, Daniel Taylor wrote:
> I guess we'll find out how well they work ;)  we're putting them into
> pre-production test now.  The main reason is that we're building a NAS
> that will see significant use as a media server (we hope) and we do see
> a performance improvement with the larger file system blocks in our
> engineering tests.

I suspect that the reason you see better performance with ext3 and 64kB blocksize is due to the lower per-block allocation overhead.  This issue is gone with ext4 due to extents and mballoc.

>> Is there a particular reason why you care about this with 
>> ext3?   Ext4 does provide a superset of the features in ext3...
> 
> We're switching to ext4.  I just thought someone might want to take
> a look at the error message.  I can do some more testing, next
> week, if there are suggestions of what to try.

It would be interesting to see if there are still differences in performance with ext4 + 64kB blocksize.  At a minimum it is good for someone to test the 64kB blocksize support (which not many people can do), and it is worthwhile to know if there is still performance to be gained from large blocksize or not.

Cheers, Andreas





