From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [SOLVED] (was "Re: Restoring filenames from partly damaged
 ext4-filesystem")
Date: Sat, 11 Feb 2012 13:30:06 -0500
Message-ID: <20120211183006.GC13189@thunk.org>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
 <1328981610.63291.YahooMailNeo@web132402.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41369 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2BKSaI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Feb 2012 13:30:08 -0500
Content-Disposition: inline
In-Reply-To: <1328981610.63291.YahooMailNeo@web132402.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 11, 2012 at 05:33:30PM +0000, Rudolf Zran wrote:
> Hi List!
> 
> In an offlist reply someone recommended me ext4magic (see
> http://developer.berlios.de/projects/ext4magic ).

I wasn't familiar with ext4magic, so thanks for recommending it.
After taking a quick look at its wiki page, it looks like worthy
successor to ext3grep (which only works on ext3 file systems).  It
appears from their web page (I haven't had a chance to play with it
yet) that it uses a variety of techniques to recover data, which
combined should work really well.

Thanks for reporting back!

						- Ted
