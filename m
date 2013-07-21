From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: EXT4 Larger Than 16TB
Date: Mon, 22 Jul 2013 07:43:26 +0800
Message-ID: <20130721234325.GA15659@gmail.com>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
 <20130709021403.GC6000@thunk.org>
 <CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
 <51EC64E8.8090509@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michael <mike@draftx.net>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64579 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3GUXne (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jul 2013 19:43:34 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so6365113pad.2
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 16:43:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <51EC64E8.8090509@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 21, 2013 at 03:47:04PM -0700, H. Peter Anvin wrote:
> On 07/09/2013 06:45 AM, Michael wrote:
> > No problem, it sounds like it would be a very tricky bit of code to
> > write. Shuffling metadata blocks is not an easy feat.
> > 
> > Is there any way to tell if I'm using 64 bit? Ubuntu defaults to
> > setting ext4 to default, but I don't know if it did when I first
> > created this FS.
> > 
> > If it is 64 bit, the resize2fs utility should be able to handle this
> > one kernels >3.7, correct?
> > 
> 
> Is there a way to force this at mkfs time?  I.e. "I know I may want to
> expand this filesystem beyond the 16 TB point?"

Hi Peter,

You could use 'mkfs.ext4 -O 64bit' to force enable 64bit support.  In
addition, we will enable this feature by default.  Lukas has a patch to
fix it.  Here is the link [1].

1. http://patchwork.ozlabs.org/patch/253234/

Regards,
                                                - Zheng
