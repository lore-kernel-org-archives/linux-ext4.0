From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Fri, 17 Feb 2012 09:46:12 -0500
Message-ID: <4F3E6834.1030606@ubuntu.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <20120216225810.GB26473@thunk.org> <4F3D8D01.5040604@ubuntu.com> <20120216233031.GD26473@thunk.org> <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com> <20120217143026.GA19606@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:18971 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2BQOqO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Feb 2012 09:46:14 -0500
In-Reply-To: <20120217143026.GA19606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/17/2012 9:30 AM, Ted Ts'o wrote:
> Yep, thanks for the suggestion; I like that.  I'll chain to this 
> message the two patches that I've put together which I think
> should address this issue.  The first uses your suggestion so
> sparse never gets set to zero when we are still extending the
> hole.
> 
> The second uses ftruncate64() if possible to set i_size (which
> saves allocating a block, which is cool when it works).
> 
> What do folks think?

Sounds good to me.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPPmg0AAoJEJrBOlT6nu757WsH/Akcc1iQH70NzwKcyxgkGGJf
b7/as/olbJE+ZQhmYswMzcwQjwYDsbTfQZLLZM5KRZZGNpmaGhW9FtrV5U7ayiYf
FU9duik/BUXfH1pmg6jmyM+QDgIuxFghFT3WOAWS5PosECJ0P0ORQ1sxARp9+P2W
jSiaJCeHZZ37dDej1qEOy8S6IKwLPmlIroSuUBckkOcGewBzaZWvQYjxkmz4Dv8V
PTmeTFwpcz8mBECHXyun1mE5Ym44yfD+bYazQZO3sVRqF5O+T5uktmte10905g+4
Qluv7rv/6ZT2j/S9MIMylA7pOfJNgcdkjKjSlxZLIofmRVm/1yeA70YJWfkFpCg=
=+I+P
-----END PGP SIGNATURE-----
