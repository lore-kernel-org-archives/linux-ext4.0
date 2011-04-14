From: Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 18:28:56 +0200
Message-ID: <20110414162856.GA21658@x4.trippels.de>
References: <20110414102608.GA1678@x4.trippels.de>
	<20110414120635.GB1678@x4.trippels.de>
	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com> <4DA717B2.3020305@sandeen.net>
	<4DA7182B.8050409@draigBrady.com> <4DA71920.9@sandeen.net>
	<20110414160343.GA12787@x4.trippels.de>
	<BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>,
	coreutils-mXXj517/zsQ@public.gmane.org, xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
To: Yongqiang Yang <xiaoqiangnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTimRxvBMp9M7zwiUY_UmmFOY5N58+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On 2011.04.15 at 00:21 +0800, Yongqiang Yang wrote:
> On Fri, Apr 15, 2011 at 12:03 AM, Markus Trippelsdorf
> <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org> wrote:
> > On 2011.04.14 at 10:56 -0500, Eric Sandeen wrote:
> >> On 4/14/11 10:52 AM, Pádraig Brady wrote:
> >> > On 14/04/11 16:50, Eric Sandeen wrote:
> >> >> On 4/14/11 9:59 AM, Pádraig Brady wrote:
> >> >>> On 14/04/11 15:02, Markus Trippelsdorf wrote:
> >> >>>>>> Hi Pádraig,
> >> >>>>>>
> >> >>>>>> here you go:
> >> >>>>>> + filefrag -v unwritten.withdata
> >> >>>>>> Filesystem type is: ef53
> >> >>>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)
> >> >>>>>>  ext logical physical expected length flags
> >> >>>>>>    0       0   274432            2560 unwritten,eof
> >> >>>>>> unwritten.withdata: 1 extent found
> >> >>>>>>
> >> >>>>>> Please notice that this also happens with ext4 on the same kernel.
> >> >>>>>> Btrfs is fine.
> >> >>>>>
> >> >>>> `filefrag -vs` fixes the issue on both xfs and ext4.
> >> >>>
> >> >>> So in summary, currently on (2.6.39-rc3), the following
> >> >>> will (usually?) report a single unwritten extent,
> >> >>> on both ext4 and xfs
> >> >>>
> >> >>>   fallocate -l 10MiB -n k
> >> >>>   dd count=10 if=/dev/urandom conv=notrunc iflag=fullblock of=k
> >> >>>   filefrag -v k # grep for an extent without unwritten || fail
> >> >>
> >> >> right, that's what I see too in testing.
> >> >>
> >> >> But would the coreutils install have done a preallocation of the destination file?
> >> >>
> >> >> Otherwise this looks like a different bug...
> >> >>
> >> >>> This particular issue has been discussed so far at:
> >> >>> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8411
> >> >>> Note there it was stated there that ext4 had this
> >> >>> fixed as of 2.6.39-rc1, so maybe there is something lurking?
> >> >>
> >> >> ext4 got a fix, but not xfs, I guess.  My poor brain can't remember, I think I started looking into it, but it's clearly still broken.
> >> >>
> >> >> Still, I don't know for sure what happened to Markus - did something preallocate, in his case?
> >> >
> >> > Well that preallocate test is failing for him
> >> > when the source file is either on ext4 or xfs.
> >> > He noticed the issue initially on XFS when copying
> >> > none preallocated files, so XFS probably just has
> >> > the general issue of needing a sync before fiemap,
> >> > where as EXT4 just has this preallocate one
> >> > (though I've not seen it myself).
> >> >
> >> > cheers,
> >> > Pádraig.
> >> >
> >>
> >> well, if I simply take the preallocation step out of the testcase, it works fine on xfs without a sync.
> >>
> >> So I still don't know what Markus hit...
> >
> > Maybe it's delalloc:
> >
> > x4 /tmp # dd count=10 if=/dev/urandom conv=notrunc iflag=fullblock of=k
> > 10+0 records in
> > 10+0 records out
> > 5120 bytes (5.1 kB) copied, 0.0021822 s, 2.3 MB/s
> > x4 /tmp # filefrag -v k
> > Filesystem type is: 58465342
> > File size of k is 5120 (2 blocks, blocksize 4096)
> >  ext logical physical expected length flags
> >   0       0        0              16 unknown,delalloc,eof
> > k: 1 extent found
> > x4 /tmp # sync
> > x4 /tmp # filefrag -v k
> > Filesystem type is: 58465342
> > File size of k is 5120 (2 blocks, blocksize 4096)
> >  ext logical physical expected length flags
> >   0 0 26960045 16 eof
> > k: 1 extent found
> There is no preallocation in this case. Problem comes when fallocate
> and dealloc work together.

Yes, but we're still trying to find out what caused the zeros in the
binaries that coreutils installed on my system.

Now the failure only happens when I use "gold" as my linker. With GNU ld
everything is OK. But I thought this must be a timing issue, because
gold is faster and the binaries in coreutils-8.11/src are all fine.

-- 
Markus
