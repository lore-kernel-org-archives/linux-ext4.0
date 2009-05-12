From: Alexander Shishkin <alexander.shishckin@gmail.com>
Subject: Re: [Q] ext3 mkfs: zeroing journal blocks
Date: Tue, 12 May 2009 14:55:10 +0300
Message-ID: <71a0d6ff0905120455x291d7280ybe8d1a562987fd1b@mail.gmail.com>
References: <71a0d6ff0905110803t1a6b34ccq91d5494f95fe1f34@mail.gmail.com>
	 <4A086763.9090907@redhat.com>
	 <20090511182050.GA3209@webber.adilger.int>
	 <4A087202.4010601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40375 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZELLzL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 07:55:11 -0400
Received: by fxm2 with SMTP id 2so3271464fxm.37
        for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 04:55:11 -0700 (PDT)
In-Reply-To: <4A087202.4010601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11 May 2009 21:44, Eric Sandeen <sandeen@redhat.com> wrote:
> Andreas Dilger wrote:
>
>> The reason that the journal is zeroed is because there is some chance
>> that old (valid at the time) transaction headers and commit blocks might
>> be in the journal and could accidentally be "recovered" and cause bad
>> corruption of the filesystem.
>
> But I guess the question is, why isn't a normal internal log zeroed?
>
> If I'm reading it right only external logs get this treatment, and I
> think that's what generated the original question from Alexander.

My concern was basically if it is safe to skip zeroing for internal journal.

Regards,
--
Alex
