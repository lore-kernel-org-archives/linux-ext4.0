From: Fredrik Andersson <nablaman@gmail.com>
Subject: Re: Fwd: Ext4 bug with fallocate
Date: Thu, 22 Oct 2009 09:37:09 +0200
Message-ID: <a125a870910220037j1ceeb19du73c977b8ce3df2b7@mail.gmail.com>
References: <a125a870910180836i66781e1ey8113e7f8569f1fad@mail.gmail.com>
	 <a125a870910180847s5f3eaf6cxfe58e6ceb26419c6@mail.gmail.com>
	 <4ADB3AEC.8040901@redhat.com>
	 <a125a870910190249l39183927i8f042a9ace39904c@mail.gmail.com>
	 <a125a870910200949v5d9d0318q65b0ff6d5a1181e1@mail.gmail.com>
	 <1256084662.4316.4.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Mingming <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56623 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJVHhG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Oct 2009 03:37:06 -0400
Received: by ewy3 with SMTP id 3so260701ewy.17
        for <linux-ext4@vger.kernel.org>; Thu, 22 Oct 2009 00:37:09 -0700 (PDT)
In-Reply-To: <1256084662.4316.4.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The link you provided about is related to a race between restart a
> transaction from truncate, and the other process is doing something like
> block allocation to the same file. Do you have another threads
> allocating blocks while you are truncating?

No, there is only a single thread in this program. No other thread or
process is accessing the same file or file descriptor.

/Fredrik
