From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: CF Card wear optimalisation for ext4
Date: Fri, 10 Oct 2014 13:02:09 -0600
Message-ID: <08F28BC7-34FD-46BA-9D91-CC7D57A4A4D5@dilger.ca>
References: <5435661D.2040905@powercraft.nl>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8048723B-0736-4737-8AB6-5A54CE575966"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: EXT3 Users <ext3-users@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jelle de Jong <jelledejong@powercraft.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37371 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaJJTBe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 15:01:34 -0400
Received: by mail-pa0-f54.google.com with SMTP id ey11so2286852pad.27
        for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2014 12:01:34 -0700 (PDT)
In-Reply-To: <5435661D.2040905@powercraft.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8048723B-0736-4737-8AB6-5A54CE575966
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 8, 2014, at 10:28 AM, Jelle de Jong <jelledejong@powercraft.nl> wrote:
> Hello everyone,
> 
> I been using CF cards for almost more then 7 years now with ext
> file-system without any major problems on ALIX boards.
> 
> Last year I took 30 other systems in production with ext4 and the CF
> cards been dropping out pretty fast, it may have been a bad batch but
> I do want to look at it. I don't think the devices writes a lot of IO
> (is there a tool that can give me some useful numbers for say 24H or a
> week? iotop, atop, sysstat doesn?t seem suited for long term IO write
> monitoring, but maybe I am misusing them and can use some help here)

You can see in the ext4 superblock the amount of data that has been
written to a filesystem over its lifetime:

dumpe2fs -h /dev/vg_mookie/lv_home
dumpe2fs 1.42.7.wc2 (07-Nov-2013)
Filesystem volume name:   home
Last mounted on:          /home
:
:
Lifetime writes:          27 GB
:
:

Note that this number isn't wholly accurate, but rather a guideline.
IIRC it is not updated on disk all the time, so may lose writes.

You can also get this information from /sys/fs/ext4 including data
just for the current mount:

# grep . /sys/fs/ext4/*/*_write_kbytes 
/sys/fs/ext4/dm-0/lifetime_write_kbytes:77632360
/sys/fs/ext4/dm-0/session_write_kbytes:7124948
/sys/fs/ext4/dm-19/lifetime_write_kbytes:28081448
/sys/fs/ext4/dm-19/session_write_kbytes:16520
/sys/fs/ext4/dm-2/lifetime_write_kbytes:60847858
/sys/fs/ext4/dm-2/session_write_kbytes:7739388
/sys/fs/ext4/dm-7/lifetime_write_kbytes:22385952
/sys/fs/ext4/dm-7/session_write_kbytes:6379728
/sys/fs/ext4/sda1/lifetime_write_kbytes:835020
/sys/fs/ext4/sda1/session_write_kbytes:60848

> I mount root with the following options:
> 
> /dev/disk/by-uuid/09a04c01-64c6-4600-9e22-525667bda3e3 on / type ext4
> (rw,noatime,user_xattr,barrier=1,data=ordered)
> 
> # dumpe2fs /dev/sda1
> http://paste.debian.net/hidden/e3f81f11/
> 
> Are there kernel options to avoid synchronous disk writes? As
> suggested here: http://www.pcengines.ch/cfwear.htm

If you increase the journal commit interval (e.g. 30s) you can reduce
the number of times a block needs to be written to the journal.  The
drawback is that you also increase the amount of un-sync'd metadata
that would be lost in case of a crash.  This usually means the data
would also be lost, unless you are using a database-like workload that
overwrites the same files continuously.

> Is there a list of other kernel options I can optimise to limit any cf
> wear? The devices don't use
> 
> Kind regards
> 
> Jelle de Jong
> 
> 
> _______________________________________________
> Ext3-users mailing list
> Ext3-users@redhat.com
> https://www.redhat.com/mailman/listinfo/ext3-users


Cheers, Andreas






--Apple-Mail=_8048723B-0736-4737-8AB6-5A54CE575966
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDgtMXKl2rkXzB/gAQJxSQ/7BqjVhu8g5LOHu29kfKlMdbPg6HH4fRFZ
JS6tDip2btqnxi4RT7QeFv5tz7HRq3D2JjdRH7gsUtr4S0B/w1zm0dMB3KRsUqdr
axxcjWFagfp7bGynNKVIVkYjHq/F2dtagzPEYtvTGVjQnglLXNDqEyEiu0BQsgCM
9GQK5nCJ9qqPnzMIMn3BOVztPRqiOKv+YiEXFiPHf2044IQB+EvVgFTgwyiaplLD
AlyX5DRTcKjDGfCtP1Blox6alEmhhPgDhePvRBNnMzSnqFJPylIrz1K8UlxLU8b5
AnP9295w0CutQS2xE5jJ7vqNT3r91Lndzl+H+31FmX/AN9WwtEdpxMDjQ/VI3KGj
ePI816OhlC6yI4u3zCCkYX9h04HY5DR0rQVB8oQYm5YVBWUiGxoYjCpbA3Xajrk9
H++jo0Gq6K2vo/UpOaygZcxpWkDPyLdvw64HXhC1zvoTS4K4z+wY9F8t/BCSCWZ+
3jc3zybd5raeafA6KQHNy8It6+xets03xg511osqvYQPUcIl48Cdo7P0YCcnY96b
YG88vtZ8xqqviawxBOBhzKv5cj8v4QT7jxd/PRXsE4fv7ORIyAaR26hRnQna3qpQ
yDbh2T8dIlJ88q0IJmiFx0zagHpZJCXyTyVHlqAN+7nUlpI4OkSNC2we5G1gphti
y5TfRHFFiPg=
=IpKT
-----END PGP SIGNATURE-----

--Apple-Mail=_8048723B-0736-4737-8AB6-5A54CE575966--
