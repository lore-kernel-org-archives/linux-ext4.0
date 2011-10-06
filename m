From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Wed, 5 Oct 2011 18:34:36 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1110051823380.8000@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com> <20110908185139.GA2393@quack.suse.cz> <alpine.DEB.2.01.1109091809180.9183@trent.utfs.org>
 <20110910200414.GA6709@quack.suse.cz> <alpine.DEB.2.01.1109122150060.9183@trent.utfs.org> <alpine.DEB.2.01.1109152044090.5628@trent.utfs.org> <20111005180339.GG23467@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	mszeredi@suse.cz, Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:57808 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1JFBej (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Oct 2011 21:34:39 -0400
In-Reply-To: <20111005180339.GG23467@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 5 Oct 2011 at 20:03, Jan Kara wrote:
>> With Miklos' patches applied to -rc5, this happend again just now :-(
>>
> Thanks for careful testing! Hmm, since you are able to reproduce on ppc
> but not on x86 there might be some memory ordering bug in Miklos' patches
> or it's simply because of different timing. Miklos, care to debug this
> further?

Just to be clear: I'm still not entirely sure how to reproduce this at 
will. I *assumed* that the daily remount-rw-and-ro-again routine that left 
some inodes in limbo and eventually lead to those "unprocessed orphan 
inodes". With that in mind I tried to reproduce this with the help of a 
test-script (test-remount.sh, [0]) - but the message did not occur while 
the script was running.

I've ran the script again today on the said powerpc machine on a 
loop-mounted 500MB ext4 partition. But even after 100 iterations no
such message occured.

So maybe it's caused by something else or my test-script just doesn't get 
the scenario right and there's something subtle to this whole 
remounting-business I haven't figured out yet, leading to those orphan 
inodes.

I'm at 3.1.0-rc9 now and will wait until the errors occur again.

Christian.

[0] nerdbynature.de/bits/3.1-rc4/ext4/
-- 
BOFH excuse #423:

It's not RFC-822 compliant.
