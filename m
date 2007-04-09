From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: Interface for the new fallocate() system call
Date: Mon, 9 Apr 2007 18:34:37 +0200
Message-ID: <20070409163436.GA24012@lazybastard.org>
References: <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com> <20070330104449.GA9371@lazybastard.org> <17946.14646.808334.441833@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17946.14646.808334.441833@cargo.ozlabs.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 9 April 2007 23:01:42 +1000, Paul Mackerras wrote:
> J=C3=B6rn Engel writes:
>=20
> > Wouldn't that work be confined to fallocate()?  If I understand Hei=
ko
> > correctly, the alternative would slow s390 down for every syscall,
> > including more performance-critical ones.
>=20
> The alternative that Jakub suggested wouldn't slow s390 down.

True.  And it appears to be one of the least offensive options we have.

J=C3=B6rn

--=20
My second remark is that our intellectual powers are rather geared to
master static relations and that our powers to visualize processes
evolving in time are relatively poorly developed.
-- Edsger W. Dijkstra
-
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
