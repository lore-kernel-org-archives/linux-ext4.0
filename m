From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: ext4_fallocate
Date: Tue, 03 Jul 2012 23:06:58 -0400
Message-ID: <4FF3B352.3040707@ubuntu.com>
References: <4FE9F9F4.7010804@zoho.com> <4FEA0DD1.8080403@gmail.com> <4FEA1415.8040809@redhat.com> <4FEA1F18.6010206@redhat.com> <20120627193034.GA3198@thunk.org> <4FEB9115.6090309@redhat.com> <20120702031611.GB2406@gmail.com> <4FF1CD5D.8010904@redhat.com> <20120702174421.GM6679@quack.suse.cz> <4FF39924.7070602@ubuntu.com> <20120704023634.GB16947@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:12221 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2GDDHB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 23:07:01 -0400
In-Reply-To: <20120704023634.GB16947@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/03/2012 10:36 PM, Zheng Liu wrote:
> Actually the workload needs to flush the data after writting a small
> random bits.  This workload is met in our product system at Taobao.
> Thus, the application has to wait this write to be done.  Certainly if
> we don't flush the data, the problem won't happen but there is a risk
> that we could loss our data.

Ohh, I see now... you want lots of small, random, synchronous writes.  Then I think the only way to avoid the metadata overhead is with the unsafe stale data patch.  More importantly, this workload is going to have terrible performance no matter what the fs does, because even with all of the blocks initialized, you're still doing lots of seeking and not allowing the IO elevator to help.  Maybe the application can be redesigned so that it does not generate such pathological IO?

Or is this another case of userspace really needing access to barriers rather than using the big hammer of fsync?

Is there any technical reason why a barrier flag can't be added to the aio interface?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP87NSAAoJEJrBOlT6nu75F7wH/0NrhBZyp+KwYuJpqM+hUs8o
1CSRXpw/OBOljH61kAT1zqRofMNA/6gF5EYnAB3usUiwjJk4eQu4kFCVastZrLRQ
Zm3H2yuSXbeoRvuSnNBbpjCPFQYIKWHcKjt2+pov853Kb2auYSyN2T6I7qUmLu7U
tMJtJekMi4HPz3snBrLGsvYRyy7rMLWwf3wd+G2SBrVNS/tKuRSRaw0FwXqDaoN9
Dc4FqWmVeicG9qQbszkal84IZo1YwSWMzeRvqjn+LER1XTJJaSzvttppBKKFsS2M
FVeMwTtRHJ3wl3jWYTyN/AwDUg3Pr/PX9/xmdn8DSGQG3eo7sBlqyPBzN6QYz5w=
=C2YA
-----END PGP SIGNATURE-----
