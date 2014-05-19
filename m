From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: small .de translation fix
Date: Sun, 18 May 2014 21:41:56 -0400
Message-ID: <20140519014156.GA16937@thunk.org>
References: <52C704EC.8000501@redhat.com>
 <5306D3D9.4040303@redhat.com>
 <20140221081228.GE31047@thunk.org>
 <20140221120133.GC6304@paradies.suse.de>
 <20140221152531.GF31047@thunk.org>
 <535E9CA0.8020305@redhat.com>
 <20140429101939.GA5744@paradies.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Philipp Thomas <pth@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48083 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbaESBmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2014 21:42:03 -0400
Content-Disposition: inline
In-Reply-To: <20140429101939.GA5744@paradies.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 29, 2014 at 12:19:39PM +0200, Philipp Thomas wrote:
> * Eric Sandeen (sandeen@redhat.com) [20140428 20:23]:
>=20
> > Any progress on this?  AFAICT we still have goats.  ;)
>=20
> Oh sorry, with work on SLES 12 and a very nasty cold this totally
> sliped throught the cracks. I'll finish it today.

I just synced up with the translation project, and apparently this
hasn't been fixed yet.  So I've pushed the following into what will be
the 1.43.10 release.  It would be nice if you could make the same fix
in your tree.  It matches the patch that Eric sent, as well as what is
in:

	https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D703048

So I'm going to assume it's correct....

Thanks!!

					- Ted

commit 6236e47b0b14af8484476efb6881fc1846eb0110
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun May 18 21:36:52 2014 -0400

    Fix obvious typo in German translation
   =20
    Addresses-Debian-Bug: #737800
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/po/de.po b/po/de.po
index d1ed005..9d05cfe 100644
--- a/po/de.po
+++ b/po/de.po
@@ -645,7 +645,7 @@ msgstr "Fortsetzen"
=20
 #: e2fsck/problem.c:65
 msgid "Clone multiply-claimed blocks"
-msgstr "mehrfach referenzierte BL=F6cke werden geklont"
+msgstr "mehrfach referenzierte Bl=F6cke werden geklont"
=20
 #: e2fsck/problem.c:66
 msgid "Delete file"
@@ -1840,7 +1840,7 @@ msgid ""
 "  has %r @m @b(s), shared with %N file(s):\n"
 msgstr ""
 "Datei %Q (@i #%i, =C4nderungszeit %IM) \n"
-"  hat %r mehrfach belegte(n) Block/B=F6cke, gemeinsam genutzt mit %N =
Datei(en):\n"
+"  hat %r mehrfach belegte(n) Block/Bl=F6cke, gemeinsam genutzt mit %N=
 Datei(en):\n"
=20
 #. @-expanded: \t%Q (inode #%i, mod time %IM)\n
 #: e2fsck/problem.c:1011

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
