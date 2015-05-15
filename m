From: =?windows-1252?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: ext4 lazytime: ctime of some files changed
Date: Fri, 15 May 2015 09:17:04 +0200
Message-ID: <55559D70.7070207@web.de>
References: <55531AE3.7030704@web.de> <mivtkj$fhi$1@ger.gmane.org> <20150514222044.GA3901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:48175 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbbEOH0N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2015 03:26:13 -0400
In-Reply-To: <20150514222044.GA3901@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote on 05/15/2015 00:20:
> On Wed, May 13, 2015 at 06:20:35PM +0200, J=F6rg-Volker Peetz wrote:
>>
>> Thereafter, the two emacs package files again had a wrong mtime (whi=
ch by the
>> way shows when I start emacs).
>>
>> Could this be due to the lazytime mount option?
>=20
> I think I found the problem.  My bad.  Can you verify that this solve=
s
> the problem for you?
>=20
I'll try the patch today after repairing most of the timestamps from ba=
ckup to
have a reference.
--=20
Regards,
J=F6rg.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
