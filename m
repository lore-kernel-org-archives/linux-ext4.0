From: Andrey Sidorov <qrxd43@motorola.com>
Subject: Re: [PATCH RFC 1/2] ext4: speed-up truncate/unlink
Date: Tue, 18 Sep 2012 14:17:09 -0400
Message-ID: <CAA0+VHxM6s7dmmeEf6CsF+5YxaUhv1zgQ3Q-ZNbwADFu8UeftQ@mail.gmail.com>
References: <CAA0+VHzw55=4X43GK9RkRK_q4qmzR8KyqrrFidQMCPb6r4nPeA@mail.gmail.com>
	<20120918041006.GC32195@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:60804 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2IRSRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Sep 2012 14:17:12 -0400
Received: from DE01MGRG01.AM.MOT-MOBILITY.COM ([10.176.130.20])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8IIJQJN025265
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 14:19:26 -0400 (EDT)
Received: from mail-vb0-f46.google.com (mail-vb0-f46.google.com [209.85.212.46])
	by DE01MGRG01.AM.MOT-MOBILITY.COM (8.14.3/8.14.3) with ESMTP id q8IIJ5SG025066
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 14:19:26 -0400 (EDT)
Received: by mail-vb0-f46.google.com with SMTP id ff1so189371vbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 11:17:09 -0700 (PDT)
In-Reply-To: <20120918041006.GC32195@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 12:10 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The one thing which is missing from your patch is a Signed-off-by:
> footer.  This has a specific legal meaning.  See:
>
>         http://elinux.org/Developer_Certificate_Of_Origin
>
> You don't need to resend this patch, though; just reply with an
> acknowledgement that you agree to add your DCO to the patch:
>
> Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>
>
>
> Thanks for contributing to the ext4 file system!
>
>                                                 - Ted

Hi Ted,

Yes, please add
Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>

Thanks!
