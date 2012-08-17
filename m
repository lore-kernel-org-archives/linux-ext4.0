From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: Far too long mount time
Date: Fri, 17 Aug 2012 15:18:37 -0400
Message-ID: <024f01cd7cad$1bf722e0$53e568a0$@lucidpixels.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com> <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca> <1345126608.22142.59.camel@cwalton-XPS-8300> <20120816144219.GB29410@thunk.org> <20120816185337.GB31346@thunk.org> <20120817135506.GC11439@thunk.org> <018901cd7c87$515904b0$f40b0e10$@lucidpixels.com> <018a01cd7c89$05687cf0$103976d0$@lucidpixels.com> <20120817151320.GE11439@thunk.org> <20120817152747.GA31297@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Calvin Walton'" <calvin.walton@kepstin.ca>, <ap@solarrain.com>,
	"'Andreas Dilger'" <adilger@dilger.ca>,
	"'Javier Marcet'" <jmarcet@gmail.com>,
	"'Linux Ext4 Mailing List'" <linux-ext4@vger.kernel.org>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50415 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2HQTSm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Aug 2012 15:18:42 -0400
Received: by yenl14 with SMTP id l14so4307073yen.19
        for <linux-ext4@vger.kernel.org>; Fri, 17 Aug 2012 12:18:42 -0700 (PDT)
In-Reply-To: <20120817152747.GA31297@thunk.org>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Friday, August 17, 2012 11:28 AM
To: Justin Piszcz
Cc: 'Calvin Walton'; ap@solarrain.com; 'Andreas Dilger'; 'Javier Marcet';
'Linux Ext4 Mailing List'
Subject: Re: Far too long mount time

OK, I think what you were trying to say; that you've only gone back to
the original kernel and you have not tried the fixed patch.  Yes?

Sorry, all of the excess quoting made it very hard for me to parse
your reply....

						- Ted


Hi Theo,

I used the patch from this URL:
http://www.spinics.net/lists/linux-ext4/msg33498.html

The filesystem does mount quickly and normally BUT it shows up as 45TB and
not the 60TB it is normally.
I went back to the 3.5.1 kernel with 8aeb00ff85a reverted and all is back to
normal.

Justin.

