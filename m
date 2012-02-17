From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 1/2] e2image: truncate raw image file to correct size
Date: Fri, 17 Feb 2012 09:31:42 -0500
Message-ID: <4F3E64CE.6060504@ubuntu.com>
References: <1329428112-8911-1-git-send-email-psusi@ubuntu.com> <20120216225810.GB26473@thunk.org> <4F3D8D01.5040604@ubuntu.com> <20120216233031.GD26473@thunk.org> <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:31965 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2BQObo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Feb 2012 09:31:44 -0500
In-Reply-To: <alpine.LFD.2.00.1202171054320.6479@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/17/2012 5:04 AM, Lukas Czerner wrote:
> We can easily fix that by doing this instead:
> 
> if (sparse > 1024*1024) { write_block(fd, 0, 1024*1024, 0, 0); 
> sparse -= 1024*1024; }

That occurred to me last night while I slept.  I still would like to try
to truncate instead of write the last zero though.  Patch coming up.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPPmTOAAoJEJrBOlT6nu75TekH/RAG5FgOHsUU0uMFG3v9Z1av
sw/KTmaLpnFGOkQDBYzgZ8+1StfhVdZOUpjNduNWots5cv5+9YoMwyBaLgw51YPN
1HIi5UucRiW5KT8j+FShbHbv4SBtU/PaMvqxangNETttT+MMbPj288QSldEYv1Zf
E/0ZPnYxmtd55vs0tee+q0XdSJNLBpMV64nOVIMDPXwOYbjZr+nhAv8LrRGvIk5a
2kduQ2zbN47CjPSod8PjlHIq3MQ+SqYgI9/7aHye9a/K3sGMVMAekacs7vCQquFe
lLx593a6F32p6f2ee+3uqleftzUzxRsDAE3Myollq0STLsfdm9+P+5fdfp8iLEs=
=BYbM
-----END PGP SIGNATURE-----
