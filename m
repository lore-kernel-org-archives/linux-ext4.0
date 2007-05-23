From: coly <colyli@gmail.com>
Subject: [RFC 1/5] inode reservation v0.1
Date: Thu, 24 May 2007 02:03:24 +0800
Message-ID: <1179943404.4179.52.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel@vger.kernel.org
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:43929 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757348AbXEWSC6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 May 2007 14:02:58 -0400
Received: by mu-out-0910.google.com with SMTP id i10so202544mue
        for <linux-ext4@vger.kernel.org>; Wed, 23 May 2007 11:02:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch is only experimental, just have a try whether the
subdirectory inode reservation idea works. Now the answer is it works,
and I am working on an improved version for this patch.

The basic idea of subdirecctory inode reservation is to avoid
unnecessary redundant meta data writing and hard disk seeking. Detailed
idea can be found here:http://lkml.org/lkml/2007/3/26/180

This email has another 4 extra parts:
1) ext4 kernel patch
2) e2fsprogs patch
3) current benchmark
4) next step working

The reason to release this unstable patch is:
* I want others to know I am working on it.
* The result of benchmark indecates that this work maybe is valuable.
* Hope others can give me feedback at very basic phase of this patch.

I should thank Adreas Dilger, who firstly introduces this idea to me.
Also I should thank other friends in #linuxfs at irc.oftc.org, great
helps to me.

In the next several months, I will try best to write a usable patch :-)


Coly
