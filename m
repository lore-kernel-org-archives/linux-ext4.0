From: =?GB2312?B?tqG2qLuq?= <dingdinghua85@gmail.com>
Subject: Re: [PATCH 1/2] Jbd: fix an assertion, jh->b_transaction should be
Date: Thu, 25 Feb 2010 09:11:12 +0800
Message-ID: <7bb361261002241711g7174c9aiaf6b5852e6b21ffa@mail.gmail.com>
References: <1264391104-10950-1-git-send-email-dingdinghua@nrchpc.ac.cn>
	 <1264391104-10950-2-git-send-email-dingdinghua@nrchpc.ac.cn>
	 <20100224171215.GH5166@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:54692 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640Ab0BYBLN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2010 20:11:13 -0500
Received: by qw-out-2122.google.com with SMTP id 8so1051156qwh.37
        for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2010 17:11:12 -0800 (PST)
In-Reply-To: <20100224171215.GH5166@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks a lot. I forgot the comment and the sign-off issue.

2010/2/25  <tytso@mit.edu>:
> On Mon, Jan 25, 2010 at 11:45:03AM +0800, dingdinghua wrote:
>> ---
>>  fs/jbd/commit.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>
> I've changed the commit message to read:
>
> jbd2: clean up an assertion in jbd2_journal_commit_transaction()
>
> commit_transaction has the same value as journal->j_running_transacti=
on,
> so we can simplify the assert statement.
>
> This is a pretty simple patch, but I wanted to give you credit, so I
> assumed that you had meant to add a Signed-off-by: line but just
> forgot.  Please let me know if this was not your intention!
>
>                                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--=20
=B6=A1=B6=A8=BB=AA
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
