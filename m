From: Florian Weimer <fweimer@bfk.de>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Fri, 29 May 2009 12:52:21 +0200
Message-ID: <82k540dvve.fsf@mid.bfk.de>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	<20090511081216.GK4694@kernel.dk> <20090511084121.GB29082@mit.edu>
	<1242062325.9647.4.camel@localhost.localdomain>
	<20090511184323.GA16885@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Chris Mason <chris.mason@oracle.com>, Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.bfk.de ([193.227.124.2]:52891 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421AbZE2LFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 May 2009 07:05:22 -0400
In-Reply-To: <20090511184323.GA16885@linux.intel.com> (Matthew Wilcox's message of "Mon\, 11 May 2009 11\:43\:23 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Matthew Wilcox:

> Actually, that's the exact opposite of what you want.  You want to tr=
y
> to reuse blocks that are scheduled for trimming so that we never have=
 to
> send the command at all.

I thought that the device would receive as many TRIM commands as
possible, to aid its internal reorganization process?  A write which
overwrites a whole block could be equivalent, but it may not be a good
idea to artificially increase I/O traffic to turn partial writes to
unused blocks into full-block writes.

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
