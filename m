From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 13:02:01 -0500
Message-ID: <B43723CA-78A5-416D-B44F-3018CE981211@mit.edu>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Rudolf Zran <rudolfzran@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:51193 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160Ab2BJSCG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 13:02:06 -0500
In-Reply-To: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Feb 9, 2012, at 11:29 AM, Rudolf Zran wrote:

> Hi everybody!
>=20
> I recently damaged an ext4 partition by accident (mistakenly forced
> a RAID sync with another partition onto it, which I realized after
> about 3% completion). As a result the beginning of the ext4 partition
> seems to be overwritten with garbage and refuses to mount.
>=20
> As you might guess, I'd now like to get as most of my data back (from
> the part which hasn't been overwritten, of course :)).
>=20
> Maybe somebody knows a good method to just "repair" the ext4-structur=
e
> from the remaining part of the partition?\

Have you tried just simply running e2fsck, specifying an alternate supe=
rblock?

I'd do this by making a copy of the file system first, of course=85.

-- Ted


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
