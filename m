From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] e2fslibs: fix llseek on i386
Date: Thu, 24 Jan 2013 15:22:37 -0500
Message-ID: <5101980D.30904@ubuntu.com>
References: <1359044517-18243-1-git-send-email-psusi@ubuntu.com> <20130124195158.GC9477@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:51336 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab3AXUWk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2013 15:22:40 -0500
In-Reply-To: <20130124195158.GC9477@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/24/2013 2:51 PM, Theodore Ts'o wrote:
> How did you find this?  I've done a quick search for SEEK_CUR, and
> it looks like only place where this could cause a problem is with 
> e2image.  And a quick test of a i386 version of e2image with a
> large file system is that it does indeed blow up with an
> "Inappropriate ioctl for device" error.

That's where I found it, but the error should be "seek: Value too
large for defined data type"

> Is there any other potential problems that are caused by this bug?
> I like to explain the impacts of bug fixes in libext2fs for folks
> who are doing bug fix / code archeology.

If e2image is the only internal user of the call with SEEK_CUR, then I
guess it only affects any external users of the library who were doing
this ( I am not aware of any ).


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJRAZgNAAoJEJrBOlT6nu752g0IAN4czK0LevEa9Mx2htaZ3oms
TtcpKe7tuXgmvLB0XWv8Q2f6zCDMH7qmWqWZORdx98jg2XeynaEbZvVIQFEsfOVa
05r7sk64TPGXrdkwuqFTe4M7MYmrQmLnfGzd2NMddlWcXOc+R4pFUrrvYbU7QQv/
SGfb9Uo+EFZhSuJLPY1QW4EO09ghD4k6XHnHtioAsgjyxSa4p2NcZiBxmFT7ZJdw
DbET65wHkKT2s+jLQQAOPx/IYAftrZuV7t+YoX7RTS4tdpENlgoVlZ3drCvHB2aG
LwDDns4C1e0cAMncGKh3HY4/CInMZ1jFWHYW+VvuzZNJ7Uxur2mG6NUyWp6cNqU=
=WeEv
-----END PGP SIGNATURE-----
