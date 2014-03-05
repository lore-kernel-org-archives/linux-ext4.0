From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [Bug 70121] New: Increasing efficiency of full data journaling
Date: Wed, 05 Mar 2014 15:37:30 -0500
Message-ID: <53178B0A.9020906@ubuntu.com>
References: <bug-70121-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50607 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbaCEUhc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2014 15:37:32 -0500
In-Reply-To: <bug-70121-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/6/2014 5:38 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> Full data journaling provides the ability that it is guaranteed
> that a file will never be saved visible for the user in a damaged
> state (except a hardware defect appears afterwards). But this has
> the disadvantage that the writing througput is ~halfed as all files
> are written 2 times.

It does no such thing.  To do that, a new kernel api is needed to
allow the application to specify where transactions start/stop.  Data
journaling only makes sense for an external journal on an ssd or
similar: then fsync() and friends can return as soon as the data hits
the ssd and rely on it being safely migrated to the hdd in the future.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTF4sKAAoJEI5FoCIzSKrwBpsH/35GAm2iqyNudw0JjJdceYqd
PC+47MwQoJE2kcGLNCPVZLhRdHg+fWF6JKewnGAJXz6jsOIeblWyqyL03x8cCDMB
107ssZzXy8OllhczGp1oMR4q7bM0RiIwDjqD8qPJxYwTOHcoIp7RbyK0ER++LcE6
lISrSCyzyqpgo9o2oRAlAdP8/aioaOyiJbGpIhfH42Je+zG5k3mGwaCIuVvBR+Ef
wm6rOqApxv6JwZy0s12alq6MUFMzE9qb9WTzLiDtPybSFzvUgt5brePi74HdJZHs
JYjtUqk43q8wYCWcDcEjKb8q6/h/HGP296ZhM9CoXjq+HYqqWWXbl9T5F5+Nl6k=
=nADc
-----END PGP SIGNATURE-----
