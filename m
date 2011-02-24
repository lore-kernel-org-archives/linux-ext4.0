From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: fsck performance.
Date: Thu, 24 Feb 2011 11:33:34 +0200
Message-ID: <AANLkTi=VVRRTqmiYYwmru9yAVNTKOD6Xhu8Lookdcyvq@mail.gmail.com>
References: <20110222133652.GI21917@bitwizard.nl>
	<20110222135431.GK21917@bitwizard.nl>
	<386B23FA-CE6E-4D9C-9799-C121B2E8C3BB@dilger.ca>
	<20110222221304.GH2924@thunk.org>
	<20110223044427.GM21917@bitwizard.nl>
	<DC8EC4D5-BB64-4908-985B-C6D3EDA955E3@mit.edu>
	<20110223205309.GA16661@bitwizard.nl>
	<F03E2EAC-9D44-4D8E-93AC-902FDFC22B92@dilger.ca>
	<20110224072945.GE16661@bitwizard.nl>
	<AANLkTinv-JPaiPzKC4xSqh0shmzjf4rKeQShRwiOznoz@mail.gmail.com>
	<20110224090232.GG16661@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55697 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1BXJdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 04:33:35 -0500
Received: by qyk7 with SMTP id 7so4713006qyk.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 01:33:35 -0800 (PST)
In-Reply-To: <20110224090232.GG16661@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 24, 2011 at 11:02 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl>=
 wrote:
> On Thu, Feb 24, 2011 at 10:59:23AM +0200, Amir Goldstein wrote:
>
>> That tool is e2image -r, which creates a sparse file image of your
>> fs (only metadata is written, the rest is holes), so you need to be
>> careful when copying/transferring it to another machine to do it
>> wisely (i.e. bzip or dd directly to a new HDD) Not sure what you
>> will do if fsck fixes errors on that image... =A0Mostly (if it didn'=
t
>> clone multiply claimed blocks for example), you would be able to
>> write the fixed image back onto your original fs, but that would be
>> risky.
>
> I can then run the fsck tests on the image. I expect fsck to find
> errors: I'm using the filesystem when I'm making that image.... It
> won't be consistent.
>

So you probably won't learn a lot from fsck results, unless you only
want to provide memusage/runtime statistic as per Andreas request.

You have the option to use NEXT3 so take a snapshot of your fs,
while it is online, but I don't suppose you would want to experiment
on your backup server.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
