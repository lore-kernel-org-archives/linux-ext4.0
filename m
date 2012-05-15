From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] ext4: fix how i_version is modified and turn it on by
 default V2
Date: Tue, 15 May 2012 14:29:14 -0400
Message-ID: <20120515182914.GC1907@localhost.localdomain>
References: <1337092396-3272-1-git-send-email-josef@redhat.com>
 <20120515175308.GB1907@localhost.localdomain>
 <4FB29DAC.3020801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, bfields@fieldses.org, adilger@dilger.ca,
	tytso@mit.edu, jack@suse.cz
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894Ab2EOS3p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 May 2012 14:29:45 -0400
Content-Disposition: inline
In-Reply-To: <4FB29DAC.3020801@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 15, 2012 at 09:17:16PM +0300, Boaz Harrosh wrote:
> On 05/15/2012 08:53 PM, Josef Bacik wrote:
>=20
> > On Tue, May 15, 2012 at 10:33:16AM -0400, Josef Bacik wrote:
> >> This makes MS_I_VERSION be turned on by default.  Ext4 had been
> >> unconditionally doing i_version++ in a few cases anway so the moun=
t option
> >> was kind of silly.  This patch also removes the update in mark_ino=
de_dirty
> >> and makes all of the cases where we update ctime also do inode_inc=
_=D7=91.
> >> file_update_time takes care of the write case and all the places w=
here we
> >> update iversion are protected by the i_mutex so there should be no=
 extra
> >> i_lock overhead in the normal non-exported fs case.  Thanks,
> >>
> >=20
> > Ok did some basic benchmarking with dd, I ran
> >=20
> > dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1 count=3D10485760
> > dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1M count=3D1000
> > dd if=3D/dev/zero of=3D/mnt/btrfs-test/file bs=3D1M count=3D5000
> >=20
> > 3 times with the patch and without the patch.  With the worst case =
scenario
> > there is about a 40% longer run time, going from on average 12 seco=
nds to 17
> > seconds. =20
>=20
>=20
> do you mean that the "with the patch" is 40% slower then "without the=
 patch"
> 	in the same "bs=3D1 count=3D10485760 test" ?
>=20
> Then count me clueless. Do you understand this difference?
>=20
> The way I read your patch the inode is copied and written to disk exa=
ctly the
> same number of times, as before. Only that now i_version is also upda=
ted
> together with ctime and/or mtime. What is the fundamental difference =
then?
> Is it just that i_version++ in-memory operation?
>

Yeah but for every write() call we have to do this in-memory operation =
(via
file_update_time()), so in the worst case where you are doing 1 byte wr=
ites
where you would notice this sort of overhead you get a 40% overhead jus=
t from

spin_lock(&inode->i_lock);
inode->i_version++;
spin_unlock(&inode->i_lock);

and then the subsequent mark_inode_dirty() call.  What is likely saving=
 us here
is that the 1 byte writes are happening fast enough that the normal cti=
me/mtime
operations aren't triggering a mark_inode_dirty() since it appears to h=
appen
wihtin the same time, but now that we're doing the i_version++ we are c=
alling
mark_inode_dirty() more than before.  I'd have to profile it to verify =
that's
what is actually happening, but that means turning on ftrace and parsin=
g a bunch
of output and man that sounds like more time than I want to waste on th=
is.  The
question is do we care that the worst case is so awful since the worst =
case is
likely to not show up often if at all?  If we do then I guess the next =
step is
to add a fs flag for i_version so that people who are going to be expor=
ting file
systems can get this without having to use a special option all the tim=
e.
Thanks,

Josef=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
