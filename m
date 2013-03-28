From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: s390x: kernel BUG at fs/ext4/inode.c:1591!
Date: Thu, 28 Mar 2013 08:05:17 -0400
Message-ID: <20130328120517.GB5737@thunk.org>
References: <863434221.7624846.1364452822093.JavaMail.root@redhat.com>
 <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: LKML <linux-kernel@vger.kernel.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Steve Best <sbest@redhat.com>, linux-ext4@vger.kernel.org
To: CAI Qian <caiqian@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <356372233.7624880.1364452833412.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Mar 28, 2013 at 02:40:33AM -0400, CAI Qian wrote:
> System hung when running xfstests-dev 013 test case on an s390x guest=
=2E Never saw
> this on 3.9-rc3 before but need to double-check. Any idea?
>=20
> =DD 1113.795759=A8 ------------=DD cut here =A8------------
> =DD 1113.795771=A8 kernel BUG at fs/ext4/inode.c:1591!

thanks for the report.  What kernel version did this come from?  Was
it 3.9-rc4?  (line 1591 for 3.9-rc3 doesn't contain a BUG_ON).

If it is indeed 3.9-rc4, it would be helpful, since you can reproduce
the problem, to insert a debugging printk which fires when
bh->b_blocknr !=3D pblock before the BUG_ON, and have it print the
b_blocknr and pblock values.

Thanks,

						- Ted
