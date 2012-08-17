From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Far too long mount time
Date: Fri, 17 Aug 2012 14:44:07 -0500
Message-ID: <502E9F07.4020005@redhat.com>
References: <CAAnFQG_O051svcCZftDefebVEds+P1zAceteh=B18HOqmoqitg@mail.gmail.com> <CAAnFQG9esXovsAYkCS5Lw5JGpc5dW2PLccvYjN7NvaHLQDqGmA@mail.gmail.com> <0F24AF1B-39C9-4300-862B-B9E84A21E34C@dilger.ca> <1345126608.22142.59.camel@cwalton-XPS-8300> <20120816144219.GB29410@thunk.org> <20120816185337.GB31346@thunk.org> <20120817135506.GC11439@thunk.org> <018901cd7c87$515904b0$f40b0e10$@lucidpixels.com> <018a01cd7c89$05687cf0$103976d0$@lucidpixels.com> <20120817151320.GE11439@thunk.org> <20120817152747.GA31297@thunk.org> <024f01cd7cad$1bf722e0$53e568a0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "'Theodore Ts'o'" <tytso@mit.edu>,
	"'Calvin Walton'" <calvin.walton@kepstin.ca>, ap@solarrain.com,
	"'Andreas Dilger'" <adilger@dilger.ca>,
	"'Javier Marcet'" <jmarcet@gmail.com>,
	"'Linux Ext4 Mailing List'" <linux-ext4@vger.kernel.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2HQToP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 15:44:15 -0400
In-Reply-To: <024f01cd7cad$1bf722e0$53e568a0$@lucidpixels.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/17/12 2:18 PM, Justin Piszcz wrote:
>
>
> -----Original Message-----
> From: Theodore Ts'o [mailto:tytso@mit.edu]
> Sent: Friday, August 17, 2012 11:28 AM
> To: Justin Piszcz
> Cc: 'Calvin Walton'; ap@solarrain.com; 'Andreas Dilger'; 'Javier Marcet';
> 'Linux Ext4 Mailing List'
> Subject: Re: Far too long mount time
>
> OK, I think what you were trying to say; that you've only gone back to
> the original kernel and you have not tried the fixed patch.  Yes?
>
> Sorry, all of the excess quoting made it very hard for me to parse
> your reply....
>
> 						- Ted
>
>
> Hi Theo,
>
> I used the patch from this URL:
> http://www.spinics.net/lists/linux-ext4/msg33498.html
>
> The filesystem does mount quickly and normally BUT it shows up as 45TB and
> not the 60TB it is normally.
> I went back to the 3.5.1 kernel with 8aeb00ff85a reverted and all is back to
> normal.

Didn't this all start w/ df reporting issues?  Seems like we need an xfs 
test explicitly for extN, with and without minixdf ....

-Eric

