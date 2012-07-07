From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: e2defrag 0.81 released
Date: Sat, 07 Jul 2012 10:53:00 -0400
Message-ID: <4FF84D4C.1030308@ubuntu.com>
References: <4FF76E37.1020001@ubuntu.com> <6642BE04-8D3A-4B15-8FB1-05DFB80CB6B9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:14938 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2GGOxC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jul 2012 10:53:02 -0400
In-Reply-To: <6642BE04-8D3A-4B15-8FB1-05DFB80CB6B9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/07/2012 02:02 AM, Andreas Dilger wrote:
> I hate to rain on your parade, but, are you aware of e4defrag?

Of course.  I started working on e2fsprogs two years ago though, when e4defrag was still on the drawing board, and just haven't gotten around to polishing and announcing it until now.

My understanding of e4defrag is that it works essentially like tools such as shake: find a fragmented file and copy it, hoping the copy will be less fragmented.  Thus, it does nothing for free space fragmentation, file locality, etc.  Plus, it doesn't have cool ansi graphics ;)

> It is already in e2fsprogs, and can be used on a mounted ext4 filesystem...
> It also needs some lovin' to make it really robust, but would definitely
> be a better starting point than the ancient e2defrag code...
> 
> That's why it is always a good idea to post to the mailing list _before_
> you start on a project, to see what else is going on...  Definitely there
> is a need for such a tool, but I hate to see effort being spent in two
> different directions to make two so-so tools, when it could be going in
> the same direction to make one excellent tool.

I'm hoping that eventually e4defrag will be able to do everything e2defrag can, and not too much slower, but for the moment, e2defrag already works, and I haven't seen any indication that e4defrag is planned to do free space defragging and file packing.  Perhaps having a little friendly competition will change that.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP+E1MAAoJEJrBOlT6nu75bkYH/2rXRYqMYAA+D/EUwxfvq18p
ltrb3nOWXA7ZA6Gy1Lg+zcoG203F44XOKg8aNADS/1sYKkyiF5NhFcGRgXrp/gM/
0586WqpkAc0rhuk0vGcDinr8KOdaeTH3Ye5zN/6jju/bEls3Q5wpSCU71LfYYj62
Q+YOJK+TRq6r5NudIe6rIbNArVPMedPDw17L6yP4opi2iPrylW/WndStFFzjDAgK
Fa0/YRLl+SLwfKvCSorBtuSpuOToC1bfdq2ZmqIX7VCe7WThTVAzE9avDoaDhzIj
LK3ErsyztJZWPcfr34A1BEYZn2ZH5+Hsf+/Pmh4M8grMRgGfUhy1UU1/t7Zhyq0=
=Bxln
-----END PGP SIGNATURE-----
