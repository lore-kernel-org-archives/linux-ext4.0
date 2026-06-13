Received: from zucker2.schokokeks.org (zucker2.schokokeks.org [178.63.68.90])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B50BA224AF2
	for <linux-ext4@vger.kernel.org>; Sat, 13 Jun 2026 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.68.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781341510; cv=none; b=Hqm0hhHkHFg1BR0ZntpEz8lSES1Q+Z6ThxkLke2nnIiR72RMM+P8aJ15mRdHRLtFwRKFtZyZirE9z5lJY1MZudbPA8LKU2+bkP5Xbp8K84j298gpdqU/y5SaYvrplVRPoICUGQZMTOwUhC+kCMP7q7TF9e0P//Yv02HFOI9QtJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781341510; c=relaxed/simple;
	bh=loIdqTL0RKxSshfbX1MM17OcdW1BGXu3ZG+9CDKQt9E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=O8lHZHJtm8mcgqJI40XdUcgYXO8o8xCWvUdZoSsnp8xKeguhiFk1UNYL5Js7DPyWgrbtmHqxvU0AcDJJSMxBEp2ZzkmSdjdyiRRyIZ0AA3v8bBrP1fzo2TCtpl0CN5qZz0M9tWOH2WtlGORrrXwFkMfj41ArZc+lFM9BeFSEI+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hboeck.de; spf=pass smtp.mailfrom=hboeck.de; dkim=fail (2048-bit key) header.d=hboeck.de header.i=@hboeck.de header.b=IdGuNx/H reason="signature verification failed"; arc=none smtp.client-ip=178.63.68.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hboeck.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hboeck.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=hboeck.de header.i=@hboeck.de header.b="IdGuNx/H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hboeck.de; s=key1;
	t=1781341507; bh=6uMp872Kz38jj5kiearkYjfbqBcfZ8eIBHalFUl830Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	b=IdGuNx/HCh2MYtx6X/KKXpg4/mJZTlMzW5nPibk6DXJdgWUD9swJzgC4igPkWU6OD
	 N3BsYQ/8m5pQhhV4TYOwIbUVVlBSRyK9lfB3ASVld79vX+B2NwoHkvIIxqz8bgoTu2
	 oUXLfPxUaCl4wSbqov7BV/u318LG4HWmcjMQpPz6F8uE+ChZtEhruSXcwev3pTrIXW
	 CLKorH+uvPaafyU7uyV39Ha4UOvUmjGfZDk2+dXdNGNFWMJrmxkCZMatacwAmt3pC8
	 WGdqtKuSmqZAumM0/VO8z2N7SVYPMSa74hzEvTHS5Be8iF6P6Zim+kdtkYwLGf4vMG
	 y84h/kj4EkbZA==
Original-Subject: [PATCH] e2fsprogs/resize2fs: allow online resizing with
 CONFIG_BLK_DEV_WRITE_MOUNTED disabled
Author: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Date: Sat, 13 Jun 2026 11:05:07 +0200
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
To: linux-ext4@vger.kernel.org
Cc: theodore.tso@gmail.com
Subject: [PATCH] e2fsprogs/resize2fs: allow online resizing with
 CONFIG_BLK_DEV_WRITE_MOUNTED disabled
Message-ID: <20260613110507.67289f68@hboeck.de>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Kernels since version 6.8 have an option CONFIG_BLK_DEV_WRITE_MOUNTED
that, if disabled, prevents accidental writes to and data corruption of
mounted devices.

This breaks online resizing with resize2fs, as it opens the device with
O_RDWR. However, it appears that this is not necessary and by changing
it to O_RDONLY, online resizing works again.

See also: https://unix.stackexchange.com/a/796881

Signed-off-by: Hanno B=C3=B6ck <hanno@hboeck.de>
--- a/resize/main.c	2026-03-06 18:17:36.000000000 +0100
+++ b/resize/main.c	2026-06-13 10:53:46.165030199 +0200
@@ -256,7 +256,7 @@ int main (int argc, char ** argv)
 	int		force_min_size =3D 0;
 	int		print_min_size =3D 0;
 	int		fd, ret;
-	int		open_flags =3D O_RDWR;
+	int		open_flags =3D O_RDONLY;
 	blk64_t		new_size =3D 0;
 	blk64_t		max_size =3D 0;
 	blk64_t		min_size =3D 0;
@@ -364,9 +364,6 @@ int main (int argc, char ** argv)
 		len =3D 2 * len;
 	}
=20
-	if (print_min_size)
-		open_flags =3D O_RDONLY;
-
 	fd =3D ext2fs_open_file(device_name, open_flags, 0);
 	if (fd < 0) {
 		com_err("open", errno, _("while opening %s"),
