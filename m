From: Amir Goldstein <amir73il@gmail.com>
Subject: orphan cleanup on readonly fs will corrupt future fs!
Date: Sat, 26 Feb 2011 20:21:47 +0200
Message-ID: <AANLkTi=_QBgDutcb7h2XHpjHR6k-4Rj-r6zryMXaNn6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41195 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1BZSVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Feb 2011 13:21:48 -0500
Received: by qwd7 with SMTP id 7so1960970qwd.19
        for <linux-ext4@vger.kernel.org>; Sat, 26 Feb 2011 10:21:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi guys,

I have just realized something very disturbing -
that orphan cleanup is not being skipped on readonly mount of ext4/ext3.

I know that journal recovery is done on readonly mount
and there is problem with that, since nothing happens
in the fs level.

But orphan cleanup deletes inodes and frees blocks and that
could be very bad for some RO_COMPAT features, SNAPSHOT
and BIGALLOC to name two.

I am not so sure why orphan cleanup is so important for readonly
mount in the first place?

Now the damage has been done, because current stock kernels will
corrupt future fs with SNAPSHOT and BIGALLOC features
(unless Ted backs up from the decision to make BIGALLOC RO_COMPAT...)

I think that we should skip orphan cleanup on readonly mount ASAP and try
to push this fix to as many stable/maint kernels out there, before the
problem gets worse.

Can anyway see a problem with skipping orphan cleanup?
Maybe there is a problem with later remount read-write?

I would spend time more time to investigate these questions,
but I find this problem too disturbing and urgent to wait until I find
the time to do so...

Amir.
