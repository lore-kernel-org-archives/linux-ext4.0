From: Coly Li <coyli@suse.de>
Subject: Re: [PATCH] removing e2fsprogs compiling warnings
Date: Sun, 05 Aug 2007 21:25:42 +0800
Message-ID: <46B5CFD6.9030708@suse.de>
References: <46B033AC.1070809@gmail.com> <20070803223229.GB7449@thunk.org> <46B417A2.1040201@suse.de> <20070804145620.GA16163@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42712 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbXHENYm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Aug 2007 09:24:42 -0400
In-Reply-To: <20070804145620.GA16163@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

clear, this is a perfect explaining for Signed-off-by :-)

Thanks a lot.

Coly

Theodore Tso wrote:
> On Sat, Aug 04, 2007 at 02:07:30PM +0800, Coly Li wrote:
>> Do you mean  "Signed-off-by Coly Li <coyli@suse.de>" ?
>> I just though this is used for others to sign my patch :-) 
> 
> No, it's really bad to add a Signed-off-by for anyone other than
> yourself, since it has legal significance.  It's something that you
> have to do for yourself.  :-)
> 
> Quoting from SUBMITTING-PATCHES:
> 
> The sign-off is a simple line at the end of the explanation for the
> patch, which certifies that you wrote it or otherwise have the right to
> pass it on as a open-source patch.  The rules are pretty simple: if you
> can certify the below:
> 
>         Developer's Certificate of Origin 1.1
> 
>         By making a contribution to this project, I certify that:
> 
>         (a) The contribution was created in whole or in part by me and I
>             have the right to submit it under the open source license
>             indicated in the file; or
> 
>         (b) The contribution is based upon previous work that, to the best
>             of my knowledge, is covered under an appropriate open source
>             license and I have the right under that license to submit that
>             work with modifications, whether created in whole or in part
>             by me, under the same open source license (unless I am
>             permitted to submit under a different license), as indicated
>             in the file; or
> 
>         (c) The contribution was provided directly to me by some other
>             person who certified (a), (b) or (c) and I have not modified
>             it.
> 
> 	(d) I understand and agree that this project and the contribution
> 	    are public and that a record of the contribution (including all
> 	    personal information I submit with it, including my sign-off) is
> 	    maintained indefinitely and may be redistributed consistent with
> 	    this project or the open source license(s) involved.
> 
> then you just add a line saying
> 
> 	Signed-off-by: Random J Developer <random@developer.example.org>
> 
> In this case of your gcc -Wall cleanups, the changes involved were
> small and probably fell below the threshold of something that could be
> protected by copyright --- and I ended up choosing a different way of
> cleaning up for one or two of the cleanups anyway.  But for anything
> non-trivial, these days I am requested a Developers Certification of
> Origin.
> 
> Regards,
> 
> 						- Ted
> 
