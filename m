From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 2/4] e2image: perform in-place move
Date: Mon, 16 Dec 2013 11:30:56 -0500
Message-ID: <52AF2AC0.2030103@ubuntu.com>
References: <1381247792-22508-1-git-send-email-psusi@ubuntu.com> <1381247792-22508-3-git-send-email-psusi@ubuntu.com> <20131216043338.GD28536@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:37386 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPQa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 11:30:57 -0500
In-Reply-To: <20131216043338.GD28536@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/15/2013 11:33 PM, Theodore Ts'o wrote:
> On Tue, Oct 08, 2013 at 11:56:30AM -0400, Phillip Susi wrote:
>> If given at least one offset and only one file, assume source and
>> dest are the same, and do an in place move.
>> 
>> Signed-off-by: Phillip Susi <psusi@ubuntu.com>
> 
> You **really** only want to allow move_mode if you are in raw
> mode. In particular, the safe move isn't even implemented in the
> other mods (nor does it make any sense), and if the user simply
> forgot to specify -r, it would be a shame if it ended up destroying
> the user's file system.  :-(

Good point, also only with -a.  Fixed.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSryrAAAoJEI5FoCIzSKrwOicH/25obbcwApT1fMCZx3ZESYyg
q2zOgJafZCZfe4cx6Knn8TDZ+gk66229IslTMi3oXDTXkPXQXdc5oAtcuAs8iKNN
/bIgT+JKrwhvUsP8rL4F4oIfq1gzx9//YgS5awgyKV7653qGSmtXUdp5TZhSD8KU
f8dz66pWz/jnapv072qdqJOIXRndIGTSNWfR7M/GC0DVAKn+vRJVjXYRQ1Woov2m
tkzM5glZIFW5PUVngmckkUHLwxbdVHSQPQJE+Jib44ZOLmqYtcAfxfsrUxjbc/Ur
jWFUZOHBoDlNEmeHafDhudw3dC3yyutW+uTFKrg9dy85g5tobZ9NICZK4XgiJfw=
=/KYA
-----END PGP SIGNATURE-----
