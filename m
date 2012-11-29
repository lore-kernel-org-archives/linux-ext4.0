From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: fix configure help text for quota
Date: Wed, 28 Nov 2012 23:50:46 -0600
Message-ID: <50B6F7B6.4050003@redhat.com>
References: <50B504C4.6090504@redhat.com> <20121129040323.GA8029@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab2K2Fut (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2012 00:50:49 -0500
In-Reply-To: <20121129040323.GA8029@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/28/12 10:03 PM, Theodore Ts'o wrote:
> On Tue, Nov 27, 2012 at 12:21:56PM -0600, Eric Sandeen wrote:
>> It's --enable-quota, not --enable-libquota.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks, applied.
> 
>> PS it's still off by default.  Should it be?  What bugs remain?
> 
> Yeah, we probably should turn it on.  It's turned on by default in
> Debian in the 1.42.x releases.  I don't know of any remaining bugs,
> but at the same time, it's not gotten a lot of use to date.
> 
>        	   	      	       	      - Ted

Hum, ok.

Maybe then rather than fixing up all the configure stuff, I
should have just removed the switch and turned it on.  Oh well.

-Eric

