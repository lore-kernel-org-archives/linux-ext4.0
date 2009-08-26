From: Michael Rubin <mrubin@google.com>
Subject: Re: Problem with ext4_sync_file in no-journal mode.
Date: Wed, 26 Aug 2009 15:30:53 -0700
Message-ID: <532480950908261530p2113b0cct22abf1f5ee0c0f2a@mail.gmail.com>
References: <1251222245.20219.25.camel@bobble.smo.corp.google.com>
	<20090826162737.GB28867@atrey.karlin.mff.cuni.cz> <1251304886.23722.6.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: fmayhar@google.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:52819 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZHZWbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 18:31:15 -0400
Received: from zps36.corp.google.com (zps36.corp.google.com [172.25.146.36])
	by smtp-out.google.com with ESMTP id n7QMVGjW008132
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:31:16 -0700
Received: from vws38 (vws38.prod.google.com [10.241.21.166])
	by zps36.corp.google.com with ESMTP id n7QMUTGj022966
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:31:13 -0700
Received: by vws38 with SMTP id 38so433230vws.16
        for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 15:31:13 -0700 (PDT)
In-Reply-To: <1251304886.23722.6.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 9:41 AM, Frank Mayhar<fmayhar@google.com> wrote=
:
> That's what you would think, isn't it? =A0However, you (and we) would=
 be
> wrong. =A0In our testing, ext4+fsync was significantly worse than ext=
4
> without fsync. =A0Like, six times worse. =A0Yes, this is a nonintuiti=
ve
> result and no, I can't yet explain it.

=46rank is referring to (ext4 with no_journal)+fsync compared to ext4
with no journal and no fsync.

With the journal everything is working as reliably as expected.

We will be publishing data for all the permutations of crashes and
power cycles we have tested as soon as we are confident in all the
data.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
