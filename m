From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: Mentor for a GSoC application wanted (Online ext2/3 filesystem
	checker)
Date: Mon, 21 Apr 2008 18:29:34 +0100
Message-ID: <1208798974.14123.28.camel@localhost>
References: <f19298770804180720w2e72b821j95b709c1dd1b1c25@mail.gmail.com>
 <20080419012952.GE25797@mit.edu>
 <f19298770804190244y5d6a8502p39f98d1c420135a@mail.gmail.com>
 <20080419185603.GA30449@mit.edu> <480A42F6.2030005@redhat.com>
 <20080419220432.GB30449@mit.edu> <87iqyc85q7.fsf@basil.nowhere.org>
 <20080420234241.GB23292@shareable.org>
 <20080421080111.GD14446@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Rik van Riel <riel@surriel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20080421080111.GD14446@one.firstfloor.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

(sorry if this is a duplicate, my previous email was rejected)

Hi Andi,

On Seg, 2008-04-21 at 10:01 +0200, Andi Kleen wrote:=20
> > (I continue to be surprised at the un-safety of Linux fsync)
>=20
> Note barrier less does not necessarily always mean unsafe fsync,
> it just often means that.

Am I correct that the Linux fsync(), when used =EF=BB=BF(from userspace=
)
directly on file descriptors associated with block devices doesn't
actually flush the disk write cache and wait for the data to reach the
disk before returning?

Is there a reason why this isn't being done other than performance?
I would imagine that the only reason a process is using fsync() is
because it is worried about data loss, and therefore is perfectly
willing to lose some performance if necessary..

Regards,
Ricardo
--

Ricardo Manuel Correia
Lustre Engineering

Sun Microsystems, Inc.
Portugal
Phone +351.214134023 / x58723
Mobile +351.912590825
Email Ricardo.M.Correia@Sun.COM

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
