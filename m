From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Strange "rm -fr" issue
Date: Mon, 30 Dec 2013 23:22:29 +0100
Message-ID: <20131230222229.GA395@x4>
References: <20131229142406.GA393@x4>
 <20131230221723.GF5457@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:55905 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab3L3WWc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Dec 2013 17:22:32 -0500
Content-Disposition: inline
In-Reply-To: <20131230221723.GF5457@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013.12.30 at 23:17 +0100, Jan Kara wrote:
> On Sun 29-12-13 15:24:06, Markus Trippelsdorf wrote:
> > I came across the following strange issue today:
> >=20
> > markus@x4 tmp % rm -fr boost
> > rm: cannot remove =E2=80=98boost/results/boost/bin.v2/libs=E2=80=99=
: Directory not empty
> > markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> > total 68K
> > drwxr-xr-x 17 markus markus 4.0K Dec 29 15:01 .
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
> > drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 python
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 serialization
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
> > markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> > total 140K
> > drwxr-xr-x 35 markus markus 4.0K Dec 29 15:01 .
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 config
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
> > drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 predef
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 preprocessor
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 program_options
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_map
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_tree
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 proto
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ptr_container
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 python
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 random
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 range
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ratio
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 rational
> > drwxr-xr-x  5 markus markus 4.0K Dec 29 15:01 regex
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 scope_exit
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 serialization
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 signals
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 signals2
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 smart_ptr
> > drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 spirit
> > drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
> > markus@x4 tmp % rm -fr boost
> > markus@x4 tmp % ll boost/results/boost/bin.v2/libs
> > ls: cannot access boost/results/boost/bin.v2/libs: No such file or =
directory
> > markus@x4 tmp %
>   Hum, my guess would be that some other process has been adding file=
s to
> the directory while the first 'rm -fr' was running. Thus rm got a lis=
t of
> files in 'libs' to delete, deleted them, tried to delete 'libs' and f=
ailed
> because the other process has added some new files / dirs in the mean=
 time.
> By the time you run second rm, the creating process has apparently
> finished.

I'm pretty sure that this wasn't the case. The boost test suite had
finished and the machine was idle for a while, before I tried to remove
the directory...

--=20
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
