From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 blocksize peculiarities
Date: Fri, 24 Sep 2010 23:57:53 -0500
Message-ID: <4C9D8151.7090800@redhat.com>
References: <4C9D640E.5020609@sm-wg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Bernhard Rohrer <graylion@sm-wg.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab0IYE6f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Sep 2010 00:58:35 -0400
In-Reply-To: <4C9D640E.5020609@sm-wg.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bernhard Rohrer wrote:
> Hi all
> 
> I have a 3.3 TB partition (yes really) that is formatted with ext4 and 4
> kiB blocks. What little data I have on that appears to use up an
> extraordinary amount of space, so I had a closer look.
> 
> root@newcollab:/home/adminlion# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/primary_vg-primary_var
>                       3.5T   43G  3.3T   2% /var
> 
> we see that 43 GiB appear to be taking up something that gets rounded to
> 200 GiB

by default 5% is reserved for the super-user, 5% of 3.3T is 168G,
168G + 43G is roughly 200G

-Eric
 
> if we look at:
> 
> root@newcollab:/home/adminlion# df
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/mapper/primary_vg-primary_var
>           3696706360  44362800 3464561624   2% /var
> 
> now 44362800 4k blocks are 169.23 GiB, 

those are 1k blocks :)

Anyway, what you are seeing is the 5% reserved space, which does
not show up in "Used" but is reflected in "Avail"

It is confusing and you're not the first one to get tripped up :)

-Eric

> which does indeed round to 200
> GiB. similar usage also gets reported when I get the properties of the
> share via cifs.
> 
> debugfs shows:
> 
> Block count:              937689088
> Reserved block count:      46884454
> Free blocks:              912175341
> 
> so while df shows 4 times as many available 1k blocks as debugfs, which
> after all shows the actual number of 4k blocks, both are more or less in
> agreement as to the space used. This leads me to believe that somehow
> only 1k of every 4k block gets used. Now i could of course reformat to
> 1k blocks, but I'd prefer to avoid that.
> 
> OS is Lucid64 and the volume is a LVM volume.
> 
> Has anybody seen this before? Uncle Google was rather mum on the subject.
> 
> cheers
> 
> Bernhard
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

