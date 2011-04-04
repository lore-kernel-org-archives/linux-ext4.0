From: Ted Ts'o <tytso@mit.edu>
Subject: Re: potential memory leak on transaction commit
Date: Mon, 4 Apr 2011 18:10:09 -0400
Message-ID: <20110404221009.GD2832@thunk.org>
References: <alpine.LFD.2.02.1103081849430.6414@zhanghuan.nrchpc.ac.cn>
 <AANLkTi=ZPGd6scA8u3eSCzq1jgZWZdxs0p4p5knd2bN5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zhang Huan <zhhuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57328 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1DDWKL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Apr 2011 18:10:11 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=ZPGd6scA8u3eSCzq1jgZWZdxs0p4p5knd2bN5@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zhang,

Sorry for the delay in looking at it.  One thing which is missing from
your patch is a signed-off-by header.  From section 12 of the
Documentation/SubmittingPatches file in the Linux source tree:

>The sign-off is a simple line at the end of the explanation for the
>patch, which certifies that you wrote it or otherwise have the right to
>pass it on as a open-source patch.  The rules are pretty simple: if you
>can certify the below:
>
>        Developer's Certificate of Origin 1.1
>
>        By making a contribution to this project, I certify that:
>
>        (a) The contribution was created in whole or in part by me and I
>            have the right to submit it under the open source license
>            indicated in the file; or
>
>        (b) The contribution is based upon previous work that, to the best
>            of my knowledge, is covered under an appropriate open source
>            license and I have the right under that license to submit that
>            work with modifications, whether created in whole or in part
>            by me, under the same open source license (unless I am
>            permitted to submit under a different license), as indicated
>            in the file; or
>
>        (c) The contribution was provided directly to me by some other
>            person who certified (a), (b) or (c) and I have not modified
>            it.
>
>	(d) I understand and agree that this project and the contribution
>	    are public and that a record of the contribution (including all
>	    personal information I submit with it, including my sign-off) is
>	    maintained indefinitely and may be redistributed consistent with
>	    this project or the open source license(s) involved.
>
>then you just add a line saying
>
>	Signed-off-by: Random J Developer <random@developer.example.org>
>
>using your real name (sorry, no pseudonyms or anonymous contributions.)

If you could send me an acknowledgement that it would be OK to add a

Signed-off-by: Zhang Huan <zhhuan@gmail.com>

line to your patch, it would be much appreciated.

     	     	       	     	     - Ted
