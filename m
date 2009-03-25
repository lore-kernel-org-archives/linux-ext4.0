From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090310: ext4 hangs
Date: Wed, 25 Mar 2009 18:18:43 +0300
Message-ID: <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
References: <a4423d670903100517y42f342d4pd73c4c36f5c64dd7@mail.gmail.com>
	 <20090310124658.GE8840@mit.edu>
	 <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com>
	 <20090310154745.GF23075@mit.edu>
	 <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com>
	 <20090325151122.GA14881@atrey.karlin.mff.cuni.cz>
	 <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:43811 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbZCYPSq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 11:18:46 -0400
In-Reply-To: <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2009/3/25 Jan Kara <jack@suse.cz>:
>> > So, I think I need to try it on 2.6.29-rc7 again.
>> =C2=A0 I've looked into this. Obviously, what's happenning is that w=
e delete
>> an inode and jbd2_journal_release_jbd_inode() finds inode is just un=
der
>> writeout in transaction commit and thus it waits. But it gets never =
woken
>> up and because it has a handle from the transaction, every one event=
ually
>> blocks on waiting for a transaction to finish.
>> =C2=A0 But I don't really see how that can happen. The code is reall=
y
>> straightforward and everything happens under j_list_lock... Strange.
> =C2=A0BTW: Is the system SMP?
No, it is UP system.

The bug exists even in 2.6.29, I posted it with a new topic.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
