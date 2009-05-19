From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Tue, 19 May 2009 17:18:06 +0200
Message-ID: <m2eiul5dg1.fsf@vador.mandriva.com>
References: <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan>
	<20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan>
	<20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan>
	<20090514212325.GG21316@mit.edu> <m2iqjx5s4n.fsf@vador.mandriva.com>
	<20090519113644.GA7927@mit.edu> <4A129FA0.9050500@sun.com>
	<20090519150430.GC7927@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz@sun.com>, Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:60966 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753103AbZESPSI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 May 2009 11:18:08 -0400
In-Reply-To: <20090519150430.GC7927@mit.edu> (Theodore Tso's message of "Tue\, 19 May 2009 11\:04\:30 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> >> On the other hand, most of the time writes into the directory will
> >> tend to be into pre-existing free space; but if you had two parallel
> >> cp's copying a large number of files into the same directory, that
> >> could certainly happen.
> >
> > isn't access to a directory protected with i_mutex ?
> 
> Hmm, good point.  Yes, that should prevent problems with directories.
> So there should only be a problem when two processes are writing to
> the same file at the same time.

I remember that happened...
