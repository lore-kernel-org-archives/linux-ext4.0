From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: Ext4 test failures -- COLLAPSE_RANGE and ZERO_RANGE
Date: Fri, 4 Apr 2014 23:46:21 +0900
Message-ID: <CAKYAXd-iCCYTqvKNSytpM0z_3=KnV+=LwQKS6e=kBf5T2wQ-0A@mail.gmail.com>
References: <20140403184703.GA2246@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35090 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaDDOqV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Apr 2014 10:46:21 -0400
Received: by mail-qg0-f53.google.com with SMTP id z60so2182752qgd.12
        for <linux-ext4@vger.kernel.org>; Fri, 04 Apr 2014 07:46:21 -0700 (PDT)
In-Reply-To: <20140403184703.GA2246@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-04-04 3:47 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> Hi Lukas, Namjae,
>
> During final testing, I found two problems.  One is that the mount
> option dioread_nolock is causing a test failure for ext4/001, which is
> a ZERO_RANGE test.
>
> The other is that the mount option data=journal is cuasing a test
> failure for shared/002 and shared/004, which are COLLAPSE_RANGE bugs.
>
> Since these aren't regressions, and I don't think these new fallocate
> modes will probably be widely used at least initially, I don't think
> it's worth it to drop these two patches, especialy since we've done
> all of our testing for this merge window with the tests present.
> However, I'd really appreicate it if you take a look at them.
Hi Ted.
Sorry about this bug.
I will look into collapse range issue with data=journal.
And I'll also check more carefully insert range patch with the way you guided.

Thanks!
>
