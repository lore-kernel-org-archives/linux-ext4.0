From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 10:57:19 -0400
Message-ID: <20140505145719.GI22287@thunk.org>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
 <1399295044-24489-2-git-send-email-tytso@mit.edu>
 <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
 <20140505140401.GD22287@thunk.org>
 <20140505142808.GF22287@thunk.org>
 <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain>
 <20140505144423.GG22287@thunk.org>
 <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, kzak@redhat.com,
	linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49938 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887AbaEEO51 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 10:57:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 05, 2014 at 04:51:25PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> Which would be reasonable if there was a consumer of such
> information and it seemed to be useful. So I wonder what other
> people think about that.
>=20
> Karel, you had some suggestions about how to utilize that aside from
> the mkfs...

Well, if we were going to make this be more general, one other thought
I had was that might be useful to also stash the last hostname in the
superblock.  Consider the situation where you have several hundred
fibre-channel disk volumes in your SAN, and where of course the SAN
administrator hasn't done a good job naming them, and of course the
human sysadmins hadn't bothered to use file system labels.  If we were
automatically stashing the hostname into the superblock at mount time,
it might help in certain cases after the SAN directory gets smashed,
or some such.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
