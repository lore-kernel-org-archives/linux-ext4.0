From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [PATCH 01/11 RESEND] libe2p: Add new function get_fragment_score()
Date: Sat, 18 Jun 2011 13:00:54 -0400
Message-ID: <BANLkTimZ1fhzgZiqe0Zamyt1yTV5LrHKFA@mail.gmail.com>
References: <4DF8522F.2020304@sx.jp.nec.com> <20110617031814.GA31884@thunk.org>
 <4DFB62C7.5070008@redhat.com> <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1FRRBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Jun 2011 13:01:25 -0400
Received: by bwz15 with SMTP id 15so1401479bwz.19
        for <linux-ext4@vger.kernel.org>; Sat, 18 Jun 2011 10:01:24 -0700 (PDT)
In-Reply-To: <E94A4A11-B1FB-4D95-87C5-F18190EF333B@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 18, 2011 at 3:19 AM, Andreas Dilger <aedilger@gmail.com> wr=
ote:
> I was thinking about this, and am wondering if it makes sense to have=
 an absolute score for fragmentation instead of a relative one?
>
> By absolute I mean something like fragments per MB or similar. A bad =
score might be anything > 1. For files smaller than 1 MB in size it wou=
ld scale the ratio to the equivalent if the file was 1MB in size (e.g. =
a 16kB file with 4 fragments would have a score of 256, which is clearl=
y bad). =A0Large files can have a score much less than 1, which is good=
=2E
>
> Cheers, Andreas

Shouldn't be based on fragments per max extent size for ext4?

And I think the max extent size for a 4KB page is 128 MB, right?

Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
