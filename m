From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Question of online defrag, thanks
Date: Tue, 29 Oct 2013 10:26:02 +0900
Message-ID: <526F0EAA.10401@rs.jp.nec.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C78E294@sfo1exc-mbxp08.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Peng Chen <Peng.Chen@riverbed.com>
To: Ming Lei <Ming.Lei@riverbed.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:57799 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3J2BcW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Oct 2013 21:32:22 -0400
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id r9T1WK6r017241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 29 Oct 2013 10:32:20 +0900 (JST)
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C78E294@sfo1exc-mbxp08.nbttech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ming,
 
> During running e4defrag, I am writing/reading data on file system.
> Is it safe to use e4defrag? I mean if power failure happens, is there any possibility of data loss or defragging file corruption?

# I have received same question from Peng and I already answered him. Anyway;

The journal feature and kernel internal locks protect data corruption
against power failure and R/W confliction on ext4, so you don't need to
worry about that.

For more detail about journal, please check
the following web page.

https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Journal_.28jbd2.29

Regards,
Akira Fujita

(2013/10/29 2:13), Ming Lei wrote:
> Hi,
> 
> I am using e4defrag to defrag running ext4 online.
> During running e4defrag, I am writing/reading data on file system.
> Is it safe to use e4defrag? I mean if power failure happens, is there any possibility of data loss or defragging file corruption?
> If there is possibility of defragging file corruption after power failure, can fsck fix it?
> 
> Thank you very much.
> Peng
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

