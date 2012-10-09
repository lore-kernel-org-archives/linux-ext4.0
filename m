From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running
 xfstest
Date: Tue, 9 Oct 2012 14:29:31 +0800
Message-ID: <20121009062931.GA29314@gmail.com>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
 <20121009054820.GA8028@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53751 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2JIGSi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2012 02:18:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so4697065pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 08 Oct 2012 23:18:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20121009054820.GA8028@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 09, 2012 at 01:48:20AM -0400, Theodore Ts'o wrote:
> On Mon, Oct 08, 2012 at 10:59:34PM +0800, Zheng Liu wrote:
> > 
> > This warning is printed when test case #127 and #225 are being run
> > with bigalloc and delalloc.  You could use the following commands to
> > reproduce it using xfstest.
> 
> Ah, I see I misunderstood you; I thought you had said that the tests
> had failed, I didn't realize what what you had meant was that they
> were trigging a WARN_ON.
> 
> I believe this warning is related to the general class of bugs
> surrounding bigalloc and delalloc, once we get the extent status tree
> in mainline, I'm hoping we will be able to use it to significantly
> improve how we handle bigalloc's delalloc handling.
> 
> Here are the results I have from running my tests, as well as the
> results from right after the previous merge window for comparison....

Sorry for my bad expression. :-(

OK, I see.  Thanks for the result.  It is very useful for me to
understand whether or not my patches break something up.

Regards,
Zheng
