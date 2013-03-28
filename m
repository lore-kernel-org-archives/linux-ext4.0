From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: [qrxd43@motorola.com: [PATCH V2] ext4: speed-up releasing blocks
 on commit]
Date: Thu, 28 Mar 2013 23:30:22 +0400
Message-ID: <CAA0+VHzvr+0VH4d-t2q3LkZwEWP4NEoE8hqQ2U6iK3np9rcoJA@mail.gmail.com>
References: <20130203031122.GC1359@thunk.org>
	<88575CD0-1CF4-4C12-83ED-845C87FFFDA4@dilger.ca>
	<94F448E5-429B-4740-BF87-CE82F477DE93@gmail.com>
	<CAA0+VHyOqK-yQqWZPjkwfTDzfFj_Bvy=cAtUdZXx1vOS6B7OcA@mail.gmail.com>
	<20130327145720.GB14900@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Alex Tomas <bzzz.tomas@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:45133 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3C1TaZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Mar 2013 15:30:25 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2SJXMfR019082
	for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 15:33:22 -0400 (EDT)
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com [209.85.223.180])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id r2SJXMDr019063
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 15:33:22 -0400 (EDT)
Received: by mail-ie0-f180.google.com with SMTP id a11so12030763iee.11
        for <linux-ext4@vger.kernel.org>; Thu, 28 Mar 2013 12:30:23 -0700 (PDT)
In-Reply-To: <20130327145720.GB14900@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I've just posted version rebased to yesterday's ext4 dev.
Regards,
Andrey.


On Wed, Mar 27, 2013 at 6:57 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Mar 13, 2013 at 02:38:55PM +0400, Andrey Sidorov wrote:
>>
>> Thanks for review! I'll post rebased patch with comments and some
>> ascii art this weekend.
>
> Hi Andrey, have you had a chance to post a rebased patch for your
> proposed change?  If not, it would be great if you could look at doing
> this against either 3.9-rc4 or the ext4 dev branch, since we're not
> actively looking at patches for the next merge window.
>
> Thanks!!
>
>                                         - Ted
