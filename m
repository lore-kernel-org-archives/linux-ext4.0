From: Richard Weinberger <richard@nod.at>
Subject: Question on ext4 directory hashes in combination with file name
 encryption
Date: Fri, 30 Sep 2016 16:09:09 +0200
Message-ID: <9a5198b3-0c00-a558-5132-9c38b4bb8795@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932237AbcI3OJN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Sep 2016 10:09:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

if I read the ext4 code correctly, you pass encrypted filenames to ext4fs_dirhash().
These filenames are not encoded and therefore binary gibberish.
Isn't this a problem for the ext4 hash functions? My fear is that these hashes are optimized
for ASCII strings and produce more collisions when binary data is used as input.

Thanks,
//richard
