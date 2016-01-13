From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: which IO-scheduler is best for flash based storage device with ext4
Date: Wed, 13 Jan 2016 06:33:28 +0000
Message-ID: <a6b26fd61d88475784c7745b92fe0ae2@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:18617 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbcAMGde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jan 2016 01:33:34 -0500
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Could you tell me which  IO-scheduler is best for flash based storage device with ext4 ?
Just search from WWW, I saw it is said that the noop is best because the CFQ is design for the mechanical hard disk.
And I did the performance test with IOzone between the IO-scheduler noop and cfq. The performance difference is small.
So here I want to get some answer from you about this question.

Thanks.
Huang weller


