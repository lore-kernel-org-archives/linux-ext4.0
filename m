From: Ming Lei <Ming.Lei@riverbed.com>
Subject: Question of online defrag, thanks
Date: Mon, 28 Oct 2013 17:13:15 +0000
Message-ID: <2CE44BD3DBCF9541909CCB42F11CA3921C78E294@sfo1exc-mbxp08.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Peng Chen <Peng.Chen@riverbed.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.riverbed.com ([208.70.196.45]:13850 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3J1RWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Oct 2013 13:22:45 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am using e4defrag to defrag running ext4 online.
During running e4defrag, I am writing/reading data on file system.
Is it safe to use e4defrag? I mean if power failure happens, is there any possibility of data loss or defragging file corruption?
If there is possibility of defragging file corruption after power failure, can fsck fix it?

Thank you very much.
Peng

