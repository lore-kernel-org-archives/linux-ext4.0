From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Patch to support LUKS UUIDs in libblkid
Date: Tue, 03 Jul 2007 10:57:57 -0500
Message-ID: <468A7205.4010509@redhat.com>
References: <4665479E.2060707@redhat.com> <20070608153600.GA9726@thunk.org> <466D373C.6000502@redhat.com> <20070612234004.GA12189@thunk.org> <466FCE52.4000605@redhat.com> <20070621175618.GA22285@thunk.org> <468A149B.60700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	dm-crypt@saout.de
To: Karsten Hopp <karsten@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761139AbXGCQAf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jul 2007 12:00:35 -0400
In-Reply-To: <468A149B.60700@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Karsten Hopp wrote:

> Thanks for applying the small patch !
> 
> FYI:
> I've opened a bugzilla about your udev concerns to get some comments from our
> and the upstream maintainer at
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=245717
> 
> Kay Sievers from the udev team responded:
> #> That's nothing new. Guessing filesystems by magic bytes on the disk is by
> #> definition unsafe.
> #>
> #> _All_ filesystem formatters are required to wipe out _all_ existing signatures
> #> before applying a new signature. Even then, it's not entirely safe to probe, but
> #> we obviously have no alternatives.

We fought this for a while in xfs, trying to be sure we wipe out old fs
signatures at mkfs time.  It'd be nice to have a library to do such
things...

-Eric
