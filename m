From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Date: Fri, 27 Apr 2007 19:46:13 +0200
Message-ID: <20070427174613.GA8228@osiris.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com> <20070427144327.GC22949@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070427144327.GC22949@lazybastard.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Apr 27, 2007 at 04:43:28PM +0200, J=F6rn Engel wrote:
> On Fri, 27 April 2007 14:10:03 +0200, Heiko Carstens wrote:
> >=20
> > After long discussions where at least two possible implementations
> > were suggested that would work on _all_ architectures you chose one
> > which doesn't and causes extra effort.
>=20
> I believe the long discussion also showed that every possible
> implementation has drawbacks.  To me this one appeared to be the best=
 of
> many bad choices.

If one insists to have fd at first argument, what is wrong with having
u32 arguments only? It's not that this syscall comes even close to
what can be considered performance critical...

> Is this implementation worse than we thought?

It adds userspace overhead for one architecture. Every *trace and
*libc needs special handling on s390 for this syscall. I would
prefer to avoid this.
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
