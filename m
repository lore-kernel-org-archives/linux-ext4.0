From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Sat, 19 Apr 2008 20:24:55 -0500
Message-ID: <480A9B67.2050200@redhat.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbYDTB1F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Apr 2008 21:27:05 -0400
In-Reply-To: <20080419220432.GB30449@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sat, Apr 19, 2008 at 02:07:34PM -0500, Eric Sandeen wrote:


>> If you really just want to verify a snapshot of the fs at a point in
>> time, surely there are simpler ways.  If the device is on lvm, there's
>> already a script floating around to do it in automated fasion.  (I'd
>> pondered the idea of introducing META_WRITE (to go with META_READ) and
>> maybe lvm could do a "metadata-only" snapshot to be lighter weight?)
> 
> That would be great, although I think the major issue is not
> necessarily the performance problems of using an LVM snapshot on a
> very busy filesystem 

well, backing space for the snapshot could be an issue too.  Basically,
if you're only using it for this purpose, why COW all the post-snapshot
data if you just don't care...

> (althouh I could imagine for some users this
> might be an issue), but rather for filesystem devices that aren't
> using LVM at all.  (I've heard some complaints that LVM imposes a
> performance penalty even if you aren't using a snapshot; has anyone
> done any benchmarks of a filesystem with and without LVM to see
> whether or not there really is a significant performance penalty;
> whether or not there really is one, the perception is definitely out
> there that it does.)

I've heard from someone who did some testing about a minor penalty, but
I can't point to any published test so I guess that's just more hearsay.
 It's intuitive that putting lvm on top of a block device might not be
absolutely, 100% free, though....  Adds to stack, too.

> If we could do a lightweight snapshot that didn't require an LVM, that
> would be really great.  But that's probably not an ext4 project, and
> I'm not sure the it would be considered politically correct in the
> LKML community.

Yep; my original reply originally wished something about non-lvm
snapshots but... while yes, it'd be nice for this purpose, ponies for
everyone would be nice too... :)  But I didn't mention it because... how
do you do a generic non-lvm snapshot of, say, /dev/sda3 without some
sort of volume manager...?

If there's some clever idea that could be implemented cleanly, I'd be
all ears.  :)

-Eric
