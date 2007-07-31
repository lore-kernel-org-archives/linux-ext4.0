From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: 64 bit support for ext4 problem
Date: Tue, 31 Jul 2007 11:39:09 +0200
Message-ID: <46AF033D.6020909@bull.net>
References: <46AEE61B.5000207@fmi.uni-sofia.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: anton.andreev@fmi.uni-sofia.bg
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33903 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbXGaJi2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2007 05:38:28 -0400
In-Reply-To: <46AEE61B.5000207@fmi.uni-sofia.bg>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Anton Andreev wrote:
> Hi,
>=20
> I want to try my ext4 to be 64 bit.
>=20
> I could not patch e2fsprogs-1.39=20
> <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.39.tar.gz>=20
> with=20
> http://www.bullopensource.org/ext4/patches/ext4-e2fsprogs-1.39.patch.=
tar=20
> . I would appreciate if someone tell me exactly how to do that.
>=20
> Does the newest version of e2fsprogs=20
> <http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.39.tar.gz>=20
> supports the features in the patch?

Hi Anton,

you need to patch the e2fsprogs only if you want to create an ext4=20
filesystem larger than 16 TB with 4KB block size. If it is your case,
I could send you a more recent version of patches. Let me know.

Ext4 supports 48-bit physical block numbers, not yet 64-bit physical=20
block numbers; this is due to the use of extents mapping.

If you want to use the extent format (mount -t ext4dev -o extents), I=20
think you should use the latest version of e2fsprogs available here:
http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.40.2.tar.gz
ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/e2fsprogs-=
1.40.2.tar.gz
This version should integrate the extents capability.

Remember that if you use extents, your filesystem will no longer be=20
mountable by ext3.

Regards,
   Val=E9rie
