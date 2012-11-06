From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Fwd: What should be the optimum value of G (number-of-groups) when
 using flex_bg?
Date: Tue, 6 Nov 2012 10:06:19 +0530
Message-ID: <CAOiN93nGvYNZUiNRq23ThDU+sYmooAgjjTfYode3vdXna2E7fg@mail.gmail.com>
References: <CAOiN93nrrFHZpcBHih-ySa8FNMdOp4gTgzjVPXWKPYSABgHMMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38120 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2KFEgU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2012 23:36:20 -0500
Received: by mail-vc0-f174.google.com with SMTP id fk26so25846vcb.19
        for <linux-ext4@vger.kernel.org>; Mon, 05 Nov 2012 20:36:19 -0800 (PST)
In-Reply-To: <CAOiN93nrrFHZpcBHih-ySa8FNMdOp4gTgzjVPXWKPYSABgHMMw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have a 2TB HDD which we formated using default options of mkfs.ext4(v1.42.6).
I took around ~15 seconds to complete this operation.

Than we formatted the same partition with "-G 1024" and there was
around 30% performance improvement in
the mkfs.ext4 timings.

Than, out of curiosity, we increased the G's value to 1048576 and
there was a drastic degradation in the performance of mkfs.ext4.
It took more than 5 minutes to complete the execution.

Is it the expected behavior?

AFAIK flex_bg is on by default with G's vaule as 16. Can we consider
this the optimum value?

Any suggesstions on what  we can set the Gs value for a 2TB HDD such
that both the FS and the
mkfs.ext4 gives optimum performance?
It would be really helpful if somebody can shed some light over this feature.

Thanks,
Ashish
