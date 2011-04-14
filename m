From: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 14 Apr 2011 10:50:10 -0500
Message-ID: <4DA717B2.3020305@sandeen.net>
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>
	<4DA70BD3.1070409@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreutils-mXXj517/zsQ@public.gmane.org,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>, xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <4DA70BD3.1070409-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
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

On 4/14/11 9:59 AM, P=E1draig Brady wrote:
> On 14/04/11 15:02, Markus Trippelsdorf wrote:
>>>> Hi P=E1draig,
>>>>
>>>> here you go:
>>>> + filefrag -v unwritten.withdata                                    =
                                                                         =
       =20
>>>> Filesystem type is: ef53                                            =
                                                                         =
       =20
>>>> File size of unwritten.withdata is 5120 (2 blocks, blocksize 4096)  =
                                                                         =
       =20
>>>>  ext logical physical expected length flags                         =
                                                                         =
       =20
>>>>    0       0   274432            2560 unwritten,eof                 =
                                                                         =
       =20
>>>> unwritten.withdata: 1 extent found
>>>>
>>>> Please notice that this also happens with ext4 on the same kernel.=20
>>>> Btrfs is fine.
>>>
>> `filefrag -vs` fixes the issue on both xfs and ext4.
>=20
> So in summary, currently on (2.6.39-rc3), the following
> will (usually?) report a single unwritten extent,
> on both ext4 and xfs
>=20
>   fallocate -l 10MiB -n k
>   dd count=3D10 if=3D/dev/urandom conv=3Dnotrunc iflag=3Dfullblock of=3D=
k
>   filefrag -v k # grep for an extent without unwritten || fail

right, that's what I see too in testing.

But would the coreutils install have done a preallocation of the destinat=
ion file?

Otherwise this looks like a different bug...

> This particular issue has been discussed so far at:
> http://debbugs.gnu.org/cgi/bugreport.cgi?bug=3D8411
> Note there it was stated there that ext4 had this
> fixed as of 2.6.39-rc1, so maybe there is something lurking?

ext4 got a fix, but not xfs, I guess.  My poor brain can't remember, I th=
ink I started looking into it, but it's clearly still broken.

Still, I don't know for sure what happened to Markus - did something prea=
llocate, in his case?

-Eric
=20
> cheers,
> P=E1draig.
>=20
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs
>=20
