From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Sun, 27 Jan 2008 09:06:59 -0600
Message-ID: <479C9E13.8040209@redhat.com>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYA0PHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jan 2008 10:07:45 -0500
In-Reply-To: <20080127050543.GC24842@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:

> Patch10:        close.patch
> 
> I don't understand what this patch is trying to do.

* Tue Nov 15 2005 jblunck@suse.de
- added close.patch provided by Ted Tso (IBM) to fix bug #132708

*grin* Maybe obsolete by now?  haven't looked closely.

> Patch12:        e2fsprogs-mkinstalldirs.patch
> 
> Why?
> 

Probably same as why we have something similar; for one reason or other
need to rerun autoconf, and e2fsprogs isn't compatible with latest
autoconf.  (This is a patch I inherited, and haven't yet investigated
all the details)

> Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
> 
> The problem with this patch is that /var/run is cleared via rm -rf, so
> it is highly problamtic to put the scratch directory for uuidd in
> /var/run.

Hm, I had similar issues with uuidd too - common theme here?

> 
> Patch32:        libcom_err-no-e2fsck.static.patch
> 
> This patch does two completely unrelated things.  One is to disable
> the libcom_err regression test suite (probably because some of the
> other changes made) and the other is to disable building the
> e2fsck.static file.  Why these two are bundled into a single patch I'm
> not sure.

And I have a patch to do the latter as well.  Interesting how we've
arrived at similar needed changes, independently.  :)

and Patch99:        e2fsprogs-no_cmd_hiding.patch

honestly I like that; I should whip up a nice patch to emulate kbuild,
with V=1 or something, unless there is some other easy way to show full
build commands already?

-Eric
