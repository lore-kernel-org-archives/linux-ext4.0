From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH] xfstests: Check concurrently of readdir and read on the
 same directory fd
Date: Fri, 5 Apr 2013 12:32:43 -0500
Message-ID: <515F0ABB.804@sgi.com>
References: <515BC786.3070102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <david@fromorbit.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:33438 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1162173Ab3DERcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 13:32:21 -0400
In-Reply-To: <515BC786.3070102@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zhao,

Thanks for submitting this test, it has been committed.

--Rich
commit bbaf78c01bc98b2afc3bb3d31eac38fc5d4b3b19
Author: Zhao Hongjiang <zhaohongjiang@huawei.com>
Date:   Wed Apr 3 06:09:10 2013 +0000

     xfstests generic 310: check concurrently of readdir and read on the 
same directory fd

     Check if there are two threads,one keeps calling read() or lseek(), and
     the other calling readdir(), both on the same directory fd.

     Based on a testcase from Li Zefan <lizefan@huawei.com>.
     http://marc.info/?l=linux-kernel&m=136123703211869&w=2

     Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
     Reviewed-by: Rich Johnston <rjohnston@sgi.com>
     [rjohnston@sgi.com minor white space fixes and test renumbering]
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>


