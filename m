From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Strange "rm -fr" issue
Date: Sun, 29 Dec 2013 15:24:06 +0100
Message-ID: <20131229142406.GA393@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:38294 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3L2Oas (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Dec 2013 09:30:48 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I came across the following strange issue today:

markus@x4 tmp % rm -fr boost
rm: cannot remove =E2=80=98boost/results/boost/bin.v2/libs=E2=80=99: Di=
rectory not empty
markus@x4 tmp % ll boost/results/boost/bin.v2/libs
total 68K
drwxr-xr-x 17 markus markus 4.0K Dec 29 15:01 .
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 python
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 serialization
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
markus@x4 tmp % ll boost/results/boost/bin.v2/libs
total 140K
drwxr-xr-x 35 markus markus 4.0K Dec 29 15:01 .
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 ..
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 config
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 move
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 mpl
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 msm
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_array
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 multi_index
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:00 multiprecision
drwxr-xr-x  6 markus markus 4.0K Dec 29 15:01 numeric
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 optional
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 parameter
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 phoenix
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 polygon
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 pool
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 predef
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 preprocessor
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 program_options
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_map
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 property_tree
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 proto
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ptr_container
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 python
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 random
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 range
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 ratio
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 rational
drwxr-xr-x  5 markus markus 4.0K Dec 29 15:01 regex
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 scope_exit
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 serialization
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 signals
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 signals2
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 smart_ptr
drwxr-xr-x  4 markus markus 4.0K Dec 29 15:01 spirit
drwxr-xr-x  3 markus markus 4.0K Dec 29 15:01 test
markus@x4 tmp % rm -fr boost
markus@x4 tmp % ll boost/results/boost/bin.v2/libs
ls: cannot access boost/results/boost/bin.v2/libs: No such file or dire=
ctory
markus@x4 tmp %

fsck.ext4 shows nothing. Kernel is latest git. coreutils-8.22.
 /dev/sda       ext4      1.8T  743G  1.1T  41% /var
 /dev/sda on /var type ext4 (rw,relatime,data=3Dordered)

--=20
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
