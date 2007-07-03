From: Karsten Hopp <karsten@redhat.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Tue, 03 Jul 2007 11:19:23 +0200
Message-ID: <468A149B.60700@redhat.com>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com> <20070612234004.GA12189@thunk.org> <466FCE52.4000605@redhat.com> <20070621175618.GA22285@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, dm-crypt@saout.de
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbXGCJT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2007 05:19:29 -0400
In-Reply-To: <20070621175618.GA22285@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso schrieb:
> Thanks, I've applied the blkid LUKS patch to the e2fsprogs SCM (modulo
> a minor whitespace breakage which I fixed up).
> 
> BTW, there appears to be a problem here in udev regarding LUKS
> identification:
> 
> https://bugs.launchpad.net/ubuntu/+source/e2fsprogs/+bug/93921
> 
...

Thanks for applying the small patch !

FYI:
I've opened a bugzilla about your udev concerns to get some comments from our
and the upstream maintainer at
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=245717

Kay Sievers from the udev team responded:
#> That's nothing new. Guessing filesystems by magic bytes on the disk is by
#> definition unsafe.
#>
#> _All_ filesystem formatters are required to wipe out _all_ existing signatures
#> before applying a new signature. Even then, it's not entirely safe to probe, but
#> we obviously have no alternatives.
#>
#> Shuffling the probing order around will only switch the systems where such
#> problems occur. From my standpoint, you can close this "bug". Thanks!

So, no help from this side....

   Karsten

--
  Karsten Hopp        | Mail: karsten@redhat.de
  Red Hat Deutschland | Tel: +49-711-96437-0
  Hauptstaetterstr.58 | Fax: +49-711-613590
  D-70178 Stuttgart   | http://www.redhat.de
