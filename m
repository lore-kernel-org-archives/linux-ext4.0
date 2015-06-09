From: Pavel Machek <pavel@ucw.cz>
Subject: [4.1-rc] File was modified, but mtime stayed the same (according to
 unison)
Date: Tue, 9 Jun 2015 12:43:30 +0200
Message-ID: <20150609104330.GA29980@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi!

Today, I got strange warning from unison:

pavel/.config/chromium/Default/Extension State/LOG.old =E2=80=94 transp=
ort
failure
=E2=80=A2 The source file /data/pavel/.config/chromium/Default/Extensio=
n
State/LOG.old
has been modified but the fast update detection mechanism
failed to detect it.  Try running once with the fastcheck
option set to 'no'.

=46ilesystem is plain ext4.
pavel@amd:~$ cat /proc/mounts  | grep /data
/dev/sda2 /data ext4 rw,relatime,errors=3Dremount-ro,data=3Dordered 0 0
pavel@amd:~$ uname -a
Linux amd 4.1.0-rc5 #23 SMP Wed May 27 09:19:18 CEST 2015 x86_64
GNU/Linux

Now, I know mount -oloop can do such "silent updates"... but that
should not be case for chromium. unison 2.40.102. Any ideas?

Thanks,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
