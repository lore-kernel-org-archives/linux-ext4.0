From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: ext4_fallocate
Date: Thu, 28 Jun 2012 11:12:15 -0400
Message-ID: <4FEC744F.6010901@ubuntu.com>
References: <4FE8086F.4070506@zoho.com> <13363B8E-7411-4AA3-8835-F9DEF67B2ABE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Fredrick <fjohnber@zoho.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5337 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab2F1PMT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jun 2012 11:12:19 -0400
In-Reply-To: <13363B8E-7411-4AA3-8835-F9DEF67B2ABE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 6/25/2012 3:33 AM, Andreas Dilger wrote:
> There was a recent patch series "ext4: add an io-tree to track
> block allocation" that may improve the performance for your case of
> overwrite of uninitialized files, but it hasn't landed yet.

I'm confused.  Why is writing to uninitialized extents slow, and why
would this help?  If you have an uninitialized extent, then the blocks
are already allocated, just flagged as containing uninitialized data.
 Writing to them should be no different than writing to initialized
extents, save for the step of clearing the uninitialized flag.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP7HROAAoJEJrBOlT6nu75nb8IANw0fBczdWvuO7Ne/Xi6uYjY
0RUoAlsEsdmHy8Gjc7aZK0f6Qlf/pC2YQanNeMCE9DdxHEc83ibBA1jppjk1oFQ4
Qq2+lX+UNP3xsvPnB6NyH6nZNY+rZGHceDksSVZySAzdN+HCwdiBlByEXMLY7iY3
AuAm5mWPlRT34yY8/YZhs4OmlKW7FaAHxetRpj9GyobRfkqFK8EcbpXp/7iAon87
dSj4QXdQoFx6fVF1wEhCbzxrmMs+R3wpfIuqnNJwSfiunND0JYQGMC/GuSKveD0R
Gn9Xd9XkNK6JXWNdGdMiGU2+R2FMjRdW1igcgkrOXd5tEUGYKjeUIwTiIclp5VY=
=N44C
-----END PGP SIGNATURE-----
