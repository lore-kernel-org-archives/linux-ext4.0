From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] ext3: Coding style fix in namei.c
Date: Fri, 19 Nov 2010 23:47:14 +0900
Message-ID: <1290178034.1678.53.camel@leonhard>
References: <1290161589-5370-1-git-send-email-namhyung@gmail.com>
	 <60024FF1-3903-49AD-9A68-B04C6D678A8E@mit.edu>
	 <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62955 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab0KSOr0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Nov 2010 09:47:26 -0500
In-Reply-To: <093B58FD-0DA7-4E94-A70E-C926EC6D02F6@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010-11-19 (=EA=B8=88), 08:05 -0500, Theodore Tso:
> Oooh, I forgot another downside which just came to mind:
>=20
> * Call of this code churn to fix whitespace all for the sake of keep
>  some damned checkpatch.pl script happy also breaks "git blame"
>  reports.
>=20
> -- Ted
>=20

Ah, agreed, it would be bad really. :(


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
