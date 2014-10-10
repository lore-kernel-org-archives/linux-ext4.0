From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Does the filesystem alter file permissions?
Date: Fri, 10 Oct 2014 14:18:45 -0600
Message-ID: <E8F54846-9AFE-4980-B90B-6C47E3D28D75@dilger.ca>
References: <Pine.LNX.4.44L0.1410101535100.1539-100000@iolanthe.rowland.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_71A2526A-4F52-484A-BDD4-BF05244EA60A"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33838 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaJJUSJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 16:18:09 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so2250177pde.34
        for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2014 13:18:09 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1410101535100.1539-100000@iolanthe.rowland.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_71A2526A-4F52-484A-BDD4-BF05244EA60A
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Oct 10, 2014, at 1:41 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> I'm getting very weird results when creating new files on ext4 
> filesystems (this is on a CentOS 7 system).  The permissions are not 
> what they should be.
> 
> On the / filesystem, as superuser:
> 
> [root@server ~]# umask
> 0000
> [root@server ~]# touch a
> [root@server ~]# ls -l a
> -r--r----- 1 root root 0 Oct 10 11:45 a
> 
> As a normal user:
> 
> [stern@server ~]$ umask
> 0000
> [stern@server ~]$ touch b
> [stern@server ~]$ ls -l b
> -rw------- 1 stern stern 0 Oct 10 11:47 b

Do you have a default ACL set on the filesystem?  Try "getfacl".

Cheers, Andreas

> In /boot (which is a separate ext4 filesystem):
> 
> [root@server boot]# umask
> 0000
> [root@server boot]# touch a
> [root@server boot]# ls -l a
> -r--r--r--. 1 root root 0 Oct 10 15:30 a
> 
> On a tmpfs filesystem, the permissions are -rw-rw-rw-, as expected.
> 
> What causes this sort of thing, and how can I change it?
> 
> Thanks,
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_71A2526A-4F52-484A-BDD4-BF05244EA60A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVDg/JXKl2rkXzB/gAQJHWxAAuj3hP2jBpJU6g3655xBLFDanrcdk4pfF
6scdoDVVJMWZOGZEmKFLKFfrBQ/nD8czWhSPYTNCrqbkBcvtS2Fk4hzAqVTPODdz
DAmemtIkDzqsCfksyHpCfm3v2/C0sIvJpRvD1UHsC5q5Kt55BstwjMyB8/ZP3gNU
FLLmZzhOdd+6CBSw8OLaivyYS/ygPgURuPCRQkDtHvrPVO+2VzKpRSQD7ty3ZpZf
t2xLxg+Hv+Il8sxBpqul9X34T7J6mAjCWNqy1INieAfoykixs0vWDLzjHwt6iEss
f3mz2Nqt9o5BA6L1CSYkRoa4EydRYqBLYbmLES//0iXXPaJj6B3Oxy+LZqm763Hf
O9jKAAEa5xslXrh47blawHLyXi4kHpbSzJPL3jIzcWPFO0461TIddEJP81jyGGPD
gPF1QP4MOaWYKICRsaPHgEpWcYJg1kmGOisH6sV8H/m/rBYX04EY+cRASKnJAYzk
1UlR/Z/2TniWXtiSgfJKmFu7zbx01lnCPfS066GPXgsvQVKOPqqNNjymrWRm8BnK
QL3+Ra8qu/hZkVVKQtf5UGFDS//QMkBF8kiSJRMXqOtdjKz5TsHP0mtstj6tbv39
MBMPvY9iMmXgiLRe2WwM0mH0m+mhjfAMfJZsn9D3C2dyHJm7v/Egh+rclmBqsNip
Gt4rdZ8iSdE=
=YjiN
-----END PGP SIGNATURE-----

--Apple-Mail=_71A2526A-4F52-484A-BDD4-BF05244EA60A--
