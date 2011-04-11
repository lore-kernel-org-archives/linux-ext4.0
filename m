From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: ready for release of coreutils-8.11?
Date: Mon, 11 Apr 2011 12:07:46 +0100
Message-ID: <4DA2E102.5080801@draigBrady.com>
References: <87ei5chcy1.fsf@rho.meyering.net> <4D9F9C20.5020709@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: coreutils@gnu.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:13805 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751856Ab1DKLJO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2011 07:09:14 -0400
In-Reply-To: <4D9F9C20.5020709@draigBrady.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 09/04/11 00:37, P=E1draig Brady wrote:
> One thing I'm worried about is fiemap with compressed file systems.
> I'm unsure that the extent length refers to the length of
> the unencoded data. That's what I would expect so that
> user space is abstracted from encoding details and so
> we know how much to read to fully process an extent.
>=20
> I've not got a new BTRFS kernel readily available at present
> to do a quick test. I'll try to text tomorrow night.

I've tried various BTRFS combinations here with 2.6.38.2-9.fc15.i686.
I'm using `mount -o compress -o compress-force`, but any files
copied into the file system, don't have FIEMAP_EXTENT_ENCODED flags,
and du doesn't indicate that less space is used in the file system.

So I'm assuming that the compression is below the file system,
and doesn't increase the space available. I.E. it's just
there to more efficiently write blocks to disk.

As for the FIEMAP_EXTENT_ENCODED flag, are there any uses currently?
Note coreutils currently assumes that the length of an extent, is
that required to read it fully, even in the presence of implicit conver=
sion.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
