From: jon ernst <jonernst07@gmail.com>
Subject: xfstest-bld generic/018 fails due to e4defrag issue
Date: Wed, 9 Apr 2014 01:37:04 -0400
Message-ID: <CAGW2f1F1sL+if9zejgB92j0YDRjswvB3LG_dBR+pK3Yj4aQfHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:61463 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbaDIFhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2014 01:37:05 -0400
Received: by mail-qa0-f48.google.com with SMTP id s7so1458938qap.21
        for <linux-ext4@vger.kernel.org>; Tue, 08 Apr 2014 22:37:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
running latest xfstest-bld with latest ext4 kernel "dev"
branch(ad6599ab3a).I always get generic/018 failed.
Then I took closer look and found out this issue.

After run this:

fragfile="/vdf/testfile"
for I in `seq 9 -1 0`; do
    dd if=/dev/zero of=$fragfile bs=4k count=1 conv=notrunc seek=$I oflag=sync
done


Even though the file does exist. e4defrag complains about:

(this output comes from kvm guest machine)
> e4defrag -v /vdf/testfile
Can't get super block info: Success
"/vdf/testfile"

Is this a known issue or something I did wrong.

Thank you!

Jon
