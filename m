From: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH v4 0/3] dioread_nolock patch
Date: Fri, 15 Jan 2010 13:47:26 -0800
Message-ID: <532480951001151347w2f1bf2b2j34bb88b58a766f9c@mail.gmail.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>
	<4B50C78D.2000807@redhat.com> <20100115201521.GE7256@thunk.org>
	<4B50CD5B.9050804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:55588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0AOVrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jan 2010 16:47:51 -0500
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com [172.28.16.75])
	by smtp-out.google.com with ESMTP id o0FLlntZ009068
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 21:47:49 GMT
Received: from qyk2 (qyk2.prod.google.com [10.241.83.130])
	by spaceape23.eur.corp.google.com with ESMTP id o0FLlmKo014379
	for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 13:47:48 -0800
Received: by qyk2 with SMTP id 2so683229qyk.6
        for <linux-ext4@vger.kernel.org>; Fri, 15 Jan 2010 13:47:48 -0800 (PST)
In-Reply-To: <4B50CD5B.9050804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 15, 2010 at 12:17 PM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> tytso@mit.edu wrote:
> At one point google was planning to devise a power-fail test
> harness. =A0Any news on that?

We completed the tests. But there is good news and bad news. The good
news is that we were able to shake out a lot of bugs in the no journal
case (which have already been submitted upstream). We now can fairly
quickly and easily drive a lot of traffic to a system and then cut the
power, issue a panic or other event.

The bad news is that I was hoping to use open source tools to drive
the traffic. The goal would be to allow everyone to reproduce the
experiment. We got a little short handed on resources and ended up
using Google closed source workloads instead. This was mostly since we
were in a rush and able to get the network traffic up in one day with
those tools.

I was holding back on publishing the results since I was hoping we
would be able to generate traffic in a more open manner. But if you
are interested in the results anyway then give me or some one on the
team a day or two to dig them up.

In any case we have powerfail testing as part of our validation and
once Jiayingz is satisfied with the patch we will be running those
tests.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
