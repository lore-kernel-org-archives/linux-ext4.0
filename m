From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Question about writable ext4-snapshot
Date: Mon, 23 Jan 2012 22:08:49 +0200
Message-ID: <CAOQ4uxh-7P-Lg4u9rqo6RghUcXYMhdZ8xNHVXuzfOna0FmjGYg@mail.gmail.com>
References: <CAFZ0FUWzq4GV-Xi6n+8+5R+oVi8uPBFg6XHzgwZfXVP_FbMz=w@mail.gmail.com>
	<92365222-576D-43F6-8BC0-3F7D4A663D05@mit.edu>
	<CAOQ4uxgUFqYeCWiuHn+jXSS0bD=8u1aM5ujcd9BRdpMJtHeFdQ@mail.gmail.com>
	<CAFZ0FUXK89LLOmRGuXWW1UAZo0ydTi_O=383E+nsCywQgYh6eQ@mail.gmail.com>
	<20120123032143.GA16363@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Robin Dong <hao.bigrat@gmail.com>, Tao Ma <taoma.tm@gmail.com>,
	coly <colyli@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52375 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab2AWUIv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 15:08:51 -0500
Received: by lahc1 with SMTP id c1so1865188lah.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 Jan 2012 12:08:49 -0800 (PST)
In-Reply-To: <20120123032143.GA16363@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 23, 2012 at 5:21 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Jan 22, 2012 at 11:31:31AM +0800, Robin Dong wrote:
>> > At the end of the day, thinp target is a very powerful tool, but
>> > is does not fit all use cases. In particular, it fragments the
>> > on-disk layout of ext4 metadata and benchmark results for how this
>> > affect performance were never published.
>
> Amir,
>
> Well, to be fair, your approach to snapshotting also causes
> fragmentation. =A0If a file or a directory in the base image gets
> modified while there is a read-only snapshot, the inode in the base
> image gets fragmented as a result.

Yes, that's true, to some extent. directory inodes, however, do not
get fragmented. all journaled metadata is copied a side on JBD hooks.
My claim was about fragmentation of ext4 metadata, but fragmentation
of data is also a problem in both approaches.

>
> It is true that thin provisioning in general tends to defeat the bloc=
k
> placement algorithms used by a file system, but it will be possible t=
o
> create snapshots of non-thinp volumes, which will address this issue.
> Hopefully in the next 3-6 months, these things will be implemented
> enough so that we can benchmark them and see for certain how well or
> poorly this approach will work out. =A0I'm sure there will be a certa=
in
> number of tradeoffs for both approaches.
>
> Regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
