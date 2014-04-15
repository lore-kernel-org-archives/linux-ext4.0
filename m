From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Tue, 15 Apr 2014 18:09:34 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404151808440.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
	<alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
	<20140415153643.GB4456@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1907578942-1397578177=:2146"
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140415153643.GB4456@thunk.org>
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

--8323328-1907578942-1397578177=:2146
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Apr 2014, Theodore Ts'o wrote:

> Date: Tue, 15 Apr 2014 11:36:43 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.or=
g,
>     ceph-devel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi=
.com
> Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
>=20
> On Tue, Apr 15, 2014 at 03:10:38PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> >=20
> > I'll update the description and the subject.
>=20
> Luk=C3=A1=C5=A1, FYI, I'm waiting for your update(s) to these patches i=
n
> response to Christoph's comments.
>=20
> I'd like to push a set of bugfixes to Linus, hopefully this week so
> they can make -rc2.
>=20
> Cheers,
>=20
> 					- Ted
>=20

Ok, I'll run some tests and resend it right away without the patch
#4.

Thanks!
-Lukas
--8323328-1907578942-1397578177=:2146
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1907578942-1397578177=:2146--
