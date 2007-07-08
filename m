From: "Ninel Evol" <myLC@gmx.net>
Subject: inserting/deleting into/from the middle of large files?
Date: Sun, 08 Jul 2007 15:13:31 +0200
Message-ID: <20070708131331.212980@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47981 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752368AbXGHNNd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 Jul 2007 09:13:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


'lo there, =3D)

having a DVB-S receiver running Linux (PPC) I found myself=20
wondering how to delete data from the middle of a large file=20
(stripping a recording of ads, for example - or messing=20
around in a virtual disk file, etc.). Currently, the common=20
way of doing this seems to be by copying the file (leaving a=20
part behind) and then deleting the original. Of course, on a=20
large file (say 12 GB) this can take an eternity; also you=20
can run into trouble if the filesystem is nearly full...

Is it me, or doesn't that make any sense?
Having a block-oriented filesystem, operations like this=20
should only take an instance.

So basically I'm looking for functions to:
- insert a chunk into a file
- delete a chunk from a file
- move a chunk from one file into another

All of the above would be very useful when dealing with=20
large data, such as DVB-recordings (Linux being the nr.1 OS=20
on those receivers, naturally:-).

Seeing a large file as a chain of blocks, making such an=20
operation on a block-sized basis should already be easy to=20
accomplish. However, if you want full support there should=20
be the possibility to insert "sparse blocks" (less content=20
than the usual) within a chain of blocks (including the=20
beginning).

Is this already possible?
Would it be difficult to implement?

Think about it: instead of copying gigabytes with the=20
drive's heads clicking around - taking minutes to hours,=20
such operations could be performed in (milli)seconds.

I think that there should indeed be a standard (Posix?) for=20
providing such functionality. (One call could be to=20
determine if the filesystem supports those operations fast -
it could return a version for instance, 0 meaning that the=20
operations, although provided, will be slow.)

What is needed in the first place however, is a filesystem=20
supporting those operations - making it first choice for=20
VDRs running Linux. (The others would surely follow soon=20
after, at which point there should be the chance for=20
establishing a standard.)


Looking forward for some enlightenment... :-)

                                           LC (myLC@gmx.net)


--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt?
Der kanns mit allen: http://www.gmx.net/de/go/multimessenger
