From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Tue, 22 Apr 2008 19:52:29 -0500
Message-ID: <480E884D.7010602@redhat.com>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <804dabb00804220954s67d56cacj89098d88697565aa@mail.gmail.com> <480E1A3F.9030103@redhat.com> <20080422213144.GW2775@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Teoh <htmldeveloper@gmail.com>, Theodore Tso <tytso@mit.edu>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbYDWAyi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2008 20:54:38 -0400
In-Reply-To: <20080422213144.GW2775@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Apr 22, 2008  12:02 -0500, Eric Sandeen wrote:
>> Peter Teoh wrote:
>>> On Sun, Apr 20, 2008 at 3:07 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>>>>  If you really just want to verify a snapshot of the fs at a point in
>>>>  time, surely there are simpler ways.  If the device is on lvm, there's
>>>>  already a script floating around to do it in automated fasion.  (I'd
>>>>  pondered the idea of introducing META_WRITE (to go with META_READ) and
>>>>  maybe lvm could do a "metadata-only" snapshot to be lighter weight?)
>>> Can I know where is this script?   Or if u cannot locate it, does it
>>> have any resemblance to all the stuff mentioned below?.
>> Google for "lvcheck" and find it buried in a thread "forced fsck
>> (again?)" on the ext3-users list - I'm not sure if it has an upstream
>> home anywhere yet...
> 
> We thought the best place to put it would be in the lvm2 utilities, since
> it is tied to LVM snapshots (and not really a particular filesystem).
> 
> Eric, any chance you could pass the script over to the LVM folks at RH?
> AFAIK, they are the official LVM/DM maintainers still (adopted as part of
> Sistina and GFS).

Sure, I'll see who I can bug :)

-Eric
