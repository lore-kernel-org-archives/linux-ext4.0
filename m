From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.5.1 kernel: Oops + stracktrace + ext4 kernel errors!
Date: Fri, 24 Aug 2012 19:29:21 -0400
Message-ID: <069c01cd8250$4a8b7360$dfa25a20$@lucidpixels.com>
References: <CAO9zADxVjZ7y-wGqV2n89yov_z=XT6zxhHQW4Yp+whe0RO5tuA@mail.gmail.com> <20120824223854.GF5094@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
	"'al piszcz'" <ap@solarrain.com>
To: "'Theodore Ts'o'" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2HXX3Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Aug 2012 19:29:24 -0400
Received: by ialo24 with SMTP id o24so4419426ial.19
        for <linux-ext4@vger.kernel.org>; Fri, 24 Aug 2012 16:29:23 -0700 (PDT)
In-Reply-To: <20120824223854.GF5094@thunk.org>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



-----Original Message-----
From: Theodore Ts'o [mailto:tytso@mit.edu] 
Sent: Friday, August 24, 2012 6:39 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; linux-ext4@vger.kernel.org; al piszcz
Subject: Re: 3.5.1 kernel: Oops + stracktrace + ext4 kernel errors!

On Fri, Aug 24, 2012 at 11:31:44AM -0400, Justin Piszcz wrote:
> Hello,
> 
> Thoughts?
> 
> Saw this when trying to copy files to array with Samba and doing file
> operations:
> 
> [28939.505792] ------------[ cut here ]------------
> [29367.345433] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000028
> [29367.345455] IP: [<ffffffff8116539c>] ext4_ext_remove_space+0x89c/0xc90

Fixed by commit 89a4e48f84 in upstream.  It is scheduled for inclusion
in the a stable kernel series; I believe it should be in 3.5.3.

Regards,

					- Ted


--

Thanks.. if/when I come across another box I can test with I will ensure
that patch (89a4e48f84 ) gets applied.  For PROD hosts I need stability >
16T.

Justin.

