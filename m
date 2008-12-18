From: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 1/1] Allow ext4 to run without a journal.
Date: Thu, 18 Dec 2008 10:13:13 -0800
Message-ID: <532480950812181013m76fef953s3b3fb517d708b383@mail.gmail.com>
References: <1228953270.14314.15.camel@bobble.smo.corp.google.com>
	 <20081218180004.GB6797@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Frank Mayhar <fmayhar@google.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:33324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYLRSNS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Dec 2008 13:13:18 -0500
Received: from zps75.corp.google.com (zps75.corp.google.com [172.25.146.75])
	by smtp-out.google.com with ESMTP id mBIIDHLB015059
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:13:17 -0800
Received: from el-out-1112.google.com (elfj27.prod.google.com [10.126.186.27])
	by zps75.corp.google.com with ESMTP id mBIIDEsE000343
	for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:13:14 -0800
Received: by el-out-1112.google.com with SMTP id j27so129203elf.15
        for <linux-ext4@vger.kernel.org>; Thu, 18 Dec 2008 10:13:13 -0800 (PST)
In-Reply-To: <20081218180004.GB6797@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 18, 2008 at 10:00 AM, Jan Kara <jack@suse.cz> wrote:
>  Interesting although I'm not that surprised because those tests seem
> to do a lot of data changes (which are never journaled in fact) and tiny
> amount of metadata changes. If you run some benchmark doing lots of
> directory operations, I guess the numbers would be considerably
> different.

Actually we have some compile bench numbers (coming to this list soon)
that also surprised us.
The stages of compile bench that I believe are dominated by directory
operations are also
showing improvements without the journal.

> Maybe trying dbench (I know it's kind of stupid ;) or
> postmark will show the differences better.

I admit also we see huge variance using dbench on subsequent runs. To
the point where I don't know how much I trust it's numbers.
Is this a tool that people on this list have a lot of faith in?

mrubin
