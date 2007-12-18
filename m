From: Florian Weimer <fweimer@bfk.de>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Tue, 18 Dec 2007 09:13:41 +0100
Message-ID: <8263yw2zey.fsf@mid.bfk.de>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
	<20071217171100.GA7070@thunk.org>
	<20071217223455.GE3214@webber.adilger.int>
	<20071217225930.GJ7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx01.bfk.de ([193.227.124.2]:41242 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXLRI2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Dec 2007 03:28:34 -0500
In-Reply-To: <20071217225930.GJ7070@thunk.org> (Theodore Tso's message of "Mon, 17 Dec 2007 17:59:30 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Tso:

> Hm.  I was very concerned about using db4, mainly because of the ABI
> and on-disk format compatibility nightmare, which is why I chose tdb.

If you don't use the transactional data store, the B-tree disk format
hasn't changed in years.  The API is fairly stable, too (not the ABI,
of course, because it's deliberately tied to a particular version by
most distros).

The main issues I see with Berkeley DB are: it assumes atomic page
writes (even in transactional data store mode), it writes database
files in a way that maximizes file-system level fragmentation, and
sequential scans are unbearably slow.  Oh, and most applications using
TDS do not handle recovery and upgrades properly. (For them, SQLite
would probably have been a better choice. 8-/)

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
