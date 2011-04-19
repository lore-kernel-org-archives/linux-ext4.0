From: Yongqiang Yang <xiaoqiangnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Tue, 19 Apr 2011 16:11:37 +0800
Message-ID: <BANLkTinozFL1Q5BmWr=7=Pua+0g_BciVvA@mail.gmail.com>
References: <20110415000940.GL21395@dastard>
	<76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>,
	Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>, xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
	"coreutils-mXXj517/zsQ@public.gmane.org" <coreutils-mXXj517/zsQ@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <20110419074538.GG23985@dastard>
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 19, 2011 at 3:45 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> On Tue, Apr 19, 2011 at 02:53:20PM +0800, Yongqiang Yang wrote:
>> On Tue, Apr 19, 2011 at 11:44 AM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wro=
te:
>> > On Tue, Apr 19, 2011 at 09:58:15AM +0800, Yongqiang Yang wrote:
>> >> On Mon, Apr 18, 2011 at 10:45 AM, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> =
wrote:
>> >> > On 2011-04-17, at 6:40 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote=
:
>> >> >
>> >> > On Sat, Apr 16, 2011 at 08:21:28AM -0400, Theodore Tso wrote:
>> >> >
>> >> > On Apr 16, 2011, at 1:11 AM, Andreas Dilger wrote:
>> >> >
>> >> > In that case, it means cp should just always use FIEMAP_FLAG_SYNC, =
which is
>> >> > fine.
>> >> >
>> >> > Except that if someone is copying a large delay allocated file, it =
will
>> >> > cause
>> >> >
>> >> > the file to immediately snapped to disk, which might not be the gre=
atest
>> >> >
>> >> > thing in the world.
>> >> >
>> >> > Obvious workaround - if the initial fiemap call shows unwritten
>> >> > extents, redo it with the sync flag set. Though that assume=D1=95 t=
hat
>> >> > you can trust things like delalloc extents to only cover the range
>> >> > that valid data exists in. Which, of course, you can't assume,
>> >> > either. :/
>> >> >
>> >> > Always passing=C2=A0FIEMAP_FLAG_SYNC is fine in this case. It shoul=
d only do
>> >> > anything if there is unwritten data, which is the only case we are =
concerned
>> >> > with at this point. =C2=A0In any case, this is a simple solution fo=
r coreutils
>> >> > until such a time that a more complex solution is added in the kern=
el (if
>> >> > ever).
>> >> >
>> >> > Christoph is write, SEEK_HOLE and SEEK_DATA are
>> >> >
>> >> > a much better API for what cp woulld lke to do. =C2=A0Unfortunately=
 it hasn't
>> >> >
>> >> > been implemented yet in the VFS...
>> >> >
>> >> > Agreed, SEEK_HOLE/SEEK_DATA is the right way to solve this problem.
>> >> >
>> >> > I don't see how this will change the problem in any meaningful way.=
 There
>> >> > will still need to be code that is traversing the on-disk mapping, =
and also
>> >> > keeping it coherent with unwritten data in the page cache.
>> >>
>> >> It seems that we are being messed up by page cache and disk.
>> >> Unwritten flag returned from FIEMAP indicates blocks on disk are not
>> >> written, but it does not say if there is data in page cache. =C2=A0So
>> >> FIEMAP itself just tells user the map on disk. =C2=A0However there is=
 an
>> >> exception for delayed allocation, =C2=A0FIEMAP tells users the data i=
s in
>> >> page cache.
>> >
>> > No, FIEMAP does not tell the user there is data in the page cache.
>> > It tells there user there is a delayed allocation extent. For XFS, a
>> > delayed allocation extent can cover a range _greater_ than there is
>> > data in the page cache - we do allocation allignment, speculative
>> > allocation and other tricks to avoid fragmentation via
>> > delayed allocation. When XFSs says there is a delalloc extent, it is
>> > simply showing the in-memory representation of the extent. if you
>> > want to know where the data in the page cache actually is, you need
>> > to sync the file to disk to get those ranges converted to real
>> > extents. This is how xfs_bmap has worked for 15 years....
>> >
>> >> Maybe FIEMAP should return all known messages for unwritten extent, i=
f
>> >> unwritten data exists in page cache, FIEMAP should let users know tha=
t
>> >> data is in page cache and space on disk has been preallocated, but
>> >> data has not been flushed into disk. =C2=A0Actually, delayed allocati=
on has
>> >> done like this. Then user-space applications can determine how to do.
>> >> Taking cp as an example, it will copy from page cache rather ignore
>> >> it.
>> >
>> > Once again, FIEMAP is for showing the filesystem's current extent
>> > state, not the page cache state. Ext4 may implement FIEMAP by doing
>> > page cache walks, but that is a filesystem specific implementation
>> > detail.
>> >
>> >> We need a definite definition for FIEMAP, in other words, it tells
>> >> users map on disk or both disk and page cache.
>> >
>> > We already have a definition - and it has nothing to do with the
>> > page cache state.
>> >
>> >> If the former one is taken, then FIEMAP should not consider
>> >> delayed allocation.
>> >
>> > Not at all. the delayed allocation extent is a first class extent
>> > type in XFS and it is reported directly from the extent list. Your
>> > viewpoint is very ext4-specific and ignores the fact that other
>> > filesystems were doing this sort of mapping long before even ext3
>> > (let alone ext4) was a glint in the designer's eye....
>> >
>> >> otherwise, FIEMAP should return all known messages for unwritten case
>> >> like delayed allocation.
>> >
>> > See my previous comments about extents being unwritten until data is
>> > physically written to them.
>> Understood, thank you for your explanation.
>>
>> Ok. =C2=A0Let's look at it from a higher view. =C2=A0What you described =
about
>> extent state is specific to xfs.
>>
>> I think there are 2 ways to provide a definite definition for FIEMAP
>> for all filesystems:
>>
>> 1. FIEMAP returns extent state on disk.
>> 2. FIEMAP returns extent both in memory and on disk.
>
> You are *not listening*. There is no #2. FIEMAP returns the extent
> state _on disk_ at the time of the call. If you want it to reflect
> the in-memory state at the time of the call (for data or metadata),
> you *must* use the the SYNC flag to convert that in-memory state to
> on-disk state, which FIEMAP then reports just fine.

Sorry for being dense.

I think delayed extent is an exception. because it is not on the disk.

Yongqiang.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
>



--=20
Best Wishes
Yongqiang Yang
