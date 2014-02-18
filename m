From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
	for fallocate
Date: Tue, 18 Feb 2014 10:05:49 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
	<CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1913822621-1392714354=:2216"
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	Ashish Sangwan <a.sangwan@samsung.com>,
	linux-fsdevel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, mtk.manpages@gmail.com
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1913822621-1392714354=:2216
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Feb 2014, Namjae Jeon wrote:

> Date: Wed, 12 Feb 2014 11:28:35 +0900
> From: Namjae Jeon <linkinjeon@gmail.com>
> To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mi=
t.edu,
>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
>     linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Namjae Jeon <namjae.jeon@samsung.com>,
>     Ashish Sangwan <a.sangwan@samsung.com>
> Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_R=
ANGE
>     for fallocate
>=20
> 2014-02-11 20:59 GMT+09:00, Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.co=
m>:
> > On Sun, 2 Feb 2014, Namjae Jeon wrote:
> >
> >> Date: Sun,  2 Feb 2014 14:44:34 +0900
> >> From: Namjae Jeon <linkinjeon@gmail.com>
> >> To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
> >> tytso@mit.edu,
> >>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
> >> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
> >>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >>     Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon
> >> <namjae.jeon@samsung.com>,
> >>     Ashish Sangwan <a.sangwan@samsung.com>
> >> Subject: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RA=
NGE
> >> for
> >>     fallocate
> >>
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> Hi Lukas.
> >
> > Description is missing here, please provide FALLOC_FL_COLLAPSE_RANGE
> > description so people know what it's supposed to be doing.
> >
> > more comments bellow.
> Okay, I will udpate.
> >
> > Thanks!
> > -Lukas

Hi,

you may have noticed my patches for new FALLOC_FL_ZERO_RANGE
fallocate flag. This changes things around the same area as your
patches does so we should probably figure out which are going to
land in first and then rebase the other on top of that.

One concern I have is that I have not seen any tests provided to
verify the feature. But I just may have missed it. Do you have any
xfstests test or at least fsx and fsstress patches to provide
support for testing FALLOC_FL_COLLAPSE_RANGE ? Patches for
util_linux might also be handy.

Thanks!
-Lukas
--8323328-1913822621-1392714354=:2216
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1913822621-1392714354=:2216--
