From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Filesystem benchmarks on reasonably fast hardware
Date: Mon, 25 Jul 2011 11:18:25 -0400
Message-ID: <20110725151825.GI3469@thunk.org>
References: <20110717160501.GA1437@logfs.org>
 <20110718120751.GH14869@thunk.org>
 <20110718124229.GG1437@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110718124229.GG1437@logfs.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 18, 2011 at 02:42:29PM +0200, J=F6rn Engel wrote:
> On Mon, 18 July 2011 08:07:51 -0400, Ted Ts'o wrote:
> >=20
> > Can you send me your script and the lockstat for ext4?
>=20
> Attached.  The first script generates a bunch of files, the second
> condenses them into the tabular form.  Will need some massaging to
> work on anything other than my particular setup, sorry.
>=20
> > (Please cc the linux-ext4@vger.kernel.org list if you don't mind.
> > Thanks!!)
>=20
> Sure.  Lockstat will come later today.  The machine is currently busy
> regenerating xfs seqrd numbers.

Hi J=F6rn,

Did you have a chance to do an ext4 lockstat run?

Many thanks!!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
