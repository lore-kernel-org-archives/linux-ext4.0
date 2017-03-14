From: Nick Alcock <nick.alcock@oracle.com>
Subject: Re: v4.7--v4.10+: ext4: repeatable inline-data oops (and fs corruption) caused by msync() of shared writable mmap (with recipe)
Date: Tue, 14 Mar 2017 15:18:26 +0000
Message-ID: <87a88nga4d.fsf@esperi.org.uk>
References: <874lzdcj9r.fsf@esperi.org.uk> <20170313005232.GA593@zzz>
        <87tw6wg4bc.fsf@esperi.org.uk>
        <20170313233701.GA5271@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20967 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbdCNPSd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Mar 2017 11:18:33 -0400
In-Reply-To: <20170313233701.GA5271@birch.djwong.org> (Darrick J. Wong's
        message of "Mon, 13 Mar 2017 16:37:01 -0700")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 13 Mar 2017, Darrick J. Wong told this:

> I wouldn't turn on inline_data for files, period.  It's not as well tested
> as it ought to be (clearly). :/

Bah, if I don't, how will it get tested? :) this machine is newly
commissioned and doesn't have much load or important content yet: it's
just the time to try experimental and potentially dangerous things :)

(I didn't know you could turn it on in any sense other than a 'big
hammer' for everything. I have a great many symlinks, and it's really
that I'm interested in reducing seeks for...)

-- 
NULL && (void)
