From: Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Date: Sat, 30 Jul 2011 15:25:32 +0800
Message-ID: <4E33B1EC.9030004__29028.6702839241$1312010505$gmane$org@gmail.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop> <20110727082730.GG20655@tux1.beaverton.ibm.com> <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com> <20110728165615.GI20655@tux1.beaverton.ibm.com> <20110728220735.GA27253@noexit.corp.google.com> <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca> <20110729131937.GB5910@noexit.corp.google.com>
Reply-To: colyli@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <aedilger@gmail.com>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	l
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40928 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753112Ab1G3HVY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jul 2011 03:21:24 -0400
In-Reply-To: <20110729131937.GB5910@noexit.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B407=E6=9C=8829=E6=97=A5 21:19, Joel Becker Wrote:
> On Fri, Jul 29, 2011 at 03:48:45AM -0600, Andreas Dilger wrote:
>> On 2011-07-28, at 4:07 PM, Joel Becker wrote:
>>> 	We use ethernet crc32 in ocfs2.  btrfs uses crc32c.  Frankly, I
>>> could have used crc32c if I'd really thought about the hardware
>>> acceleration benefits.  I think it's a good idea for ext4.
>>
>> The problem with crc32[c] is that if you don't have hardware acceler=
ation
>> it is terribly slow.
>=20
> 	We find ethernet crc32 just fine in ocfs2.  I use the kernel's
> implementation, which survives everyone's network traffic, and of cou=
rse
> we added the triggers to jbd2 so we only have to do the calculations =
on
> read and write.
>=20

Ext4 supports non-journal mode, and there are a few users (Google, Taob=
ao, etc.).
A trigger of jbd2 may not work well for non-journal Ext4 ...

And in non-journal mode, there is not copy of any meta data block in jb=
d2, we need to be
more careful in check summing, e.g. inode/block bitmap blocks...


>> Yes, it makes sense to just put a "fake" dirent at the end of the le=
af block,
>> or similar.  I don't think it is necessary to modify existing direct=
ories or
>> extent blocks to add these structures in, if there is no room, but f=
or new
>> blocks, or blocks with space it is enough.
>=20
> 	We have tunefs.ocfs2 code to adjust existing directories to add
> the trailer.  It's not too bad, really.

Agree, enable/disable the trailer isn't that difficult. We need more ey=
es to take care the user space tools.

Coly
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
