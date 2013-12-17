From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: set umask to avoid spurious generic/314 test
 failures
Date: Tue, 17 Dec 2013 10:39:55 -0600
Message-ID: <52B07E5B.4090302@sgi.com>
References: <20130921211735.GC7855@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Eric Whitney <enwlinux@gmail.com>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:43188 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753468Ab3LQQkA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Dec 2013 11:40:00 -0500
In-Reply-To: <20130921211735.GC7855@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch has been committed.

Thanks
--Rich

commit d0b5b6f9a8ccdb1279f319866e4540e8a05ac7c4
Author: Eric Whitney <enwlinux@gmail.com>
Date:   Sat Sep 21 21:17:35 2013 +0000

     xfstests: set umask to avoid spurious generic/314 test failures
