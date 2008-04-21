From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
 checker)
Date: Mon, 21 Apr 2008 19:40:31 +0200
Message-ID: <480CD18F.7000108@firstfloor.org>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com> <20080419012952.GE25797@mit.edu> <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com> <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com> <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org> <20080420234241.GB23292@shareable.org> <20080421080111.GD14446@one.firstfloor.org> <1208798974.14123.28.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:58493 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYDURki (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 13:40:38 -0400
In-Reply-To: <1208798974.14123.28.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> Am I correct that the Linux fsync(), when used =EF=BB=BF(from userspa=
ce)
> directly on file descriptors associated with block devices doesn't
> actually flush the disk write cache and wait for the data to reach th=
e
> disk before returning?

Not quite. It depends. Sometimes it does this and sometimes it doesn't,
depending on the disk and the controller and the file system and the
kernel version and the distribution default.

=46or details search the archives of linux-kernel/linux-fsdevel. This
has been discussed many times.

> Is there a reason why this isn't being done other than performance?

One reason against it is that in many (but not all) setups to guarantee
reaching the platter you have to disable the write cache, and at least
for consumer level hard disks disk vendors generally do not recommend
doing this because it significantly lowers the MTBF of the disk.

-Andi

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
