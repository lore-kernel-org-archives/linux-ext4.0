From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing ext2/3/4 file systems
Date: Mon, 5 May 2014 10:25:55 -0600
Message-ID: <DF90E5C1-976B-4831-93C3-6D8213B020E6@dilger.ca>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain> <20140505140401.GD22287@thunk.org> <20140505142808.GF22287@thunk.org> <alpine.LFD.2.00.1405051629270.2223@localhost.localdomain> <20140505144423.GG22287@thunk.org> <alpine.LFD.2.00.1405051649050.2223@localhost.localdomain> <20140505145719.GI22287@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?utf-8?Q?Luk=C3=A1=C5=A1_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"kzak@redhat.com" <kzak@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:41382 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaEEQZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 May 2014 12:25:57 -0400
Received: by mail-ig0-f178.google.com with SMTP id hl10so4982016igb.17
        for <linux-ext4@vger.kernel.org>; Mon, 05 May 2014 09:25:57 -0700 (PDT)
In-Reply-To: <20140505145719.GI22287@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Note that the MMP block already contains the hostname for informational=
 purposes.=20

I'd argue that if you have several hundred SAN attached disks and they =
are not zoned for specific nodes then using MMP will save your bacon fr=
om foolish admins that are trying to use the same disk on multiple node=
s.=20

Cheers, Andreas

> On May 5, 2014, at 8:57, Theodore Ts'o <tytso@mit.edu> wrote:
>=20
>> On Mon, May 05, 2014 at 04:51:25PM +0200, Luk=C3=A1=C5=A1 Czerner wr=
ote:
>>=20
>> Which would be reasonable if there was a consumer of such
>> information and it seemed to be useful. So I wonder what other
>> people think about that.
>>=20
>> Karel, you had some suggestions about how to utilize that aside from
>> the mkfs...
>=20
> Well, if we were going to make this be more general, one other though=
t
> I had was that might be useful to also stash the last hostname in the
> superblock.  Consider the situation where you have several hundred
> fibre-channel disk volumes in your SAN, and where of course the SAN
> administrator hasn't done a good job naming them, and of course the
> human sysadmins hadn't bothered to use file system labels.  If we wer=
e
> automatically stashing the hostname into the superblock at mount time=
,
> it might help in certain cases after the SAN directory gets smashed,
> or some such.
>=20
>                        - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
