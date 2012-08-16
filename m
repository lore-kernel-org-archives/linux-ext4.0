From: Marc MERLIN <marc@merlins.org>
Subject: Re: du -s src is a lot slower on SSD than spinning disk in the same laptop
Date: Thu, 16 Aug 2012 10:55:40 -0700
Message-ID: <20120816175540.GH8802@merlins.org>
References: <20120725154521.GA3398@merlins.org> <alpine.LFD.2.00.1207252023080.4340@(none)> <20120726033223.GA5884@thunk.org> <20120726065412.GB20315@merlins.org> <20120801053042.GG12695@merlins.org> <20120816075004.GE8802@merlins.org> <502CC2A2.4010506@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58117 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814Ab2HPRzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Aug 2012 13:55:42 -0400
Content-Disposition: inline
In-Reply-To: <502CC2A2.4010506@shiftmail.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 16, 2012 at 11:51:30AM +0200, Spelic wrote:
> On 08/16/12 09:50, Marc MERLIN wrote:
> >On Tue, Jul 31, 2012 at 10:30:42PM -0700, Marc MERLIN wrote:
> >>How can ntfs via fuse be the fastest?
> >To provide closure to this thread.
> >
> >I owed everyone an update, which I just finished typing:
> >http://marc.merlins.org/perso/linux/post_2012-08-15_The-tale-of-SSDs_-Crucial-C300-early-Death_-Samsung-830-extreme-random-IO-slowness_-and-settling-with-OCZ-Vertex-4.html
> 
> Hello,
> reading your article a few ideas came to my mind.
> 
> Firstly, for the Crucial, I haven't read much about that bug, but would 
> leaving the last 20% of the drive free (make an empty partition there 
> and then fstrim it and leave it empty) help with that bug? Maybe the 
> garbage collection algorithm hasn't got enough free blocks to shuffle 
> data around. I am interested because Crucial would be my prime choice 
> for what I read around. When it resuscitated did you try to TRIM it 
> wholly to try regain performances? I don't know if you still have it around.
 
The drive was still mostly dead, it didn't work long enough for me to try to
reformat it. I RMA'ed it and haven't used the replacement yet because I
don't have data I don't care about enough :)

> Secondly, for the Samsung 830:
> The random access slowness is reproducible also without dm-crypt it 
> seems to me. This benchmark of yours was NOT on dm-crypt, correct?
> http://www.spinics.net/lists/linux-btrfs/msg18238.html

Correct.

> In your  fio benchmarks, e.g.
> http://www.spinics.net/lists/linux-btrfs/msg18204.html
> I noticed how the iodepth is at 64
> 
> The Samsung SSD has a bug on high IO depths:
> 
> http://www.bit-tech.net/hardware/2011/09/29/samsung-ssd-830-256gb-review/3
> http://www.bit-tech.net/hardware/2011/09/29/samsung-ssd-830-256gb-review/5
> already at 32 behaves bad.
> 
> Please do
> echo 1 > /sys/block/sdX/device/queue_depth
 
Sorry, I don't have the drives anymore, so I can't, but between you and me
if the drive fails to perform after as much work I put in it, as in its
default configuration on windows 7, that's pretty damn sad.

Point being that those things should kind of "just work", like the Crucial
(before sudden death) and the OCZ.
I spent too many hours of my life trying to get the damn drive to perform,
and if it takes even more kernel and IO experts to kind of get the drive to
work (assuming it would have, and at this point I'm not certain), then it's
crap in my book (also you can't tune half that stuff on windows for the
primary users who would buy that drive).

You are welcome to order one though and try your own tests and post them
here. Worst case, you can return it if it sucks for you too.

I just added the screeshot of the windows benchmarks if that helps.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
