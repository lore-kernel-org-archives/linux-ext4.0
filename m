From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] ext4: mark metadata blocks using bh flags
Date: Sun, 21 Apr 2013 15:55:34 -0400
Message-ID: <20130421195534.GA13543@thunk.org>
References: <20130421000522.GA5054@thunk.org>
 <1366502828-7793-1-git-send-email-tytso@mit.edu>
 <1366502828-7793-3-git-send-email-tytso@mit.edu>
 <5173828A.2030809@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-mm@kvack.org,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	mgorman@suse.de
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <5173828A.2030809@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Apr 21, 2013 at 08:09:14AM +0200, Jiri Slaby wrote:
> On 04/21/2013 02:07 AM, Theodore Ts'o wrote:
> > This allows metadata writebacks which are issued via block device
> > writeback to be sent with the current write request flags.
>=20
> Hi, where do these come from?
> fs/ext4/ext4_jbd2.c: In function =E2=80=98__ext4_handle_dirty_metadata=E2=
=80=99:
> fs/ext4/ext4_jbd2.c:218:2: error: implicit declaration of function
> =E2=80=98mark_buffer_meta=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
> fs/ext4/ext4_jbd2.c:219:2: error: implicit declaration of function
> =E2=80=98mark_buffer_prio=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]
> cc1: some warnings being treated as errors

They are defined by "[PATCH 2/3] buffer: add BH_Prio and BH_Meta flags" h=
ere:

+BUFFER_FNS(Meta, meta)
+BUFFER_FNS(Prio, prio)

When you tried applying this patch, did you try applying all three
patches in the patch series?

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
