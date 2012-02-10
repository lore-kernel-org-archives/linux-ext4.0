From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Restoring filenames from partly damaged ext4-filesystem
Date: Fri, 10 Feb 2012 23:17:17 +0100
Message-ID: <4F35976D.4090309@fastmail.fm>
References: <1328804993.34330.YahooMailNeo@web132403.mail.ird.yahoo.com> <B43723CA-78A5-416D-B44F-3018CE981211@mit.edu> <1328899012.92220.YahooMailNeo@web132404.mail.ird.yahoo.com> <20120210213237.GF5381@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rudolf Zran <rudolfzran@yahoo.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"debian-user@lists.debian.org" <debian-user@lists.debian.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55367 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab2BJWRU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Feb 2012 17:17:20 -0500
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 24F1F208EF
	for <linux-ext4@vger.kernel.org>; Fri, 10 Feb 2012 17:17:19 -0500 (EST)
In-Reply-To: <20120210213237.GF5381@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/10/2012 10:32 PM, Ted Ts'o wrote:
> On Fri, Feb 10, 2012 at 06:36:52PM +0000, Rudolf Zran wrote:
>>>> * "fsck.ext4 -b $SBOK -B 4096 -v -y /dev/loop0" recoveres after a =
long time.
>>>>    Filesystem is mountable. Root is empty besides lost+found folde=
r, which
>>>>    contains about 300GB mostly useless data: Millions of files wit=
h wrong
>>>>    permissions, useless names and some random content.
>>
>>> I'd do this by making a copy of the file system first, of course=E2=
=80=A6.
>
> I would have expected at least some subdirectories from your director=
y
> hierarcy that contained useful content.
>
> Just to set expectations, things that you might do that tried to look
> for directory blocks, etc., *might* give you more useful filenames as
> opposed to random inode numbers in lost+found, but it's unlikely to
> recover any more *files*.  It sounds most of your files were located
> in part of the inode table that got smashed, and so short of looking
> at each data block to find useful bits, I doubt spending a lot of tim=
e
> on trying to use or create more recovery tools based on file system
> metadata is likely to result in more data getting recovered.
>

You do not need inode tables to get back a basic directory structure.=20
Assigning directory blocks with '.' and '..' and then with real content=
=20
provide the file system structure and also inode-number to name=20
translation. Even better would be if secondary blocks also would have=20
'.' and '..'.


Cheers,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
