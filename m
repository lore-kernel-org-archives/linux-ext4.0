From: Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: Shred mount option for ext4?
Date: Wed, 1 Nov 2006 12:20:53 -0500
Message-ID: <200611011720.kA1HKrJc005424@agora.fsl.cs.sunysb.edu>
References: <Pine.GSO.4.53.0611011142120.13266@compserv1>
Cc: Ric Wheeler <ric@emc.com>, Andreas Dilger <adilger@clusterfs.com>,
	Erik Mouw <erik@harddisk-recovery.com>,
	Samuel Tardieu <sam@rfc1149.net>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42186 "EHLO
	filer.fsl.cs.sunysb.edu") by vger.kernel.org with ESMTP
	id S2992684AbWKARWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Nov 2006 12:22:17 -0500
To: Nikolai Joukov <kolya@cs.sunysb.edu>
In-reply-to: Your message of "Wed, 01 Nov 2006 11:52:42 EST."
             <Pine.GSO.4.53.0611011142120.13266@compserv1>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Also of note is that some government standards for data destruction (e.g.,
NIST and NISPOM) specifically require that files be overwritten with a
certain pattern, and even multiple times for different security levels.  So
those sites who have to comply with such standards won't be able to use an
encryption-only solution to discard data.

The other problem with crypto on persistent media is that you can't easily
predict how secure data will be in the really long run, say years or
decades.  Suppose an attacker manages to get their hands on a crypto disk
whose keys were destroyed.  With today's technology, the attacker might not
be able to break the crypto.  But wait 10 years, and who knows what kinds of
computing powers we will have then.  (Even ten-year old data, if recovered,
could still be highly valuable -- eg., top-secret military files).

Crypto is great.  But overwriting data even just a couple of times w/ random
bits, elevates the level of attack required to recover such data, well past
crypto.

Erez.
