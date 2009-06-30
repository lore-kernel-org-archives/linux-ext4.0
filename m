From: Alex Buell <alex.buell@munted.org.uk>
Subject: Re: [PATCH] debugfs: don't try to fclose NULL
Date: Tue, 30 Jun 2009 17:46:23 +0100
Message-ID: <1246380383.11440.2.camel@lithium.local.net>
References: <4A451A23.20307@redhat.com> <m2r5x1pvyg.fsf@vador.mandriva.com>
	 <20090630163956.GE7398@mit.edu>
Reply-To: alex.buell@munted.org.uk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Thierry Vignaud <tvignaud@mandriva.com>,
	Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from v-smtp-auth-relay-6.gradwell.net ([79.135.125.112]:40582 "EHLO
	v-smtp-auth-relay-6.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbZF3RGj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 13:06:39 -0400
In-Reply-To: <20090630163956.GE7398@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-06-30 at 12:39 -0400, Theodore Tso wrote:
> On Tue, Jun 30, 2009 at 05:44:55PM +0200, Thierry Vignaud wrote:
> > Eric Sandeen <sandeen@redhat.com> writes:
> > 
> > > do_logdump may jump to errout if fopen(out_file) fails, 
> > > but in that case out_file is NULL, and fclose will segfault.
> > 
> > You should report that segfault to glibc authors too.
> 
> It would be robust for glibc to code fclose() defensively such that it
> would survive a null pointer, but I don't think it's technically
> required by the ANSI or POSIX spec.

It's the programmer's responsibility to write the following:

if (fp)
	fclose(fp);

-- 
http://www.munted.org.uk

One very high maintenance cat living here.
