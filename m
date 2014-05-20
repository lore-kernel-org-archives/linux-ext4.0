From: Andreas Dilger <adilger@dilger.ca>
Subject: compile warning on master
Date: Tue, 20 May 2014 17:14:34 -0600
Message-ID: <65EABAA6-4117-4059-B04D-0E0D77D698CE@dilger.ca>
References: <CFA1367A.A6C68%andreas.dilger@intel.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AA159B8E-C514-4D98-BD9B-1A5FCBC6FA92"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Zheng Liu <wenqing.lz@taobao.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59088 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaEVQ5P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2014 12:57:15 -0400
Received: by mail-pb0-f48.google.com with SMTP id rr13so2764172pbb.35
        for <linux-ext4@vger.kernel.org>; Thu, 22 May 2014 09:57:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_AA159B8E-C514-4D98-BD9B-1A5FCBC6FA92
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii


When compiling with LLVM, it generates the following warning in
debugfs::do_lsdel():

367 debugfs/lsdel.c:155 col 23: warning: '&&' within '||'
[-Wlogical-op-parentheses]
368:                if (lsd.free_blocks && !lsd.bad_blocks ||
369:                    ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~ ~~
370 debugfs/lsdel.c:155 col 23: note: place parentheses around the '&&'
expression to silence this warning
371:                if (lsd.free_blocks && !lsd.bad_blocks ||
372:                                    ^
373:                    (                                 )


Unfortunately, even looking at this code and the patch that changed it,
I can't figure out what the correct parenthesis is for it.

Zheng, could you please send a patch to fix this?

Cheers, Andreas






--Apple-Mail=_AA159B8E-C514-4D98-BD9B-1A5FCBC6FA92
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU301X3Kl2rkXzB/gAQLfxw//bweSS3l5dVcxpd20qQk5evBksa5aMQKI
4Y+SJvVdUad1TQXC5LTTSWvfANpEqlEnWnWsMrdYh9O9dTlvbrXGf8vKWhzSTmAw
RZ+h3asLOJO7KK+golxuP87vfx4WYmKPQSSSCQpboOLNfBFN5c8UXIifn//8Q9bN
kbaMxdMog234sIAXf+me8dsSfL9CNR6hO1P17ktfgKt7NCbO1rkBW7gKtQnLWntr
dQd20MddR1avqTQMC3J7tI1NKdOS00s4pjWsdOjtIKwZ4FlXSlkSPQzPjnEj34L+
ptb5Wr8Wnl/AH5vNAOgD7bQYuCN3cQySIdmU1wOB3kgtO7lG1UVAvP/wqe+axFRG
+iG14L6BnGvMvPh9a3ClS3NtMl/uJLtFDqzHx0omirwXziktq8VsMNtTZoA7O74y
0M0yWYU5FXSsZns3Ga3fS1/Icths7k/wiBiAR9G9/+U3t1J1/yv9wnt8/HME8x32
TDwfiymXBOqrDy6LEmHMpy/5Gs3Ra27vC++T64a6vL5TWwY69mSeuBH/slTwhBX2
/1TePQaaOV2VjGhTF/cgpdPwl3ULRcyUafiVCYrxNf9rPKXTPgRPKaDBBOAkv1cv
abh6ZrzTph4jek5SiVswRGZhQgJqx7orLTp3azf5Go+sXsq04qGb0Xxv7kgueDCj
fgFgwxn/ll8=
=V+r2
-----END PGP SIGNATURE-----

--Apple-Mail=_AA159B8E-C514-4D98-BD9B-1A5FCBC6FA92--
