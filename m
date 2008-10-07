From: "Peter Kukol" <pkukol@google.com>
Subject: Re: No-journal option for ext4
Date: Tue, 7 Oct 2008 07:59:17 -0700
Message-ID: <929ffc5e0810070759p39310eb4m53e239e83e951079@mail.gmail.com>
References: <929ffc5e0810061839l6d5977b4o96ea1699c8451446@mail.gmail.com>
	 <20081007054530.GI9337@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Michael Rubin" <mrubin@google.com>,
	"Frank Mayhar" <fmayhar@google.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:25510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYJGO71 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 10:59:27 -0400
Received: from spaceape12.eur.corp.google.com (spaceape12.eur.corp.google.com [172.28.16.146])
	by smtp-out.google.com with ESMTP id m97ExPfC020427
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 15:59:25 +0100
Received: from yx-out-2324.google.com (yxj3.prod.google.com [10.190.3.67])
	by spaceape12.eur.corp.google.com with ESMTP id m97EwuW6006266
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 07:59:24 -0700
Received: by yx-out-2324.google.com with SMTP id 3so545869yxj.85
        for <linux-ext4@vger.kernel.org>; Tue, 07 Oct 2008 07:59:17 -0700 (PDT)
In-Reply-To: <20081007054530.GI9337@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the great suggestions - they all make perfect sense. I did
see the "journal present" flag, BTW, but figured that it might be
safer not to change existing behavior - e.g. when someone accidentally
says ext4 instead of ext2 when mounting an ext2 volume, right now they
get an error. If folks are OK with this changing to a successful
mount, I'm happy - less code/work is good ;-).

I'll rework my patch and send out an update when it's ready.

Thanks again!

PeterK
