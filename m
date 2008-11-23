From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Maximum filename length
Date: Sat, 22 Nov 2008 22:08:06 -0500
Message-ID: <20081123030806.GH9150@mit.edu>
References: <87a8dc10811210451p3ec1e3dar371a3ebffcedcdc@mail.gmail.com> <20081121223248.GA22671@mit.edu> <91b13c310811211850s74cb9ec4x6b311612ed31664c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Salmin <alexey.salmin@gmail.com>, linux-ext4@vger.kernel.org
To: rae l <crquan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:48966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbYKWEnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Nov 2008 23:43:41 -0500
Content-Disposition: inline
In-Reply-To: <91b13c310811211850s74cb9ec4x6b311612ed31664c@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 22, 2008 at 10:50:25AM +0800, rae l wrote:
> In China, there's also a trend moving ahead from 2bytes charsets
> (GB2312/GBK/GB18030/BIG5) to UTF-8, so all Chinese characters will
> need 3 bytes for each to each instead of 2 from then on. The 255
> filename length limit the Chinese filename to 85 characters:

Sure, but 85 characters is a lot, given that each character might be
the equivalent of multiple letters.  For example the English word
"country", which takes six characters, or 6 bytes in UTF-8, can be
encoded as a single Chinese ideograph, which can be encoded in 3 bytes
in UTF-8.  Something like "United States of America", is encoded in 24
bytes in English, and 6 bytes (two ideographs) in Chinese in UTF-8.
My name, "Theodore Yue Tak Ts'o", takes 21 bytes in English and UTF-8.
In Chinese, it's 3 ideographs, or 9 bytes in UTF-8.  I'm choosing
fairly basied examples here, of course, but I think it's in general
true.

As a final example consider, "The Tao which can be described is not
the true Tao".  This can be expressed *much* more succiently in
Chinese.  :-)

So I don't think people who use the Chinese writing system have much
to complain about with respect to the 255 byte / 85 ideograph limit.
I have much more sympathy for people who trying to are trying to write
something like "Union of Soviet Socialist Republics" in Russian, and
find that it takes many more bytes in UTF-8.....

					- Ted
