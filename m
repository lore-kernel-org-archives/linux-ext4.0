From: Zhang Huan <zhhuan@gmail.com>
Subject: Question on readdir implementation
Date: Tue, 15 Sep 2009 17:57:24 +0800
Message-ID: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:14270 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZIOJ5a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Sep 2009 05:57:30 -0400
Received: by an-out-0708.google.com with SMTP id d40so9804565and.1
        for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2009 02:57:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I'm reading EXT4 codes and has some questions about readdir
implementation.

Why traverse the directory in hash order? This brings lots of code to
build and traverse a red-black tree. Why not just plainly traverse the
directory's blocks?

Since the red-black tree is built every time a NFS readdir request comes
in, in case of hash collision, the nfs client may receive duplicate dir
entries if the buffer is not large enough to return all entries with the
same hash value in once.

Thanks.

-- 
Zhang Huan
