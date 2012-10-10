From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: A warning from 3.6+ with bigalloc and delalloc when running xfstest
Date: Wed, 10 Oct 2012 13:02:52 -0400
Message-ID: <CAA0+VHwL0u0h6sn=Z0FyHsqYi2ji=sUaQ9ZPJCQ9kEMOpQHarg@mail.gmail.com>
References: <CANWLp03Kcp75CZPr6DubSExH9GhLUqaLf=xHvLiivprs=z2BvQ@mail.gmail.com>
	<20121009054820.GA8028@thunk.org>
	<20121009062931.GA29314@gmail.com>
	<20121009135152.GA29156@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:46525 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2JJRCz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2012 13:02:55 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.176.130.20])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q9AGrYYu023947
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 12:53:34 -0400 (EDT)
Received: from mail-vc0-f174.google.com (mail-vc0-f174.google.com [209.85.220.174])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id q9AGrX0h023935
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 12:53:34 -0400 (EDT)
Received: by mail-vc0-f174.google.com with SMTP id fo13so1025695vcb.19
        for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2012 10:02:52 -0700 (PDT)
In-Reply-To: <20121009135152.GA29156@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 9, 2012 at 9:51 AM, Theodore Ts'o <tytso@mit.edu> wrote:

> It is indeed, something we need to fix, and it's part of the problem
> where where the delayed allocation for bigalloc is completely screwed
> up.  Part of the problem is when we write into a cluster which has not
> yet been mapped in the extent tree, but which might (or might not)
> have had other blocks in the cluster that have already been subject to
> delayed allocation, we don't know whether to reserve clusters for the
> purposes of doing the the delayed allocation accounting.  Fixing this
> w/o the extent status tree means having to search the page cache and
> for other pages in the cluster, which is not only painful, but tricky
> from the perspective of lock ordering.
>
> Unfortunately, I didn't notice this problem originally because I
> hadn't been doing regular xfstests runs with bigalloc, and most of my
> testing had been with direct I/O, where these issues didn't come up.
>
>                                 - Ted

Hi Ted,

Does it mean I'd better turn off delalloc if I use bigalloc with linux 3.5.3?

Regards,
Andrey.
