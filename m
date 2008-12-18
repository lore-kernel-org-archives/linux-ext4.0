From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 18 Dec 2008 10:29:21 -0800
Message-ID: <6601abe90812181029r626e6ed4n4c8500e42f88a101@mail.gmail.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
	 <20081218180004.GB6797@atrey.karlin.mff.cuni.cz>
	 <532480950812181013m76fef953s3b3fb517d708b383@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:37290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYLRS3Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:29:24 -0500
Received: from spaceape24.eur.corp.google.com (spaceape24.eur.corp.google.com [172.28.16.76])
	by smtp-out.google.com with ESMTP id mBIITMgM001348
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:23 -0800
Received: from bwz13 (bwz13.prod.google.com [10.188.26.13])
	by spaceape24.eur.corp.google.com with ESMTP id mBIISVJE017763
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:21 -0800
Received: by bwz13 with SMTP id 13so1726466bwz.21
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:29:21 -0800 (PST)
In-Reply-To: <532480950812181013m76fef953s3b3fb517d708b383@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I should be able to post some numbers we're seeing for compilebench on
various filesystems next week, including ext4 without a journal
(Frank's patch).

Curt

On Thu, Dec 18, 2008 at 10:13 AM, Michael Rubin <mrubin@google.com> wrote:
> On Thu, Dec 18, 2008 at 10:00 AM, Jan Kara <jack@suse.cz> wrote:
>>  Interesting although I'm not that surprised because those tests seem
>> to do a lot of data changes (which are never journaled in fact) and tiny
>> amount of metadata changes. If you run some benchmark doing lots of
>> directory operations, I guess the numbers would be considerably
>> different.
>
> Actually we have some compile bench numbers (coming to this list soon)
> that also surprised us.
> The stages of compile bench that I believe are dominated by directory
> operations are also
> showing improvements without the journal.
>
>> Maybe trying dbench (I know it's kind of stupid ;) or
>> postmark will show the differences better.
>
> I admit also we see huge variance using dbench on subsequent runs. To
> the point where I don't know how much I trust it's numbers.
> Is this a tool that people on this list have a lot of faith in?
>
> mrubin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
