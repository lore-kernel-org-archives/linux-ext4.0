From: frankcmoeller@arcor.de
Subject: Aw: Re: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sun, 19 May 2013 15:00:03 +0200 (CEST)
Message-ID: <1545375580.3424480.1368968403367.JavaMail.ngmail@webmail10.arcor-online.net>
References: <1626815623.663380.1368957713809.JavaMail.ngmail@webmail08.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:43885 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731Ab3ESNAF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 May 2013 09:00:05 -0400
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net [151.189.8.28])
	by mx.arcor.de (Postfix) with ESMTP id 6313810C06E
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 15:00:03 +0200 (CEST)
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net [151.189.21.44])
	by mail-in-11-z2.arcor-online.net (Postfix) with ESMTP id 647697FF45A
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 15:00:03 +0200 (CEST)
Received: from webmail10.arcor-online.net (webmail10.arcor-online.net [151.189.8.93])
	by mail-in-04.arcor-online.net (Postfix) with ESMTP id 624ADAA3DF
	for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 15:00:03 +0200 (CEST)
In-Reply-To: <1626815623.663380.1368957713809.JavaMail.ngmail@webmail08.arcor-online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> One question regarding fallocate: I create a new file and do a 100MB
> fallocate 
> with FALLOC_FL_KEEP_SIZE. Then I write only 70MB to that file and close it.
> Is the 30 MB unused preallocated space still preallocated for that file
> after closing
> it? Or does a close release the preallocated space?

I did some tests and now I can answer it by myself ;-)
The space stays preallocated after closing the file. Also umount don't releases 
the space. Interesting!

I was testing concurrent fallocates and writes to the same file descriptor. It 
seems to work. If it is quick enough I cannot say at the moment.

Regards,
Frank

----- Original Nachricht ----
Von:     frankcmoeller@arcor.de
An:      linux-ext4@vger.kernel.org
Datum:   19.05.2013 12:01
Betreff: Re: Aw: Re: Ext4: Slow performance on first write after mount

> Hi Andreas,
> 
> > Part of the problem is that filesystems are rarely unmounted cleanly, so
> it
> > means that this information would need to be updated periodically to disk
> so
> > that it is available after a crash.
> > I wouldn't object to some kind of "lazy" updating of group information on
> > disk that at least gives the newly-mounted filesystem a rough idea of
> what
> > each group's usage is. It wouldn't have to be totally accurate (it
> wouldn't
> > replace the bitmaps), but maybe 2 bits per group would be enough as a
> > starting point?
> > For a 32 TB filesystem that would be about 16 4kB blocks of bits that
> would
> > be updated periodically (e.g. every five minutes or so). Since the
> allocator
> > will typically work in successive groups that might not cause too much
> > churn. 
> 
> Yes, you're right. The stored data wouldn't be 100% reliable. And yes, it
> would be really good if 
> right after mount the filesystem would knew something more to find a good
> group quicker.
> What do you think of this:
> 1. I read this already in some discussions: You already store the free space
> amount for every
>   group. Why not also storing how big the biggest contiguous free space
> block in a group is? Then you 
>   don't have to read the whole group.
> 2. What about a list (in memory and also stored on disk) with all unused
> groups (1 bit for every group).
>   If the allocator cannot find a good group within lets say half second, a
> group from this list is used.
>   The list is also not be 100% reliable (because of the mentioned unclean
> unmounts), so you need to search
>   a good group in the list. If no good group was found in the list, the
> allocator can continue searching.
>   This don't helps in all situations (e.g. almost full disk or every group
> contains a small amount of data),
>   but it should be in many cases much faster, if the list is not totally
> outdated.
> 
> > It would be possible to fallocate() at some expected size (e.g. average
> file
> > size) and then either truncate off the unused space, or fallocate() some
> > more in another thread when you are close to tunning out. 
> > If the fallocate() is done in a separate thread the latency can be hidden
> > from the main application?
> Adding a new thread for fallocate shouldn't be a big problem. But fallocate
> might 
> generate high disk usage (while searching for a good group). I don't know
> whether
> parallel writing from the other thread is quick enough.
> 
> One question regarding fallocate: I create a new file and do a 100MB
> fallocate 
> with FALLOC_FL_KEEP_SIZE. Then I write only 70MB to that file and close it.
> Is the 30 MB unused preallocated space still preallocated for that file
> after closing
> it? Or does a close release the preallocated space?
> 
> Regards,
> Frank
> 
> > 
> > Cheers, Andreas 
> > 
> > > And you have to take care about alignment and there are several threads
> in
> > the internet which explain why you shouldn't use it (or only in very
> special
> > situations and I don't think that my situation is one of them). And ext4
> > group initialization takes also place when using O_DIRECT (as said before
> > perhaps I did something wrong).
> > > 
> > > Regards,
> > > Frank
> > > 
> > > ----- Original Nachricht ----
> > > Von:     "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
> > > An:      "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>, ext4
> > development <linux-ext4@vger.kernel.org>
> > > Datum:   17.05.2013 23:18
> > > Betreff: Re: Ext4: Slow performance on first write after mount
> > > 
> > >> Hi Frank,
> > >> 
> > >> Consider using bigalloc feature (requires reformat), preallocate space
> > >> with fallocate and use O_DIRECT for reads/writes. However, 188k writes
> > >> are too small for good throughput with O_DIRECT. You might also want
> to
> > >> adjust max_sectors_kb to something larger than 512k.
> > >> 
> > >> We're doing 6in+6out 20Mbps streams just fine.
> > >> 
> > >> Regards,
> > >> Andrei.
> > >> 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4"
> in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
