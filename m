From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: large file system & high object count testing
Date: Mon, 31 Aug 2009 16:37:16 -0700
Message-ID: <150c16850908311637t18683386j66bcebd06fe05e9b@mail.gmail.com>
References: <4A9BFB88.5030409@redhat.com> <4A9C0220.1040503@redhat.com>
	 <20090831205608.GE4197@webber.adilger.int>
	 <4A9C3A7B.3050302@redhat.com>
	 <150c16850908311425vbc1c0a1if2a7d8ed56f650f5@mail.gmail.com>
	 <20090831231331.GJ4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	"Ted Ts'o" <tytso@thunk.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f175.google.com ([209.85.222.175]:58479 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZHaXnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Aug 2009 19:43:40 -0400
Received: by pzk5 with SMTP id 5so3187388pzk.21
        for <linux-ext4@vger.kernel.org>; Mon, 31 Aug 2009 16:43:42 -0700 (PDT)
In-Reply-To: <20090831231331.GJ4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 31, 2009 at 4:13 PM, Andreas Dilger<adilger@sun.com> wrote:
> Justin, could you please replicate this corruption, collecting some
> additional information before & after. =A0My recollection is that the
> corruption appears in the first few groups, so 64kB should be plenty
> to capture the group descriptor tables (where the checksum is kept).
>
> - mke2fs
> - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-new.gz
> - mkdir ...
> - sync
> - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-mkdir.gz
> - umount
> - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-umount.gz
> - e2fsck
> - dd if=3D/dev/XXX bs=3D4k count=3D16 | gzip -9 > /tmp/gdt-e2fsck.gz
>

No problem.  I just sent you an email with those four attached.  If
anyone would like me to upload them somewhere else, just let me know.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
