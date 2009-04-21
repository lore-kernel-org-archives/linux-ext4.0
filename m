From: Thierry Vignaud <tvignaud@mandriva.com>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup blocks...
Date: Tue, 21 Apr 2009 18:56:46 +0200
Message-ID: <m2ljpu3pyp.fsf@vador.mandriva.com>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com>
	<gshfgl$o6m$1@ger.gmane.org> <m2eivm599b.fsf@vador.mandriva.com>
	<49EDEBCC.3030008@redhat.com> <m23ac255pp.fsf@vador.mandriva.com>
	<49EDF6E8.7070101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Sanders <jss@ast.cam.ac.uk>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.moondrake.net ([212.85.150.166]:45657 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753197AbZDUQ4d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2009 12:56:33 -0400
In-Reply-To: <49EDF6E8.7070101@redhat.com> (Eric Sandeen's message of "Tue\, 21 Apr 2009 11\:40\:08 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen <sandeen@redhat.com> writes:

> Could you send me dumpe2fs -h output of the large target device, as
> well as an "e2image -r" image of the source filesystem?  That way I
> can hopefully perfectly replicate your target filesystem as well as
> the data you're using to populate it, try the cp myself, and see if I
> hit the same thing.
> 
> e2image only sends metadata information, not data.  If you are
> concerned about filenames, use -s to scramble them, though this
> *might* impact my ability to reproduce it...

I'll do (disk's at home).

Filesystems were formatted with standard mkfs.ext4 (some were formated
with mkfs.ext4 -F which is why diskdrake default to), that us using std
/etc/mke2fs.conf.
