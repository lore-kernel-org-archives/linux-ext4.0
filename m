From: Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of directory inodes
Date: Wed, 2 Oct 2013 12:52:10 -0400
Message-ID: <20131002165210.GA16076@kvack.org>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz> <524C3574.7020106@redhat.com> <20131002153101.GE4353@kvack.org> <alpine.LFD.2.00.1310021838370.1924@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kanga.kvack.org ([205.233.56.17]:58046 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab3JBQwK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 12:52:10 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1310021838370.1924@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 02, 2013 at 06:44:56PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
> What is the frequency of unlink operation in comparison to file
> creation ? There is a possible issue with the global goal cursors
> s_mb_last_group and s_mb_last_start which might make your files
> increasingly scattered across the disk. I've attempted to address
> this problem with my patch

unlink() is 1:1 with creation.  The storage on disk is essentially used=
=20
as an elastic buffer for the rest of the system.  That said, unlink() m=
ay=20
not occur for minutes, hours or days.

In terms of actual allocation pattern on disk, using fallocate() is=20
sufficient to ensure that files on disk are usually limited to 1 extent=
,=20
and allocated immediately following each other.  Without fallocate(), I=
=20
was seeing allocations aligned to 2048 block boundaries for 9MB files,=20
which hurt performance quite a bit.

> ext4: Try to better reuse recently freed space
>=20
> What is the usual size of the files this application is creating ?

It varies.  The target is 8MB, but it ranges from 5MB to 22MB.  In the=20
worst case it can be as small as 4KB.

		-ben

> Thanks!
> -Lukas

--=20
"Thought is the essence of where you are now."
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
