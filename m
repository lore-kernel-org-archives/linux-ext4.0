From: Nathaniel W Filardo <nwf@cs.jhu.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Thu, 10 Apr 2014 12:33:51 -0400
Message-ID: <20140410163350.GW10985@gradx.cs.jhu.edu>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
 <20140410050428.GV10985@gradx.cs.jhu.edu>
 <20140410140316.GD15925@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qesg98+uAFykT7J8"
Cc: Mike Rubin <mrubin@google.com>, Frank Mayhar <fmayhar@google.com>,
	admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [128.220.13.50] ([128.220.13.50]:42153 "EHLO blaze.cs.jhu.edu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934885AbaDJQeZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 12:34:25 -0400
Content-Disposition: inline
In-Reply-To: <20140410140316.GD15925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Qesg98+uAFykT7J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 10:03:16AM -0400, Theodore Ts'o wrote:
> On Thu, Apr 10, 2014 at 01:04:28AM -0400, Nathaniel W Filardo wrote:
> >[snip]
> What is your workload?  Can you reproduce this easily?  And can you
> try using a local disk to see if the problem goes away, so we can
> start to bisect which software components might be at fault?

We're running an OpenAFS fileserver; the partition that most often causes us
trouble is that which contains our mirrors (Debian, Fedora, etc.) which has
~5T of its 10T capacity filled.  Every few days, at least, we trip over one
of these.

I will see what I can do about getting some local storage hooked up to the
VM, but my fear is that this is related to the size of the volume and the
amount of data therein.  If that's true, any amount of local storage I could
muster will not shake this out.

> I'm not aware of any corruption problem with a 3.13 based kernel which
> matches your signature, and the ext4 errors that you are showing
> (minor accounting discrepancies in the number free blocks and number
> of free inodes between the allocation bitmap and the summary
> statistics in the block group descriptors) is very closely matches the
> signature of some part of the storage stack not honoring FLUSH CACHE
> ("barrier") operations, either by ignoring them completely, or
> reordring writes across a barrier / flush cache request.

Shouldn't cache reordering or fail to flush correctly only matter if the
machine is crashing or otherwise losing power?  I suppose it's possible
there's a bug that would cause the cache to fail to write a block at all,
rather than simply "too late".  But as I said before, we've not had any
crashes or otherwise lost uptime anywhere: host, guest, storage providers,
etc.

That said, we do occasionally, though much less often than we get reports of
corrupted metadata, get messages that I don't know how to decode from the
ATA stack (though naively they all seemed to be successfully resolved
transients)?  One of our VMs, nearly identically configured, though not the
one that's been reporting corruption on its filesystem, spat this out the
other day, for example:

[532625.888251] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[532625.888762] ata1.00: failed command: FLUSH CACHE
[532625.889128] ata1.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[532625.889128]          res 40/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x4 (time out)
[532625.889945] ata1.00: status: { DRDY }
[532630.928064] ata1: link is slow to respond, please be patient (ready=0)
[532635.912178] ata1: device not ready (errno=-16), forcing hardreset
[532635.912220] ata1: soft resetting link
[532636.070087] ata1.00: configured for MWDMA2
[532636.070701] ata1.01: configured for MWDMA2
[532636.070705] ata1.00: retrying FLUSH 0xe7 Emask 0x4
[532651.068208] ata1.00: qc timeout (cmd 0xe7)
[532651.068216] ata1.00: FLUSH failed Emask 0x4
[532651.236146] ata1: soft resetting link
[532651.393918] ata1.00: configured for MWDMA2
[532651.394533] ata1.01: configured for MWDMA2
[532651.394537] ata1.00: retrying FLUSH 0xe7 Emask 0x4
[532651.395550] ata1.00: device reported invalid CHS sector 0
[532651.395564] ata1: EH complete

This appears to have been during a stall in Ceph's ability to write data to
the OSDs.  I don't know what caused that, and the machine has been happy
ever since (though maybe it's all about to go south?).  I'll keep my eyes
open, especially for any reports of problems between fscking and the
blockmap corruption being detected.

Would I be better off attaching the RBDs via virtio than achi?  Do I need to
do anything specially on the guest to make that work?

Thanks very much, again,
--nwf;

--Qesg98+uAFykT7J8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlNGx+4ACgkQTeQabvr9Tc+thQCeM0IOi6tzDpoAG1TxxfBOlYUw
Vz8An0cwNleX+YYaAmdCcXuJcMTpMTuD
=lv5+
-----END PGP SIGNATURE-----

--Qesg98+uAFykT7J8--
