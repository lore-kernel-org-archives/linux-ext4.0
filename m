From: Philipp Thomas <pth@suse.de>
Subject: Re: [PATCH] e2fsprogs: small .de translation fix
Date: Fri, 21 Feb 2014 13:01:33 +0100
Message-ID: <20140221120133.GC6304@paradies.suse.de>
References: <52C704EC.8000501@redhat.com>
 <5306D3D9.4040303@redhat.com>
 <20140221081228.GE31047@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbaBUMBe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Feb 2014 07:01:34 -0500
Content-Disposition: inline
In-Reply-To: <20140221081228.GE31047@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Ted T'so (tytso@mit.edu) [20140221 09:12]:

> Yeah, I usually let the fixes for the translations come through the
> Translation Project, for which Philipp is on the translation team.

And this translation has gone completely unnoticed by me, being swamped
with the work on SLES12. 

> Philipp, while you're at it, could you also take a look at these two
> Debian bugs?
> 
>        https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=703048
>        https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=737800

I'll check them. While I have your eye: I noticed the buglet:

#: misc/e2image.c:1368
msgid "Raw and qcow2 images cannotbe installed"

with the space between cannot and be missing. I'll patch the package for
opensuse factory for the time being.

Philipp
