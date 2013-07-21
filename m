From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: EXT4 Larger Than 16TB
Date: Sun, 21 Jul 2013 15:47:04 -0700
Message-ID: <51EC64E8.8090509@zytor.com>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com> <20130709021403.GC6000@thunk.org> <CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Michael <mike@draftx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:37307 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3GUWr1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jul 2013 18:47:27 -0400
In-Reply-To: <CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/09/2013 06:45 AM, Michael wrote:
> No problem, it sounds like it would be a very tricky bit of code to
> write. Shuffling metadata blocks is not an easy feat.
> 
> Is there any way to tell if I'm using 64 bit? Ubuntu defaults to
> setting ext4 to default, but I don't know if it did when I first
> created this FS.
> 
> If it is 64 bit, the resize2fs utility should be able to handle this
> one kernels >3.7, correct?
> 

Is there a way to force this at mkfs time?  I.e. "I know I may want to
expand this filesystem beyond the 16 TB point?"

	-hpa


