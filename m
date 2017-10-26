From: "Grochowalski, Matthew (GE Aviation, US)"
        <MatthewS.Grochowalski@ge.com>
Subject: e4crypt - Possible to Change Passphrase?
Date: Thu, 26 Oct 2017 23:20:16 +0000
Message-ID: <4F5135A853DDCC4BAAF325E04E1419C807A384A4@ALPMBAPA10.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00176a03.pphosted.com ([67.231.149.52]:45864 "EHLO
        mx0a-00176a03.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751646AbdJ0AiE (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 26 Oct 2017 20:38:04 -0400
Received: from pps.filterd (m0047961.ppops.net [127.0.0.1])
        by m0047961.ppops.net-00176a03. (8.16.0.21/8.16.0.21) with SMTP id v9QNJoFK007962
        for <linux-ext4@vger.kernel.org>; Thu, 26 Oct 2017 19:20:19 -0400
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is it possible to change the passphrase of a folder encrypted using e4crypt set_policy?

Looking through the documentation it appears the answer is no, but I haven't found anything that addresses that specifically.

I'm assuming I'd need to copy everything from one directory to another with a different policy then delete the originals, or generate some random data to use as a passphrase then encrypt that with the actual user passphrase?

Thanks,
--Matt Grochowalski
