From: Coly Li <i@coly.li>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Sat, 20 Aug 2011 01:46:56 +0800
Message-ID: <4E4EA190.7080905@coly.li>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110817032519.GN20655@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011=E5=B9=B408=E6=9C=8817=E6=97=A5 11:25, Darrick J. Wong Wrote:
> Hi all,
>=20
> I've created a page on the ext4 wiki outlining the patchset that I'm =
working on
> to add metadata checksumming to ext4.  The page can be found at this =
address:
> https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
>=20

Hi Darrick,

I just go through the proposal, have on objection for most of the text.=
 Only some things want to confirm,
1) If a metadata_csum enabled file system is metadata_csum disabled, it=
 should be better to mark the block group or
inode whether the existing (disabled) checksum is valid or not. So if p=
eople re-enable metadata_csum, we can save quite
a lot of time to re-build check sums for all metadata objects.
2) In no-journal mode, every time when we modify the metadata objects, =
we may have to hold a lock, calculate the check
sum, and release the lock, which may introduce performance regression. =
I hope this is only my unnecessary over worry.

BTW, an engineer in Taobao kernel team, is trying to count different me=
ta data objects I/O in run time now. One of the
first efforts, is trying to unify a set of routines to read or dirty me=
ta data object blocks. A.k.a something (might)
like ext4_read_ext_block(), ext4_read_idx_block(), ... etc. Then the co=
unting routines can be added inside the meta data
object blocks I/O routines. So far, it seems the modification is not tr=
ivial, needs more study on the code. Anyway,
since you mentioned on the wiki page, just let you know what we are doi=
ng now :-)

P.S. The idea of meta data I/O counting is to help us understanding the=
 I/O characteristic of our online servers running
Ext4 file systems, which is the basic material for further I/O performa=
nce optimization.

Thanks.
--=20
Coly Li
