From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
Date: Sun, 30 Aug 2009 02:01:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908300152490.5744@bogon.housecafe.de>
References: <ff262c08b0c3a7a9c32dabd53a4a9a27.squirrel@neil.brown.name> <20090824212518.GF29763@elf.ucw.cz> <20090825232601.GF4300@elf.ucw.cz> <4A947682.2010204@redhat.com> <200908262253.17886.rob@landley.net> <4A967175.5070700@redhat.com> <20090827221319.GA1601@ucw.cz>
 <4A9733C1.2070904@redhat.com> <20090828064449.GA27528@elf.ucw.cz> <20090828120854.GA8153@mit.edu> <20090830075135.GA1874@ucw.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, NeilBrown <neilb@suse.de>,
	Ric Wheeler <rwheeler@redhat.com>,
	Rob Landley <rob@landley.net>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZH3JB2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Aug 2009 05:01:28 -0400
In-Reply-To: <20090830075135.GA1874@ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 30 Aug 2009 at 09:51, Pavel Machek wrote:
> > give system administrators.  It's better than the fear-mongering
> > patches you had proposed earlier, but what would be better *still* is
> > telling people why running with degraded RAID arrays is bad, and to
> > give them further tips about how to use RAID arrays safely.
> 
> Maybe this belongs to Doc*/filesystems, and more detailed RAID
> description should go to md description?

Why should this be placed in *kernel* documentation anyway? The "dangers 
of RAID", the hints that "backups are a good idea" - isn't that something 
for howtos for sysadmins? No end-user will ever look into Documentation/ 
anyway. The sysadmins should know what they're doing and see the upsides 
and downsides of RAID and journalling filesystems. And they'll turn to 
howtos and tutorials to find out. And maybe seek *reference* documentation 
in Documentation/ - but I don't think Storage-101 should be covered in 
a mostly hidden place like Documentation/.

Christian.
-- 
BOFH excuse #212:

Of course it doesn't work. We've performed a software upgrade.
