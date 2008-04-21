From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Mon, 21 Apr 2008 19:27:21 +0100
Message-ID: <1208802441.14123.39.camel@localhost>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
 <20080419012952.GE25797@mit.edu>
 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
 <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
 <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org>
 <20080420234241.GB23292@shareable.org>
 <20080421080111.GD14446@one.firstfloor.org>
 <1208798974.14123.28.camel@localhost> <480CD18F.7000108@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:58609 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbYDUS1Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 14:27:24 -0400
In-reply-to: <480CD18F.7000108@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Seg, 2008-04-21 at 19:40 +0200, Andi Kleen wrote:
> > Is there a reason why this isn't being done other than performance?
> 
> One reason against it is that in many (but not all) setups to guarantee
> reaching the platter you have to disable the write cache, and at least
> for consumer level hard disks disk vendors generally do not recommend
> doing this because it significantly lowers the MTBF of the disk.

I understand that, but if the disk/storage doesn't support flushing the
cache, I would expect fsync() to return EIO or ENOTSUP, I wouldn't
expect it to ignore my request and risk losing data without my
knowledge..

I know fsync() also flushes dirty buffers, but IMHO even if it flushes
the buffers it'd be better to return an error if a full sync wasn't
being done rather than returning success and misleading the application.

Anyway, sorry if this has been discussed before, I should take a look at
the archives..

Thanks,
Ricardo
--

Ricardo Manuel Correia
Lustre Engineering

Sun Microsystems, Inc.
Portugal
Phone +351.214134023 / x58723
Mobile +351.912590825
Email Ricardo.M.Correia@Sun.COM

