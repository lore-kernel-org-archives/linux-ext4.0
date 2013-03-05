From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH v2] xfstests: use right defrag program path
Date: Tue, 5 Mar 2013 09:55:40 -0600
Message-ID: <5136157C.5080404@sgi.com>
References: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com> <5130CDC1.8060704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>, <xfs@oss.sgi.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:36715 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab3CEP6J (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Mar 2013 10:58:09 -0500
In-Reply-To: <5130CDC1.8060704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch has been committed.

commit 08557e219c12e573be459407033495899f46967a
Author: Zheng Liu <wenqing.lz@taobao.com>
Date:   Fri Mar 1 14:17:13 2013 +0000

     xfstests: use right defrag program path

     In _require_defrag defragmentation command path is fixed.  That will
     cause that this test case is skipped in some distributions.

     Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


