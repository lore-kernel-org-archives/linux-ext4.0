From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v3] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Tue, 10 May 2011 12:45:51 -0700
Message-ID: <BANLkTimDiBTaCY7Lek1rM+7xTZucAX8jiQ@mail.gmail.com>
References: <1303762999-20541-1-git-send-email-curtw@google.com>
	<alpine.LSU.2.00.1105101037440.1243@sister.anvils>
	<20110510191747.GB6933@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Jim Meyering <jim@meyering.net>,
	Mingming Cao <cmm@us.ibm.com>,
	Curt Wohlgemuth <curtw@google.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48559 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1EJTqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 May 2011 15:46:20 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p4AJjwOd015307
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 12:46:03 -0700
Received: from gyg13 (gyg13.prod.google.com [10.243.50.141])
	by wpaz33.hot.corp.google.com with ESMTP id p4AJhvqH011345
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 12:45:57 -0700
Received: by gyg13 with SMTP id 13so2828365gyg.13
        for <linux-ext4@vger.kernel.org>; Tue, 10 May 2011 12:45:52 -0700 (PDT)
In-Reply-To: <20110510191747.GB6933@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 10, 2011 at 12:17 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, May 10, 2011 at 10:41:56AM -0700, Hugh Dickins wrote:
>>
>> I'm concerned that we've reached -rc7, with Linus planning on 2.6.39
>> release next week, but Curt's fix above to the mblk_io corruption bu=
g
>> seems to have fallen through the cracks.
>
> It's in the ext4 master branch so it's queued to be pushed during the
> next merge window, and then it would go into the 2.6.39.x stable
> series. =C2=A0So it didn't fall through the cracks; it was just a que=
stion
> of whether to push late in the rc series, or waiting until the merge
> window and then backporting to 2.6.39 stable. =C2=A0Basically I got t=
he
> patch in -rc5, and at that point, given that the vast majority of the
> file systems are 4k blocksize on x86, and most Power and Itanic users
> are using distribution kernels (and that's a very small number
> anyway), I decided not to push it to Linus at that point.
>
> It's a judgement call; and I could have gone the other way; it was
> very much a 49/51 sort of decision.

Hmm.  Well, thanks for the reply.  I do disagree with your decision,
and am surprised that you're still seeing it in the past tense.  This
is a corruption and a regression: prime material for a fix even at
this stage.

Admittedly, in my case the data was written correctly and only
temporarily presented incorrectly; but in other tests that could then
have got written back incorrectly.  And admittedly, not many people
outside of the large-page-size world are using blocksize less than
pagesize.  But even so....

Moral: cc Rafael's regression list next time?

Hugh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
