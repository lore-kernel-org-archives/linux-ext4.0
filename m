From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: only call ext4_truncate when size <= isize
Date: Tue, 9 Jun 2015 12:07:39 -0400
Message-ID: <20150609160739.GT19168@thunk.org>
References: <1432049337-3520-1-git-send-email-jbacik@fb.com>
 <alpine.LFD.2.00.1506021008030.4950@localhost.localdomain>
 <20150606202011.GC15306@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Josef Bacik <jbacik@fb.com>, linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55471 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933118AbbFIQHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Jun 2015 12:07:45 -0400
Content-Disposition: inline
In-Reply-To: <20150606202011.GC15306@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 06, 2015 at 04:20:11PM -0400, Theodore Ts'o wrote:
> On Tue, Jun 02, 2015 at 10:08:18AM +0200, Luk=C3=A1=C5=A1 Czerner wro=
te:
> > On Tue, 19 May 2015, Josef Bacik wrote:
> >=20
> > > Date: Tue, 19 May 2015 11:28:57 -0400
> > > From: Josef Bacik <jbacik@fb.com>
> > > To: tytso@mit.edu, linux-ext4@vger.kernel.org
> > > Subject: [PATCH] ext4: only call ext4_truncate when size <=3D isi=
ze
> > >=20
> > > At LSF we decided that if we truncate up from isize we shouldn't =
trim fallocated
> > > blocks that were fallocated with KEEP_SIZE and are past the new i=
_size.  This
> > > patch fixes ext4 to do this.  Thanks,
> >=20
> > Looks good, thanks!
> >=20
> > Reviewed-by: Lukas Czerner <lczerner@redhat.com>
>=20
> Applied, thanks.

Unfortunately this patch is causing generic/239 to fail when run with
1k blocksizes.

I'm dropping this for now; could you take a look?

Thanks!

						- Ted

generic/239 22s ...	[11:46:25] [11:46:54] 29s
 _check_generic_filesystem: filesystem on /dev/vdd is inconsistent (see=
 /results/results-1k/generic/239.full)
 Ran: generic/239
 Failures: generic/239
 Failed 1 of 1 tests

e2fsck 1.43-WIP (18-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 0, should be 4096.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/vdd: ***** FILE SYSTEM WAS MODIFIED *****
/dev/vdd: 12/327680 files (0.0% non-contiguous), 120145/5242880 blocks


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
