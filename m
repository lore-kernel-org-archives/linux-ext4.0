From: Xue jiufei <xuejiufei@huawei.com>
Subject: A question about function jbd2__journal_restart()
Date: Tue, 14 Apr 2015 11:00:09 +0800
Message-ID: <552C82B9.7060305@huawei.com>
Reply-To: <xuejiufei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <linux-ext4@vger.kernel.org>,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:42402 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbbDNDAZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2015 23:00:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,
I have a question about function jbd2__journal_restart().
If we call this function when there's not more credits,
it may commit the handle's transaction and start another one.
So a handle can be attached to 2 transaction and can not ensure the
consistency. It is the caller's responsibility to keep things consistently
before call jbd2__journal_restart(), right?

Thanks very much.


