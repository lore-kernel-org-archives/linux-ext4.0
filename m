From: Subranshu Patel <spatel.ml@gmail.com>
Subject: fsck memory usage
Date: Wed, 17 Apr 2013 20:40:08 +0530
Message-ID: <CAEUQceh3Wm6LZpGQnXNjh0c9WbO8S70D5-KYjY8anup80WbLHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60495 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966605Ab3DQPKJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Apr 2013 11:10:09 -0400
Received: by mail-qa0-f53.google.com with SMTP id p6so927444qad.12
        for <linux-ext4@vger.kernel.org>; Wed, 17 Apr 2013 08:10:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I performed some recovery (fsck) tests with large EXT4 filesystem. The
filesystem size was 500GB (3 million files, 5000 directories).
Perfomed force recovery on the clean filesystem and measured the
memory usage, which was around 2 GB.

Then I performed metadata corruption - 10% of the files, 10% of the
directories and some superblock attributes using debugfs. Then I
executed fsck to find a memory usage of around 8GB, a much larger
value.

1. Is there a way to reduce the memory usage (apart from scratch_files
option as it increases the recovery time time)

2. This question is not related to this EXT4 mailing list. But in real
scenario how this kind of situation (large memory usage) is handled in
large scale filesystem deployment when actual filesystem corruption
occurs (may be due to some fault in hardware/controller)
