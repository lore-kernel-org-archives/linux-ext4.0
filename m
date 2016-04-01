From: Eric Biggers <ebiggers3@gmail.com>
Subject: Legal characters in encrypted fscrypto (f2fs/ext4) filename?
Date: Fri, 1 Apr 2016 01:00:18 -0500
Message-ID: <20160401060018.GD1323@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
	jaegeuk@kernel.org, tytso@mit.edu, mhalcrow@google.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

While reviewing the new filesystem encryption code, I was confused by the
intended set of legal characters in the printable form of an encrypted filename.

According to the actual code in fs/crypto/fname.c, the legal characters are:

	a-zA-Z0-9+,

Alternatively, according to the comment in the same file, the legal characters
are actually:

	a-zA-Z0-9+_

Still alternatively, according to the design document[1], the legal characters
are actually:

	a-zA-Z0-9+=

Which one is correct?

[1] https://docs.google.com/document/d/1ft26lUQyuSpiu6VleP70_npaWdRfXFoNnB8JYnykNTg/preview?pref=2&pli=1#
