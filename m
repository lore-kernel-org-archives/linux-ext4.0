From: Grzegorz Kulewski <kangur@polcom.net>
Subject: Re: ext4 roadmap
Date: Thu, 2 Nov 2006 00:52:41 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0611020026000.14187@alpha.polcom.net>
References: <1162422997.13777.35.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alpha.polcom.net ([83.143.162.52]:36060 "EHLO alpha.polcom.net")
	by vger.kernel.org with ESMTP id S1751034AbWKAXwr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 18:52:47 -0500
To: Dave Kleikamp <shaggy@austin.ibm.com>
In-Reply-To: <1162422997.13777.35.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On Wed, 1 Nov 2006, Dave Kleikamp wrote:
> It has been discussed in the conference call that we need to better
> define the requirements for ext4 and set some kind of target for when
> new function should be added, so we can then work on stabilizing the
> code and getting it production-ready.  The list below is based on the
> candidate features list in Documentation/filesystems/ext4.txt.  It is by
> no means complete, as some other ideas are being floated around, and I
> very well may have missed some features.

Is there any chance to get compression and/or encryption in ext4?

Compression could be very usefull for directories (or whole trees) with 
big amount text or nearly text documents (like man pages, ebuilds in 
Gentoo, many other things).

But compression (on small files) would probably only work good if they 
will be aggregated somehow - like tail in reiserfs3 or something. Maybe 
there could be some attribute per directory meaning "there are 
only/mainly small files in this directory, try to store them together" and 
another "try to compress contents of this directory"?

As to the encryption - everybody knows why it can be usefull (of course 
not to store your warez and porn in a safe place... :-) - to protect 
important company secrets!). Since encryption algorithms are already 
available in kernel and encryption does not change lenght of data it 
should be easily doable. No?


Also, while working on openvz vservers I found that having per-dir quota 
would be usefull. Basically I mean I want to be able to say that if ext4 
is mounted under /foo then whole content of /foo/001 could only take 20GB 
(and maybe even that additionally /foo/001/tmp can take only 2GB - then 
both limits work for /foo/001/tmp of course). And of course I want to be 
able to know how much of this 20GB or 2GB is used. The same goes for 
inodes.

People in openvz done some artificial filesystem (simfs) to do that but it 
does not look too good, is not journaled (== it looses it's calculations 
during crash or any other strange event, including probably accessing that 
part of the native filesystem directly under it and recalculation it's 
quota can take really long time) and so on. Making it part of the native 
filesystem could work better. And probably this can be usefull not only 
for vserver solutions.

So, is there any chance to see something like that in ext4?



Thanks,

Grzegorz Kulewski
