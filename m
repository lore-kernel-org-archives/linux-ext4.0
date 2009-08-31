From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 14:25:08 -0700
Message-ID: <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>
	 <20090831205608.GE4197@webber.adilger.int>
	 <4A9C3A7B.3050302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@thunk.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:2039 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHaVZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 17:25:07 -0400
Received: by wa-out-1112.google.com with SMTP id j5so570463wah.21
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 14:25:08 -0700 (PDT)
In-Reply-To: <4A9C3A7B.3050302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 31, 2009 =A013:02 -0400, Ric Wheeler wrote:
> Mount after fsck:
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75):
> ext4_check_descriptors: Checksum for group 487 failed (59799!=3D46827=
)
> Aug 31 12:27:12 megadeth kernel: EXT4-fs (dm-75): group descriptors
> corrupted!

Ah, so it's not just me.  It looks like you're seeing the exact same
thing I reported a few days ago in the ">16TB issues" thread.  You
don't even have to do anything fancy to make this happen.  My test
case involves simply creating 5 directories on the newly-created
64-bit filesystem, and running e2fsck on it immediately after
unmounting to get the same results.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
