From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Read operations and journaled data
Date: Tue, 26 Jun 2012 19:42:11 -0400
Message-ID: <20120626234211.GB7594@thunk.org>
References: <CAM3FfDwJhWNO39xrodOFcjQJKE+BD3fNH3t5C5SUtzYubAbGMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Pedro =?iso-8859-1?Q?Eug=EAnio?= Rocha
	<pedro.eugenio.rocha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52913 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab2FZXmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jun 2012 19:42:21 -0400
Content-Disposition: inline
In-Reply-To: <CAM3FfDwJhWNO39xrodOFcjQJKE+BD3fNH3t5C5SUtzYubAbGMA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 26, 2012 at 07:58:12PM -0300, Pedro Eug=EAnio Rocha wrote:
>=20
> I know that ext4 postpones checkpoints in data journaling
> mode, i.e., most of data (and meta-data) are only written
> to the journal and checkpointed to their final location only
> when certain thresholds are crossed. My question is: how
> do ext4 handle read operations to data blocks that are only
> written to the journal (supposing that its cache has been
> evicted)? Does it execute the read operation in the journaled
> data? Does it trigger a checkpoint?

It's not quite true that we postpone writing blocks to their final
location on disk until a checkpoint operation; what happens instead is
that we _forbid_ blocks from getting written to disk until the
transaction has committed.  At that point, the buffer cache writeback
threads are free to write them to their final location on disk
whenever they want.  We only allow a buffer to be evicted from the
buffer cache once it is written to the final location on disk, so this
isn't a problem.

When we do a checkpoint, we *force* all dirty blocks to be written to
disk, before we reuse that portion of the journal.  However, some or
many of these blocks may have already been written out to disk, and
they certainly will be written to disk before their in-memory copy is
allowed to be evicted from memory.

=46inally, note that normally data blocks do not get written into the
journal at all; this only happens in the data journalling mode, which
is not the default.

Regards,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
