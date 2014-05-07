From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: add sysfs entry showing whether the fs contains
 errors
Date: Wed, 7 May 2014 12:01:52 -0400
Message-ID: <20140507160152.GA6408@thunk.org>
References: <1399464274-16310-1-git-send-email-lczerner@redhat.com>
 <20140507143646.GB28814@thunk.org>
 <alpine.LFD.2.00.1405071714470.2128@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54698 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933723AbaEGQBz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 May 2014 12:01:55 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405071714470.2128@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 07, 2014 at 05:35:54PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I tried to find sysfs guidelines but I can not see any in
> Documentation speaking about the contents of the files.
>=20
> What are the guidelines then ?

Documentation/filesystems/sysfs.txt:

   Attributes can be exported for kobjects in the form of regular
   files in the filesystem. Sysfs forwards file I/O operations to
   methods defined for the attributes, providing a means to read and
   write kernel attributes.

   Attributes should be ASCII text files, preferably with only one valu=
e
   per file. It is noted that it may not be efficient to contain only o=
ne
   value per file, so it is socially acceptable to express an array of
   values of the same type.=20

I don't remember that last sentence; it was apparently added since the
last time I've looked at it.  Originally, the requirement that each
sysfs file (which was supposed to be an kobject attribute) was
required to be a single value.  Now there's an escape hatch for
"efficiency", which is nice....

> So you're suggesting to have three sysfs files ?
>=20
> errors_count
> first_error_time
> last_error_time

Yes, that's what I was suggesting.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
