From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] Faster ext2_clear_inode()
Date: Mon, 09 Jul 2007 17:02:20 -0500
Message-ID: <1184018540.6820.5.camel@kleikamp.austin.ibm.com>
References: <20070709041122.GA5889@martell.zuzino.mipt.ru>
	 <20070709083431.GA14761@lazybastard.org>
	 <20070709180148.GA5747@martell.zuzino.mipt.ru>
	 <20070709200003.GA18501@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070709200003.GA18501@lazybastard.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-09 at 22:00 +0200, J=F6rn Engel wrote:
> On Mon, 9 July 2007 22:01:48 +0400, Alexey Dobriyan wrote:
> >=20
> > Yes. Note that ext2_clear_inode() is referenced from ext2_sops, so =
even
> > empty, it leaves traces in resulting kernel.
>=20
> Is that your opinion or have you actually measured a difference?
> I strongly suspect that compilers are smart enough to optimize away a
> call to an empty static function.

It's not a direct call to a static function.  It is called as a
super_ops method.  I don't think the overhead is very significant, but
it doesn't look like it could do any harm.

--=20
David Kleikamp
IBM Linux Technology Center

-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
