From: Michael Rubin <mrubin@google.com>
Subject: Re: RFC PATCH: ext4 no journal corruption with locale-gen
Date: Wed, 1 Jul 2009 11:44:40 -0700
Message-ID: <532480950907011144m105a9f5cm51ef7f902c665cbc@mail.gmail.com>
References: <6601abe90906171148w1431258fvd0afa105cda9b77b@mail.gmail.com>
	 <20090617234604.GF7867@mit.edu>
	 <6601abe90906220942se70fb70w5481e178f1525dd8@mail.gmail.com>
	 <20090622211327.GI13398@webber.adilger.int>
	 <20090701183509.GB31235@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Curt Wohlgemuth <curtw@google.com>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:32930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZGASom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jul 2009 14:44:42 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n61IiiZv002385
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 19:44:44 +0100
Received: from wf-out-1314.google.com (wfc25.prod.google.com [10.142.3.25])
	by spaceape10.eur.corp.google.com with ESMTP id n61Ihtlq017691
	for <linux-ext4@vger.kernel.org>; Wed, 1 Jul 2009 11:44:41 -0700
Received: by wf-out-1314.google.com with SMTP id 25so419341wfc.5
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2009 11:44:41 -0700 (PDT)
In-Reply-To: <20090701183509.GB31235@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 1, 2009 at 11:35 AM, Aneesh Kumar
K.V<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Mon, Jun 22, 2009 at 11:13:27PM +0200, Andreas Dilger wrote:
>> On Jun 22, 2009 =A009:42 -0700, Curt Wohlgemuth wrote:
> I think this is better. I would suggest data=3Dnojournal. That way we=
 can
> check the mount options to figure out whether we are running with
> journal or not. Also i guess this enables us to run without using a
> journal even if =A0mke2fs created a journal for us
>

As a heavy consumer of the non-journal mode I really like this idea.
It will make many things easier and clear for us.

mrubin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
